// // Turf Partner Admin Service for Firestore Operations

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ticpin_play/constants/model.dart';

// class TurfPartnerAdminService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // ==================== CREATE ADMIN ====================

//   /// Create turf partner admin document after OTP login
//   Future<void> createAdminDocument(String phoneNumber) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     final adminDoc = _firestore.collection('play_partner_admins').doc(user.uid);
//     final docSnapshot = await adminDoc.get();

//     // Only create if doesn't exist
//     if (!docSnapshot.exists) {
//       final adminData = {
//         'adminId': user.uid,
//         'phoneNumber': phoneNumber,
//         'name': null,
//         'email': null,
//         'profilePicUrl': null,
//         'turfIds': [],
//         'status': 'pending',
//         'permissions': {
//           'canManageTurfs': true,
//           'canViewBookings': true,
//           'canCancelBookings': false,
//           'canUpdatePricing': true,
//           'canViewAnalytics': true,
//           'canManageSlots': true,
//           'canProcessRefunds': false,
//         },
//         'businessInfo': null,
//         'bankDetails': null,
//         'bookingIds': [],
//         'documentVerification': {
//           'aadharNumber': null,
//           'aadharDocUrl': null,
//           'panCardUrl': null,
//           'gstCertificateUrl': null,
//           'businessLicenseUrl': null,
//           'additionalDocUrls': [],
//           'aadharStatus': 'pending',
//           'panStatus': 'pending',
//           'gstStatus': 'notProvided',
//           'businessLicenseStatus': 'notProvided',
//           'rejectionReason': null,
//         },
//         'stats': {
//           'totalTurfs': 0,
//           'totalBookings': 0,
//           'activeBookings': 0,
//           'completedBookings': 0,
//           'cancelledBookings': 0,
//           'totalRevenue': 0.0,
//           'pendingPayouts': 0.0,
//           'averageRating': 0.0,
//           'totalReviews': 0,
//         },
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': null,
//         'approvedAt': null,
//         'approvedBy': null,
//       };

//       await adminDoc.set(adminData);
//       print('Turf partner admin document created for ${user.uid}');
//     } else {
//       print('Turf partner admin document already exists');
//     }
//   }

//   // ==================== GET ADMIN ====================

//   Future<TurfPartnerAdminModel?> getAdminData() async {
//     final user = _auth.currentUser;
//     if (user == null) return null;

//     final doc = await _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .get();
//     if (!doc.exists) return null;

//     return TurfPartnerAdminModel.fromFirestore(doc);
//   }

//   Stream<TurfPartnerAdminModel?> getAdminDataStream() {
//     final user = _auth.currentUser;
//     if (user == null) return Stream.value(null);

//     return _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .snapshots()
//         .map(
//           (doc) => doc.exists ? TurfPartnerAdminModel.fromFirestore(doc) : null,
//         );
//   }

//   /// Get admin data by ID (for super admin use)
//   Future<TurfPartnerAdminModel?> getAdminDataById(String adminId) async {
//     final doc = await _firestore
//         .collection('play_partner_admins')
//         .doc(adminId)
//         .get();
//     if (!doc.exists) return null;

//     return TurfPartnerAdminModel.fromFirestore(doc);
//   }

//   // ==================== UPDATE ADMIN PROFILE ====================

//   Future<void> updateProfile({
//     String? name,
//     String? email,
//     String? profilePicUrl,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     final updates = <String, dynamic>{
//       'updatedAt': FieldValue.serverTimestamp(),
//     };

//     if (name != null) updates['name'] = name;
//     if (email != null) updates['email'] = email;
//     if (profilePicUrl != null) updates['profilePicUrl'] = profilePicUrl;

//     await _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .update(updates);
//   }

//   // ==================== UPDATE BUSINESS INFO ====================

//   Future<void> updateBusinessInfo(BusinessInfo businessInfo) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore.collection('play_partner_admins').doc(user.uid).update({
//       'businessInfo': businessInfo.toMap(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // ==================== UPDATE BANK DETAILS ====================

//   Future<void> updateBankDetails(BankDetails bankDetails) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore.collection('play_partner_admins').doc(user.uid).update({
//       'bankDetails': bankDetails.toMap(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // ==================== DOCUMENT VERIFICATION ====================

//   Future<void> uploadDocuments({
//     String? aadharNumber,
//     String? aadharDocUrl,
//     String? panCardUrl,
//     String? gstCertificateUrl,
//     String? businessLicenseUrl,
//     List<String>? additionalDocUrls,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     final updates = <String, dynamic>{
//       'updatedAt': FieldValue.serverTimestamp(),
//     };

