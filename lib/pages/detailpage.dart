import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticpin_dining/pages/analyticspage.dart';

// ─────────────────────────────────────────────────────────────
// Dining Detail Page - For managing table bookings
// ─────────────────────────────────────────────────────────────

class DiningDetailPage extends StatefulWidget {
  final String diningId;
  final Map<String, dynamic> diningData;

  const DiningDetailPage({
    super.key,
    required this.diningId,
    required this.diningData,
  });

  @override
  State<DiningDetailPage> createState() => _DiningDetailPageState();
}

class _DiningDetailPageState extends State<DiningDetailPage> {
  // ───── Time Slots (Breakfast, Lunch, Dinner) ─────
  final List<Map<String, String>> _timeSlots = [
    {'name': 'Breakfast', 'icon': '🌅', 'time': '8:00 AM - 11:00 AM'},
    {'name': 'Lunch', 'icon': '☀️', 'time': '12:00 PM - 3:00 PM'},
    {'name': 'Dinner', 'icon': '🌙', 'time': '7:00 PM - 11:00 PM'},
  ];

  String _selectedTimeSlot = 'Breakfast';

  // ───── Date selection ─────
  int _selectedDayIndex = 0;
  late final List<List<String>> _tabs;

  // ───── Booking state ─────
  Map<String, List<Map<String, dynamic>>> _bookingsBySlot = {};
  bool _loadingBookings = false;

