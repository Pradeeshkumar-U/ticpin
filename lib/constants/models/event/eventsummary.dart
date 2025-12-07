// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';

// /// Converts a Google Drive view URL → direct image/video URL
// String driveToDirect(String url) {
//   final reg = RegExp(r"[-\w]{25,}");
//   final match = reg.firstMatch(url);
//   if (match == null) return url;
//   return "https://drive.google.com/uc?export=view&id=${match.group(0)}";
// }

// class EventSummary {
//   final String id;
//   final String name;
//   final String posterUrl;
//   final String videoUrl;
//   final double venueLat;
//   final double venueLng;
//   final String venue;
//   final DateTime dateTime;

//   // dynamic distance (auto-updated)
//   RxDouble distanceKm = 0.0.obs;

//   EventSummary({
//     required this.id,
//     required this.name,
//     required this.posterUrl,
//     required this.videoUrl,
//     required this.venueLat,
//     required this.venueLng,
//     required this.venue,
//     required this.dateTime,
//   });

//   factory EventSummary.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     final venue = data["venue"] ?? {};

//     return EventSummary(
//       id: doc.id,
//       name: data["name"] ?? "",
//       posterUrl: driveToDirect(data["media"]?["posterLink"] ?? ""),
//       videoUrl: driveToDirect(data["media"]?["videoLink"] ?? ""),

//       /// Ensure correct double conversion
//       venueLat: double.tryParse(venue["venueLat"]?.toString() ?? "") ?? 0.0,
//       venueLng: double.tryParse(venue["venueLng"]?.toString() ?? "") ?? 0.0,

//       venue: venue["name"] ?? "",

//       dateTime: (data["dateTime"] as Timestamp).toDate(),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================
// OPTIMIZED EVENT SUMMARY
// ============================================

/// Converts a Google Drive view URL → direct image/video URL
String driveToDirect(String url) {
  if (!url.contains("drive.google.com")) return url;
  final reg = RegExp(r"[-\w]{25,}");
  final match = reg.firstMatch(url);
  if (match == null) return url;
  return "https://drive.google.com/uc?export=view&id=${match.group(0)}";
}

class EventSummary {
  final String id;
  final String name;
  final String posterUrl;
  final String videoUrl;
  final double venueLat;
  final double venueLng;
  final String venueName;
  final DateTime dateTime;
  final DateTime? endDateTime;

  double distanceKm = 0.0;

  EventSummary({
    required this.id,
    required this.name,
    required this.posterUrl,
    required this.videoUrl,
    required this.venueLat,
    required this.venueLng,
    required this.venueName,
    required this.dateTime,
    this.endDateTime,
  });

  factory EventSummary.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final venue = data["venue"] ?? {};
    final media = data["media"] ?? {};
    
    // Get the first day's date
    DateTime firstDate = DateTime.now();
    DateTime? lastDate;
    
    final days = data["days"] as List?;
    if (days != null && days.isNotEmpty) {
      final firstDay = days.first as Map<String, dynamic>;
      final dayData = firstDay["day1"] as Map<String, dynamic>?;
      if (dayData != null && dayData["date"] is Timestamp) {
        firstDate = (dayData["date"] as Timestamp).toDate();
      }
      
      if (days.length > 1) {
        final lastDay = days.last as Map<String, dynamic>;
        final lastDayKey = "day${days.length}";
        final lastDayData = lastDay[lastDayKey] as Map<String, dynamic>?;
        if (lastDayData != null && lastDayData["date"] is Timestamp) {
          lastDate = (lastDayData["date"] as Timestamp).toDate();
        }
      }
    }

    return EventSummary(
      id: doc.id,
      name: data["name"] ?? "",
      posterUrl: media["posterLink"] ?? "", // Firebase Storage URL - no conversion
      videoUrl: driveToDirect(media["videoLink"] ?? ""), // Drive link - convert
      venueLat: double.tryParse(venue["venueLat"]?.toString() ?? "") ?? 0.0,
      venueLng: double.tryParse(venue["venueLng"]?.toString() ?? "") ?? 0.0,
      venueName: venue["name"] ?? "",
      dateTime: firstDate,
      endDateTime: lastDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'posterUrl': posterUrl,
    'videoUrl': videoUrl,
    'venueLat': venueLat,
    'venueLng': venueLng,
    'venueName': venueName,
    'dateTime': dateTime.millisecondsSinceEpoch,
    'endDateTime': endDateTime?.millisecondsSinceEpoch,
    'distanceKm': distanceKm,
  };

  factory EventSummary.fromJson(Map<String, dynamic> json) {
    return EventSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      venueLat: json['venueLat'] ?? 0.0,
      venueLng: json['venueLng'] ?? 0.0,
      venueName: json['venueName'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime'] ?? 0),
      endDateTime: json['endDateTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['endDateTime']) 
          : null,
    )..distanceKm = json['distanceKm'] ?? 0.0;
  }
}