//     if (aadharNumber != null) {
//       updates['documentVerification.aadharNumber'] = aadharNumber;
//     }
//     if (aadharDocUrl != null) {
//       updates['documentVerification.aadharDocUrl'] = aadharDocUrl;
//       updates['documentVerification.aadharStatus'] = 'pending';
//     }
//     if (panCardUrl != null) {
//       updates['documentVerification.panCardUrl'] = panCardUrl;
//       updates['documentVerification.panStatus'] = 'pending';
//     }
//     if (gstCertificateUrl != null) {
//       updates['documentVerification.gstCertificateUrl'] = gstCertificateUrl;
//       updates['documentVerification.gstStatus'] = 'pending';
//     }
//     if (businessLicenseUrl != null) {
//       updates['documentVerification.businessLicenseUrl'] = businessLicenseUrl;
//       updates['documentVerification.businessLicenseStatus'] = 'pending';
//     }
//     if (additionalDocUrls != null && additionalDocUrls.isNotEmpty) {
//       updates['documentVerification.additionalDocUrls'] = FieldValue.arrayUnion(
//         additionalDocUrls,
//       );
//     }

//     await _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .update(updates);
//   }

//   // ==================== ADMIN STATUS MANAGEMENT ====================

//   /// Update admin status (for super admin use)
//   Future<void> updateAdminStatus({
//     required String adminId,
//     required AdminStatus status,
//     String? rejectionReason,
//     String? approvedByUserId,
//   }) async {
//     final updates = <String, dynamic>{
//       'status': status.toString().split('.').last,
//       'updatedAt': FieldValue.serverTimestamp(),
//     };

//     if (status == AdminStatus.approved) {
//       updates['approvedAt'] = FieldValue.serverTimestamp();
//       if (approvedByUserId != null) {
//         updates['approvedBy'] = approvedByUserId;
//       }
//     }

//     if (status == AdminStatus.rejected && rejectionReason != null) {
//       updates['documentVerification.rejectionReason'] = rejectionReason;
//     }

//     await _firestore
//         .collection('play_partner_admins')
//         .doc(adminId)
//         .update(updates);
//   }

//   /// Verify specific document (for super admin use)
//   Future<void> verifyDocument({
//     required String adminId,
//     required String documentType, // 'aadhar', 'pan', 'gst', 'businessLicense'
//     required VerificationStatus status,
//     String? rejectionReason,
//   }) async {
//     final statusString = status.toString().split('.').last;

//     final updates = <String, dynamic>{
//       'documentVerification.${documentType}Status': statusString,
//       'updatedAt': FieldValue.serverTimestamp(),
//     };

//     if (status == VerificationStatus.rejected && rejectionReason != null) {
//       updates['documentVerification.rejectionReason'] = rejectionReason;
//     }

//     await _firestore
//         .collection('play_partner_admins')
//         .doc(adminId)
//         .update(updates);
//   }

//   // ==================== TURF MANAGEMENT ====================

//   /// Add turf to admin's managed turfs
//   Future<void> addTurf(String turfId) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore.collection('play_partner_admins').doc(user.uid).update({
//       'turfIds': FieldValue.arrayUnion([turfId]),
//       'stats.totalTurfs': FieldValue.increment(1),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   /// Remove turf from admin's managed turfs
//   Future<void> removeTurf(String turfId) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore.collection('play_partner_admins').doc(user.uid).update({
//       'turfIds': FieldValue.arrayRemove([turfId]),
//       'stats.totalTurfs': FieldValue.increment(-1),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   /// Get all turfs managed by this admin
//   Future<List<Map<String, dynamic>>> getManagedTurfs() async {
//     final user = _auth.currentUser;
//     if (user == null) return [];

//     final adminData = await getAdminData();
//     if (adminData == null || adminData.turfIds.isEmpty) return [];

//     final turfs = await Future.wait(
//       adminData.turfIds.map((turfId) async {
//         final doc = await _firestore.collection('turfs').doc(turfId).get();
//         if (doc.exists) {
//           return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
//         }
//         return null;
//       }),
//     );

//     return turfs.whereType<Map<String, dynamic>>().toList();
//   }

//   Stream<QuerySnapshot> getManagedTurfsStream() {
//     final user = _auth.currentUser;
//     if (user == null) return const Stream.empty();

//     return _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .snapshots()
//         .asyncExpand((adminDoc) {
//           if (!adminDoc.exists) return const Stream.empty();

//           final turfIds = List<String>.from(adminDoc.data()?['turfIds'] ?? []);
//           if (turfIds.isEmpty) return const Stream.empty();

//           return _firestore
//               .collection('turfs')
//               .where(FieldPath.documentId, whereIn: turfIds)
//               .snapshots();
//         });
//   }