  // ───── Carousel images ─────
  List<String> _carouselUrls = [];
  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = _generateNextDays(15);
    _parseImages();
    _fetchBookings();
  }

  // ─────────────────────────────────────────────
  // IMAGE PARSING
  // ─────────────────────────────────────────────
  void _parseImages() {
    final images = widget.diningData['images'];
    if (images is Map) {
      _carouselUrls = List<String>.from(images['carousel'] ?? []);
    }
  }

  // ─────────────────────────────────────────────
  // DATE HELPERS
  // ─────────────────────────────────────────────
  List<List<String>> _generateNextDays(int count) {
    final List<List<String>> days = [];
    final today = DateTime.now();
    for (int i = 0; i < count; i++) {
      final date = today.add(Duration(days: i));
      days.add([
        DateFormat('d MMM').format(date),
        DateFormat('EEE').format(date),
      ]);
    }
    return days;
  }

  String _getSelectedDate() {
    final today = DateTime.now();
    return DateFormat('yyyy-MM-dd')
        .format(today.add(Duration(days: _selectedDayIndex)));
  }

  /// Returns the lowercase weekday key for the selected date
  String _getSelectedDayKey() {
    final today = DateTime.now();
    final date = today.add(Duration(days: _selectedDayIndex));
    const keys = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return keys[date.weekday - 1];
  }

  // ─────────────────────────────────────────────
  // CHECK IF DINING IS OPEN
  // ─────────────────────────────────────────────
  bool _isDiningOpen() {
    final timings = widget.diningData['timings'];
    if (timings == null) return true;

    final openTime = timings['open'] ?? '9:00 AM';
    final closeTime = timings['close'] ?? '11:00 PM';

    // Simple check - you can enhance this
    return openTime.isNotEmpty && closeTime.isNotEmpty;
  }

  String _getOpeningHours() {
    final timings = widget.diningData['timings'];
    if (timings == null) return 'Open daily';

    final openTime = timings['open'] ?? '9:00 AM';
    final closeTime = timings['close'] ?? '11:00 PM';

    return '$openTime – $closeTime';
  }

  // ─────────────────────────────────────────────
  // FETCH BOOKINGS FROM FIRESTORE
  // ─────────────────────────────────────────────
  Future<void> _fetchBookings() async {
    if (!mounted) return;
    setState(() {
      _loadingBookings = true;
    });

    try {
      final selectedDate = _getSelectedDate();

      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('dining_bookings')
          .where('diningId', isEqualTo: widget.diningId)
          .where('date', isEqualTo: selectedDate)
          .where('status', whereIn: ['confirmed', 'completed'])
          .get();

      Map<String, List<Map<String, dynamic>>> groupedBookings = {
        'Breakfast': [],
        'Lunch': [],
        'Dinner': [],
      };

      for (var doc in bookingsSnapshot.docs) {
        final data = doc.data();
        final timeSlot = data['timeSlot'] ?? 'Lunch';

        groupedBookings[timeSlot]?.add({
          'bookingId': doc.id,
          'startTime': data['startTime'] ?? '',
          'endTime': data['endTime'] ?? '',
          'numberOfPeople': data['numberOfPeople'] ?? 1,
          'userName': data['userDetails']?['name'] ?? 'Guest',
          'userPhone': data['userDetails']?['phone'] ?? '',
          'status': data['status'] ?? 'confirmed',
          'bookingType': data['bookingType'] ?? 'table',
          'advanceAmount': data['advanceAmount'] ?? 0.0,
          'billAmount': data['billAmount'],
          'createdAt': data['createdAt'],
        });
      }

      if (mounted) {
        setState(() {
          _bookingsBySlot = groupedBookings;
        });
      }
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingBookings = false;
        });
      }
    }
  }

  // ─────────────────────────────────────────────
  // GET BOOKINGS FOR SELECTED TIME SLOT
  // ─────────────────────────────────────────────
  List<Map<String, dynamic>> get _currentSlotBookings {
    return _bookingsBySlot[_selectedTimeSlot] ?? [];
  }

  // ─────────────────────────────────────────────
  // CANCEL BOOKING
  // ─────────────────────────────────────────────
  Future<void> _cancelBooking(Map<String, dynamic> booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Booking',
          style: TextStyle(fontFamily: 'Medium'),
        ),
        content: Text(
          'Cancel booking for ${booking['userName']}?\n\n'
          'People: ${booking['numberOfPeople']}\n'
          'Time: ${booking['startTime']} - ${booking['endTime']}\n\n'
          'A refund will be initiated if advance was paid.',
          style: const TextStyle(fontFamily: 'Regular'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No', style: TextStyle(fontFamily: 'Regular')),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(fontFamily: 'Regular'),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final bookingId = booking['bookingId'];

      // Update booking status
      await FirebaseFirestore.instance
          .collection('dining_bookings')
          .doc(bookingId)
          .update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'refundStatus': 'pending',
        'refundInitiatedAt': FieldValue.serverTimestamp(),
      });

      // Create refund record if advance was paid
      final advanceAmount = (booking['advanceAmount'] ?? 0.0).toDouble();
      if (advanceAmount > 0) {
        await FirebaseFirestore.instance.collection('refunds').add({
          'bookingId': bookingId,
          'userId': booking['userId'] ?? '',
          'diningId': widget.diningId,
          'amount': advanceAmount,
          'status': 'pending',
          'reason': 'Cancelled by admin',
          'createdAt': FieldValue.serverTimestamp(),
          'processedAt': null,
        });
      }

      _fetchBookings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ─────────────────────────────────────────────
  // COMPLETE BOOKING (Mark bill as paid)
  // ─────────────────────────────────────────────
  Future<void> _completeBooking(Map<String, dynamic> booking) async {
    final billController = TextEditingController();

    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Complete Booking',
          style: TextStyle(fontFamily: 'Medium'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer: ${booking['userName']}\n'
              'People: ${booking['numberOfPeople']}\n'
              'Advance Paid: ₹${booking['advanceAmount']}',
              style: const TextStyle(fontFamily: 'Regular'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: billController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontFamily: 'Regular'),
              decoration: InputDecoration(
                labelText: 'Total Bill Amount',
                labelStyle: const TextStyle(fontFamily: 'Regular'),
                prefixText: '₹ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Regular')),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(billController.text.trim());
              Navigator.pop(ctx, amount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E1E82),
            ),
            child: const Text(
              'Complete',
              style: TextStyle(fontFamily: 'Regular', color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (result == null || result <= 0) return;

    try {
      final bookingId = booking['bookingId'];

      await FirebaseFirestore.instance
          .collection('dining_bookings')
          .doc(bookingId)
          .update({
        'status': 'completed',
        'billAmount': result,
        'billPaidAt': FieldValue.serverTimestamp(),
      });

      _fetchBookings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking completed successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ─────────────────────────────────────────────
  // SHOW BOOKING OPTIONS
  // ─────────────────────────────────────────────
  void _showBookingOptions(Map<String, dynamic> booking) {
    final isCompleted = booking['status'] == 'completed';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Booking info
            Text(
              booking['userName'],
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Medium',
                color: Color(0xFF1E1E82),
              ),
            ),
            Text(
              '${booking['numberOfPeople']} ${booking['numberOfPeople'] == 1 ? 'Person' : 'People'} • ${booking['startTime']} - ${booking['endTime']}',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Regular',
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),

            // Options
            if (!isCompleted) ...[
              _buildBottomSheetOption(
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
                label: 'Complete Booking',
                onTap: () {
                  Navigator.pop(ctx);
                  _completeBooking(booking);
                },
              ),
              const SizedBox(height: 8),
            ],

            _buildBottomSheetOption(
              icon: Icons.cancel_outlined,
              iconColor: Colors.red,
              label: 'Cancel Booking',
              onTap: () {
                Navigator.pop(ctx);
                _cancelBooking(booking);
              },
            ),

            const SizedBox(height: 8),

            _buildBottomSheetOption(
              icon: Icons.info_outline,
              iconColor: const Color(0xFF1E1E82),
              label: 'View Details',
              onTap: () {
                Navigator.pop(ctx);
                _showBookingDetails(booking);
              },
            ),

            const SizedBox(height: 8),

            _buildBottomSheetOption(
              icon: Icons.close_outlined,
              iconColor: Colors.grey.shade500,
              label: 'Close',
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SHOW BOOKING DETAILS
  // ─────────────────────────────────────────────
  void _showBookingDetails(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Booking Details',
          style: TextStyle(fontFamily: 'Medium'),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Customer', booking['userName']),
              _detailRow('Phone', booking['userPhone']),
              _detailRow('People', '${booking['numberOfPeople']}'),
              _detailRow('Time Slot', _selectedTimeSlot),
              _detailRow(
                'Time',
                '${booking['startTime']} - ${booking['endTime']}',
              ),
              _detailRow('Booking Type', booking['bookingType']),
              _detailRow('Status', booking['status']),
              const Divider(height: 24),
              _detailRow(
                'Advance Amount',
                '₹${booking['advanceAmount']}',
              ),
              if (booking['billAmount'] != null)
                _detailRow(
                  'Total Bill',
                  '₹${booking['billAmount']}',
                ),
              if (booking['createdAt'] != null)
                _detailRow(
                  'Booked At',
                  DateFormat('MMM dd, yyyy hh:mm a').format(
                    (booking['createdAt'] as Timestamp).toDate(),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(fontFamily: 'Regular')),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Regular',
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Medium',
                color: Color(0xFF1E1E82),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 20)),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(fontFamily: 'Regular', fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isOpen = _isDiningOpen();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(size),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.width * 0.04),

                  // Time Slot Selector
                  _buildSectionLabel('Select Meal Time', size),
                  SizedBox(height: size.width * 0.025),
                  _buildTimeSlotSelector(size),
                  SizedBox(height: size.width * 0.045),

                  // Date Selector
                  _buildSectionLabel('Select Date', size),
                  SizedBox(height: size.width * 0.025),
                  _buildDateSelector(size),
                  SizedBox(height: size.width * 0.045),

                  // Opening Hours Badge
                  if (isOpen) ...[
                    _buildHoursBadge(size),
                    SizedBox(height: size.width * 0.03),
                  ],

                  // Bookings List
                  _buildSectionLabel(
                    'Bookings (${_currentSlotBookings.length})',
                    size,
                  ),
                  SizedBox(height: size.width * 0.03),

                  _loadingBookings
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.width * 0.1,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1E1E82),
                            ),
                          ),
                        )
                      : _buildBookingsList(size),

                  SizedBox(height: size.width * 0.06),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────
  Widget _buildHeader(Size size) {
    final hasCarousel = _carouselUrls.isNotEmpty;
    final headerHeight = hasCarousel ? size.width * 0.45 : size.width * 0.28;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          hasCarousel
              ? PageView.builder(
                  itemCount: _carouselUrls.length,
                  onPageChanged: (i) => setState(() {
                    _currentCarouselIndex = i;
                  }),
                  itemBuilder: (_, i) => Image.network(
                    _carouselUrls[i],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF1E1E82),
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_outlined,
                          color: Colors.white54,
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E1E82), Color(0xFF3636B8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.restaurant_outlined,
                      size: 56,
                      color: Colors.white.withAlpha(60),
                    ),
                  ),
                ),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: headerHeight * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withAlpha(180)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Carousel dots
          if (_carouselUrls.length > 1)
            Positioned(
              bottom: 44,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _carouselUrls.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _currentCarouselIndex ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == _currentCarouselIndex
                          ? Colors.white
                          : Colors.white.withAlpha(100),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

          // Title
          Positioned(
            bottom: 16,
            left: 20,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.diningData['name'] ?? 'Restaurant',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Medium',
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.diningData['location']?['city'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Regular',
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(130),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Analytics button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(130),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Get.to(
                    () => DiningAnalyticsPage(
                      diningId: widget.diningId,
                      diningData: widget.diningData,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION LABEL
  // ─────────────────────────────────────────────
  Widget _buildSectionLabel(String title, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.width * 0.04,
          fontFamily: 'Medium',
          color: const Color(0xFF1E1E82),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TIME SLOT SELECTOR
  // ─────────────────────────────────────────────
  Widget _buildTimeSlotSelector(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Row(
        children: _timeSlots.map((slot) {
          final isSelected = _selectedTimeSlot == slot['name'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (_selectedTimeSlot == slot['name']) return;
                setState(() {
                  _selectedTimeSlot = slot['name']!;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: EdgeInsets.only(
                  right: slot == _timeSlots.last ? 0 : size.width * 0.03,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E1E82) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E1E82)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFF1E1E82).withAlpha(90)
                          : Colors.black.withAlpha(15),
                      blurRadius: isSelected ? 8 : 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.width * 0.035,
                    horizontal: size.width * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        slot['icon']!,
                        style: TextStyle(fontSize: size.width * 0.055),
                      ),
                      SizedBox(height: size.width * 0.01),
                      Text(
                        slot['name']!,
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          fontFamily: 'Medium',
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1E1E82),
                        ),
                      ),
                      SizedBox(height: size.width * 0.01),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withAlpha(30)
                              : const Color(0xFF1E1E82).withAlpha(12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_bookingsBySlot[slot['name']]?.length ?? 0}',
                          style: TextStyle(
                            fontSize: size.width * 0.024,
                            fontFamily: 'Regular',
                            color: isSelected
                                ? Colors.white.withAlpha(210)
                                : const Color(0xFF1E1E82).withAlpha(160),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DATE SELECTOR
  // ─────────────────────────────────────────────
  Widget _buildDateSelector(Size size) {
    return SizedBox(
      height: size.width * 0.14,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
        itemCount: _tabs.length,
        itemBuilder: (_, index) {
          final isSelected = _selectedDayIndex == index;
          final isToday = index == 0;

          return GestureDetector(
            onTap: () {
              if (_selectedDayIndex == index) return;
              setState(() {
                _selectedDayIndex = index;
              });
              _fetchBookings();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: index < _tabs.length - 1
                  ? EdgeInsets.only(right: size.width * 0.03)
                  : EdgeInsets.zero,
              width: size.width * 0.2,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E1E82) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E1E82)
                      : isToday
                          ? const Color(0xFF3636B8)
                          : Colors.grey.shade300,
                  width: isToday && !isSelected ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFF1E1E82).withAlpha(80)
                        : Colors.black.withAlpha(12),
                    blurRadius: isSelected ? 6 : 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.width * 0.005),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        _tabs[index][0].split(' ').first,
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontFamily: 'Medium',
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1E1E82),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _tabs[index][0].split(' ').last,
                        style: TextStyle(
                          fontSize: size.width * 0.024,
                          fontFamily: 'Regular',
                          color: isSelected
                              ? Colors.white.withAlpha(180)
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.015),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HOURS BADGE
  // ─────────────────────────────────────────────
  Widget _buildHoursBadge(Size size) {
    final hours = _getOpeningHours();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.width * 0.025,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E82).withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E1E82).withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_filled,
              size: 18,
              color: Color(0xFF1E1E82),
            ),
            const SizedBox(width: 10),
            Text(
              'Operating Hours:',
              style: TextStyle(
                fontSize: size.width * 0.03,
                fontFamily: 'Regular',
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              hours,
              style: TextStyle(
                fontSize: size.width * 0.035,
                fontFamily: 'Medium',
                color: const Color(0xFF1E1E82),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOOKINGS LIST
  // ─────────────────────────────────────────────
  Widget _buildBookingsList(Size size) {
    if (_currentSlotBookings.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.045,
          vertical: size.width * 0.08,
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.event_busy_outlined,
                size: size.width * 0.12,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: size.width * 0.04),
              Text(
                'No bookings found',
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontFamily: 'Medium',
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: size.width * 0.015),
              Text(
                'No bookings for ${_selectedTimeSlot.toLowerCase()} on this date.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.03,
                  fontFamily: 'Regular',
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Column(
        children: _currentSlotBookings.map((booking) {
          final isCompleted = booking['status'] == 'completed';
          final numberOfPeople = booking['numberOfPeople'] ?? 1;

          return GestureDetector(
            onTap: () => _showBookingOptions(booking),
            child: Container(
              margin: EdgeInsets.only(bottom: size.width * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCompleted
                      ? Colors.green.shade200
                      : Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking['userName'],
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  fontFamily: 'Medium',
                                  color: const Color(0xFF1E1E82),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: size.width * 0.01),
                              Row(
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: size.width * 0.035,
                                    color: Colors.grey.shade500,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '$numberOfPeople ${numberOfPeople == 1 ? 'Person' : 'People'}',
                                    style: TextStyle(
                                      fontSize: size.width * 0.03,
                                      fontFamily: 'Regular',
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.green.withAlpha(20)
                                : const Color(0xFF1E1E82).withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isCompleted ? 'Completed' : 'Active',
                            style: TextStyle(
                              fontSize: size.width * 0.025,
                              fontFamily: 'Regular',
                              color: isCompleted
                                  ? Colors.green.shade700
                                  : const Color(0xFF1E1E82),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.025),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: size.width * 0.035,
                          color: Colors.grey.shade500,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${booking['startTime']} - ${booking['endTime']}',
                          style: TextStyle(
                            fontSize: size.width * 0.032,
                            fontFamily: 'Regular',
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.currency_rupee,
                          size: size.width * 0.035,
                          color: Colors.grey.shade500,
                        ),
                        Text(
                          'Advance: ₹${booking['advanceAmount']}',
                          style: TextStyle(
                            fontSize: size.width * 0.032,
                            fontFamily: 'Regular',
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}