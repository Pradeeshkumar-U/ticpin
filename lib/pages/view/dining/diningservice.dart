// dining_booking_model.dart
// dining_booking_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiningBooking {
  final String bookingId;
  final String diningId;
  final String diningName;
  final String userId;
  final String bookingType; // 'table' or 'bill'
  final String status; // 'confirmed' or 'cancelled'
  final DateTime createdAt;
  final DateTime? cancelledAt;
  
  // For table bookings
  final String? date;
  final String? timeSlot;
  final String? startTime;
  final String? endTime;
  final int? numberOfPeople;
  final int? advanceAmount;
  final DateTime? paidAt;
  
  // For bill payments
  final int? billAmount;
  final DateTime? billPaidAt;
  
  // User details
  final Map<String, dynamic>? userDetails;

  DiningBooking({
    required this.bookingId,
    required this.diningId,
    required this.diningName,
    required this.userId,
    required this.bookingType,
    required this.status,
    required this.createdAt,
    this.cancelledAt,
    this.date,
    this.timeSlot,
    this.startTime,
    this.endTime,
    this.numberOfPeople,
    this.advanceAmount,
    this.paidAt,
    this.billAmount,
    this.billPaidAt,
    this.userDetails,
  });

  factory DiningBooking.fromMap(Map<String, dynamic> map) {
    return DiningBooking(
      bookingId: map['bookingId'] ?? '',
      diningId: map['diningId'] ?? '',
      diningName: map['diningName'] ?? '',
      userId: map['userId'] ?? '',
      bookingType: map['bookingType'] ?? 'table',
      status: map['status'] ?? 'confirmed',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      cancelledAt: map['cancelledAt'] != null 
          ? (map['cancelledAt'] as Timestamp).toDate() 
          : null,
      date: map['date'],
      timeSlot: map['timeSlot'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      numberOfPeople: map['numberOfPeople'],
      advanceAmount: map['advanceAmount'],
      paidAt: map['paidAt'] != null 
          ? (map['paidAt'] as Timestamp).toDate() 
          : null,
      billAmount: map['billAmount'],
      billPaidAt: map['billPaidAt'] != null 
          ? (map['billPaidAt'] as Timestamp).toDate() 
          : null,
      userDetails: map['userDetails'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'diningId': diningId,
      'diningName': diningName,
      'userId': userId,
      'bookingType': bookingType,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'cancelledAt': cancelledAt != null 
          ? Timestamp.fromDate(cancelledAt!) 
          : null,
      'date': date,
      'timeSlot': timeSlot,
      'startTime': startTime,
      'endTime': endTime,
      'numberOfPeople': numberOfPeople,
      'advanceAmount': advanceAmount,
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
      'billAmount': billAmount,
      'billPaidAt': billPaidAt != null 
          ? Timestamp.fromDate(billPaidAt!) 
          : null,
      'userDetails': userDetails,
    };
  }

  bool get isTableBooking => bookingType == 'table';
  bool get isBillPayment => bookingType == 'bill';
  bool get isActive => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  
  // Check if booking time is active (between start and end time)
  bool isBookingTimeActive() {
    if (!isTableBooking || date == null || startTime == null || endTime == null) {
      return false;
    }
    
    try {
      final now = DateTime.now();
      final bookingDate = DateFormat('yyyy-MM-dd').parse(date!);
      
      // Check if today is the booking date
      if (!DateUtils.isSameDay(now, bookingDate)) {
        return false;
      }
      
      // Parse start and end times
      final startDateTime = _parseTimeOnDate(bookingDate, startTime!);
      final endDateTime = _parseTimeOnDate(bookingDate, endTime!);
      
      // Check if current time is between start and end
      return now.isAfter(startDateTime) && now.isBefore(endDateTime);
    } catch (e) {
      return false;
    }
  }
  
  // Check if booking time has passed
  bool hasBookingTimePassed() {
    if (!isTableBooking || date == null || endTime == null) {
      return false;
    }
    
    try {
      final now = DateTime.now();
      final bookingDate = DateFormat('yyyy-MM-dd').parse(date!);
      final endDateTime = _parseTimeOnDate(bookingDate, endTime!);
      
      return now.isAfter(endDateTime);
    } catch (e) {
      return false;
    }
  }
  
  // Check if booking is upcoming (before start time)
  bool isUpcoming() {
    if (!isTableBooking || date == null || startTime == null) {
      return false;
    }
    
    try {
      final now = DateTime.now();
      final bookingDate = DateFormat('yyyy-MM-dd').parse(date!);
      final startDateTime = _parseTimeOnDate(bookingDate, startTime!);
      
      return now.isBefore(startDateTime);
    } catch (e) {
      return false;
    }
  }
  
  DateTime _parseTimeOnDate(DateTime date, String time) {
    final timeParts = DateFormat('h:mm a').parse(time);
    return DateTime(
      date.year,
      date.month,
      date.day,
      timeParts.hour,
      timeParts.minute,
    );
  }
}



class DiningBookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create table booking with 10% advance payment
  Future<String?> createTableBooking({
    required String diningId,
    required String diningName,
    required String date,
    required String timeSlot,
    required String startTime,
    required String endTime,
    required int numberOfPeople,
    required int totalEstimatedAmount,
    required Map<String, dynamic> userDetails,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      final bookingId = _firestore.collection('dining_bookings').doc().id;
      final advanceAmount = (totalEstimatedAmount * 0.1).round();

      final booking = DiningBooking(
        bookingId: bookingId,
        diningId: diningId,
        diningName: diningName,
        userId: user.uid,
        bookingType: 'table',
        status: 'confirmed',
        createdAt: DateTime.now(),
        date: date,
        timeSlot: timeSlot,
        startTime: startTime,
        endTime: endTime,
        numberOfPeople: numberOfPeople,
        advanceAmount: advanceAmount,
        paidAt: DateTime.now(),
        userDetails: userDetails,
      );

      await _firestore.runTransaction((transaction) async {
        // Create booking document
        transaction.set(
          _firestore.collection('dining_bookings').doc(bookingId),
          booking.toMap(),
        );

        // Add to user's bookings subcollection
        transaction.set(
          _firestore
              .collection('users')
              .doc(user.uid)
              .collection('bookings')
              .doc(bookingId),
          {
            'bookingId': bookingId,
            'bookingType': 'dining',
            'createdAt': FieldValue.serverTimestamp(),
          },
        );

        // Mark time slot as booked
        final slotDocId = '${diningId}_$date';
        final slotRef = _firestore.collection('dining_slots').doc(slotDocId);
        
        transaction.set(
          slotRef,
          {
            'diningId': diningId,
            'date': date,
            'slots': {
              startTime: FieldValue.increment(numberOfPeople),
            },
          },
          SetOptions(merge: true),
        );
      });

      return bookingId;
    } catch (e) {
      print('Error creating table booking: $e');
      rethrow;
    }
  }

  // Create bill payment booking
  Future<String?> createBillPayment({
    required String diningId,
    required String diningName,
    required int billAmount,
    required Map<String, dynamic> userDetails,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      final bookingId = _firestore.collection('dining_bookings').doc().id;

      final booking = DiningBooking(
        bookingId: bookingId,
        diningId: diningId,
        diningName: diningName,
        userId: user.uid,
        bookingType: 'bill',
        status: 'confirmed',
        createdAt: DateTime.now(),
        billAmount: billAmount,
        billPaidAt: DateTime.now(),
        userDetails: userDetails,
      );

      await _firestore.runTransaction((transaction) async {
        // Create booking document
        transaction.set(
          _firestore.collection('dining_bookings').doc(bookingId),
          booking.toMap(),
        );

        // Add to user's bookings subcollection
        transaction.set(
          _firestore
              .collection('users')
              .doc(user.uid)
              .collection('bookings')
              .doc(bookingId),
          {
            'bookingId': bookingId,
            'bookingType': 'dining',
            'createdAt': FieldValue.serverTimestamp(),
          },
        );
      });

      return bookingId;
    } catch (e) {
      print('Error creating bill payment: $e');
      rethrow;
    }
  }

  // Update table booking (modify time slot or number of people)
  Future<void> updateTableBooking({
    required String bookingId,
    String? newDate,
    String? newTimeSlot,
    String? newStartTime,
    String? newEndTime,
    int? newNumberOfPeople,
  }) async {
    try {
      final bookingDoc = await _firestore
          .collection('dining_bookings')
          .doc(bookingId)
          .get();

      if (!bookingDoc.exists) {
        throw Exception('Booking not found');
      }

      final booking = DiningBooking.fromMap(bookingDoc.data()!);

      if (!booking.isTableBooking) {
        throw Exception('Can only modify table bookings');
      }

      if (booking.isCancelled) {
        throw Exception('Cannot modify cancelled booking');
      }

      await _firestore.runTransaction((transaction) async {
        // Remove old slot booking
        if (booking.date != null && booking.startTime != null) {
          final oldSlotDocId = '${booking.diningId}_${booking.date}';
          final oldSlotRef = _firestore
              .collection('dining_slots')
              .doc(oldSlotDocId);
          
          transaction.update(oldSlotRef, {
            'slots.${booking.startTime}': FieldValue.increment(
              -(booking.numberOfPeople ?? 0),
            ),
          });
        }

        // Update booking
        final updateData = <String, dynamic>{};
        if (newDate != null) updateData['date'] = newDate;
        if (newTimeSlot != null) updateData['timeSlot'] = newTimeSlot;
        if (newStartTime != null) updateData['startTime'] = newStartTime;
        if (newEndTime != null) updateData['endTime'] = newEndTime;
        if (newNumberOfPeople != null) {
          updateData['numberOfPeople'] = newNumberOfPeople;
        }

        transaction.update(
          _firestore.collection('dining_bookings').doc(bookingId),
          updateData,
        );

        // Add new slot booking
        final newSlotDate = newDate ?? booking.date!;
        final newSlotTime = newStartTime ?? booking.startTime!;
        final newPeople = newNumberOfPeople ?? booking.numberOfPeople!;

        final newSlotDocId = '${booking.diningId}_$newSlotDate';
        final newSlotRef = _firestore
            .collection('dining_slots')
            .doc(newSlotDocId);
        
        transaction.set(
          newSlotRef,
          {
            'diningId': booking.diningId,
            'date': newSlotDate,
            'slots': {
              newSlotTime: FieldValue.increment(newPeople),
            },
          },
          SetOptions(merge: true),
        );
      });
    } catch (e) {
      print('Error updating table booking: $e');
      rethrow;
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      final bookingDoc = await _firestore
          .collection('dining_bookings')
          .doc(bookingId)
          .get();

      if (!bookingDoc.exists) {
        throw Exception('Booking not found');
      }

      final booking = DiningBooking.fromMap(bookingDoc.data()!);

      if (booking.isCancelled) {
        throw Exception('Booking already cancelled');
      }

      await _firestore.runTransaction((transaction) async {
        // Update booking status
        transaction.update(
          _firestore.collection('dining_bookings').doc(bookingId),
          {
            'status': 'cancelled',
            'cancelledAt': FieldValue.serverTimestamp(),
          },
        );

        // Release slot if table booking
        if (booking.isTableBooking && 
            booking.date != null && 
            booking.startTime != null) {
          final slotDocId = '${booking.diningId}_${booking.date}';
          final slotRef = _firestore.collection('dining_slots').doc(slotDocId);
          
          transaction.update(slotRef, {
            'slots.${booking.startTime}': FieldValue.increment(
              -(booking.numberOfPeople ?? 0),
            ),
          });
        }
      });
    } catch (e) {
      print('Error cancelling booking: $e');
      rethrow;
    }
  }

  // Get user's dining bookings
  Stream<List<DiningBooking>> getUserDiningBookings() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('dining_bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DiningBooking.fromMap(doc.data()))
          .toList();
    });
  }

  // Get active table booking for specific dining and date
  Future<DiningBooking?> getActiveTableBooking(
    String diningId,
    String date,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final snapshot = await _firestore
          .collection('dining_bookings')
          .where('userId', isEqualTo: user.uid)
          .where('diningId', isEqualTo: diningId)
          .where('date', isEqualTo: date)
          .where('bookingType', isEqualTo: 'table')
          .where('status', isEqualTo: 'confirmed')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return DiningBooking.fromMap(snapshot.docs.first.data());
    } catch (e) {
      print('Error getting active table booking: $e');
      return null;
    }
  }

  // Check slot availability
  Future<bool> isSlotAvailable({
    required String diningId,
    required String date,
    required String startTime,
    required int numberOfPeople,
    required int maxCapacity,
  }) async {
    try {
      final slotDocId = '${diningId}_$date';
      final slotDoc = await _firestore
          .collection('dining_slots')
          .doc(slotDocId)
          .get();

      if (!slotDoc.exists) return true;

      final slots = slotDoc.data()?['slots'] as Map<String, dynamic>?;
      if (slots == null) return true;

      final bookedPeople = slots[startTime] ?? 0;
      return (bookedPeople + numberOfPeople) <= maxCapacity;
    } catch (e) {
      print('Error checking slot availability: $e');
      return false;
    }
  }

  // Get booked slots for a date
  Future<Map<String, int>> getBookedSlots(
    String diningId,
    String date,
  ) async {
    try {
      final slotDocId = '${diningId}_$date';
      final slotDoc = await _firestore
          .collection('dining_slots')
          .doc(slotDocId)
          .get();

      if (!slotDoc.exists) return {};

      final slots = slotDoc.data()?['slots'] as Map<String, dynamic>?;
      if (slots == null) return {};

      return Map<String, int>.from(
        slots.map((key, value) => MapEntry(key, value as int)),
      );
    } catch (e) {
      print('Error getting booked slots: $e');
      return {};
    }
  }
}