// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ticpin/constants/models/event/eventsummary.dart';

// class EventFull {
//   final String id;
//   final Map<String, dynamic> raw;

//   EventFull({
//     required this.id,
//     required this.raw,
//   });

//   factory EventFull.fromDoc(DocumentSnapshot doc) {
//     return EventFull(
//       id: doc.id,
//       raw: doc.data() as Map<String, dynamic>,
//     );
//   }

//   String get name => raw["name"] ?? "";

//   Map<String, dynamic> get media => raw["media"] ?? {};
//   Map<String, dynamic> get venue => raw["venue"] ?? {};

//   String get posterUrl => driveToDirect(media["posterLink"] ?? "");
//   String get videoUrl => driveToDirect(media["videoLink"] ?? "");

//   List<String> get artistLineup =>
//       (raw["artistLineup"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   DateTime? get dateTime =>
//       raw["dateTime"] is Timestamp ? (raw["dateTime"] as Timestamp).toDate() : null;
// }


// import 'package:cloud_firestore/cloud_firestore.dart';

// class EventFull {
//   final String id;
//   final Map<String, dynamic> raw;

//   EventFull({
//     required this.id,
//     required this.raw,
//   });

//   factory EventFull.fromDoc(DocumentSnapshot doc) {
//     return EventFull(
//       id: doc.id,
//       raw: doc.data() as Map<String, dynamic>,
//     );
//   }

//   // Convert Google Drive link → direct link
//   String driveToDirect(String url) {
//     if (!url.contains("drive.google.com")) return url;
//     final id = url.split("/d/").last.split("/").first;
//     return "https://drive.google.com/uc?export=view&id=$id";
//   }

//   // BASIC INFO
//   String get name => raw["name"] ?? "";
//   String get category => raw["category"] ?? "";
//   String get ageRestriction => raw["ageRestriction"] ?? "";

//   DateTime? get dateTime =>
//       raw["dateTime"] is Timestamp ? (raw["dateTime"] as Timestamp).toDate() : null;

//   DateTime? get endDateTime =>
//       raw["endDateTime"] is Timestamp ? (raw["endDateTime"] as Timestamp).toDate() : null;

//   bool get isMultiDay => raw["isMultiDay"] ?? false;

//   // ARTIST LINEUP
//   List<String> get artistLineup =>
//       (raw["artistLineup"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // MEDIA
//   Map<String, dynamic> get media => raw["media"] ?? {};
//   String get posterUrl => driveToDirect(media["posterLink"] ?? "");
//   String get videoUrl => media["videoLink"] ?? "";

//   // VENUE
//   Map<String, dynamic> get venue => raw["venue"] ?? {};
//   String get venueName => venue["name"] ?? "";
//   String get venueAddress => venue["fullAddress"] ?? "";

//   double get venueLat =>
//       double.tryParse(venue["venueLat"]?.toString() ?? "") ?? 0;

//   double get venueLng =>
//       double.tryParse(venue["venueLng"]?.toString() ?? "") ?? 0;

//   // ORGANISER
//   Map<String, dynamic> get organiser => raw["organiser"] ?? {};
//   String get organiserCompany => organiser["companyName"] ?? "";
//   String get organiserPerson => organiser["contactPerson"] ?? "";
//   String get organiserEmail => organiser["contactEmail"] ?? "";
//   String get organiserPhone => organiser["contactPhone"] ?? "";

//   // FINANCIAL INFO
//   Map<String, dynamic> get financial => raw["financial"] ?? {};
//   String get finAccountHolder => financial["accountHolder"] ?? "";
//   String get finAccountNumber => financial["accountNumber"] ?? "";
//   String get finBankName => financial["bankName"] ?? "";
//   String get finIfsc => financial["ifsc"] ?? "";
//   String get finPanOrGst => financial["panOrGst"] ?? "";

//   // LEGAL INFO
//   Map<String, dynamic> get legal => raw["legal"] ?? {};
//   String get legalGstNo => legal["gstNo"] ?? "";
//   String get legalLiability => legal["liabilityText"] ?? "";

//   // NOC FILE LINKS
//   List<String> get noc =>
//       (raw["noc"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // PROMOTION + SOCIAL LINKS
//   Map<String, dynamic> get socialLinks => raw["socialLinks"] ?? {};
//   String get socialInstagram => socialLinks["instagram"] ?? "";
//   String get socialFacebook => socialLinks["facebook"] ?? "";
//   String get socialTwitter => socialLinks["twitter"] ?? "";

