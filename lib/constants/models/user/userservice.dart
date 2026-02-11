// User Service for Firestore Operations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin/constants/models/user/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================== CREATE USER ====================

  /// Create user document after OTP login
  Future<void> createUserDocument(String phoneNumber) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    // Only create if doesn't exist
    if (!docSnapshot.exists) {
      final userData = {
        'userId': user.uid,
        'phoneNumber': phoneNumber,
        'name': null,
        'email': null,
        'profilePicUrl': null,
        'eventBookings': [],
        'turfBookings': [],
        'ticList': {'events': [], 'turfs': [], 'artists': [], 'dining': []},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
      };

      await userDoc.set(userData);
      print('User document created for ${user.uid}');
    } else {
      print('User document already exists');
    }
  }

  // ==================== GET USER ====================

  Future<UserModel?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc);
  }

  Stream<UserModel?> getUserDataStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  // ==================== UPDATE USER PROFILE ====================

  Future<void> updateProfile({
    String? name,
    String? email,
    String? profilePicUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (name != null) updates['name'] = name;
    if (email != null) updates['email'] = email;
    if (profilePicUrl != null) updates['profilePicUrl'] = profilePicUrl;

    await _firestore.collection('users').doc(user.uid).update(updates);
  }

  // ==================== TICLIST OPERATIONS ====================

  /// Add item to TicList
  Future<void> addToTicList(String itemId, TicListItemType type) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final fieldName = _getTicListFieldName(type);

    await _firestore.collection('users').doc(user.uid).update({
      'ticList.$fieldName': FieldValue.arrayUnion([itemId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove item from TicList
  Future<void> removeFromTicList(String itemId, TicListItemType type) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final fieldName = _getTicListFieldName(type);

    await _firestore.collection('users').doc(user.uid).update({
      'ticList.$fieldName': FieldValue.arrayRemove([itemId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Check if item is in TicList
  Future<bool> isInTicList(String itemId, TicListItemType type) async {
    final userData = await getUserData();
    if (userData == null) return false;

    switch (type) {
      case TicListItemType.event:
        return userData.ticList.events.contains(itemId);
      case TicListItemType.turf:
        return userData.ticList.turfs.contains(itemId);
      case TicListItemType.artist:
        return userData.ticList.artists.contains(itemId);
      case TicListItemType.dining:
        return userData.ticList.dining.contains(itemId);
    }
  }

  // ==================== BOOKING OPERATIONS ====================

  /// Add event booking
  Future<void> addEventBooking(String bookingId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('users').doc(user.uid).update({
      'eventBookings': FieldValue.arrayUnion([bookingId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveUserBooking({
    required String bookingId,
    required String bookingType, // "event" | "turf"
    required Map<String, dynamic> bookingData,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookings')
        .doc(bookingId)
        .set({
          ...bookingData,
          'bookingType': bookingType,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<QuerySnapshot> getUserBookingsStream() {
    final user = _auth.currentUser;

  
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Add turf booking
  Future<void> addTurfBooking(String bookingId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('users').doc(user.uid).update({
      'turfBookings': FieldValue.arrayUnion([bookingId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get user's event bookings
  Future<List<Map<String, dynamic>>> getUserEventBookings() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final userData = await getUserData();
    if (userData == null || userData.eventBookings.isEmpty) return [];

    final bookings = await Future.wait(
      userData.eventBookings.map((bookingId) async {
        final doc =
            await _firestore.collection('bookings').doc(bookingId).get();
        if (doc.exists) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }
        return null;
      }),
    );

    return bookings.whereType<Map<String, dynamic>>().toList();
  }

  /// Get user's turf bookings
  Future<List<Map<String, dynamic>>> getUserTurfBookings() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final userData = await getUserData();
    if (userData == null || userData.turfBookings.isEmpty) return [];

    final bookings = await Future.wait(
      userData.turfBookings.map((bookingId) async {
        final doc =
            await _firestore.collection('turf_bookings').doc(bookingId).get();
        if (doc.exists) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }
        return null;
      }),
    );

    return bookings.whereType<Map<String, dynamic>>().toList();
  }

  // ==================== HELPER METHODS ====================

  String _getTicListFieldName(TicListItemType type) {
    switch (type) {
      case TicListItemType.event:
        return 'events';
      case TicListItemType.turf:
        return 'turfs';
      case TicListItemType.artist:
        return 'artists';
      case TicListItemType.dining:
        return 'dining';
    }
  }

  // ==================== CHECK PROFILE COMPLETION ====================

  Future<bool> isProfileComplete() async {
    final userData = await getUserData();
    if (userData == null) return false;

    return userData.name != null &&
        userData.name!.isNotEmpty &&
        userData.email != null &&
        userData.email!.isNotEmpty;
  }
}
