// import 'package:cloud_firestore/cloud_firestore.dart';

// class TurfFull {
//   final String id;
//   final Map<String, dynamic> raw;

//   TurfFull({
//     required this.id,
//     required this.raw,
//   });

//   factory TurfFull.fromDoc(DocumentSnapshot doc) {
//     return TurfFull(
//       id: doc.id,
//       raw: doc.data() as Map<String, dynamic>,
//     );
//   }

//   // INFO
//   String get name => raw["name"] ?? "";
//   String get address => raw["address"] ?? "";
//   String get city => raw["city"] ?? "";

//   // POSTERS (Multiple)
//   List<String> get posterUrls =>
//       (raw["poster_urls"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // VENUE
//   String get venueName => raw["name"] ?? "";
//   String get venueAddress => raw["address"] ?? "";

//   double get venueLat =>
//       double.tryParse(raw["venue_lat"]?.toString() ?? "") ?? 0.0;

//   double get venueLng =>
//       double.tryParse(raw["venue_lng"]?.toString() ?? "") ?? 0.0;

//   String get mapsLink => raw["map_link"] ?? "";

//   // SCHEDULE
//   Map<String, dynamic> get schedule => raw["schedule"] ?? {};

//   // AMENITIES
//   List<String> get amenities =>
//       (raw["amenities"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // VENUE INFO
//   List<String> get venueInfo =>
//       (raw["venue_info"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // VENUE RULES
//   List<String> get rules =>
//       (raw["venue_rules"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // OWNER
//   String get ownerName => raw["owner_name"] ?? "";
//   String get ownerUid => raw["owner_uid"] ?? "";
//   String get contact => raw["contact"] ?? "";

//   // PRICING
//   int get halfHourPrice => raw["half_hour_price"] ?? 0;

//   // METADATA
//   DateTime? get createdAt {
//     final value = raw["created_at"];
//     if (value is Timestamp) return value.toDate();
//     if (value is DateTime) return value;
//     return null;
//   }

//   DateTime? get updatedAt {
//     final value = raw["updated_at"];
//     if (value is Timestamp) return value.toDate();
//     if (value is DateTime) return value;
//     return null;
//   }

//   String get turfId => raw["turfId"] ?? "";
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class TurfFull {
  final String id;
  final Map<String, dynamic> raw;

  TurfFull({
    required this.id,
    required this.raw,
  });

  factory TurfFull.fromDoc(DocumentSnapshot doc) {
    return TurfFull(
      id: doc.id,
      raw: doc.data() as Map<String, dynamic>,
    );
  }

  // BASIC INFO
  String get name => raw["name"] ?? "";
  String get ownerName => raw["owner_name"] ?? "";
  String get ownerUid => raw["owner_uid"] ?? "";
  String get turfId => raw["turfId"] ?? "";
  String get createdBy => raw["createdBy"] ?? "";

  // LOCATION
  String get address => raw["address"] ?? "";
  String get city => raw["city"] ?? "";
  String get mapLink => raw["map_link"] ?? "";
  
  double get venueLat =>
      double.tryParse(raw["venue_lat"]?.toString() ?? "") ?? 0.0;
  
  double get venueLng =>
      double.tryParse(raw["venue_lng"]?.toString() ?? "") ?? 0.0;

  // CONTACT
  String get contact => raw["contact"] ?? "";

  // PRICING
  int get halfHourPrice => raw["half_hour_price"] ?? 0;

  // MEDIA
  List<String> get posterUrls =>
      (raw["poster_urls"] as List?)?.map((e) => e.toString()).toList() ?? [];

  // AMENITIES & FACILITIES
  List<String> get amenities =>
      (raw["amenities"] as List?)?.map((e) => e.toString()).toList() ?? [];
  
  List<String> get playground =>
      (raw["playground"] as List?)?.map((e) => e.toString()).toList() ?? [];
  
  List<String> get venueInfo =>
      (raw["venue_info"] as List?)?.map((e) => e.toString()).toList() ?? [];
  
  List<String> get venueRules =>
      (raw["venue_rules"] as List?)?.map((e) => e.toString()).toList() ?? [];

  // SCHEDULE
  Map<String, dynamic> get schedule => raw["schedule"] ?? {};
  
  TurfDaySchedule get mondaySchedule => 
      TurfDaySchedule.fromMap(schedule["monday"] as Map<String, dynamic>? ?? {});
  
  TurfDaySchedule get tuesdaySchedule => 
      TurfDaySchedule.fromMap(schedule["tuesday"] as Map<String, dynamic>? ?? {});
  
  TurfDaySchedule get wednesdaySchedule => 
      TurfDaySchedule.fromMap(schedule["wednesday"] as Map<String, dynamic>? ?? {});
  
  TurfDaySchedule get thursdaySchedule => 
      TurfDaySchedule.fromMap(schedule["thursday"] as Map<String, dynamic>? ?? {});
  
  TurfDaySchedule get fridaySchedule => 
      TurfDaySchedule.fromMap(schedule["friday"] as Map<String, dynamic>? ?? {});
  
  TurfDaySchedule get saturdaySchedule => 
      TurfDaySchedule.fromMap(schedule["saturday"] as Map<String, dynamic>? ?? {});
  
  TurfDaySchedule get sundaySchedule => 
      TurfDaySchedule.fromMap(schedule["sunday"] as Map<String, dynamic>? ?? {});

  // METADATA
  DateTime? get createdAt {
    final value = raw["created_at"];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  DateTime? get updatedAt {
    final value = raw["updated_at"];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

// ------------------------------------------
// TURF DAY SCHEDULE MODEL
// ------------------------------------------
class TurfDaySchedule {
  final bool isOpen;

  TurfDaySchedule({
    required this.isOpen,
  });

  factory TurfDaySchedule.fromMap(Map<String, dynamic> map) {
    return TurfDaySchedule(
      isOpen: map["isOpen"] ?? false,
    );
  }
}