//   List<String> get hashtags =>
//       (raw["promotion"]?["hashtags"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // TICKETS
//   List<EventTicket> get tickets {
//     final list = raw["tickets"] as List?;
//     if (list == null) return [];
//     return list.map((t) => EventTicket.fromMap(t)).toList();
//   }
// }

// // ------------------------------------------
// // TICKET MODEL
// // ------------------------------------------
// class EventTicket {
//   final String id;
//   final String type;
//   final int price;
//   final int quantity;
//   final String seatingType;
//   final List<String> inclusions;
//   final DateTime? bookingCutoff;

//   EventTicket({
//     required this.id,
//     required this.type,
//     required this.price,
//     required this.quantity,
//     required this.seatingType,
//     required this.inclusions,
//     required this.bookingCutoff,
//   });

//   factory EventTicket.fromMap(Map<String, dynamic> map) {
//     return EventTicket(
//       id: map["id"] ?? "",
//       type: map["type"] ?? "",
//       price: map["price"] ?? 0,
//       quantity: map["quantity"] ?? 0,
//       seatingType: map["seatingType"] ?? "",
//       inclusions: (map["inclusions"] as List?)?.map((e) => e.toString()).toList() ?? [],
//       bookingCutoff: map["bookingCutoff"] is Timestamp
//           ? (map["bookingCutoff"] as Timestamp).toDate()
//           : null,
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class EventFull {
//   final String id;
//   final Map<String, dynamic> raw;

//   EventFull({
//     required this.id,
//     required this.raw,
//   });

//   factory EventFull.fromDoc(DocumentSnapshot doc) {
//     return EventFull(
//       id: doc.id,
//       raw: doc.data() as Map<String, dynamic>,
//     );
//   }

//   // Convert Google Drive link → direct link
//   String 0driveToDirect(String url) {
//     if (!url.contains("drive.google.com")) return url;
//     final id = url.split("/d/").last.split("/").first;
//     return "https://drive.google.com/uc?export=view&id=$id";
//   }

//   // BASIC INFO
//   String get name => raw["name"] ?? "";
//   String get category => raw["category"] ?? "";
//   String get ageRestriction => raw["ageRestriction"] ?? "";

//   DateTime? get dateTime {
//     final value = raw["dateTime"];
//     if (value is Timestamp) return value.toDate();
//     if (value is DateTime) return value;
//     if (value is String) {
//       try {
//         return DateTime.parse(value);
//       } catch (_) {
//         return null;
//       }
//     }
//     return null;
//   }

//   DateTime? get endDateTime {
//     final value = raw["endDateTime"];
//     if (value is Timestamp) return value.toDate();
//     if (value is DateTime) return value;
//     if (value is String) {
//       try {
//         return DateTime.parse(value);
//       } catch (_) {
//         return null;
//       }
//     }
//     return null;
//   }

//   bool get isMultiDay => raw["isMultiDay"] ?? false;

//   // ARTIST LINEUP
//   List<String> get artistLineup =>
//       (raw["artistLineup"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // MEDIA
//   Map<String, dynamic> get media => raw["media"] ?? {};
//   String get posterUrl => media["posterLink"] ?? "";
//   String get videoUrl => driveToDirect(media["videoLink"] ?? "");

//   // VENUE
//   Map<String, dynamic> get venue => raw["venue"] ?? {};
//   String get venueName => venue["name"] ?? "";
//   String get venueAddress => venue["fullAddress"] ?? "";

//   double get venueLat =>
//       double.tryParse(venue["venueLat"]?.toString() ?? "") ?? 0;

//   double get venueLng =>
//       double.tryParse(venue["venueLng"]?.toString() ?? "") ?? 0;

//   // ORGANISER
//   Map<String, dynamic> get organiser => raw["organiser"] ?? {};
//   String get organiserCompany => organiser["companyName"] ?? "";
//   String get organiserPerson => organiser["contactPerson"] ?? "";
//   String get organiserEmail => organiser["contactEmail"] ?? "";
//   String get organiserPhone => organiser["contactPhone"] ?? "";

//   // FINANCIAL INFO
//   Map<String, dynamic> get financial => raw["financial"] ?? {};
//   String get finAccountHolder => financial["accountHolder"] ?? "";
//   String get finAccountNumber => financial["accountNumber"] ?? "";
//   String get finBankName => financial["bankName"] ?? "";
//   String get finIfsc => financial["ifsc"] ?? "";
//   String get finPanOrGst => financial["panOrGst"] ?? "";

//   // LEGAL INFO
//   Map<String, dynamic> get legal => raw["legal"] ?? {};
//   String get legalGstNo => legal["gstNo"] ?? "";
//   String get legalLiability => legal["liabilityText"] ?? "";

//   // NOC FILE LINKS
//   List<String> get noc =>
//       (raw["noc"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // PROMOTION + SOCIAL LINKS
//   Map<String, dynamic> get socialLinks => raw["socialLinks"] ?? {};
//   String get socialInstagram => socialLinks["instagram"] ?? "";
//   String get socialFacebook => socialLinks["facebook"] ?? "";
//   String get socialTwitter => socialLinks["twitter"] ?? "";

//   List<String> get hashtags =>
//       (raw["promotion"]?["hashtags"] as List?)?.map((e) => e.toString()).toList() ?? [];

//   // TICKETS
//   List<EventTicket> get tickets {
//     final list = raw["tickets"] as List?;
//     if (list == null) return [];
//     return list.map((t) => EventTicket.fromMap(t)).toList();
//   }
// }

// // ------------------------------------------
// // TICKET MODEL
// // ------------------------------------------
// class EventTicket {
//   final String id;
//   final String type;
//   final int price;
//   final int quantity;
//   final String seatingType;
//   final List<String> inclusions;
//   final DateTime? bookingCutoff;

//   EventTicket({
//     required this.id,
//     required this.type,
//     required this.price,
//     required this.quantity,
//     required this.seatingType,
//     required this.inclusions,
//     required this.bookingCutoff,
//   });

//   factory EventTicket.fromMap(Map<String, dynamic> map) {
//     DateTime? parseBookingCutoff(dynamic value) {
//       if (value is Timestamp) return value.toDate();
//       if (value is DateTime) return value;
//       if (value is String) {
//         try {
//           return DateTime.parse(value);
//         } catch (_) {
//           return null;
//         }
//       }
//       return null;
//     }

//     return EventTicket(
//       id: map["id"] ?? "",
//       type: map["type"] ?? "",
//       price: map["price"] ?? 0,
//       quantity: map["quantity"] ?? 0,
//       seatingType: map["seatingType"] ?? "",
//       inclusions: (map["inclusions"] as List?)?.map((e) => e.toString()).toList() ?? [],
//       bookingCutoff: parseBookingCutoff(map["bookingCutoff"]),
//     );
//   }
// }
class EventFull {
  final String id;
  final Map<String, dynamic> raw;

  EventFull({
    required this.id,
    required this.raw,
  });

  factory EventFull.fromDoc(DocumentSnapshot doc) {
    return EventFull(
      id: doc.id,
      raw: doc.data() as Map<String, dynamic>,
    );
  }

  // Convert Google Drive link → direct link
  String driveToDirect(String url) {
    if (!url.contains("drive.google.com")) return url;
    final reg = RegExp(r"[-\w]{25,}");
    final match = reg.firstMatch(url);
    if (match == null) return url;
    return "https://drive.google.com/uc?export=view&id=${match.group(0)}";
  }

  // BASIC INFO
  String get name => raw["name"] ?? "";
  String get category => raw["category"] ?? "";
  String get ageRestriction => raw["ageRestriction"] ?? "";
  String get ticketRequiredAge => raw["ticketRequiredAge"] ?? "";
  String get layout => raw["layout"] ?? "";

  // DAYS - Multi-day event support
  List<EventDay> get days {
    final daysList = raw["days"] as List?;
    if (daysList == null || daysList.isEmpty) return [];
    
    return daysList.asMap().entries.map((entry) {
      final dayMap = entry.value as Map<String, dynamic>;
      final dayKey = "day${entry.key + 1}";
      final dayData = dayMap[dayKey] as Map<String, dynamic>?;
      
      if (dayData == null) return null;
      return EventDay.fromMap(dayData, entry.key + 1);
    }).whereType<EventDay>().toList();
  }

  DateTime? get firstDate => days.isNotEmpty ? days.first.date : null;
  DateTime? get lastDate => days.isNotEmpty ? days.last.date : null;

  // ARTIST LINEUP
  List<String> get artistLineup =>
      (raw["artistLineup"] as List?)?.map((e) => e.toString()).toList() ?? [];

  // LANGUAGES
  List<String> get languages =>
      (raw["languages"] as List?)?.map((e) => e.toString()).toList() ?? [];

  // MEDIA
  Map<String, dynamic> get media => raw["media"] ?? {};
  String get posterUrl => media["posterLink"] ?? ""; // Firebase Storage - no conversion
  String get videoUrl => driveToDirect(media["videoLink"] ?? ""); // Drive link - convert
  
  List<String> get galleryImages =>
      (media["galleryImages"] as List?)?.map((e) => e.toString()).toList() ?? [];

  // VENUE
  Map<String, dynamic> get venue => raw["venue"] ?? {};
  String get venueName => venue["name"] ?? "";
  String get venueAddress => venue["fullAddress"] ?? "";
  String get mapsLink => venue["mapsLink"] ?? "";

  double get venueLat =>
      double.tryParse(venue["venueLat"]?.toString() ?? "") ?? 0;

  double get venueLng =>
      double.tryParse(venue["venueLng"]?.toString() ?? "") ?? 0;

  // ORGANISER
  Map<String, dynamic> get organiser => raw["organiser"] ?? {};
  String get organiserCompany => organiser["companyName"] ?? "";
  String get organiserPerson => organiser["contactPerson"] ?? "";
  String get organiserEmail => organiser["contactEmail"] ?? "";
  String get organiserPhone => organiser["contactPhone"] ?? "";

  // FINANCIAL INFO
  Map<String, dynamic> get financial => raw["financial"] ?? {};
  String get finAccountHolder => financial["accountHolder"] ?? "";
  String get finAccountNumber => financial["accountNumber"] ?? "";
  String get finBankName => financial["bankName"] ?? "";
  String get finIfsc => financial["ifsc"] ?? "";
  String get finPanOrGst => financial["panOrGst"] ?? "";

  // LEGAL INFO
  Map<String, dynamic> get legal => raw["legal"] ?? {};
  String get legalGstNo => legal["gstNo"] ?? "";
  String get legalLiability => legal["liabilityText"] ?? "";

  // NOC FILE LINKS
  List<String> get noc =>
      (raw["noc"] as List?)?.map((e) => e.toString()).toList() ?? [];

  // PROMOTION + SOCIAL LINKS
  Map<String, dynamic> get promotion => raw["promotion"] ?? {};
  Map<String, dynamic> get socialLinks => promotion["socialLinks"] ?? {};
  String get socialInstagram => socialLinks["instagram"] ?? "";
  String get socialFacebook => socialLinks["facebook"] ?? "";
  String get socialTwitter => socialLinks["twitter"] ?? "";

  List<String> get hashtags =>
      (promotion["hashtags"] as List?)?.map((e) => e.toString()).toList() ?? [];

  // TICKETS
  List<EventTicket> get tickets {
    final list = raw["tickets"] as List?;
    if (list == null) return [];
    return list.map((t) => EventTicket.fromMap(t)).toList();
  }

  // METADATA
  DateTime? get createdAt {
    final value = raw["createdAt"];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  DateTime? get updatedAt {
    final value = raw["updatedAt"];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  String get createdBy => raw["createdBy"] ?? "";
  String get eventId => raw["eventId"] ?? "";
}

// ------------------------------------------
// EVENT DAY MODEL
// ------------------------------------------
class EventDay {
  final int dayNumber;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  EventDay({
    required this.dayNumber,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory EventDay.fromMap(Map<String, dynamic> map, int dayNumber) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return DateTime.now();
    }

    TimeOfDay parseTime(Map<String, dynamic>? timeMap) {
      if (timeMap == null) return TimeOfDay(hour: 0, minute: 0);
      return TimeOfDay(
        hour: timeMap["hour"] ?? 0,
        minute: timeMap["minute"] ?? 0,
      );
    }

    return EventDay(
      dayNumber: dayNumber,
      date: parseDate(map["date"]),
      startTime: parseTime(map["startTime"] as Map<String, dynamic>?),
      endTime: parseTime(map["endTime"] as Map<String, dynamic>?),
    );
  }

  String get formattedDate => "${date.day}/${date.month}/${date.year}";
  String get formattedStartTime => "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";
  String get formattedEndTime => "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";
}

// ------------------------------------------
// TICKET MODEL
// ------------------------------------------
class EventTicket {
  final String id;
  final String type;
  final int price;
  final int quantity;
  final String seatingType;
  final List<String> inclusions;
  final DateTime? bookingCutoff;

  EventTicket({
    required this.id,
    required this.type,
    required this.price,
    required this.quantity,
    required this.seatingType,
    required this.inclusions,
    required this.bookingCutoff,
  });

  factory EventTicket.fromMap(Map<String, dynamic> map) {
    DateTime? parseBookingCutoff(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return EventTicket(
      id: map["id"] ?? "",
      type: map["type"] ?? "",
      price: map["price"] ?? 0,
      quantity: map["quantity"] ?? 0,
      seatingType: map["seatingType"] ?? "",
      inclusions: (map["inclusions"] as List?)?.map((e) => e.toString()).toList() ?? [],
      bookingCutoff: parseBookingCutoff(map["bookingCutoff"]),
    );
  }
}