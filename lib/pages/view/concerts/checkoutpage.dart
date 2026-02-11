import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/user/userservice.dart';
import 'package:ticpin/constants/size.dart';

class EventCheckoutPage extends StatefulWidget {
  final String eventId;
  final Map<String, dynamic> eventData;
  final List<Map<String, dynamic>> selectedTickets;
  final int totalAmount;

  const EventCheckoutPage({
    Key? key,
    required this.eventId,
    required this.eventData,
    required this.selectedTickets,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<EventCheckoutPage> createState() => _EventCheckoutPageState();
}

class _EventCheckoutPageState extends State<EventCheckoutPage>
    with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

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
    if (state == AppLifecycleState.resumed && bookingId != null) {
      _checkBookingStatus();
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.getUserData();
      if (userData != null) {
        _emailController.text = userData.email ?? '';
        _nameController.text = userData.name ?? '';
        _phoneController.text = userData.phoneNumber;
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {}
  }

  Future<void> _createPendingBooking() async {
    final user = _auth.currentUser;
    if (user == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => isProcessing = true);

    try {
      final result = await _firestore.runTransaction<Map<String, dynamic>>((
        transaction,
      ) async {
        // Read event document
        final eventRef = _firestore.collection('events').doc(widget.eventId);
        final eventDoc = await transaction.get(eventRef);

        if (!eventDoc.exists) {
          throw Exception('Event not found');
        }

        final eventData = eventDoc.data()!;
        final List<dynamic> tickets = List.from(eventData['tickets'] ?? []);

        // Check availability and update tickets
        for (var selectedTicket in widget.selectedTickets) {
          final ticketId = selectedTicket['ticketId'];
          final requestedQty = selectedTicket['quantity'];

          // Find the ticket
          int ticketIndex = tickets.indexWhere((t) => t['id'] == ticketId);
          if (ticketIndex == -1) {
            throw Exception('Ticket type not found');
          }

          final ticketData = tickets[ticketIndex];

          // Check booking cutoff
          final Timestamp? cutoff = ticketData['bookingCutoff'];
          if (cutoff != null && Timestamp.now().compareTo(cutoff) > 0) {
            throw Exception('Booking period has ended');
          }

          final int totalQuantity = ticketData['quantity'] ?? 0;
          final int currentAvailable = ticketData['available'] ?? totalQuantity;

          // Check availability
          if (currentAvailable < requestedQty) {
            throw Exception(
              'Only $currentAvailable ${ticketData['type']} tickets available',
            );
          }

          // Reserve tickets
          final int newAvailable =
              currentAvailable - (requestedQty as num).toInt();
          tickets[ticketIndex]['available'] = newAvailable;
        }

        // Update event tickets
        transaction.update(eventRef, {'tickets': tickets});

        // Create booking
        final newBookingId = _firestore.collection('bookings').doc().id;
        final bookingData = {
          'bookingId': newBookingId,
          'eventId': widget.eventId,
          'eventName': widget.eventData['name'] ?? '',
          'userId': user.uid,
          'tickets': widget.selectedTickets,
          'totalAmount': widget.totalAmount,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'expiresAt': Timestamp.fromDate(
            DateTime.now().add(Duration(minutes: 10)),
          ),
        };

        transaction.set(
          _firestore.collection('bookings').doc(newBookingId),
          bookingData,
        );

        transaction.set(
  _firestore
      .collection('users')
      .doc(user.uid)
      .collection('bookings')
      .doc(newBookingId),
  {
    'bookingId' :newBookingId, 
    'bookingType': 'event',
    'createdAt': FieldValue.serverTimestamp(),
  },
);

        return {'success': true, 'bookingId': newBookingId};
      }, timeout: const Duration(seconds: 10));

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
      final doc = await _firestore.collection('bookings').doc(bookingId).get();
      if (!doc.exists || doc.data()?['status'] != 'pending') {
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
      builder:
          (context) => AlertDialog(
            title: Text(
              'Time Expired',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            content: Text(
              'Your booking time has expired. The tickets have been released.',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
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
      await _firestore.collection('bookings').doc(bookingId).update({
        'userDetails': {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      });

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
      builder:
          (context) => AlertDialog(
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(fontFamily: 'Regular')),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _firestore.collection('bookings').doc(bookingId).update(
                    {
                      'status': 'confirmed',
                      'paidAt': FieldValue.serverTimestamp(),
                    },
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);

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
            builder:
                (context) => AlertDialog(
                  title: Text(
                    'Cancel Booking?',
                    style: TextStyle(fontFamily: 'Regular'),
                  ),
                  content: Text(
                    'Your booking will be cancelled and tickets will be released.',
                    style: TextStyle(fontFamily: 'Regular'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Stay',
                        style: TextStyle(fontFamily: 'Regular'),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Leave',
                        style: TextStyle(
                          fontFamily: 'Regular',
                          color: Colors.red,
                        ),
                      ),
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
        body:
            isProcessing
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
                            color:
                                _remainingTime.inMinutes < 3
                                    ? Colors.red.shade50
                                    : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  _remainingTime.inMinutes < 3
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color:
                                    _remainingTime.inMinutes < 3
                                        ? Colors.red
                                        : Colors.orange,
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
                                        color:
                                            _remainingTime.inMinutes < 3
                                                ? Colors.red
                                                : Colors.orange,
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
                          color: whiteColor,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.eventData['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 12),
                                ...widget.selectedTickets.map((ticket) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${ticket['ticketType']} x${ticket['quantity']}',
                                          style: TextStyle(
                                            fontFamily: 'Regular',
                                          ),
                                        ),
                                        Text(
                                          '₹${ticket['subtotal']}',
                                          style: TextStyle(
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Amount',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                      ),
                                    ),
                                    Text(
                                      '₹${widget.totalAmount}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
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
                              _timerExpired
                                  ? 'Time Expired'
                                  : 'Proceed to Payment',
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
}
