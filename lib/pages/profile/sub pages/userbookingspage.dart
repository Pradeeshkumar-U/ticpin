import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/user/userservice.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/dining/diningservice.dart';

// ignore: must_be_immutable
class UserBookingsPage extends StatefulWidget {
  int index;
  UserBookingsPage({super.key, this.index = 0});

  @override
  State<UserBookingsPage> createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  late TabController _tabController;
  Sizes size = Sizes();

  bool isLoadingEvents = true;
  bool isLoadingTurfs = true;
  bool isLoadingDining = true;

  List<Map<String, dynamic>> eventBookings = [];
  List<Map<String, dynamic>> turfBookings = [];
  List<Map<String, dynamic>> diningBookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: widget.index,
      length: 4,
      vsync: this,
    );
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      isLoadingEvents = true;
      isLoadingTurfs = true;
      isLoadingDining = true;
    });

    // Load event bookings
    final events = await _userService.getUserEventBookings();
    setState(() {
      eventBookings = events;
      isLoadingEvents = false;
    });

    // Load turf bookings
    final turfs = await _userService.getUserTurfBookings();
    setState(() {
      turfBookings = turfs;
      isLoadingTurfs = false;
    });
    //    final dining = await _userService.getUserDiningBookings();
    // setState(() {
    //   diningBookings = dining;
    //   isLoadingDining = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text('My Bookings', style: TextStyle(fontFamily: 'Regular')),
        bottom: TabBar(
          controller: _tabController,
          labelColor: blackColor,
          splashFactory: NoSplash.splashFactory,
          unselectedLabelColor: Colors.grey,
          indicatorColor: blackColor,
          labelStyle: TextStyle(
            fontFamily: 'Regular',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: [
            // Tab(text: 'All (${eventBookings.length + turfBookings.length})'),
            // Tab(text: 'Events (${eventBookings.length})'),
            // Tab(text: 'Turfs (${turfBookings.length})'),
            Tab(text: 'All'),
            Tab(text: 'Events'),
            Tab(text: 'Turfs'),
            Tab(text: 'Dining'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsStream(), // All
          _buildBookingsStream(type: 'event'), // Events
          _buildBookingsStream(type: 'turf'), // Turfs
          _buildBookingsStream(type: 'dining'), // Dining
        ],
      ),
    );
  }

  // Add this method to _UserBookingsPageState class in UserBookingsPage

  Widget _buildDiningBookingCard(DiningBooking booking) {
    final status = booking.status;
    final statusColor = _getStatusColor(status);
    final createdAt = booking.createdAt;

    final isTableBooking = booking.isTableBooking;
    final isBillPayment = booking.isBillPayment;

    return Card(
      color: whiteColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showDiningBookingDetails(booking),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          isTableBooking
                              ? Colors.purple.shade100
                              : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isTableBooking ? Icons.restaurant_menu : Icons.receipt,
                      color: isTableBooking ? Colors.purple : Colors.orange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.diningName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Booking ID: ${booking.bookingId.substring(0, 8)}...',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Regular',
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Details based on booking type
              if (isTableBooking) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        Icons.calendar_today,
                        booking.date ?? 'N/A',
                        Colors.black12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoChip(
                        Icons.access_time,
                        booking.timeSlot ?? 'N/A',
                        Colors.black12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        Icons.people,
                        '${booking.numberOfPeople ?? 0} people',
                        Colors.black12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoChip(
                        Icons.schedule,
                        '${booking.startTime ?? ''} - ${booking.endTime ?? ''}',
                        Colors.black12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Advance Paid',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Regular',
                      ),
                    ),
                    Text(
                      '₹${booking.advanceAmount ?? 0}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Regular',
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ] else if (isBillPayment) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.orange.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Bill Payment',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Regular',
                          ),
                        ),
                      ),
                      Text(
                        '₹${booking.billAmount ?? 0}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular',
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Booking date
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Regular',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // Status-specific actions
              if (booking.isActive && isTableBooking) ...[
                const SizedBox(height: 12),
                if (booking.isBookingTimeActive()) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Booking is active now! You can pay your bill.',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Regular',
                              color: Colors.green.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (booking.isUpcoming()) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Upcoming booking. You can modify or cancel.',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Regular',
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (booking.hasBookingTimePassed()) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This booking has ended.',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Regular',
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDiningBookingFromBookingId(String bookingId) {
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('dining_bookings')
              .where('bookingId', isEqualTo: bookingId)
              .limit(1)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              height: size.safeWidth * 0.6,
              width: size.safeWidth * 0.9,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: LoadingShimmer(
                width: double.infinity,
                height: double.infinity,
                isCircle: false,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        final bookingData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final booking = DiningBooking.fromMap(bookingData);

        return _buildDiningBookingCard(booking);
      },
    );
  }

  void _showDiningBookingDetails(DiningBooking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder:
                (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular',
                        ),
                      ),
                      SizedBox(height: 24),

                      _buildDetailRow('Booking ID', booking.bookingId),
                      _buildDetailRow('Status', booking.status.toUpperCase()),
                      _buildDetailRow('Restaurant', booking.diningName),
                      _buildDetailRow(
                        'Type',
                        booking.isTableBooking
                            ? 'Table Booking'
                            : 'Bill Payment',
                      ),

                      if (booking.isTableBooking) ...[
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 16),
                        Text(
                          'Table Booking Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildDetailRow('Date', booking.date ?? 'N/A'),
                        _buildDetailRow('Time Slot', booking.timeSlot ?? 'N/A'),
                        _buildDetailRow(
                          'Time',
                          '${booking.startTime ?? ''} - ${booking.endTime ?? ''}',
                        ),
                        _buildDetailRow(
                          'Number of People',
                          '${booking.numberOfPeople ?? 0}',
                        ),
                        _buildDetailRow(
                          'Advance Paid',
                          '₹${booking.advanceAmount ?? 0}',
                          isBold: true,
                        ),
                      ] else if (booking.isBillPayment) ...[
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 16),
                        _buildDetailRow(
                          'Bill Amount',
                          '₹${booking.billAmount ?? 0}',
                          isBold: true,
                        ),
                      ],

                      if (booking.userDetails != null) ...[
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 16),
                        Text(
                          'Contact Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildDetailRow(
                          'Name',
                          booking.userDetails!['name'] ?? 'N/A',
                        ),
                        _buildDetailRow(
                          'Email',
                          booking.userDetails!['email'] ?? 'N/A',
                        ),
                        _buildDetailRow(
                          'Phone',
                          booking.userDetails!['phone'] ?? 'N/A',
                        ),
                      ],

                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        'Booked On',
                        _formatDate(booking.createdAt),
                      ),
                      if (booking.isCancelled && booking.cancelledAt != null)
                        _buildDetailRow(
                          'Cancelled On',
                          _formatDate(booking.cancelledAt!),
                        ),

                      SizedBox(height: 24),

                      // Actions based on status
                      if (booking.isActive && booking.isTableBooking) ...[
                        if (booking.isUpcoming()) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigate to modify/cancel
                              },
                              icon: Icon(Icons.edit),
                              label: Text(
                                'Modify Booking',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Regular',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showCancelConfirmation(booking);
                              },
                              icon: Icon(Icons.cancel),
                              label: Text(
                                'Cancel Booking',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Regular',
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: BorderSide(color: Colors.red),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ] else if (booking.isBookingTimeActive()) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigate to pay bill
                              },
                              icon: Icon(Icons.payment),
                              label: Text(
                                'Pay Bill Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Regular',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
          ),
    );
  }

  void _showCancelConfirmation(DiningBooking booking) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Cancel Booking?',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            content: Text(
              'Are you sure you want to cancel this booking? The advance payment of ₹${booking.advanceAmount} is non-refundable.',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No', style: TextStyle(fontFamily: 'Regular')),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await DiningBookingService().cancelBooking(
                      booking.bookingId,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booking cancelled successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to cancel: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  'Yes, Cancel',
                  style: TextStyle(fontFamily: 'Regular', color: whiteColor),
                ),
              ),
            ],
          ),
    );
  }

  // Update the _buildBookingsStream method in UserBookingsPage to handle dining
  Widget _buildBookingsStream({String? type}) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userService.getUserBookingsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('No bookings yet', Icons.receipt_long);
        }

        final bookings =
            snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .where((booking) {
                  if (type == null) return true;
                  return booking['bookingType'] == type;
                })
                .toList();

        if (bookings.isEmpty) {
          return _buildEmptyState(
            'No ${type ?? ''} bookings yet',
            Icons.receipt_long,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {},
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              switch (booking['bookingType']) {
                case 'event':
                  return _buildEventBookingCard(booking);
                case 'turf':
                  return buildTurfBookingFromBookingId(booking['bookingId']);
                case 'dining':
                  return buildDiningBookingFromBookingId(booking['bookingId']);
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }

  // Widget _buildBookingsStream({String? type}) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: _userService.getUserBookingsStream(),
  //     builder: (context, snapshot) {
  //       print(snapshot.data.toString());
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //         print(snapshot.error.toString());
  //         return _buildEmptyState('No bookings yet', Icons.receipt_long);
  //       }

  //       final bookings =
  //           snapshot.data!.docs
  //               .map((doc) => doc.data() as Map<String, dynamic>)
  //               .where((booking) {
  //                 if (type == null) return true;
  //                 return booking['bookingType'] == type;
  //               })
  //               .toList();

  //       if (bookings.isEmpty) {
  //         return _buildEmptyState(
  //           'No ${type ?? ''} bookings yet',
  //           Icons.receipt_long,
  //         );
  //       }

  //       return RefreshIndicator(
  //         onRefresh: () async {},
  //         child: ListView.builder(
  //           padding: const EdgeInsets.all(16),
  //           itemCount: bookings.length,
  //           itemBuilder: (context, index) {
  //             final booking = bookings[index];

  //             switch (booking['bookingType']) {
  //               case 'event':
  //                 return _buildEventBookingCard(booking);
  //               case 'turf':
  //                 return buildTurfBookingFromBookingId(booking['bookingId']);
  //               case 'dining':
  //                 return _buildEventBookingCard(booking); // reuse or custom
  //               default:
  //                 return const SizedBox.shrink();
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildAllBookings() {
  //   if (isLoadingEvents || isLoadingTurfs) {
  //     return Center(child: CircularProgressIndicator());
  //   }

  //   final allBookings = [...eventBookings, ...turfBookings];

  //   if (allBookings.isEmpty) {
  //     return _buildEmptyState('No bookings yet', Icons.receipt_long);
  //   }

  //   // Sort by date (most recent first)
  //   allBookings.sort((a, b) {
  //     final aDate = a['createdAt'] as Timestamp?;
  //     final bDate = b['createdAt'] as Timestamp?;
  //     if (aDate == null || bDate == null) return 0;
  //     return bDate.compareTo(aDate);
  //   });

  //   return RefreshIndicator(
  //     onRefresh: _loadBookings,
  //     child: ListView.builder(
  //       padding: EdgeInsets.all(16),
  //       itemCount: allBookings.length,
  //       itemBuilder: (context, index) {
  //         final booking = allBookings[index];
  //         final isEvent = booking.containsKey('eventName');

  //         return isEvent
  //             ? _buildEventBookingCard(booking)
  //             : _buildTurfBookingCard(booking);
  //       },
  //     ),
  //   );
  // }

  // Widget _buildEventBookings() {
  //   if (isLoadingEvents) {
  //     return Center(child: CircularProgressIndicator());
  //   }

  //   if (eventBookings.isEmpty) {
  //     return _buildEmptyState('No event bookings yet', Icons.event);
  //   }

  //   return RefreshIndicator(
  //     onRefresh: _loadBookings,
  //     child: ListView.builder(
  //       padding: EdgeInsets.all(16),
  //       itemCount: eventBookings.length,
  //       itemBuilder: (context, index) {
  //         return _buildEventBookingCard(eventBookings[index]);
  //       },
  //     ),
  //   );
  // }

  // Widget _buildDiningBookings() {
  //   if (isLoadingDining) {
  //     return Center(child: CircularProgressIndicator());
  //   }

  //   if (diningBookings.isEmpty) {
  //     return _buildEmptyState('No dining bookings yet', Icons.event);
  //   }

  //   return RefreshIndicator(
  //     onRefresh: _loadBookings,
  //     child: ListView.builder(
  //       padding: EdgeInsets.all(16),
  //       itemCount: diningBookings.length,
  //       itemBuilder: (context, index) {
  //         return _buildEventBookingCard(diningBookings[index]);
  //       },
  //     ),
  //   );
  // }

  // Widget _buildTurfBookings() {
  //   if (isLoadingTurfs) {
  //     return Center(child: CircularProgressIndicator());
  //   }

  //   if (turfBookings.isEmpty) {
  //     return _buildEmptyState('No turf bookings yet', Icons.sports_soccer);
  //   }

  //   return RefreshIndicator(
  //     onRefresh: _loadBookings,
  //     child: ListView.builder(
  //       padding: EdgeInsets.all(16),
  //       itemCount: turfBookings.length,
  //       itemBuilder: (context, index) {
  //         return _buildTurfBookingCard(turfBookings[index]);
  //       },
  //     ),
  //   );
  // }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start exploring and book now!',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Regular',
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] ?? 'unknown';
    final statusColor = _getStatusColor(status);
    final createdAt = booking['createdAt'] as Timestamp?;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showBookingDetails(booking, true),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.event, color: Colors.blue, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['eventName'] ?? 'Event',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Booking ID: ${booking['bookingId']?.substring(0, 8) ?? 'N/A'}...',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Regular',
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Divider(height: 1),
              SizedBox(height: 16),

              // Tickets info
              if (booking['tickets'] != null) ...[
                Text(
                  'Tickets',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Regular',
                  ),
                ),
                SizedBox(height: 8),
                ...(booking['tickets'] as List).map((ticket) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ticket['ticketType']} x${ticket['quantity']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Regular',
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          '₹${ticket['subtotal']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Regular',
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 12),
              ],

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                  Text(
                    '₹${booking['totalAmount']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(
                    createdAt != null
                        ? _formatDate(createdAt.toDate())
                        : 'Date unavailable',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Regular',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTurfBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] ?? 'unknown';
    final statusColor = _getStatusColor(status);
    final createdAt = booking['createdAt'] as Timestamp?;

    return Card(
      color: whiteColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showBookingDetails(booking, false),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.sports_soccer,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['turfName'] ?? 'Turf',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Booking ID: ${booking['bookingId']?.substring(0, 8)}...',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Regular',
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // DETAILS
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.calendar_today,
                      booking['date'] ?? 'N/A',
                      Colors.black12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      Icons.wb_sunny,
                      booking['session'] ?? 'N/A',
                      Colors.black12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.grid_on,
                      booking['fieldSize'] ?? 'N/A',
                      Colors.black12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      Icons.access_time,
                      '${booking['totalHours']} hrs',
                      Colors.black12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // TOTAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                  Text(
                    '₹${booking['totalAmount']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (createdAt != null)
                Text(
                  'Booked on ${_formatDate(createdAt.toDate())}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Regular',
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTurfBookingFromBookingId(String bookingId) {
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('turf_bookings')
              .where('bookingId', isEqualTo: bookingId)
              .limit(1)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              height: size.safeWidth * 0.7,
              width: size.safeWidth * 0.9,
              decoration: BoxDecoration(
                color: whiteColor,

                borderRadius: BorderRadius.circular(16),
              ),
              child: LoadingShimmer(
                width: double.infinity,
                height: double.infinity,
                isCircle: false,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(); // booking not found
        }

        final booking =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;

        return _buildTurfBookingCard(booking);
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: blackColor),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Regular',
                color: blackColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  void _showBookingDetails(Map<String, dynamic> booking, bool isEvent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder:
                (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular',
                        ),
                      ),
                      SizedBox(height: 24),

                      // Show all booking details
                      _buildDetailRow(
                        'Booking ID',
                        booking['bookingId'] ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Status',
                        booking['status']?.toUpperCase() ?? 'UNKNOWN',
                      ),

                      if (isEvent) ...[
                        _buildDetailRow(
                          'Event Name',
                          booking['eventName'] ?? 'N/A',
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tickets',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 8),
                        if (booking['tickets'] != null)
                          ...(booking['tickets'] as List).map((ticket) {
                            return _buildDetailRow(
                              ticket['ticketType'],
                              '${ticket['quantity']} × ₹${ticket['price']} = ₹${ticket['subtotal']}',
                            );
                          }).toList(),
                      ] else ...[
                        _buildDetailRow(
                          'Turf Name',
                          booking['turfName'] ?? 'N/A',
                        ),
                        _buildDetailRow('Date', booking['date'] ?? 'N/A'),
                        _buildDetailRow('Session', booking['session'] ?? 'N/A'),
                        _buildDetailRow(
                          'Field Size',
                          booking['fieldSize'] ?? 'N/A',
                        ),
                        _buildDetailRow(
                          'Duration',
                          '${booking['totalHours']?.toStringAsFixed(1) ?? '0'} hours',
                        ),
                      ],

                      SizedBox(height: 16),
                      Divider(),
                      _buildDetailRow(
                        'Total Amount',
                        '₹${booking['totalAmount']}',
                        isBold: true,
                      ),

                      SizedBox(height: 24),
                      if (booking['status'] == 'confirmed')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Download ticket functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Download coming soon!'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blackColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Download Ticket',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular',
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Regular',
              color: Colors.grey.shade700,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Regular',
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  // Widget _buildTurfBookingCard(Map<String, dynamic> booking) {
  //   final status = booking['status'] ?? 'unknown';
  //   final statusColor = _getStatusColor(status);
  //   final createdAt = booking['createdAt'] as Timestamp?;

  //   return Card(
  //     color: whiteColor,
  //     margin: EdgeInsets.only(bottom: 16),
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: InkWell(
  //       onTap: () => _showBookingDetails(booking, false),
  //       borderRadius: BorderRadius.circular(16),
  //       child: Padding(
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Header
  //             Row(
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.all(8),
  //                   decoration: BoxDecoration(
  //                     color: Colors.green.shade100,
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   child: Icon(
  //                     Icons.sports_soccer,
  //                     color: Colors.green,
  //                     size: 20,
  //                   ),
  //                 ),
  //                 SizedBox(width: 12),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         booking['turfName'] ?? 'Turf',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                           fontFamily: 'Regular',
  //                         ),
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       SizedBox(height: 4),
  //                       Text(
  //                         'Booking ID: ${booking['bookingId']?.substring(0, 8) ?? 'N/A'}...',
  //                         style: TextStyle(
  //                           fontSize: 12,
  //                           fontFamily: 'Regular',
  //                           color: Colors.grey.shade600,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                   decoration: BoxDecoration(
  //                     color: statusColor.withOpacity(0.1),
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   child: Text(
  //                     status.toUpperCase(),
  //                     style: TextStyle(
  //                       fontSize: 10,
  //                       fontWeight: FontWeight.bold,
  //                       color: statusColor,
  //                       fontFamily: 'Regular',
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),

  //             SizedBox(height: 16),
  //             Divider(height: 1),
  //             SizedBox(height: 16),

  //             // Booking details
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: _buildInfoChip(
  //                     Icons.calendar_today,
  //                     booking['date'] ?? 'N/A',
  //                     Colors.black12,
  //                   ),
  //                 ),
  //                 SizedBox(width: 8),
  //                 Expanded(
  //                   child: _buildInfoChip(
  //                     Icons.wb_sunny,
  //                     booking['session'] ?? 'N/A',
  //                     Colors.black12,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 8),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: _buildInfoChip(
  //                     Icons.grid_on,
  //                     booking['fieldSize'] ?? 'N/A',
  //                     Colors.black12,
  //                   ),
  //                 ),
  //                 SizedBox(width: 8),
  //                 Expanded(
  //                   child: _buildInfoChip(
  //                     Icons.access_time,
  //                     '${booking['totalHours']?.toStringAsFixed(1) ?? '0'} hrs',
  //                     Colors.black12,
  //                   ),
  //                 ),
  //               ],
  //             ),

  //             SizedBox(height: 16),

  //             // Total
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'Total Amount',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                     fontFamily: 'Regular',
  //                   ),
  //                 ),
  //                 Text(
  //                   '₹${booking['totalAmount']}',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     fontFamily: 'Regular',
  //                     color: blackColor,
  //                   ),
  //                 ),
  //               ],
  //             ),

  //             SizedBox(height: 10),

  //             // Date
  //             Row(
  //               children: [
  //                 // Icon(Icons.calendar_today, size: 14, color: Colors.grey),
  //                 // SizedBox(width: 6),
  //                 Text(
  //                   createdAt != null
  //                       ? 'Booked on ${_formatDate(createdAt.toDate())}'
  //                       : 'Date unavailable',
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     fontFamily: 'Regular',
  //                     color: Colors.grey.shade600,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
