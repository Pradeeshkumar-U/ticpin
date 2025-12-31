import 'package:cloud_firestore/cloud_firestore.dart';

class DiningSummary {
  final String id;
  final String name;
  final String briefDescription;
  final String contactNumber;
  final double venueLat;
  final double venueLng;
  final String carouselImage;
  final List<String>? cuisines;
  final List<String>? categories;
  final List<String>? facilities;
  final double rating;
  final int totalReviews;
  final String openTime;
  final String closeTime;
  
  double distanceKm = 0.0;

  DiningSummary({
    required this.id,
    required this.name,
    required this.briefDescription,
    required this.contactNumber,
    required this.venueLat,
    required this.venueLng,
    required this.carouselImage,
    this.cuisines,
    this.categories,
    this.facilities,
    required this.rating,
    required this.totalReviews,
    required this.openTime,
    required this.closeTime,
    this.distanceKm = 0.0,
  });

  factory DiningSummary.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return DiningSummary(
      id: doc.id,
      name: data['name'] ?? '',
      briefDescription: data['briefDescription'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      venueLat: _parseDouble(data['location']?['lat']),
      venueLng: _parseDouble(data['location']?['lng']),
      carouselImage: (data['images']?['carousel'] as List?)?.isNotEmpty == true
          ? data['images']['carousel'][0]
          : '',
      cuisines: (data['filters']?['cuisines'] as List?)?.cast<String>(),
      categories: (data['filters']?['categories'] as List?)?.cast<String>(),
      facilities: (data['facilities'] as List?)?.cast<String>(),
      rating: _parseDouble(data['reviews']?['rating'], defaultValue: 0.0),
      totalReviews: data['reviews']?['total'] ?? 0,
      openTime: data['timings']?['open'] ?? '',
      closeTime: data['timings']?['close'] ?? '',
    );
  }

  factory DiningSummary.fromJson(Map<String, dynamic> json) {
    return DiningSummary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      briefDescription: json['briefDescription'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      venueLat: _parseDouble(json['venueLat']),
      venueLng: _parseDouble(json['venueLng']),
      carouselImage: json['carouselImage'] ?? '',
      cuisines: (json['cuisines'] as List?)?.cast<String>(),
      categories: (json['categories'] as List?)?.cast<String>(),
      facilities: (json['facilities'] as List?)?.cast<String>(),
      rating: _parseDouble(json['rating'], defaultValue: 0.0),
      totalReviews: json['totalReviews'] ?? 0,
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
      distanceKm: _parseDouble(json['distanceKm'], defaultValue: 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'briefDescription': briefDescription,
      'contactNumber': contactNumber,
      'venueLat': venueLat,
      'venueLng': venueLng,
      'carouselImage': carouselImage,
      'cuisines': cuisines,
      'categories': categories,
      'facilities': facilities,
      'rating': rating,
      'totalReviews': totalReviews,
      'openTime': openTime,
      'closeTime': closeTime,
      'distanceKm': distanceKm,
    };
  }

  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  String get formattedDistance {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toInt()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  bool get isOpenNow {
    // You can implement time-based logic here
    return true;
  }
}