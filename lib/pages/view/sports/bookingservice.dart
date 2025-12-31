// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // ==================== TURF BOOKING SERVICE ====================

// class TurfBookingService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   /// Create reservation for turf - Does NOT lock slots
//   /// Slots are only locked when payment is initiated
//   Future<Map<String, dynamic>> createReservation({
//     required String turfId,
//     required String date, // e.g., "2025-12-30"
//     required String session, // "Twilight", "Morning", "Afternoon", "Evening"
//     required String startTime, // e.g., "6:00 AM"
//     required String endTime, // e.g., "8:00 AM"
//     required double duration, // in hours
//     required String fieldSize, // "4x4" or "6x6"
//     required Map<String, dynamic> userDetails,
//   }) async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         return {
//           'success': false,
//           'message': 'User not authenticated',
//         };
//       }

//       if (duration <= 0) {
//         return {
//           'success': false,
//           'message': 'Invalid duration',
//         };
//       }

//       final result = await _firestore.runTransaction<Map<String, dynamic>>(
//         (transaction) async {
//           // Read turf document
//           final turfRef = _firestore.collection('turfs').doc(turfId);
//           final turfDoc = await transaction.get(turfRef);

//           if (!turfDoc.exists) {
//             throw Exception('Turf not found');
//           }

//           final turfData = turfDoc.data()!;
//           final String turfName = turfData['name'] ?? '';
//           final double halfHourPrice = (turfData['half_hour_price'] ?? 0.0).toDouble();

//           // Calculate total amount (duration is in hours, price is per 0.5 hour)
//           final double halfHours = duration * 2; // Convert hours to half-hours
//           final int totalAmount = (halfHours * halfHourPrice).round();

//           // Create booking document with 'reserved' status
//           final bookingId = _firestore.collection('turf_bookings').doc().id;
          
//           // Set expiry time (5 minutes from now)
//           final expiryTime = DateTime.now().add(Duration(minutes: 5));

//           final bookingData = {
//             'bookingId': bookingId,
//             'turfId': turfId,
//             'turfName': turfName,
//             'userId': user.uid,
//             'date': date,
//             'session': session,
//             'startTime': startTime,
//             'endTime': endTime,
//             'duration': duration,
//             'fieldSize': fieldSize,
//             'totalAmount': totalAmount,
//             'status': 'reserved', // Not locked yet
//             'createdAt': FieldValue.serverTimestamp(),
//             'expiresAt': Timestamp.fromDate(expiryTime),
//             'userDetails': userDetails,
//           };

//           final bookingRef = _firestore.collection('turf_bookings').doc(bookingId);
//           transaction.set(bookingRef, bookingData);

//           // DO NOT lock slots yet - only on payment initiation

//           return {
//             'success': true,
//             'message': 'Reservation created',
//             'bookingId': bookingId,
//             'totalAmount': totalAmount,
//             'expiresAt': expiryTime.toIso8601String(),
//           };
//         },
//         timeout: const Duration(seconds: 10),
//       );

//       return result;
//     } catch (e) {
//       return {
//         'success': false,
//         'message': e.toString().replaceAll('Exception: ', ''),
//       };
//     }
//   }

//   /// Initiate payment - Changes status to 'pending' and LOCKS slots
//   Future<Map<String, dynamic>> initiatePayment(String bookingId) async {
//     try {
//       final result = await _firestore.runTransaction<Map<String, dynamic>>(
//         (transaction) async {
//           // Get booking
//           final bookingRef = _firestore.collection('turf_bookings').doc(bookingId);
//           final bookingDoc = await transaction.get(bookingRef);

//           if (!bookingDoc.exists) {
//             throw Exception('Booking not found');
//           }

//           final bookingData = bookingDoc.data()!;

//           if (bookingData['status'] != 'reserved') {
//             throw Exception('Invalid booking status');
//           }

//           // Check if expired
//           final expiresAt = (bookingData['expiresAt'] as Timestamp).toDate();
//           if (DateTime.now().isAfter(expiresAt)) {
//             throw Exception('Reservation expired');
//           }