//   // ==================== BOOKING OPERATIONS ====================

//   /// Add booking reference to admin
//   Future<void> addBooking(String bookingId) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore.collection('play_partner_admins').doc(user.uid).update({
//       'bookingIds': FieldValue.arrayUnion([bookingId]),
//       'stats.totalBookings': FieldValue.increment(1),
//       'stats.activeBookings': FieldValue.increment(1),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   /// Get all bookings for admin's turfs
//   Future<List<Map<String, dynamic>>> getAdminBookings() async {
//     final user = _auth.currentUser;
//     if (user == null) return [];

//     final adminData = await getAdminData();
//     if (adminData == null || adminData.bookingIds.isEmpty) return [];

//     final bookings = await Future.wait(
//       adminData.bookingIds.map((bookingId) async {
//         final doc = await _firestore
//             .collection('turf_bookings')
//             .doc(bookingId)
//             .get();
//         if (doc.exists) {
//           return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
//         }
//         return null;
//       }),
//     );

//     return bookings.whereType<Map<String, dynamic>>().toList();
//   }

//   Stream<QuerySnapshot> getAdminBookingsStream({
//     String? status, // 'active', 'completed', 'cancelled'
//     DateTime? startDate,
//     DateTime? endDate,
//   }) {
//     final user = _auth.currentUser;
//     if (user == null) return const Stream.empty();

//     Query query = _firestore
//         .collection('turf_bookings')
//         .where('adminId', isEqualTo: user.uid)
//         .orderBy('createdAt', descending: true);

//     if (status != null) {
//       query = query.where('status', isEqualTo: status);
//     }

//     if (startDate != null) {
//       query = query.where('bookingDate', isGreaterThanOrEqualTo: startDate);
//     }

//     if (endDate != null) {
//       query = query.where('bookingDate', isLessThanOrEqualTo: endDate);
//     }

//     return query.snapshots();
//   }

//   // ==================== STATS OPERATIONS ====================

//   /// Update admin statistics
//   Future<void> updateStats({
//     int? totalBookings,
//     int? activeBookings,
//     int? completedBookings,
//     int? cancelledBookings,
//     double? totalRevenue,
//     double? pendingPayouts,
//     double? averageRating,
//     int? totalReviews,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     final updates = <String, dynamic>{
//       'updatedAt': FieldValue.serverTimestamp(),
//     };

//     if (totalBookings != null) {
//       updates['stats.totalBookings'] = totalBookings;
//     }
//     if (activeBookings != null) {
//       updates['stats.activeBookings'] = activeBookings;
//     }
//     if (completedBookings != null) {
//       updates['stats.completedBookings'] = completedBookings;
//     }
//     if (cancelledBookings != null) {
//       updates['stats.cancelledBookings'] = cancelledBookings;
//     }
//     if (totalRevenue != null) {
//       updates['stats.totalRevenue'] = totalRevenue;
//     }
//     if (pendingPayouts != null) {
//       updates['stats.pendingPayouts'] = pendingPayouts;
//     }
//     if (averageRating != null) {
//       updates['stats.averageRating'] = averageRating;
//     }
//     if (totalReviews != null) {
//       updates['stats.totalReviews'] = totalReviews;
//     }

//     await _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .update(updates);
//   }

//   /// Increment revenue
//   Future<void> addRevenue(double amount) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore.collection('play_partner_admins').doc(user.uid).update({
//       'stats.totalRevenue': FieldValue.increment(amount),
//       'stats.pendingPayouts': FieldValue.increment(amount),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   /// Update booking completion
//   Future<void> completeBooking() async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore.collection('play_partner_admins').doc(user.uid).update({
//       'stats.activeBookings': FieldValue.increment(-1),
//       'stats.completedBookings': FieldValue.increment(1),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   /// Update booking cancellation
//   Future<void> cancelBooking() async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore.collection('play_partner_admins').doc(user.uid).update({
//       'stats.activeBookings': FieldValue.increment(-1),
//       'stats.cancelledBookings': FieldValue.increment(1),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // ==================== PERMISSIONS ====================

//   /// Update admin permissions (for super admin use)
//   Future<void> updatePermissions({
//     required String adminId,
//     required AdminPermissions permissions,
//   }) async {
//     await _firestore.collection('play_partner_admins').doc(adminId).update({
//       'permissions': permissions.toMap(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   /// Check if admin has specific permission
//   Future<bool> hasPermission(String permissionName) async {
//     final adminData = await getAdminData();
//     if (adminData == null) return false;

