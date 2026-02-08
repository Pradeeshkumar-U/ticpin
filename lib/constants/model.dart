// Dining Partner Admin Document Structure and Models

import 'package:cloud_firestore/cloud_firestore.dart';

// ==================== DINING PARTNER ADMIN MODEL ====================

class DiningPartnerAdminModel {
  final String adminId;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profilePicUrl;
  final List<String> diningIds; // List of dining IDs managed by this admin
  final AdminStatus status;
  final AdminPermissions permissions;
  final BusinessInfo? businessInfo;
  final BankDetails? bankDetails;
  final List<String> bookingIds; // List of all booking IDs for their dinings
  final DocumentVerification documentVerification;
  final AdminStats stats;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? approvedAt;
  final String? approvedBy; // Admin user ID who approved

  DiningPartnerAdminModel({
    required this.adminId,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profilePicUrl,
    this.diningIds = const [],
    required this.status,
    required this.permissions,
    this.businessInfo,
    this.bankDetails,
    this.bookingIds = const [],
    required this.documentVerification,
    required this.stats,
    required this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.approvedBy,
  });

  factory DiningPartnerAdminModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DiningPartnerAdminModel(
      adminId: doc.id,
      phoneNumber: data['phoneNumber'] ?? '',
      name: data['name'],
      email: data['email'],
      profilePicUrl: data['profilePicUrl'],
      diningIds: List<String>.from(data['diningIds'] ?? []),
      status: AdminStatus.values.firstWhere(
        (e) => e.toString() == 'AdminStatus.${data['status']}',
        orElse: () => AdminStatus.pending,
      ),
      permissions: AdminPermissions.fromMap(data['permissions'] ?? {}),
      businessInfo: data['businessInfo'] != null
          ? BusinessInfo.fromMap(data['businessInfo'])
          : null,
      bankDetails: data['bankDetails'] != null
          ? BankDetails.fromMap(data['bankDetails'])
          : null,
      bookingIds: List<String>.from(data['bookingIds'] ?? []),
      documentVerification: DocumentVerification.fromMap(
        data['documentVerification'] ?? {},
      ),
      stats: AdminStats.fromMap(data['stats'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      approvedAt: data['approvedAt'] != null
          ? (data['approvedAt'] as Timestamp).toDate()
          : null,
      approvedBy: data['approvedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adminId': adminId,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'diningIds': diningIds,
      'status': status.toString().split('.').last,
      'permissions': permissions.toMap(),
      'businessInfo': businessInfo?.toMap(),
      'bankDetails': bankDetails?.toMap(),
      'bookingIds': bookingIds,
      'documentVerification': documentVerification.toMap(),
      'stats': stats.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'approvedBy': approvedBy,
    };
  }

  DiningPartnerAdminModel copyWith({
    String? name,
    String? email,
    String? profilePicUrl,
    List<String>? diningIds,
    AdminStatus? status,
    AdminPermissions? permissions,
    BusinessInfo? businessInfo,
    BankDetails? bankDetails,
    List<String>? bookingIds,
    DocumentVerification? documentVerification,
    AdminStats? stats,
    DateTime? updatedAt,
    DateTime? approvedAt,
    String? approvedBy,
  }) {
    return DiningPartnerAdminModel(
      adminId: this.adminId,
      phoneNumber: this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      diningIds: diningIds ?? this.diningIds,
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      businessInfo: businessInfo ?? this.businessInfo,
      bankDetails: bankDetails ?? this.bankDetails,
      bookingIds: bookingIds ?? this.bookingIds,
      documentVerification: documentVerification ?? this.documentVerification,
      stats: stats ?? this.stats,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
    );
  }
}

// ==================== ADMIN STATUS ENUM ====================

enum AdminStatus {
  pending, // Waiting for approval
  approved, // Approved and active
  suspended, // Temporarily suspended
  rejected, // Application rejected
  inactive, // Deactivated
}

// ==================== ADMIN PERMISSIONS ====================

class AdminPermissions {
  final bool canManageDining;
  final bool canViewBookings;
  final bool canCancelBookings;
  final bool canUpdateMenu;
  final bool canViewAnalytics;
  final bool canManageTimings;
  final bool canProcessRefunds;

  AdminPermissions({
    this.canManageDining = true,
    this.canViewBookings = true,
    this.canCancelBookings = false,
    this.canUpdateMenu = true,
    this.canViewAnalytics = true,
    this.canManageTimings = true,
    this.canProcessRefunds = false,
  });

  factory AdminPermissions.fromMap(Map<String, dynamic> map) {
    return AdminPermissions(
      canManageDining: map['canManageDining'] ?? true,
      canViewBookings: map['canViewBookings'] ?? true,
      canCancelBookings: map['canCancelBookings'] ?? false,
      canUpdateMenu: map['canUpdateMenu'] ?? true,
      canViewAnalytics: map['canViewAnalytics'] ?? true,
      canManageTimings: map['canManageTimings'] ?? true,
      canProcessRefunds: map['canProcessRefunds'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'canManageDining': canManageDining,
      'canViewBookings': canViewBookings,
      'canCancelBookings': canCancelBookings,
      'canUpdateMenu': canUpdateMenu,
      'canViewAnalytics': canViewAnalytics,
      'canManageTimings': canManageTimings,
      'canProcessRefunds': canProcessRefunds,
    };
  }

  AdminPermissions copyWith({
    bool? canManageDining,
    bool? canViewBookings,
    bool? canCancelBookings,
    bool? canUpdateMenu,
    bool? canViewAnalytics,
    bool? canManageTimings,
    bool? canProcessRefunds,
  }) {
    return AdminPermissions(
      canManageDining: canManageDining ?? this.canManageDining,
      canViewBookings: canViewBookings ?? this.canViewBookings,
      canCancelBookings: canCancelBookings ?? this.canCancelBookings,
      canUpdateMenu: canUpdateMenu ?? this.canUpdateMenu,
      canViewAnalytics: canViewAnalytics ?? this.canViewAnalytics,
      canManageTimings: canManageTimings ?? this.canManageTimings,
      canProcessRefunds: canProcessRefunds ?? this.canProcessRefunds,
    );
  }
}

// ==================== BUSINESS INFO ====================

class BusinessInfo {
  final String? businessName;
  final String? businessType; // Individual, Partnership, Company, etc.
  final String? gstNumber;
  final String? panNumber;
  final String? registrationNumber;
  final Address? registeredAddress;
  final String? website;
  final String? description;

  BusinessInfo({
    this.businessName,
    this.businessType,
    this.gstNumber,
    this.panNumber,
    this.registrationNumber,
    this.registeredAddress,
    this.website,
    this.description,
  });

  factory BusinessInfo.fromMap(Map<String, dynamic> map) {
    return BusinessInfo(
      businessName: map['businessName'],
      businessType: map['businessType'],
      gstNumber: map['gstNumber'],
      panNumber: map['panNumber'],
      registrationNumber: map['registrationNumber'],
      registeredAddress: map['registeredAddress'] != null
          ? Address.fromMap(map['registeredAddress'])
          : null,
      website: map['website'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'businessType': businessType,
      'gstNumber': gstNumber,
      'panNumber': panNumber,
      'registrationNumber': registrationNumber,
      'registeredAddress': registeredAddress?.toMap(),
      'website': website,
      'description': description,
    };
  }
}

// ==================== ADDRESS ====================

class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  Address({this.street, this.city, this.state, this.postalCode, this.country});

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      postalCode: map['postalCode'],
      country: map['country'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }
}

// ==================== BANK DETAILS ====================

class BankDetails {
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? bankName;
  final String? branchName;
  final String? upiId;
  final bool isVerified;

  BankDetails({
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.bankName,
    this.branchName,
    this.upiId,
    this.isVerified = false,
  });

  factory BankDetails.fromMap(Map<String, dynamic> map) {
    return BankDetails(
      accountHolderName: map['accountHolderName'],
      accountNumber: map['accountNumber'],
      ifscCode: map['ifscCode'],
      bankName: map['bankName'],
      branchName: map['branchName'],
      upiId: map['upiId'],
      isVerified: map['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'branchName': branchName,
      'upiId': upiId,
      'isVerified': isVerified,
    };
  }
}

// ==================== DOCUMENT VERIFICATION ====================

class DocumentVerification {
  final String? aadharNumber;
  final String? aadharDocUrl;
  final String? panCardUrl;
  final String? gstCertificateUrl;
  final String? fssaiLicenseUrl;
  final String? businessLicenseUrl;
  final List<String> additionalDocUrls;
  final VerificationStatus aadharStatus;
  final VerificationStatus panStatus;
  final VerificationStatus gstStatus;
  final VerificationStatus fssaiStatus;
  final VerificationStatus businessLicenseStatus;
  final String? rejectionReason;

  DocumentVerification({
    this.aadharNumber,
    this.aadharDocUrl,
    this.panCardUrl,
    this.gstCertificateUrl,
    this.fssaiLicenseUrl,
    this.businessLicenseUrl,
    this.additionalDocUrls = const [],
    this.aadharStatus = VerificationStatus.pending,
    this.panStatus = VerificationStatus.pending,
    this.gstStatus = VerificationStatus.notProvided,
    this.fssaiStatus = VerificationStatus.pending,
    this.businessLicenseStatus = VerificationStatus.notProvided,
    this.rejectionReason,
  });

  factory DocumentVerification.fromMap(Map<String, dynamic> map) {
    return DocumentVerification(
      aadharNumber: map['aadharNumber'],
      aadharDocUrl: map['aadharDocUrl'],
      panCardUrl: map['panCardUrl'],
      gstCertificateUrl: map['gstCertificateUrl'],
      fssaiLicenseUrl: map['fssaiLicenseUrl'],
      businessLicenseUrl: map['businessLicenseUrl'],
      additionalDocUrls: List<String>.from(map['additionalDocUrls'] ?? []),
      aadharStatus: VerificationStatus.values.firstWhere(
        (e) => e.toString() == 'VerificationStatus.${map['aadharStatus']}',
        orElse: () => VerificationStatus.pending,
      ),
      panStatus: VerificationStatus.values.firstWhere(
        (e) => e.toString() == 'VerificationStatus.${map['panStatus']}',
        orElse: () => VerificationStatus.pending,
      ),
      gstStatus: VerificationStatus.values.firstWhere(
        (e) => e.toString() == 'VerificationStatus.${map['gstStatus']}',
        orElse: () => VerificationStatus.notProvided,
      ),
      fssaiStatus: VerificationStatus.values.firstWhere(
        (e) => e.toString() == 'VerificationStatus.${map['fssaiStatus']}',
        orElse: () => VerificationStatus.pending,
      ),
      businessLicenseStatus: VerificationStatus.values.firstWhere(
        (e) =>
            e.toString() ==
            'VerificationStatus.${map['businessLicenseStatus']}',
        orElse: () => VerificationStatus.notProvided,
      ),
      rejectionReason: map['rejectionReason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aadharNumber': aadharNumber,
      'aadharDocUrl': aadharDocUrl,
      'panCardUrl': panCardUrl,
      'gstCertificateUrl': gstCertificateUrl,
      'fssaiLicenseUrl': fssaiLicenseUrl,
      'businessLicenseUrl': businessLicenseUrl,
      'additionalDocUrls': additionalDocUrls,
      'aadharStatus': aadharStatus.toString().split('.').last,
      'panStatus': panStatus.toString().split('.').last,
      'gstStatus': gstStatus.toString().split('.').last,
      'fssaiStatus': fssaiStatus.toString().split('.').last,
      'businessLicenseStatus': businessLicenseStatus.toString().split('.').last,
      'rejectionReason': rejectionReason,
    };
  }

  bool get isFullyVerified {
    return aadharStatus == VerificationStatus.verified &&
        panStatus == VerificationStatus.verified &&
        fssaiStatus == VerificationStatus.verified;
  }
}

enum VerificationStatus { pending, verified, rejected, notProvided }

// ==================== ADMIN STATS ====================

class AdminStats {
  final int totalDinings;
  final int totalBookings;
  final int activeBookings;
  final int completedBookings;
  final int cancelledBookings;
  final double totalRevenue;
  final double ticpinAppRevenue; // Revenue generated through Ticpin app
  final double advancePaymentRevenue; // 30% advance payments
  final double fullPaymentRevenue; // Full table bookings
  final double pendingPayouts;
  final double averageRating;
  final int totalReviews;

  AdminStats({
    this.totalDinings = 0,
    this.totalBookings = 0,
    this.activeBookings = 0,
    this.completedBookings = 0,
    this.cancelledBookings = 0,
    this.totalRevenue = 0.0,
    this.ticpinAppRevenue = 0.0,
    this.advancePaymentRevenue = 0.0,
    this.fullPaymentRevenue = 0.0,
    this.pendingPayouts = 0.0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  factory AdminStats.fromMap(Map<String, dynamic> map) {
    return AdminStats(
      totalDinings: map['totalDinings'] ?? 0,
      totalBookings: map['totalBookings'] ?? 0,
      activeBookings: map['activeBookings'] ?? 0,
      completedBookings: map['completedBookings'] ?? 0,
      cancelledBookings: map['cancelledBookings'] ?? 0,
      totalRevenue: (map['totalRevenue'] ?? 0.0).toDouble(),
      ticpinAppRevenue: (map['ticpinAppRevenue'] ?? 0.0).toDouble(),
      advancePaymentRevenue: (map['advancePaymentRevenue'] ?? 0.0).toDouble(),
      fullPaymentRevenue: (map['fullPaymentRevenue'] ?? 0.0).toDouble(),
      pendingPayouts: (map['pendingPayouts'] ?? 0.0).toDouble(),
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalDinings': totalDinings,
      'totalBookings': totalBookings,
      'activeBookings': activeBookings,
      'completedBookings': completedBookings,
      'cancelledBookings': cancelledBookings,
      'totalRevenue': totalRevenue,
      'ticpinAppRevenue': ticpinAppRevenue,
      'advancePaymentRevenue': advancePaymentRevenue,
      'fullPaymentRevenue': fullPaymentRevenue,
      'pendingPayouts': pendingPayouts,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }

  AdminStats copyWith({
    int? totalDinings,
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
  }) {
    return AdminStats(
      totalDinings: totalDinings ?? this.totalDinings,
      totalBookings: totalBookings ?? this.totalBookings,
      activeBookings: activeBookings ?? this.activeBookings,
      completedBookings: completedBookings ?? this.completedBookings,
      cancelledBookings: cancelledBookings ?? this.cancelledBookings,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      ticpinAppRevenue: ticpinAppRevenue ?? this.ticpinAppRevenue,
      advancePaymentRevenue: advancePaymentRevenue ?? this.advancePaymentRevenue,
      fullPaymentRevenue: fullPaymentRevenue ?? this.fullPaymentRevenue,
      pendingPayouts: pendingPayouts ?? this.pendingPayouts,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}