//           final turfId = bookingData['turfId'];
//           final date = bookingData['date'];
//           final fieldSize = bookingData['fieldSize'];
//           final startTime = bookingData['startTime'];
//           final endTime = bookingData['endTime'];

//           // Check if slots are already booked
//           final slotsRef = _firestore
//               .collection('turf_slots')
//               .doc('${turfId}_${date}_$fieldSize');
//           final slotsDoc = await transaction.get(slotsRef);

//           Map<String, dynamic> bookedSlots = {};
//           if (slotsDoc.exists) {
//             bookedSlots = slotsDoc.data()!['slots'] ?? {};
//           }

//           // Get all time slots between start and end
//           final timeSlots = _generateTimeSlots(startTime, endTime);

//           // Check if any slot is already booked
//           for (final slot in timeSlots) {
//             if (bookedSlots.containsKey(slot) && bookedSlots[slot] == true) {
//               throw Exception('Time slot $slot is already booked');
//             }
//           }

//           // Lock all slots NOW
//           for (final slot in timeSlots) {
//             bookedSlots[slot] = true;
//           }

//           // Update or create slots document
//           transaction.set(
//             slotsRef,
//             {
//               'turfId': turfId,
//               'date': date,
//               'fieldSize': fieldSize,
//               'slots': bookedSlots,
//               'updatedAt': FieldValue.serverTimestamp(),
//             },
//             SetOptions(merge: true),
//           );

//           // Update booking status to 'pending'
//           transaction.update(bookingRef, {
//             'status': 'pending',
//             'paymentInitiatedAt': FieldValue.serverTimestamp(),
//             'lockedSlots': timeSlots, // Store which slots were locked
//           });

//           return {
//             'success': true,
//             'message': 'Payment initiated',
//           };
//         },
//       );

//       return result;
//     } catch (e) {
//       return {
//         'success': false,
//         'message': e.toString().replaceAll('Exception: ', ''),
//       };
//     }
//   }

//   /// Confirm payment - Changes status to 'confirmed'
//   Future<Map<String, dynamic>> confirmPayment({
//     required String bookingId,
//     required String paymentId,
//     required String paymentMethod,
//   }) async {
//     try {
//       final bookingRef = _firestore.collection('turf_bookings').doc(bookingId);
//       final bookingDoc = await bookingRef.get();

//       if (!bookingDoc.exists) {
//         throw Exception('Booking not found');
//       }

//       final bookingData = bookingDoc.data()!;

//       if (bookingData['status'] != 'pending') {
//         throw Exception('Invalid booking status');
//       }

//       // Update to confirmed
//       await bookingRef.update({
//         'status': 'confirmed',
//         'paymentId': paymentId,
//         'paymentMethod': paymentMethod,
//         'confirmedAt': FieldValue.serverTimestamp(),
//       });

//       return {
//         'success': true,
//         'message': 'Payment confirmed',
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': e.toString(),
//       };
//     }
//   }

//   /// Cancel payment - Unlocks slots and deletes/cancels booking
//   Future<Map<String, dynamic>> cancelPayment(String bookingId) async {
//     try {
//       final result = await _firestore.runTransaction<Map<String, dynamic>>(
//         (transaction) async {
//           final bookingRef = _firestore.collection('turf_bookings').doc(bookingId);
//           final bookingDoc = await transaction.get(bookingRef);

//           if (!bookingDoc.exists) {
//             throw Exception('Booking not found');
//           }

//           final bookingData = bookingDoc.data()!;
//           final status = bookingData['status'];

//           // Only unlock slots if payment was initiated (status = pending)
//           if (status == 'pending') {
//             final turfId = bookingData['turfId'];
//             final date = bookingData['date'];
//             final fieldSize = bookingData['fieldSize'];
//             final lockedSlots = List<String>.from(bookingData['lockedSlots'] ?? []);

//             // Unlock slots
//             final slotsRef = _firestore
//                 .collection('turf_slots')
//                 .doc('${turfId}_${date}_$fieldSize');
//             final slotsDoc = await transaction.get(slotsRef);