//     final permissions = adminData.permissions;
//     switch (permissionName) {
//       case 'canManageTurfs':
//         return permissions.canManageTurfs;
//       case 'canViewBookings':
//         return permissions.canViewBookings;
//       case 'canCancelBookings':
//         return permissions.canCancelBookings;
//       case 'canUpdatePricing':
//         return permissions.canUpdatePricing;
//       case 'canViewAnalytics':
//         return permissions.canViewAnalytics;
//       case 'canManageSlots':
//         return permissions.canManageSlots;
//       case 'canProcessRefunds':
//         return permissions.canProcessRefunds;
//       default:
//         return false;
//     }
//   }

//   // ==================== NOTIFICATIONS ====================

//   /// Save notification for admin
//   Future<void> saveNotification({
//     required String title,
//     required String message,
//     required String type, // 'booking', 'payment', 'system', 'alert'
//     Map<String, dynamic>? data,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .collection('notifications')
//         .add({
//           'title': title,
//           'message': message,
//           'type': type,
//           'data': data,
//           'isRead': false,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//   }

//   Stream<QuerySnapshot> getNotificationsStream() {
//     final user = _auth.currentUser;
//     if (user == null) return const Stream.empty();

//     return _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .collection('notifications')
//         .orderBy('createdAt', descending: true)
//         .limit(50)
//         .snapshots();
//   }

//   /// Mark notification as read
//   Future<void> markNotificationAsRead(String notificationId) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .collection('notifications')
//         .doc(notificationId)
//         .update({'isRead': true});
//   }

//   // ==================== PAYOUTS ====================

//   /// Save payout record
//   Future<void> savePayoutRecord({
//     required double amount,
//     required String payoutMethod, // 'bank', 'upi'
//     required String status, // 'pending', 'processing', 'completed', 'failed'
//     Map<String, dynamic>? bankDetails,
//     String? transactionId,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('No user logged in');

//     await _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .collection('payouts')
//         .add({
//           'amount': amount,
//           'payoutMethod': payoutMethod,
//           'status': status,
//           'bankDetails': bankDetails,
//           'transactionId': transactionId,
//           'createdAt': FieldValue.serverTimestamp(),
//           'processedAt': null,
//         });

//     // Update pending payouts
//     if (status == 'completed') {
//       await _firestore.collection('play_partner_admins').doc(user.uid).update({
//         'stats.pendingPayouts': FieldValue.increment(-amount),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     }
//   }

//   Stream<QuerySnapshot> getPayoutsStream() {
//     final user = _auth.currentUser;
//     if (user == null) return const Stream.empty();

//     return _firestore
//         .collection('play_partner_admins')
//         .doc(user.uid)
//         .collection('payouts')
//         .orderBy('createdAt', descending: true)
//         .snapshots();
//   }

//   // ==================== QUERY HELPERS ====================

//   /// Get all pending admin applications (for super admin)
//   Stream<QuerySnapshot> getPendingAdminsStream() {
//     return _firestore
//         .collection('play_partner_admins')
//         .where('status', isEqualTo: 'pending')
//         .orderBy('createdAt', descending: true)
//         .snapshots();
//   }

//   /// Get all approved admins (for super admin)
//   Stream<QuerySnapshot> getApprovedAdminsStream() {
//     return _firestore
//         .collection('play_partner_admins')
//         .where('status', isEqualTo: 'approved')
//         .orderBy('createdAt', descending: true)
//         .snapshots();
//   }

//   /// Search admins by name or email (for super admin)
//   Future<List<Map<String, dynamic>>> searchAdmins(String searchQuery) async {
//     final querySnapshot = await _firestore
//         .collection('play_partner_admins')
//         .where('name', isGreaterThanOrEqualTo: searchQuery)
//         .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
//         .get();

//     return querySnapshot.docs
//         .map((doc) => {'id': doc.id, ...doc.data()})
//         .toList();
//   }

//   // ==================== CHECK PROFILE COMPLETION ====================

//   Future<bool> isProfileComplete() async {
//     final adminData = await getAdminData();
//     if (adminData == null) return false;

//     return adminData.name != null &&
//         adminData.name!.isNotEmpty &&
//         adminData.email != null &&
//         adminData.email!.isNotEmpty;
//   }

//   Future<bool> isDocumentVerificationComplete() async {
//     final adminData = await getAdminData();
//     if (adminData == null) return false;

//     return adminData.documentVerification.isFullyVerified;
//   }

//   Future<bool> isBusinessInfoComplete() async {
//     final adminData = await getAdminData();
//     if (adminData == null) return false;

//     return adminData.businessInfo != null &&
//         adminData.businessInfo!.businessName != null &&
//         adminData.businessInfo!.businessName!.isNotEmpty;
//   }

//   Future<bool> isBankDetailsComplete() async {
//     final adminData = await getAdminData();
//     if (adminData == null) return false;

