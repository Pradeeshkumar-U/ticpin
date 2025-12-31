
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class SnackItem {
  final String name;
  final String det;
  final int price;
  int quan;

  SnackItem({
    required this.name,
    required this.det,
    required this.price,
    this.quan = 0,
  });

  int get totalPrice => price * quan;
}



class BookingTimerService {
  static final BookingTimerService _instance = BookingTimerService._internal();
  factory BookingTimerService() => _instance;
  BookingTimerService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream controllers for real-time updates
  final _pendingBookingController = StreamController<PendingBooking?>.broadcast();
  final _timerController = StreamController<Duration>.broadcast();

  Stream<PendingBooking?> get pendingBookingStream => _pendingBookingController.stream;
  Stream<Duration> get timerStream => _timerController.stream;

  PendingBooking? _currentPendingBooking;
  Timer? _countdownTimer;
  StreamSubscription? _bookingSubscription;

  PendingBooking? get currentPendingBooking => _currentPendingBooking;

  // Initialize and check for pending bookings
  Future<void> initialize() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await checkPendingBookings();
  }

  // Check for any pending bookings for current user
  Future<void> checkPendingBookings() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Get user's bookings collection
      final userBookingsSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .where('bookingType', isEqualTo: 'turf')
          .get();

      for (var bookingDoc in userBookingsSnapshot.docs) {
        final bookingId = bookingDoc.data()['bookingId'] as String?;
        if (bookingId == null) continue;

        // Get the actual booking details
        final bookingSnapshot = await _firestore
            .collection('turf_bookings')
            .doc(bookingId)
            .get();

        if (bookingSnapshot.exists) {
          final data = bookingSnapshot.data()!;
          final status = data['status'] as String?;

          if (status == 'pending') {
            final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
            if (expiresAt != null && expiresAt.isAfter(DateTime.now())) {
              // Found a valid pending booking
              _setPendingBooking(PendingBooking(
                bookingId: bookingId,
                turfId: data['turfId'] as String,
                turfName: data['turfName'] as String,
                date: data['date'] as String,
                fieldSize: data['fieldSize'] as String,
                session: data['session'] as String,
                totalHours: (data['totalHours'] as num).toDouble(),
                totalAmount: data['totalAmount'] as int,
                expiresAt: expiresAt,
                slots: List<Map<String, dynamic>>.from(data['slots'] ?? []),
              ));
              return; // Only track one pending booking at a time
            }
          }
        }
      }

      // No pending booking found
      _clearPendingBooking();
    } catch (e) {
      print('Error checking pending bookings: $e');
    }
  }

  // Set a pending booking and start timer
  void _setPendingBooking(PendingBooking booking) {
    _currentPendingBooking = booking;
    _pendingBookingController.add(booking);
    _startTimer();
    _listenToBookingChanges();
  }

  // Start countdown timer
  void _startTimer() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentPendingBooking == null) {
        timer.cancel();
        return;
      }

      final remaining = _currentPendingBooking!.expiresAt.difference(DateTime.now());

      if (remaining.isNegative) {
        _handleTimeout();
        timer.cancel();
      } else {
        _timerController.add(remaining);
      }
    });
  }

  // Listen to booking document changes in real-time
  void _listenToBookingChanges() {
    _bookingSubscription?.cancel();

    if (_currentPendingBooking == null) return;

    _bookingSubscription = _firestore
        .collection('turf_bookings')
        .doc(_currentPendingBooking!.bookingId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        _clearPendingBooking();
        return;
      }

      final data = snapshot.data()!;
      final status = data['status'] as String?;

      if (status != 'pending') {
        // Booking completed or cancelled
        _clearPendingBooking();
      }
    });
  }

  // Handle booking timeout
  void _handleTimeout() {
    _clearPendingBooking();
  }

  // Clear pending booking
  void _clearPendingBooking() {
    _currentPendingBooking = null;
    _pendingBookingController.add(null);
    _countdownTimer?.cancel();
    _bookingSubscription?.cancel();
  }

  // Dispose resources
  void dispose() {
    _countdownTimer?.cancel();
    _bookingSubscription?.cancel();
    _pendingBookingController.close();
    _timerController.close();
  }
}

class PendingBooking {
  final String bookingId;
  final String turfId;
  final String turfName;
  final String date;
  final String fieldSize;
  final String session;
  final double totalHours;
  final int totalAmount;
  final DateTime expiresAt;
  final List<Map<String, dynamic>> slots;

  PendingBooking({
    required this.bookingId,
    required this.turfId,
    required this.turfName,
    required this.date,
    required this.fieldSize,
    required this.session,
    required this.totalHours,
    required this.totalAmount,
    required this.expiresAt,
    required this.slots,
  });

  Duration get remainingTime => expiresAt.difference(DateTime.now());
  bool get isExpired => remainingTime.isNegative;
}