//             if (slotsDoc.exists) {
//               final bookedSlots = Map<String, dynamic>.from(slotsDoc.data()!['slots'] ?? {});
              
//               for (final slot in lockedSlots) {
//                 bookedSlots.remove(slot);
//               }

//               transaction.update(slotsRef, {
//                 'slots': bookedSlots,
//                 'updatedAt': FieldValue.serverTimestamp(),
//               });
//             }
//           }

//           // Delete the booking
//           if (status == 'reserved' || status == 'pending') {
//             transaction.delete(bookingRef);
//           }

//           return {
//             'success': true,
//             'message': 'Booking cancelled',
//           };
//         },
//       );

//       return result;
//     } catch (e) {
//       return {
//         'success': false,
//         'message': e.toString().replaceAll('Exception: ', ''),
//       };
//     }
//   }

//   /// Get user's bookings
//   Stream<List<Map<String, dynamic>>> getUserBookings({bool includeAll = false}) {
//     final user = _auth.currentUser;
//     if (user == null) return Stream.value([]);

//     Query query = _firestore
//         .collection('turf_bookings')
//         .where('userId', isEqualTo: user.uid);

//     if (!includeAll) {
//       query = query.where('status', isEqualTo: 'confirmed');
//     }

//     return query.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     });
//   }

//   /// Get booked slots for a specific date and field size
//   Future<List<String>> getBookedSlots({
//     required String turfId,
//     required String date,
//     required String fieldSize,
//   }) async {
//     try {
//       final slotsDoc = await _firestore
//           .collection('turf_slots')
//           .doc('${turfId}_${date}_$fieldSize')
//           .get();

//       if (!slotsDoc.exists) {
//         return [];
//       }

//       final slots = slotsDoc.data()!['slots'] as Map<String, dynamic>?;
//       if (slots == null) return [];

//       return slots.entries
//           .where((entry) => entry.value == true)
//           .map((entry) => entry.key as String)
//           .toList();
//     } catch (e) {
//       print('Error getting booked slots: $e');
//       return [];
//     }
//   }

//   /// Helper: Generate time slots between start and end
//   List<String> _generateTimeSlots(String startTime, String endTime) {
//     final List<String> slots = [];
    
//     // Parse times
//     DateTime start = _parseTime(startTime);
//     DateTime end = _parseTime(endTime);

//     // Generate 30-minute slots
//     while (start.isBefore(end)) {
//       slots.add(_formatTime(start));
//       start = start.add(Duration(minutes: 30));
//     }

//     return slots;
//   }

//   DateTime _parseTime(String time) {
//     // Parse "6:00 AM" format
//     final parts = time.split(' ');
//     final timeParts = parts[0].split(':');
//     int hour = int.parse(timeParts[0]);
//     final minute = int.parse(timeParts[1]);
//     final isPM = parts[1].toUpperCase() == 'PM';

//     if (isPM && hour != 12) hour += 12;
//     if (!isPM && hour == 12) hour = 0;

//     return DateTime(2000, 1, 1, hour, minute);
//   }

//   String _formatTime(DateTime time) {
//     int hour = time.hour;
//     final minute = time.minute;
//     final period = hour >= 12 ? 'PM' : 'AM';
    
//     if (hour > 12) hour -= 12;
//     if (hour == 0) hour = 12;

//     return '$hour:${minute.toString().padLeft(2, '0')} $period';
//   }
// }

// // ==================== BOOKING FLOW SUMMARY ====================

// /*
// FLOW:
// 1. User selects time slots → createReservation()
//    - Status: 'reserved'
//    - Slots: NOT locked
//    - Expires in 5 minutes

// 2. User clicks "Pay Now" → initiatePayment()
//    - Status: 'reserved' → 'pending'
//    - Slots: LOCKED NOW
//    - Shows payment gateway

// 3a. Payment Success → confirmPayment()
//    - Status: 'pending' → 'confirmed'
//    - Slots: Remain locked

// 3b. Payment Failed/Cancelled → cancelPayment()
//    - Status: 'pending' → DELETED
//    - Slots: UNLOCKED