//     return adminData.bankDetails != null &&
//         adminData.bankDetails!.accountNumber != null &&
//         adminData.bankDetails!.accountNumber!.isNotEmpty &&
//         adminData.bankDetails!.ifscCode != null &&
//         adminData.bankDetails!.ifscCode!.isNotEmpty;
//   }
// }

// Turf Partner Admin Service for Firestore Operations - WITH REVENUE TRACKING

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin_play/constants/model.dart';

class TurfPartnerAdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================== CREATE ADMIN ====================

  /// Create turf partner admin document after OTP login
  Future<void> createAdminDocument(String phoneNumber) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final adminDoc = _firestore.collection('play_partner_admins').doc(user.uid);
    final docSnapshot = await adminDoc.get();

    // Only create if doesn't exist
    if (!docSnapshot.exists) {
      final adminData = {
        'adminId': user.uid,
        'phoneNumber': phoneNumber,
        'name': null,
        'email': null,
        'profilePicUrl': null,
        'turfIds': [],
        'status': 'pending',
        'permissions': {
          'canManageTurfs': true,
          'canViewBookings': true,
          'canCancelBookings': false,
          'canUpdatePricing': true,
          'canViewAnalytics': true,
          'canManageSlots': true,
          'canProcessRefunds': false,
        },
        'businessInfo': null,
        'bankDetails': null,
        'bookingIds': [],
        'documentVerification': {
          'aadharNumber': null,
          'aadharDocUrl': null,
          'panCardUrl': null,
          'gstCertificateUrl': null,
          'businessLicenseUrl': null,
          'additionalDocUrls': [],
          'aadharStatus': 'pending',
          'panStatus': 'pending',
          'gstStatus': 'notProvided',
          'businessLicenseStatus': 'notProvided',
          'rejectionReason': null,
        },
        'stats': {
          'totalTurfs': 0,
          'totalBookings': 0,
          'activeBookings': 0,
          'completedBookings': 0,
          'cancelledBookings': 0,
          'totalRevenue': 0.0,
          'ticpinAppRevenue': 0.0, // Revenue generated through Ticpin app
          'advancePaymentRevenue': 0.0, // 30% advance payments
          'fullPaymentRevenue': 0.0, // Full bookings
          'pendingPayouts': 0.0,
          'averageRating': 0.0,
          'totalReviews': 0,
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
        'approvedAt': null,
        'approvedBy': null,
      };

      await adminDoc.set(adminData);
      print('Turf partner admin document created for ${user.uid}');
    } else {
      print('Turf partner admin document already exists');
    }
  }

  // ==================== GET ADMIN ====================

  Future<TurfPartnerAdminModel?> getAdminData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .get();
    if (!doc.exists) return null;

    return TurfPartnerAdminModel.fromFirestore(doc);
  }

  Stream<TurfPartnerAdminModel?> getAdminDataStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .snapshots()
        .map(
          (doc) => doc.exists ? TurfPartnerAdminModel.fromFirestore(doc) : null,
        );
  }

  /// Get admin data by ID (for super admin use)
  Future<TurfPartnerAdminModel?> getAdminDataById(String adminId) async {
    final doc = await _firestore
        .collection('play_partner_admins')
        .doc(adminId)
        .get();
    if (!doc.exists) return null;

    return TurfPartnerAdminModel.fromFirestore(doc);
  }

  // ==================== UPDATE ADMIN PROFILE ====================

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

    await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .update(updates);
  }

  // ==================== UPDATE BUSINESS INFO ====================

  Future<void> updateBusinessInfo(BusinessInfo businessInfo) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('play_partner_admins').doc(user.uid).update({
      'businessInfo': businessInfo.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== UPDATE BANK DETAILS ====================

  Future<void> updateBankDetails(BankDetails bankDetails) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('play_partner_admins').doc(user.uid).update({
      'bankDetails': bankDetails.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== DOCUMENT VERIFICATION ====================

  Future<void> uploadDocuments({
    String? aadharNumber,
    String? aadharDocUrl,
    String? panCardUrl,
    String? gstCertificateUrl,
    String? businessLicenseUrl,
    List<String>? additionalDocUrls,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (aadharNumber != null) {
      updates['documentVerification.aadharNumber'] = aadharNumber;
    }
    if (aadharDocUrl != null) {
      updates['documentVerification.aadharDocUrl'] = aadharDocUrl;
      updates['documentVerification.aadharStatus'] = 'pending';
    }
    if (panCardUrl != null) {
      updates['documentVerification.panCardUrl'] = panCardUrl;
      updates['documentVerification.panStatus'] = 'pending';
    }
    if (gstCertificateUrl != null) {
      updates['documentVerification.gstCertificateUrl'] = gstCertificateUrl;
      updates['documentVerification.gstStatus'] = 'pending';
    }
    if (businessLicenseUrl != null) {
      updates['documentVerification.businessLicenseUrl'] = businessLicenseUrl;
      updates['documentVerification.businessLicenseStatus'] = 'pending';
    }
    if (additionalDocUrls != null && additionalDocUrls.isNotEmpty) {
      updates['documentVerification.additionalDocUrls'] = FieldValue.arrayUnion(
        additionalDocUrls,
      );
    }

    await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .update(updates);
  }

  // ==================== ADMIN STATUS MANAGEMENT ====================

  /// Update admin status (for super admin use)
  Future<void> updateAdminStatus({
    required String adminId,
    required AdminStatus status,
    String? rejectionReason,
    String? approvedByUserId,
  }) async {
    final updates = <String, dynamic>{
      'status': status.toString().split('.').last,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (status == AdminStatus.approved) {
      updates['approvedAt'] = FieldValue.serverTimestamp();
      if (approvedByUserId != null) {
        updates['approvedBy'] = approvedByUserId;
      }
    }

    if (status == AdminStatus.rejected && rejectionReason != null) {
      updates['documentVerification.rejectionReason'] = rejectionReason;
    }

    await _firestore
        .collection('play_partner_admins')
        .doc(adminId)
        .update(updates);
  }

  /// Verify specific document (for super admin use)
  Future<void> verifyDocument({
    required String adminId,
    required String documentType, // 'aadhar', 'pan', 'gst', 'businessLicense'
    required VerificationStatus status,
    String? rejectionReason,
  }) async {
    final statusString = status.toString().split('.').last;

    final updates = <String, dynamic>{
      'documentVerification.${documentType}Status': statusString,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (status == VerificationStatus.rejected && rejectionReason != null) {
      updates['documentVerification.rejectionReason'] = rejectionReason;
    }

    await _firestore
        .collection('play_partner_admins')
        .doc(adminId)
        .update(updates);
  }

  // ==================== TURF MANAGEMENT ====================

  /// Add turf to admin's managed turfs
  Future<void> addTurf(String turfId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('play_partner_admins').doc(user.uid).update({
      'turfIds': FieldValue.arrayUnion([turfId]),
      'stats.totalTurfs': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove turf from admin's managed turfs
  Future<void> removeTurf(String turfId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('play_partner_admins').doc(user.uid).update({
      'turfIds': FieldValue.arrayRemove([turfId]),
      'stats.totalTurfs': FieldValue.increment(-1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get all turfs managed by this admin
  Future<List<Map<String, dynamic>>> getManagedTurfs() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final adminData = await getAdminData();
    if (adminData == null || adminData.turfIds.isEmpty) return [];

    final turfs = await Future.wait(
      adminData.turfIds.map((turfId) async {
        final doc = await _firestore.collection('turfs').doc(turfId).get();
        if (doc.exists) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }
        return null;
      }),
    );

    return turfs.whereType<Map<String, dynamic>>().toList();
  }

  Stream<QuerySnapshot> getManagedTurfsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .snapshots()
        .asyncExpand((adminDoc) {
          if (!adminDoc.exists) return const Stream.empty();

          final turfIds = List<String>.from(adminDoc.data()?['turfIds'] ?? []);
          if (turfIds.isEmpty) return const Stream.empty();

          return _firestore
              .collection('turfs')
              .where(FieldPath.documentId, whereIn: turfIds)
              .snapshots();
        });
  }

  // ==================== BOOKING OPERATIONS ====================

  /// Add booking reference to admin
  Future<void> addBooking(String bookingId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('play_partner_admins').doc(user.uid).update({
      'bookingIds': FieldValue.arrayUnion([bookingId]),
      'stats.totalBookings': FieldValue.increment(1),
      'stats.activeBookings': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get all bookings for admin's turfs
  Future<List<Map<String, dynamic>>> getAdminBookings() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final adminData = await getAdminData();
    if (adminData == null || adminData.bookingIds.isEmpty) return [];

    final bookings = await Future.wait(
      adminData.bookingIds.map((bookingId) async {
        final doc = await _firestore
            .collection('turf_bookings')
            .doc(bookingId)
            .get();
        if (doc.exists) {
          return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        }
        return null;
      }),
    );

    return bookings.whereType<Map<String, dynamic>>().toList();
  }

  Stream<QuerySnapshot> getAdminBookingsStream({
    String? status, // 'active', 'completed', 'cancelled'
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    Query query = _firestore
        .collection('turf_bookings')
        .where('adminId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    if (startDate != null) {
      query = query.where('bookingDate', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('bookingDate', isLessThanOrEqualTo: endDate);
    }

    return query.snapshots();
  }

  // ==================== REVENUE TRACKING ====================

  /// Record revenue from Ticpin app bookings
  /// bookingType: 'advance' (30% payment) or 'full' (full booking payment)
  /// paymentSource: 'ticpin_app' or 'direct'
  Future<void> recordRevenue({
    required String bookingId,
    required double amount,
    required String bookingType, // 'advance' or 'full'
    required String paymentSource, // 'ticpin_app' or 'direct'
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final updates = <String, dynamic>{
      'stats.totalRevenue': FieldValue.increment(amount),
      'stats.pendingPayouts': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Track Ticpin app revenue separately
    if (paymentSource == 'ticpin_app') {
      updates['stats.ticpinAppRevenue'] = FieldValue.increment(amount);

      if (bookingType == 'advance') {
        updates['stats.advancePaymentRevenue'] = FieldValue.increment(amount);
      } else if (bookingType == 'full') {
        updates['stats.fullPaymentRevenue'] = FieldValue.increment(amount);
      }
    }

    await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .update(updates);

    // Create revenue transaction record
    await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .collection('revenue_transactions')
        .add({
          'bookingId': bookingId,
          'amount': amount,
          'bookingType': bookingType,
          'paymentSource': paymentSource,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  /// Get revenue analytics for a date range
  Future<Map<String, dynamic>> getRevenueAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    Query query = _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .collection('revenue_transactions');

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: endDate);
    }

    final snapshot = await query.get();

    double totalRevenue = 0.0;
    double ticpinAppRevenue = 0.0;
    double advanceRevenue = 0.0;
    double fullRevenue = 0.0;
    int totalTransactions = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] ?? 0.0).toDouble();
      final source = data['paymentSource'] ?? '';
      final type = data['bookingType'] ?? '';

      totalRevenue += amount;
      totalTransactions++;

      if (source == 'ticpin_app') {
        ticpinAppRevenue += amount;

        if (type == 'advance') {
          advanceRevenue += amount;
        } else if (type == 'full') {
          fullRevenue += amount;
        }
      }
    }

    return {
      'totalRevenue': totalRevenue,
      'ticpinAppRevenue': ticpinAppRevenue,
      'advancePaymentRevenue': advanceRevenue,
      'fullPaymentRevenue': fullRevenue,
      'totalTransactions': totalTransactions,
      'ticpinAppPercentage': totalRevenue > 0
          ? (ticpinAppRevenue / totalRevenue * 100)
          : 0.0,
    };
  }

  Stream<QuerySnapshot> getRevenueTransactionsStream({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    Query query = _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .collection('revenue_transactions')
        .orderBy('timestamp', descending: true);

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: endDate);
    }

    return query.snapshots();
  }

  // ==================== STATS OPERATIONS ====================

  /// Update admin statistics
  Future<void> updateStats({
    int? totalBookings,
    int? activeBookings,
    int? completedBookings,
    int? cancelledBookings,
    double? totalRevenue,
    double? ticpinAppRevenue,
    double? advancePaymentRevenue,
    double? fullPaymentRevenue,
    double? pendingPayouts,
    double? averageRating,
    int? totalReviews,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (totalBookings != null) {
      updates['stats.totalBookings'] = totalBookings;
    }
    if (activeBookings != null) {
      updates['stats.activeBookings'] = activeBookings;
    }
    if (completedBookings != null) {
      updates['stats.completedBookings'] = completedBookings;
    }
    if (cancelledBookings != null) {
      updates['stats.cancelledBookings'] = cancelledBookings;
    }
    if (totalRevenue != null) {
      updates['stats.totalRevenue'] = totalRevenue;
    }
    if (ticpinAppRevenue != null) {
      updates['stats.ticpinAppRevenue'] = ticpinAppRevenue;
    }
    if (advancePaymentRevenue != null) {
      updates['stats.advancePaymentRevenue'] = advancePaymentRevenue;
    }
    if (fullPaymentRevenue != null) {
      updates['stats.fullPaymentRevenue'] = fullPaymentRevenue;
    }
    if (pendingPayouts != null) {
      updates['stats.pendingPayouts'] = pendingPayouts;
    }
    if (averageRating != null) {
      updates['stats.averageRating'] = averageRating;
    }
    if (totalReviews != null) {
      updates['stats.totalReviews'] = totalReviews;
    }

    await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .update(updates);
  }

  /// Increment revenue
  Future<void> addRevenue(double amount) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('play_partner_admins').doc(user.uid).update({
      'stats.totalRevenue': FieldValue.increment(amount),
      'stats.pendingPayouts': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update booking completion
  Future<void> completeBooking() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('play_partner_admins').doc(user.uid).update({
      'stats.activeBookings': FieldValue.increment(-1),
      'stats.completedBookings': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update booking cancellation
  Future<void> cancelBooking() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore.collection('play_partner_admins').doc(user.uid).update({
      'stats.activeBookings': FieldValue.increment(-1),
      'stats.cancelledBookings': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== PERMISSIONS ====================

  /// Update admin permissions (for super admin use)
  Future<void> updatePermissions({
    required String adminId,
    required AdminPermissions permissions,
  }) async {
    await _firestore.collection('play_partner_admins').doc(adminId).update({
      'permissions': permissions.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Check if admin has specific permission
  Future<bool> hasPermission(String permissionName) async {
    final adminData = await getAdminData();
    if (adminData == null) return false;

    final permissions = adminData.permissions;
    switch (permissionName) {
      case 'canManageTurfs':
        return permissions.canManageTurfs;
      case 'canViewBookings':
        return permissions.canViewBookings;
      case 'canCancelBookings':
        return permissions.canCancelBookings;
      case 'canUpdatePricing':
        return permissions.canUpdatePricing;
      case 'canViewAnalytics':
        return permissions.canViewAnalytics;
      case 'canManageSlots':
        return permissions.canManageSlots;
      case 'canProcessRefunds':
        return permissions.canProcessRefunds;
      default:
        return false;
    }
  }

  // ==================== NOTIFICATIONS ====================

  /// Save notification for admin
  Future<void> saveNotification({
    required String title,
    required String message,
    required String type, // 'booking', 'payment', 'system', 'alert'
    Map<String, dynamic>? data,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .collection('notifications')
        .add({
          'title': title,
          'message': message,
          'type': type,
          'data': data,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<QuerySnapshot> getNotificationsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  // ==================== PAYOUTS ====================

  /// Save payout record
  Future<void> savePayoutRecord({
    required double amount,
    required String payoutMethod, // 'bank', 'upi'
    required String status, // 'pending', 'processing', 'completed', 'failed'
    Map<String, dynamic>? bankDetails,
    String? transactionId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    await _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .collection('payouts')
        .add({
          'amount': amount,
          'payoutMethod': payoutMethod,
          'status': status,
          'bankDetails': bankDetails,
          'transactionId': transactionId,
          'createdAt': FieldValue.serverTimestamp(),
          'processedAt': null,
        });

    // Update pending payouts
    if (status == 'completed') {
      await _firestore.collection('play_partner_admins').doc(user.uid).update({
        'stats.pendingPayouts': FieldValue.increment(-amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> getPayoutsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('play_partner_admins')
        .doc(user.uid)
        .collection('payouts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ==================== QUERY HELPERS ====================

  /// Get all pending admin applications (for super admin)
  Stream<QuerySnapshot> getPendingAdminsStream() {
    return _firestore
        .collection('play_partner_admins')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get all approved admins (for super admin)
  Stream<QuerySnapshot> getApprovedAdminsStream() {
    return _firestore
        .collection('play_partner_admins')
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Search admins by name or email (for super admin)
  Future<List<Map<String, dynamic>>> searchAdmins(String searchQuery) async {
    final querySnapshot = await _firestore
        .collection('play_partner_admins')
        .where('name', isGreaterThanOrEqualTo: searchQuery)
        .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
        .get();

    return querySnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  // ==================== CHECK PROFILE COMPLETION ====================

  Future<bool> isProfileComplete() async {
    final adminData = await getAdminData();
    if (adminData == null) return false;

    return adminData.name != null &&
        adminData.name!.isNotEmpty &&
        adminData.email != null &&
        adminData.email!.isNotEmpty;
  }

  Future<bool> isDocumentVerificationComplete() async {
    final adminData = await getAdminData();
    if (adminData == null) return false;

    return adminData.documentVerification.isFullyVerified;
  }

  Future<bool> isBusinessInfoComplete() async {
    final adminData = await getAdminData();
    if (adminData == null) return false;

    return adminData.businessInfo != null &&
        adminData.businessInfo!.businessName != null &&
        adminData.businessInfo!.businessName!.isNotEmpty;
  }

  Future<bool> isBankDetailsComplete() async {
    final adminData = await getAdminData();
    if (adminData == null) return false;

    return adminData.bankDetails != null &&
        adminData.bankDetails!.accountNumber != null &&
        adminData.bankDetails!.accountNumber!.isNotEmpty &&
        adminData.bankDetails!.ifscCode != null &&
        adminData.bankDetails!.ifscCode!.isNotEmpty;
  }
}
