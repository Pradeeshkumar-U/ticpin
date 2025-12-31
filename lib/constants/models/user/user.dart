// User Document Structure and Models

import 'package:cloud_firestore/cloud_firestore.dart';

// ==================== USER MODEL ====================

class UserModel {
  final String userId;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profilePicUrl;
  final List<String> eventBookings; // List of event booking IDs
  final List<String> turfBookings; // List of turf booking IDs
  final List<String> diningBookings; // List of turf booking IDs
  final List<String> diningPayBill;
  final TicList ticList;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.userId,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profilePicUrl,
    this.eventBookings = const [],
    this.turfBookings = const [],
    this.diningBookings = const [],
    this.diningPayBill = const [],
    required this.ticList,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      phoneNumber: data['phoneNumber'] ?? '',
      name: data['name'],
      email: data['email'],
      profilePicUrl: data['profilePicUrl'],
      eventBookings: List<String>.from(data['eventBookings'] ?? []),
      turfBookings: List<String>.from(data['turfBookings'] ?? []),
      diningBookings: List<String>.from(data['diningBookings'] ?? []),
      diningPayBill : List<String>.from(data['diningPayBill']??[]),
      ticList: TicList.fromMap(data['ticList'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt:
          data['updatedAt'] != null
              ? (data['updatedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'eventBookings': eventBookings,
      'turfBookings': turfBookings,
      'diningBookings': diningBookings,
      'diningPayBill':diningPayBill,
      'ticList': ticList.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePicUrl,
    List<String>? eventBookings,
    List<String>? turfBookings,
    List<String>? diningBookings,
    List<String>? diningPayBill,
    TicList? ticList,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: this.userId,
      phoneNumber: this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      eventBookings: eventBookings ?? this.eventBookings,
      turfBookings: turfBookings ?? this.turfBookings,
      diningBookings: diningBookings ?? this.diningBookings,
      diningPayBill : diningPayBill??this.diningPayBill,
      ticList: ticList ?? this.ticList,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// ==================== TICLIST MODEL ====================

class TicList {
  final List<String> events;
  final List<String> turfs;
  final List<String> artists;
  final List<String> dining;

  TicList({
    this.events = const [],
    this.turfs = const [],
    this.artists = const [],
    this.dining = const [],
  });

  factory TicList.fromMap(Map<String, dynamic> map) {
    return TicList(
      events: List<String>.from(map['events'] ?? []),
      turfs: List<String>.from(map['turfs'] ?? []),
      artists: List<String>.from(map['artists'] ?? []),
      dining: List<String>.from(map['dining'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'events': events,
      'turfs': turfs,
      'artists': artists,
      'dining': dining,
    };
  }

  TicList copyWith({
    List<String>? events,
    List<String>? turfs,
    List<String>? artists,
    List<String>? dining,
  }) {
    return TicList(
      events: events ?? this.events,
      turfs: turfs ?? this.turfs,
      artists: artists ?? this.artists,
      dining: dining ?? this.dining,
    );
  }

  int get totalCount =>
      events.length + turfs.length + artists.length + dining.length;
}

// ==================== TICLIST ITEM TYPES ====================

enum TicListItemType { event, turf, artist, dining }

class TicListItem {
  final String id;
  final TicListItemType type;

  TicListItem({required this.id, required this.type});
}

// ==================== FIRESTORE USER DOCUMENT STRUCTURE ====================

/*
Collection: users
Document ID: {userId} (Firebase Auth UID)

Document Structure:
{
  "userId": "string",
  "phoneNumber": "string (required)",
  "name": "string (optional, null initially)",
  "email": "string (optional, null initially)",
  "profilePicUrl": "string (optional, null initially)",
  "eventBookings": ["booking_id_1", "booking_id_2"],
  "turfBookings": ["booking_id_1", "booking_id_2"],
  "ticList": {
    "events": ["event_id_1", "event_id_2"],
    "turfs": ["turf_id_1", "turf_id_2"],
    "artists": ["artist_id_1", "artist_id_2"],
    "dining": ["dining_id_1", "dining_id_2"]
  },
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
*/