// 4. Reservation Expires (Cloud Function handles this)
//    - Status: 'reserved' → AUTO-DELETED
//    - Slots: Never locked

// STATUSES:
// - 'reserved': Temporary hold, no locking, expires in 5 min
// - 'pending': Payment in progress, slots locked
// - 'confirmed': Payment successful, slots permanently booked
// */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';

class TurfCheckoutPage extends StatefulWidget {
  final String turfId;
  final Map<String, dynamic> turfData;
  final String selectedDate;
  final String fieldSize;
  final String session;
  final List<dynamic> slots;
  final double totalHours;
  final int totalAmount;

  const TurfCheckoutPage({
    Key? key,
    required this.turfId,
    required this.turfData,
    required this.selectedDate,
    required this.fieldSize,
    required this.session,
    required this.slots,
    required this.totalHours,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<TurfCheckoutPage> createState() => _TurfCheckoutPageState();
}

class _TurfCheckoutPageState extends State<TurfCheckoutPage> with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? bookingId;
  bool isProcessing = false;
  Timer? _countdownTimer;
  Duration _remainingTime = Duration(minutes: 10);
  bool _timerExpired = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
    _createPendingBooking();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Timer continues running even when app is in background
    if (state == AppLifecycleState.resumed && bookingId != null) {
      _checkBookingStatus();
    }
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      _nameController.text = user.displayName ?? '';
    }
  }

  Future<void> _createPendingBooking() async {
    final user = _auth.currentUser;
    if (user == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => isProcessing = true);

    try {
      final result = await _firestore.runTransaction<Map<String, dynamic>>((transaction) async {
        // Check slot availability
        final docId = '${widget.turfId}_${widget.selectedDate}_${widget.fieldSize}';
        final slotsRef = _firestore.collection('turf_slots').doc(docId);
        final slotsDoc = await transaction.get(slotsRef);

        Map<String, dynamic> currentSlots = {};
        if (slotsDoc.exists) {
          currentSlots = Map<String, dynamic>.from(slotsDoc.data()!['slots'] ?? {});
        }

        // Check if any slot is already booked
        for (var slot in widget.slots) {
          final slotStart = slot.start;
          if (currentSlots[slotStart] == true) {
            throw Exception('Slot $slotStart is no longer available');
          }
        }

        // Create booking
        final newBookingId = _firestore.collection('turf_bookings').doc().id;
        final bookingData = {
          'bookingId': newBookingId,
          'turfId': widget.turfId,
          'turfName': widget.turfData['name'] ?? '',
          'userId': user.uid,
          'date': widget.selectedDate,
          'fieldSize': widget.fieldSize,
          'session': widget.session,
          'slots': widget.slots.map((s) => {'start': s.start, 'end': s.end}).toList(),
          'totalHours': widget.totalHours,
          'totalAmount': widget.totalAmount,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': Timestamp.fromDate(DateTime.now().add(Duration(minutes: 10))),
        };

        transaction.set(_firestore.collection('turf_bookings').doc(newBookingId), bookingData);

        // Mark slots as booked
        for (var slot in widget.slots) {
          currentSlots[slot.start] = true;
        }

        transaction.set(slotsRef, {
          'slots': currentSlots,
          'turfId': widget.turfId,
          'date': widget.selectedDate,
          'fieldSize': widget.fieldSize,
        }, SetOptions(merge: true));

        return {'success': true, 'bookingId': newBookingId};
      });

      if (result['success']) {
        setState(() {
          bookingId = result['bookingId'];
          isProcessing = false;
        });
        _startTimer();
      }
    } catch (e) {
      setState(() => isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - Duration(seconds: 1);
        } else {
          _timerExpired = true;
          timer.cancel();
          _handleTimeout();
        }
      });
    });
  }

  Future<void> _checkBookingStatus() async {
    if (bookingId == null) return;

    try {
      final doc = await _firestore.collection('turf_bookings').doc(bookingId).get();
      if (!doc.exists || doc.data()?['status'] != 'pending') {
        // Booking was cleaned up
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking expired. Please try again.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        // Calculate remaining time
        final expiresAt = (doc.data()?['expiresAt'] as Timestamp?)?.toDate();
        if (expiresAt != null) {
          final remaining = expiresAt.difference(DateTime.now());
          if (remaining.isNegative) {
            _handleTimeout();
          } else {
            setState(() {
              _remainingTime = remaining;
            });
          }
        }
      }
    } catch (e) {
      print('Error checking booking status: $e');
    }
  }

  void _handleTimeout() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Time Expired', style: TextStyle(fontFamily: 'Regular')),
        content: Text(
          'Your booking time has expired. The slots have been released.',
          style: TextStyle(fontFamily: 'Regular'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close checkout page
            },
            child: Text('OK', style: TextStyle(fontFamily: 'Regular')),
          ),
        ],
      ),
    );
  }

  Future<void> _proceedToPayment() async {
    if (!_formKey.currentState!.validate()) return;
    if (bookingId == null || _timerExpired) return;

    setState(() => isProcessing = true);

    try {
      // Update booking with user details
      await _firestore.collection('turf_bookings').doc(bookingId).update({
        'userDetails': {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      });

      // TODO: Integrate with payment gateway
      // For now, navigate to payment page
      _showPaymentDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Payment', style: TextStyle(fontFamily: 'Regular')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Booking ID: $bookingId',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            SizedBox(height: 8),
            Text(
              'Amount: ₹${widget.totalAmount}',
              style: TextStyle(
                fontFamily: 'Regular',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Payment gateway integration pending',
              style: TextStyle(color: Colors.grey, fontFamily: 'Regular'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close checkout
            },
            child: Text('Cancel', style: TextStyle(fontFamily: 'Regular')),
          ),
          ElevatedButton(
            onPressed: () async {
              // Simulate payment success
              await _firestore.collection('turf_bookings').doc(bookingId).update({
                'status': 'confirmed',
                'paidAt': FieldValue.serverTimestamp(),
              });
              
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close checkout
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking confirmed!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Pay Now', style: TextStyle(fontFamily: 'Regular')),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (bookingId != null && !_timerExpired) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Cancel Booking?', style: TextStyle(fontFamily: 'Regular')),
              content: Text(
                'Your booking will be cancelled and slots will be released.',
                style: TextStyle(fontFamily: 'Regular'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Stay', style: TextStyle(fontFamily: 'Regular')),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Leave', style: TextStyle(fontFamily: 'Regular', color: Colors.red)),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          surfaceTintColor: whiteColor,
          centerTitle: true,
          title: Text('Checkout', style: TextStyle(fontFamily: 'Regular')),
        ),
        body: isProcessing
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timer Warning
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _remainingTime.inMinutes < 3 ? Colors.red.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _remainingTime.inMinutes < 3 ? Colors.red : Colors.orange,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: _remainingTime.inMinutes < 3 ? Colors.red : Colors.orange,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Complete payment within',
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(_remainingTime),
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: _remainingTime.inMinutes < 3 ? Colors.red : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Booking Summary
                      Text(
                        'Booking Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular',
                        ),
                      ),
                      SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Turf', widget.turfData['name'] ?? ''),
                              _buildDetailRow('Date', widget.selectedDate),
                              _buildDetailRow('Field Size', widget.fieldSize),
                              _buildDetailRow('Session', widget.session),
                              _buildDetailRow('Duration', '${widget.totalHours.toStringAsFixed(1)} hours'),
                              Divider(),
                              _buildDetailRow(
                                'Total Amount',
                                '₹${widget.totalAmount}',
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // User Details
                      Text(
                        'Your Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular',
                        ),
                      ),
                      SizedBox(height: 12),

                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
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
                          border: OutlineInputBorder(),
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
                          border: OutlineInputBorder(),
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

                      SizedBox(height: 32),

                      // Payment Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _timerExpired ? null : _proceedToPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blackColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _timerExpired ? 'Time Expired' : 'Proceed to Payment',
                            style: TextStyle(
                              fontSize: 18,
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
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.green.shade700 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}