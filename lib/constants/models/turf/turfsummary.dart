// import 'package:cloud_firestore/cloud_firestore.dart';

// class TurfSummary {
//   final String id;
//   final String name;
//   final String posterUrl;
//   final double venueLat;
//   final double venueLng;
//   final String venueName;

//   double distanceKm = 0.0;

//   TurfSummary({
//     required this.id,
//     required this.name,
//     required this.posterUrl,
//     required this.venueLat,
//     required this.venueLng,
//     required this.venueName,
//   });

//   factory TurfSummary.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     return TurfSummary(
//       id: doc.id,
//       name: data["name"] ?? "",
//       posterUrl:
//           (data["poster_urls"] as List?)?.first.toString() ?? "", // first poster
//       venueLat:
//           double.tryParse(data["venue_lat"]?.toString() ?? "") ?? 0.0,
//       venueLng:
//           double.tryParse(data["venue_lng"]?.toString() ?? "") ?? 0.0,
//       venueName: data["name"] ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'posterUrl': posterUrl,
//         'venueLat': venueLat,
//         'venueLng': venueLng,
//         'venueName': venueName,
//         'distanceKm': distanceKm,
//       };

//   factory TurfSummary.fromJson(Map<String, dynamic> json) {
//     return TurfSummary(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       posterUrl: json['posterUrl'] ?? '',
//       venueLat: json['venueLat'] ?? 0.0,
//       venueLng: json['venueLng'] ?? 0.0,
//       venueName: json['venueName'] ?? '',
//     )..distanceKm = json['distanceKm'] ?? 0.0;
//   }
// }





import 'package:cloud_firestore/cloud_firestore.dart';


int parseInt(double value) {
  return value.toInt();
}

class TurfSummary {
  final String id;
  final String name;
  final String ownerName;
  final String address;
  final String city;
  final String contact;
  final double venueLat;
  final double venueLng;
  final String mapLink;
  final int halfHourPrice;
  final List<String> posterUrls;
  final List<String> amenities;
  final List<String> playground;

  double distanceKm = 0.0;

  TurfSummary({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.address,
    required this.city,
    required this.contact,
    required this.venueLat,
    required this.venueLng,
    required this.mapLink,
    required this.halfHourPrice,
    required this.posterUrls,
    required this.amenities,
    required this.playground,
  });

  factory TurfSummary.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TurfSummary(
      id: doc.id,
      name: data["name"] ?? "",
      ownerName: data["owner_name"] ?? "",
      address: data["address"] ?? "",
      city: data["city"] ?? "",
      contact: data["contact"] ?? "",
      venueLat: double.tryParse(data["venue_lat"]?.toString() ?? "") ?? 0.0,
      venueLng: double.tryParse(data["venue_lng"]?.toString() ?? "") ?? 0.0,
      mapLink: data["map_link"] ?? "",
      halfHourPrice: parseInt(data["half_hour_price"] ?? 0),
      posterUrls: (data["poster_urls"] as List?)?.map((e) => e.toString()).toList() ?? [],
      amenities: (data["amenities"] as List?)?.map((e) => e.toString()).toList() ?? [],
      playground: (data["playground"] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ownerName': ownerName,
    'address': address,
    'city': city,
    'contact': contact,
    'venueLat': venueLat,
    'venueLng': venueLng,
    'mapLink': mapLink,
    'halfHourPrice': halfHourPrice,
    'posterUrls': posterUrls,
    'amenities': amenities,
    'playground': playground,
    'distanceKm': distanceKm,
  };

  factory TurfSummary.fromJson(Map<String, dynamic> json) {
    return TurfSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      ownerName: json['ownerName'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      contact: json['contact'] ?? '',
      venueLat: json['venueLat'] ?? 0.0,
      venueLng: json['venueLng'] ?? 0.0,
      mapLink: json['mapLink'] ?? '',
      halfHourPrice: json['halfHourPrice'] ?? 0,
      posterUrls: (json['posterUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      amenities: (json['amenities'] as List?)?.map((e) => e.toString()).toList() ?? [],
      playground: (json['playground'] as List?)?.map((e) => e.toString()).toList() ?? [],
    )..distanceKm = json['distanceKm'] ?? 0.0;
  }
}