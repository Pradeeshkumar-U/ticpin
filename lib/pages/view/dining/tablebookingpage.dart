// dining_table_booking_page.dart
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/user/userservice.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/dining/diningservice.dart';

class DiningTableBookingPage extends StatefulWidget {
  final String diningId;
  final Map<String, dynamic> diningData;

  const DiningTableBookingPage({
    Key? key,
    required this.diningId,
    required this.diningData,
  }) : super(key: key);

  @override
  State<DiningTableBookingPage> createState() => _DiningTableBookingPageState();
}

class _DiningTableBookingPageState extends State<DiningTableBookingPage>
    with TickerProviderStateMixin {
  final DiningBookingService _bookingService = DiningBookingService();
  final UserService _userService = UserService();

  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  int selectedPeople = 1;
  int selectedDayIndex = 0;
  String? selectedTimeSlot;
  String? selectedStartTime;
  String? selectedEndTime;

  bool isLoading = false;
  bool isLoadingSlots = false;
  Map<String, int> bookedSlots = {};

  // Time slots configuration
  final Map<String, List<String>> timeSlots = {
    'Breakfast': ['7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM'],
    'Lunch': ['12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM'],
    'Dinner': ['7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM'],
  };

  // Get max capacity from dining data (default 50)
  int get maxCapacity => widget.diningData['max_capacity'] ?? 50;

  // Get estimated price per person (default 500)
  int get pricePerPerson => widget.diningData['avg_price_per_person'] ?? 500;

  late List<List<String>> dayTabs;

  @override
  void initState() {
    super.initState();
    dayTabs = _generateNextDays(15);
    _tabController = TabController(length: dayTabs.length, vsync: this)
      ..addListener(() {
        if (mounted && _tabController.index != selectedDayIndex) {
          setState(() {
            selectedDayIndex = _tabController.index;
            selectedTimeSlot = null;
            selectedStartTime = null;
            selectedEndTime = null;
          });
          _loadBookedSlots();
        }
      });

    _loadUserData();
    _loadBookedSlots();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.getUserData();
      if (userData != null && mounted) {
        setState(() {
          _nameController.text = userData.name ?? '';
          _emailController.text = userData.email ?? '';
          _phoneController.text = userData.phoneNumber;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadBookedSlots() async {
    if (!mounted) return;

    setState(() => isLoadingSlots = true);

    try {
      final date = _getSelectedDate();
      final slots = await _bookingService.getBookedSlots(widget.diningId, date);

      if (mounted) {
        setState(() {
          bookedSlots = slots;
          isLoadingSlots = false;
        });
      }
    } catch (e) {
      print('Error loading booked slots: $e');
      if (mounted) {
        setState(() => isLoadingSlots = false);
      }
    }
  }

  String _getSelectedDate() {
    final today = DateTime.now();
    final selectedDay = today.add(Duration(days: selectedDayIndex));
    return DateFormat('yyyy-MM-dd').format(selectedDay);
  }

  List<List<String>> _generateNextDays(int count) {
    final List<List<String>> days = [];
    final today = DateTime.now();
    for (int i = 0; i < count; i++) {
      final date = today.add(Duration(days: i));
      final dayString = DateFormat('d MMM').format(date);
      final weekDayString = DateFormat('EEE').format(date);
      days.add([dayString, weekDayString]);
    }
    return days;
  }

  bool _isSlotAvailable(String startTime) {
    final bookedPeople = bookedSlots[startTime] ?? 0;
    return (bookedPeople + selectedPeople) <= maxCapacity;
  }

  bool _isSlotInPast(String timeSlot) {
    final selectedDate = _getSelectedDate();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (selectedDate != today) return false;

    try {
      final slotTime = DateFormat('h:mm a').parse(timeSlot);
      final now = DateTime.now();
      final slotDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        slotTime.hour,
        slotTime.minute,
      );
      return slotDateTime.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  int _getAvailableSeats(String startTime) {
    final bookedPeople = bookedSlots[startTime] ?? 0;
    return maxCapacity - bookedPeople;
  }

  Future<void> _proceedToPayment() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedTimeSlot == null || selectedStartTime == null) {
      _showErrorSnackbar('Please select a time slot');
      return;
    }

    // Check availability one more time
    if (!_isSlotAvailable(selectedStartTime!)) {
      _showErrorSnackbar('Selected slot is no longer available');
      _loadBookedSlots();
      return;
    }

    setState(() => isLoading = true);

    try {
      final estimatedAmount = pricePerPerson * selectedPeople;
      final advanceAmount = (estimatedAmount * 0.1).round();

      final userDetails = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      // Show payment confirmation dialog
      final confirmed = await _showPaymentDialog(
        estimatedAmount: estimatedAmount,
        advanceAmount: advanceAmount,
      );

      if (!confirmed) {
        setState(() => isLoading = false);
        return;
      }

      // Create booking
      final bookingId = await _bookingService.createTableBooking(
        diningId: widget.diningId,
        diningName: widget.diningData['name'] ?? 'Restaurant',
        date: _getSelectedDate(),
        timeSlot: selectedTimeSlot!,
        startTime: selectedStartTime!,
        endTime: selectedEndTime!,
        numberOfPeople: selectedPeople,
        totalEstimatedAmount: estimatedAmount,
        userDetails: userDetails,
      );

      if (bookingId != null && mounted) {
        Navigator.pop(context);
        _showSuccessDialog(bookingId, advanceAmount);
      }
    } catch (e) {
      _showErrorSnackbar('Booking failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<bool> _showPaymentDialog({
    required int estimatedAmount,
    required int advanceAmount,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: Text(
                  'Confirm Booking',
                  style: TextStyle(fontFamily: 'Regular'),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details:',
                      style: TextStyle(
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildDetailText('Date', dayTabs[selectedDayIndex][0]),
                    _buildDetailText('Time', selectedTimeSlot!),
                    _buildDetailText('People', '$selectedPeople'),
                    Divider(height: 24),
                    _buildDetailText('Estimated Amount', '₹$estimatedAmount'),
                    _buildDetailText(
                      'Advance Payment (10%)',
                      '₹$advanceAmount',
                      isBold: true,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Note: You will pay the remaining amount at the restaurant.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontFamily: 'Regular'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Pay ₹$advanceAmount',
                      style: TextStyle(
                        fontFamily: 'Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _showSuccessDialog(String bookingId, int advanceAmount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text(
                  'Booking Confirmed!',
                  style: TextStyle(fontFamily: 'Regular'),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your table has been booked successfully.',
                  style: TextStyle(fontFamily: 'Regular'),
                ),
                SizedBox(height: 16),
                Text(
                  'Booking ID: ${bookingId.substring(0, 8)}...',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Advance Paid: ₹$advanceAmount',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                style: ElevatedButton.styleFrom(backgroundColor: blackColor),
                child: Text(
                  'Done',
                  style: TextStyle(fontFamily: 'Regular', color: whiteColor),
                ),
              ),
            ],
          ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildDetailText(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Regular', fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Sizes size = Sizes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        centerTitle: true,
        title: Text('Book a Table', style: TextStyle(fontFamily: 'Regular')),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  SingleChildScrollView(
                    // padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant Info
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.safeWidth * 0.05,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.restaurant_menu,
                                        color: gradient1,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.diningData['name'] ??
                                                  'Restaurant',
                                              style: TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '₹$pricePerPerson avg per person',
                                              style: TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24),

                                // Number of People
                                Text(
                                  'Number of People',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Select number of guests',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                      DropdownButton<int>(
                                        dropdownColor: whiteColor,
                                        value: selectedPeople,
                                        underline: SizedBox(),
                                        items: List.generate(
                                          20,
                                          (i) => DropdownMenuItem(
                                            value: i + 1,
                                            child: Text(
                                              '${i + 1}',
                                              style: TextStyle(
                                                fontFamily: 'Regular',
                                              ),
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              selectedPeople = value;
                                              // Reset time slot selection
                                              selectedTimeSlot = null;
                                              selectedStartTime = null;
                                              selectedEndTime = null;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24),

                                // Select Date
                                Text(
                                  'Select Date',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],
                            ),
                          ),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: size.safeWidth * 0.03),
                                SizedBox(
                                  child: ButtonsTabBar(
                                    controller: _tabController,
                                    unselectedBackgroundColor: Colors.black12,
                                    unselectedBorderColor: Colors.transparent,
                                    backgroundColor: gradient1.withAlpha(100),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: size.safeWidth * 0.04,
                                    ),
                                    borderColor: gradient1,
                                    borderWidth: 1.5,
                                    radius: 15,
                                    height: size.safeWidth * 0.17,
                                    // width: size.safeWidth * 0.22,
                                    buttonMargin: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    duration: 0,
                                    tabs: List.generate(
                                      dayTabs.length,
                                      (index) => Tab(
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                dayTabs[index][0],
                                                style: TextStyle(
                                                  fontSize:
                                                      size.safeWidth * 0.031,
                                                  fontFamily: 'Medium',
                                                  color: blackColor,
                                                ),
                                              ),
                                              Text(
                                                dayTabs[index][1],
                                                style: TextStyle(
                                                  fontSize:
                                                      size.safeWidth * 0.03,
                                                  fontFamily: 'Medium',
                                                  color: blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.safeWidth * 0.03),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.safeWidth * 0.05,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 24),

                                // Select Time Slot
                                Text(
                                  'Select Time Slot',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 12),

                                if (isLoadingSlots)
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(24),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else
                                  ...timeSlots.entries.map((entry) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Text(
                                            entry.key,
                                            style: TextStyle(
                                              fontFamily: 'Regular',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children:
                                              entry.value.map((time) {
                                                final isSelected =
                                                    selectedStartTime == time;
                                                final isPast = _isSlotInPast(
                                                  time,
                                                );
                                                final isAvailable =
                                                    _isSlotAvailable(time);
                                                final availableSeats =
                                                    _getAvailableSeats(time);

                                                return InkWell(
                                                  onTap:
                                                      isPast || !isAvailable
                                                          ? null
                                                          : () {
                                                            setState(() {
                                                              selectedTimeSlot =
                                                                  entry.key;
                                                              selectedStartTime =
                                                                  time;
                                                              // Set end time as 1 hour later
                                                              final startDateTime =
                                                                  DateFormat(
                                                                    'h:mm a',
                                                                  ).parse(time);
                                                              final endDateTime =
                                                                  startDateTime
                                                                      .add(
                                                                        Duration(
                                                                          hours:
                                                                              1,
                                                                        ),
                                                                      );
                                                              selectedEndTime =
                                                                  DateFormat(
                                                                    'h:mm a',
                                                                  ).format(
                                                                    endDateTime,
                                                                  );
                                                            });
                                                          },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isPast
                                                              ? Colors
                                                                  .grey
                                                                  .shade200
                                                              : !isAvailable
                                                              ? Colors
                                                                  .red
                                                                  .shade50
                                                              : isSelected
                                                              ? gradient1
                                                                  .withAlpha(
                                                                    100,
                                                                  )
                                                              : Colors.white,
                                                      border: Border.all(
                                                        color:
                                                            isPast
                                                                ? Colors
                                                                    .grey
                                                                    .shade400
                                                                : !isAvailable
                                                                ? Colors
                                                                    .red
                                                                    .shade300
                                                                : isSelected
                                                                ? gradient1
                                                                : Colors
                                                                    .grey
                                                                    .shade300,
                                                        width:
                                                            isSelected ? 2 : 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          time,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Regular',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                isPast ||
                                                                        !isAvailable
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                        ),
                                                        if (!isPast) ...[
                                                          SizedBox(height: 4),
                                                          Text(
                                                            isAvailable
                                                                ? '$availableSeats seats left'
                                                                : 'Full',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Regular',
                                                              fontSize: 11,
                                                              color:
                                                                  isAvailable
                                                                      ? Colors
                                                                          .green
                                                                          .shade700
                                                                      : Colors
                                                                          .red
                                                                          .shade700,
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                        SizedBox(height: 16),
                                      ],
                                    );
                                  }).toList(),

                                SizedBox(height: 24),

                                // User Details
                                Text(
                                  'Your Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 12),

                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),

                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),

                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    if (value.length < 10) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: size.safeHeight * 0.15),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                selectedTimeSlot != null
                                    ? _proceedToPayment
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blackColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                            child: Text(
                              selectedTimeSlot != null
                                  ? 'Book Table (₹${(pricePerPerson * selectedPeople * 0.1).round()} advance)'
                                  : 'Select Time Slot',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular',
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
