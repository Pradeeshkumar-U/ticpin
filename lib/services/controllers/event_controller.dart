// // import 'dart:math';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:get/get.dart';
// // import 'package:get_storage/get_storage.dart';
// // import 'package:ticpin/constants/models/event/eventfull.dart';
// // import 'package:ticpin/constants/models/event/eventsummary.dart';

// // class EventController extends GetxController {
// //   final allSummaries = <EventSummary>[].obs;
// //   final nearestSummaries = <EventSummary>[].obs;
// //   final loading = false.obs;

// //   // user location
// //   final userAddress = "".obs;
// //   double? userLat;
// //   double? userLng;
// //   RxString place = "".obs;
// //   RxString state = "".obs;

// //   bool manualLocationSelected = false;
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     loadAllEvents();
// //   }

// //   /// LOAD ALL EVENTS
// //   Future<void> loadAllEvents() async {
// //     loading.value = true;

// //     final snap =
// //         await FirebaseFirestore.instance
// //             .collection("events")
// //             .orderBy("dateTime")
// //             .get();

// //     allSummaries.value = snap.docs.map((d) => EventSummary.fromDoc(d)).toList();

// //     _recalculateNearest();

// //     loading.value = false;
// //   }

// //   /// LOAD FULL EVENT DETAILS
// //   Future<EventFull?> loadEventFull(String id) async {
// //     final doc =
// //         await FirebaseFirestore.instance.collection("events").doc(id).get();
// //     if (!doc.exists) return null;
// //     return EventFull.fromDoc(doc);
// //   }

// //   /// USER ENTERED A CITY NAME
// //   Future<void> setUserCity(String cityName) async {
// //     try {
// //       final geo = await locationFromAddress(cityName);
// //       if (geo.isNotEmpty) {
// //         print(
// //           "Fetched current position: ${geo.first.latitude}, ${geo.first.longitude}",
// //         );
// //         await setUserLocation(geo.first.latitude, geo.first.longitude);
// //       }
// //     } catch (e) {
// //       print("City geocode failed: $e");
// //     }
// //   }

// //   Future<void> fetchDeviceLocation() async {
// //     if (manualLocationSelected) return; // skip if user manually chose

// //     final position = await Geolocator.getCurrentPosition();
// //     userLat = position.latitude;
// //     userLng = position.longitude;
// //     setUserLocation(userLat!, userLng!);
// //     try {
// //       List<Placemark> placemarks = await placemarkFromCoordinates(
// //         userLat!,
// //         userLng!,
// //       );

// //       if (placemarks.isNotEmpty) {
// //         final city = placemarks.first;
// //         place.value =
// //             city.locality?.isNotEmpty == true
// //                 ? city.locality!
// //                 : (city.administrativeArea ?? "");
// //         state.value = (city.administrativeArea ?? "");
// //         // if (place == secondaryPlace) secondaryPlace = "Tamil nadu";
// //       }
// //     } catch (e) {
// //       print("Reverse geocoding failed: $e");
// //     }
// //   }

// //   /// SET USER LOCATION
// //   Future<void> setUserLocation(double lat, double lng) async {
// //     userLat = lat;
// //     userLng = lng;
// //     manualLocationSelected = true;
// //     _recalculateNearest();
// //   }

// //   /// CALCULATE NEAREST EVENTS
// //   void _recalculateNearest() {
// //     if (userLat == null || userLng == null) {
// //       nearestSummaries.clear();
// //       return;
// //     }

// //     for (var e in allSummaries) {
// //       final dist = _calculateDistance(
// //         userLat!,
// //         userLng!,
// //         e.venueLat,
// //         e.venueLng,
// //       );

// //       e.distanceKm.value = dist;
// //     }

// //     // Sort by date ascending
// //     final sorted = [...allSummaries];
// //     sorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));

// //     // If you also want to keep nearest first within same date,
// //     // you can use a compound sort like:
// //     sorted.sort((a, b) {
// //       int dateCompare = a.dateTime.compareTo(b.dateTime);
// //       if (dateCompare != 0) return dateCompare;
// //       return a.distanceKm.value.compareTo(b.distanceKm.value);
// //     });

// //     nearestSummaries.value = sorted.take(10).toList();
// //   }

// //   /// HAVERSINE
// //   double _calculateDistance(
// //     double lat1,
// //     double lon1,
// //     double lat2,
// //     double lon2,
// //   ) {
// //     const R = 6371;
// //     final dLat = _deg2rad(lat2 - lat1);
// //     final dLon = _deg2rad(lon2 - lon1);

// //     final a =
// //         sin(dLat / 2) * sin(dLat / 2) +
// //         cos(_deg2rad(lat1)) *
// //             cos(_deg2rad(lat2)) *
// //             sin(dLon / 2) *
// //             sin(dLon / 2);

// //     return R * 2 * atan2(sqrt(a), sqrt(1 - a));
// //   }

// //   double _deg2rad(double deg) => deg * (pi / 180);
// // }
// import 'dart:math';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ticpin/constants/models/event/eventsummary.dart';
// import 'package:ticpin/constants/models/event/eventfull.dart';
// import 'location_controller.dart';

// class EventController extends GetxController {
//   final allSummaries = <EventSummary>[].obs;
//   final nearestSummaries = <EventSummary>[].obs;
//   final loading = false.obs;

//   final LocationController loc = Get.put(LocationController());

//   @override
//   void onInit() {
//     super.onInit();
//     loadAllEvents();

//     /// Recalculate nearest whenever location changes
//     ever(loc.city, (_) => _recalculateNearest());
//     ever(loc.state, (_) => _recalculateNearest());
//   }

//   /// LOAD ALL EVENTS
//   Future<void> loadAllEvents() async {
//     loading.value = true;

//     final snap =
//         await FirebaseFirestore.instance
//             .collection("events")
//             .orderBy("dateTime")
//             .get();

//     allSummaries.value = snap.docs.map((d) => EventSummary.fromDoc(d)).toList();

//     _recalculateNearest();

//     loading.value = false;
//   }

//   /// LOAD FULL EVENT DETAILS
//   Future<EventFull?> loadEventFull(String id) async {
//     final doc =
//         await FirebaseFirestore.instance.collection("events").doc(id).get();
//     return doc.exists ? EventFull.fromDoc(doc) : null;
//   }

//   /// CALCULATE NEAREST EVENTS
//   void _recalculateNearest() {
//     if (loc.userLat == null || loc.userLng == null) {
//       nearestSummaries.clear();
//       return;
//     }

//     // Update distance
//     for (var e in allSummaries) {
//       e.distanceKm.value = _calculateDistance(
//         loc.userLat!,
//         loc.userLng!,
//         e.venueLat,
//         e.venueLng,
//       );
//     }

//     // Sort by date + distance
//     final sorted = [...allSummaries];
//     sorted.sort((a, b) {
//       int date = a.dateTime.compareTo(b.dateTime);
//       if (date != 0) return date;
//       return a.distanceKm.value.compareTo(b.distanceKm.value);
//     });

//     nearestSummaries.value = sorted.take(10).toList();
//   }

//   /// HAVERSINE
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const R = 6371;
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);

//     final a =
//         sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(lat1)) *
//             cos(_deg2rad(lat2)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);

//     return R * 2 * atan2(sqrt(a), sqrt(1 - a));
//   }

//   double _deg2rad(double deg) => deg * (pi / 180);
// }import 'dart:convert';


// import 'dart:convert';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:ticpin/constants/models/event/eventfull.dart';
// import 'package:ticpin/constants/models/event/eventsummary.dart';
// import 'location_controller.dart';

// class EventController extends GetxController {
//   final allSummaries = <EventSummary>[].obs;
//   final nearestSummaries = <EventSummary>[].obs;
//   final loading = false.obs;

//   final LocationController loc = Get.put(LocationController());
//   final _storage = GetStorage();
//   final _firestore = FirebaseFirestore.instance;

//   // Cache settings
//   static const String _cacheKey = 'events_cache';
//   static const String _cacheTimeKey = 'events_cache_time';
//   static const Duration _cacheExpiry = Duration(hours: 6);

//   // Pagination
//   DocumentSnapshot? _lastDocument;
//   final _pageSize = 20;
//   bool _hasMore = true;

//   @override
//   void onInit() {
//     super.onInit();
//     loadAllEvents();
//     ever(loc.city, (_) => _recalculateNearest());
//     ever(loc.state, (_) => _recalculateNearest());
//   }

//   /// ----------------------------
//   /// HELPERS
//   /// ----------------------------
//   /// ----------------------------
//   /// HELPER: Recursively convert Firestore Timestamps & ensure Map<String, dynamic>
//   /// ----------------------------
//   dynamic _convertTimestamps(dynamic value, {bool toJson = false}) {
//     if (value is Timestamp)
//       return toJson ? value.toDate().toIso8601String() : value.toDate();
//     if (value is DateTime) return toJson ? value.toIso8601String() : value;
//     if (value is Map) {
//       // Force keys to String recursively
//       return Map<String, dynamic>.fromEntries(
//         value.entries.map(
//           (e) => MapEntry(
//             e.key.toString(),
//             _convertTimestamps(e.value, toJson: toJson),
//           ),
//         ),
//       );
//     }
//     if (value is List)
//       return value.map((v) => _convertTimestamps(v, toJson: toJson)).toList();
//     return value;
//   }

//   /// ----------------------------
//   /// LOAD ALL EVENTS
//   /// ----------------------------
//   Future<void> loadAllEvents({bool forceRefresh = false}) async {
//     if (!forceRefresh && _isCacheValid()) {
//       _loadFromCache();
//       _recalculateNearest();
//       return;
//     }

//     loading.value = true;
//     try {
//       final now = DateTime.now();
//       final cutoffDate = now.subtract(Duration(days: 7));

//       final snap =
//           await _firestore
//               .collection("events")
//               .where("dateTime", isGreaterThan: Timestamp.fromDate(cutoffDate))
//               .orderBy("dateTime")
//               .limit(_pageSize)
//               .get();

//       if (snap.docs.isEmpty) {
//         loading.value = false;
//         return;
//       }

//       allSummaries.value =
//           snap.docs.map((doc) => EventSummary.fromDoc(doc)).toList();

//       _lastDocument = snap.docs.last;
//       _hasMore = snap.docs.length == _pageSize;

//       _saveToCache();
//       _recalculateNearest();
//       print('✅ Loaded ${allSummaries.length} events from Firestore');
//     } catch (e) {
//       print('Firestore load error: $e');
//     } finally {
//       loading.value = false;
//     }
//   }

//   /// ----------------------------
//   /// LOAD FULL EVENT
//   /// ----------------------------
//   Future<EventFull?> loadEventFull(String id) async {
//     try {
//       final cacheKey = 'event_full_$id';
//       final cached = _storage.read<String>(cacheKey);

//       if (cached != null) {
//         final decoded = json.decode(cached);
//         final Map<String, dynamic> raw = Map<String, dynamic>.from(decoded);
//         final cleaned = _convertTimestamps(raw);
//         return EventFull(id: id, raw: cleaned);
//       }

//       final doc = await _firestore.collection("events").doc(id).get();
//       if (!doc.exists) return null;

//       // Convert Firestore Timestamp to DateTime and ensure Map<String, dynamic>
//       final rawData = _convertTimestamps(doc.data());
//       _storage.write(
//         cacheKey,
//         json.encode(_convertTimestamps(rawData, toJson: true)),
//       );

//       return EventFull(id: id, raw: Map<String, dynamic>.from(rawData));
//     } catch (e) {
//       print("Load event full error: $e");
//       return null;
//     }
//   }

//   /// ----------------------------
//   /// LOAD MORE EVENTS
//   /// ----------------------------
//   Future<void> loadMoreEvents() async {
//     if (!_hasMore || loading.value || _lastDocument == null) return;

//     loading.value = true;
//     try {
//       final now = DateTime.now();
//       final cutoffDate = now.subtract(Duration(days: 7));

//       final snap =
//           await _firestore
//               .collection("events")
//               .where("dateTime", isGreaterThan: Timestamp.fromDate(cutoffDate))
//               .orderBy("dateTime")
//               .startAfterDocument(_lastDocument!)
//               .limit(_pageSize)
//               .get();

//       if (snap.docs.isEmpty) {
//         _hasMore = false;
//         loading.value = false;
//         return;
//       }

//       final newEvents =
//           snap.docs.map((doc) => EventSummary.fromDoc(doc)).toList();
//       allSummaries.addAll(newEvents);
//       _lastDocument = snap.docs.last;
//       _hasMore = snap.docs.length == _pageSize;

//       _saveToCache();
//       _recalculateNearest();
//     } catch (e) {
//       print('Load more error: $e');
//     } finally {
//       loading.value = false;
//     }
//   }

//   /// ----------------------------
//   /// REFRESH EVENTS
//   /// ----------------------------
//   Future<void> refreshEvents() async {
//     _lastDocument = null;
//     _hasMore = true;
//     await loadAllEvents(forceRefresh: true);
//   }

//   /// ----------------------------
//   /// CACHE
//   /// ----------------------------
//   bool _isCacheValid() {
//     final cacheTime = _storage.read<int>(_cacheTimeKey);
//     if (cacheTime == null) return false;

//     final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
//     final now = DateTime.now();

//     return now.difference(cacheDate) < _cacheExpiry;
//   }

//   void _loadFromCache() {
//     try {
//       final cached = _storage.read<String>(_cacheKey);
//       if (cached != null) {
//         final List<dynamic> decoded = json.decode(cached);
//         allSummaries.value =
//             decoded
//                 .map(
//                   (item) =>
//                       EventSummary.fromJson(Map<String, dynamic>.from(item)),
//                 )
//                 .toList();
//         print('✅ Loaded ${allSummaries.length} events from cache (FREE)');
//       }
//     } catch (e) {
//       print('Cache read error: $e');
//     }
//   }

//   void _saveToCache() {
//     try {
//       final encoded = json.encode(
//         allSummaries
//             .map((e) => _convertTimestamps(e.toJson(), toJson: true))
//             .toList(),
//       );
//       _storage.write(_cacheKey, encoded);
//       _storage.write(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
//     } catch (e) {
//       print('Cache save error: $e');
//     }
//   }

//   /// ----------------------------
//   /// NEAREST EVENTS
//   /// ----------------------------
//   void _recalculateNearest() {
//     if (loc.userLat == null || loc.userLng == null) {
//       nearestSummaries.clear();
//       return;
//     }

//     for (var e in allSummaries) {
//       e.distanceKm = _calculateDistance(
//         loc.userLat!,
//         loc.userLng!,
//         e.venueLat,
//         e.venueLng,
//       );
//     }

//     final sorted = [...allSummaries];
//     sorted.sort((a, b) {
//       int date = a.dateTime.compareTo(b.dateTime);
//       if (date != 0) return date;
//       return a.distanceKm.compareTo(b.distanceKm);
//     });

//     nearestSummaries.value = sorted.take(10).toList();
//   }

//   double _calculateDistance(
//     double lat1,
//     double lon1,
//     double lat2,
//     double lon2,
//   ) {
//     const R = 6371;
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);

//     final a =
//         sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(lat1)) *
//             cos(_deg2rad(lat2)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);

//     return R * 2 * atan2(sqrt(a), sqrt(1 - a));
//   }

//   double _deg2rad(double deg) => deg * (pi / 180);

//   /// ----------------------------
//   /// CLEAR CACHE
//   /// ----------------------------
//   void clearCache() {
//     _storage.remove(_cacheKey);
//     _storage.remove(_cacheTimeKey);
//     print('✅ Cache cleared');
//   }
// }

// import 'dart:convert';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:ticpin/constants/models/event/eventfull.dart';
// import 'package:ticpin/constants/models/event/eventsummary.dart';
// import 'location_controller.dart';

// class EventController extends GetxController {
//   final allSummaries = <EventSummary>[].obs;
//   final nearestSummaries = <EventSummary>[].obs;
//   final loading = false.obs;

//   final LocationController loc = Get.put(LocationController());
//   final _storage = GetStorage();
//   final _firestore = FirebaseFirestore.instance;

//   // Cache settings
//   static const String _cacheKey = 'events_cache';
//   static const String _cacheTimeKey = 'events_cache_time';
//   static const Duration _cacheExpiry = Duration(hours: 6);

//   // Pagination
//   DocumentSnapshot? _lastDocument;
//   final _pageSize = 20;
//   bool _hasMore = true;

//   @override
//   void onInit() {
//     super.onInit();
//     loadAllEvents();
//     ever(loc.city, (_) => _recalculateNearest());
//     ever(loc.state, (_) => _recalculateNearest());
//   }

//   /// ----------------------------
//   /// HELPER: Convert Firestore data for caching
//   /// ----------------------------
//   dynamic _convertForCache(dynamic value) {
//     if (value is Timestamp) return value.toDate().toIso8601String();
//     if (value is DateTime) return value.toIso8601String();
//     if (value is Map) {
//       return Map<String, dynamic>.fromEntries(
//         value.entries.map(
//           (e) => MapEntry(e.key.toString(), _convertForCache(e.value)),
//         ),
//       );
//     }
//     if (value is List) {
//       return value.map((v) => _convertForCache(v)).toList();
//     }
//     return value;
//   }



//   /// ----------------------------
//   /// LOAD ALL EVENTS
//   /// ----------------------------
//   Future<void> loadAllEvents({bool forceRefresh = false}) async {
//     if (!forceRefresh && _isCacheValid()) {
//       _loadFromCache();
//       _recalculateNearest();
//       return;
//     }

//     loading.value = true;
//     try {
//       final now = DateTime.now();
//       final cutoffDate = now.subtract(Duration(days: 7));

//       final snap = await _firestore
//           .collection("events")
//           .where("dateTime", isGreaterThan: Timestamp.fromDate(cutoffDate))
//           .orderBy("dateTime")
//           .limit(_pageSize)
//           .get();

//       if (snap.docs.isEmpty) {
//         _hasMore = false;
//         loading.value = false;
//         return;
//       }

//       allSummaries.value =
//           snap.docs.map((doc) => EventSummary.fromDoc(doc)).toList();

//       _lastDocument = snap.docs.last;
//       _hasMore = snap.docs.length == _pageSize;

//       _saveToCache();
//       _recalculateNearest();
//       print('✅ Loaded ${allSummaries.length} events from Firestore');
//     } catch (e) {
//       print('❌ Firestore load error: $e');
//     } finally {
//       loading.value = false;
//     }
//   }

//   /// ----------------------------
//   /// LOAD FULL EVENT
//   /// ----------------------------
//   Future<EventFull?> loadEventFull(String id) async {
//     try {
//       final cacheKey = 'event_full_$id';
//       final cached = _storage.read<String>(cacheKey);

//       if (cached != null) {
//         try {
//           final decoded = json.decode(cached);
//           final Map<String, dynamic> rawMap = Map<String, dynamic>.from(decoded);
          
//           // Convert ISO8601 strings back to DateTime objects
//           final converted = _restoreTimestampsFromCache(rawMap);
          
//           return EventFull(
//             id: id,
//             raw: converted,
//           );
//         } catch (e) {
//           print('⚠️ Cache parse error for $id: $e');
//           // Continue to fetch from Firestore if cache is corrupted
//           _storage.remove(cacheKey);
//         }
//       }

//       final doc = await _firestore.collection("events").doc(id).get();
//       if (!doc.exists || doc.data() == null) {
//         print('❌ Event $id not found');
//         return null;
//       }

//       final rawData = doc.data()!;
      
//       // Convert Firestore Timestamps to DateTime for the EventFull object
//       final processedData = _convertFirestoreTimestamps(rawData);
      
//       // Cache the data (convert DateTime to ISO8601 strings)
//       try {
//         final forCache = _convertForCache(processedData);
//         _storage.write(cacheKey, json.encode(forCache));
//       } catch (e) {
//         print('⚠️ Cache write error for $id: $e');
//       }

//       return EventFull(id: id, raw: processedData);
//     } catch (e) {
//       print("❌ Load event full error: $e");
//       return null;
//     }
//   }

//   /// Convert Firestore Timestamps to DateTime objects recursively
//   Map<String, dynamic> _convertFirestoreTimestamps(Map<String, dynamic> data) {
//     final result = <String, dynamic>{};
    
//     data.forEach((key, value) {
//       if (value is Timestamp) {
//         result[key] = value.toDate();
//       } else if (value is Map) {
//         result[key] = _convertFirestoreTimestamps(Map<String, dynamic>.from(value));
//       } else if (value is List) {
//         result[key] = value.map((item) {
//           if (item is Timestamp) return item.toDate();
//           if (item is Map) return _convertFirestoreTimestamps(Map<String, dynamic>.from(item));
//           return item;
//         }).toList();
//       } else {
//         result[key] = value;
//       }
//     });
    
//     return result;
//   }

//   /// Restore DateTime objects from cached ISO8601 strings
//   Map<String, dynamic> _restoreTimestampsFromCache(Map<String, dynamic> data) {
//     final result = <String, dynamic>{};
    
//     data.forEach((key, value) {
//       if (value is String && _isIso8601(value)) {
//         try {
//           result[key] = DateTime.parse(value);
//         } catch (_) {
//           result[key] = value;
//         }
//       } else if (value is Map) {
//         result[key] = _restoreTimestampsFromCache(Map<String, dynamic>.from(value));
//       } else if (value is List) {
//         result[key] = value.map((item) {
//           if (item is String && _isIso8601(item)) {
//             try {
//               return DateTime.parse(item);
//             } catch (_) {
//               return item;
//             }
//           }
//           if (item is Map) return _restoreTimestampsFromCache(Map<String, dynamic>.from(item));
//           return item;
//         }).toList();
//       } else {
//         result[key] = value;
//       }
//     });
    
//     return result;
//   }

//   /// Check if a string is in ISO8601 format
//   bool _isIso8601(String value) {
//     return RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}').hasMatch(value);
//   }

//   /// ----------------------------
//   /// LOAD MORE EVENTS
//   /// ----------------------------
//   Future<void> loadMoreEvents() async {
//     if (!_hasMore || loading.value || _lastDocument == null) return;

//     loading.value = true;
//     try {
//       final now = DateTime.now();
//       final cutoffDate = now.subtract(Duration(days: 7));

//       final snap = await _firestore
//           .collection("events")
//           .where("dateTime", isGreaterThan: Timestamp.fromDate(cutoffDate))
//           .orderBy("dateTime")
//           .startAfterDocument(_lastDocument!)
//           .limit(_pageSize)
//           .get();

//       if (snap.docs.isEmpty) {
//         _hasMore = false;
//         loading.value = false;
//         return;
//       }

//       final newEvents =
//           snap.docs.map((doc) => EventSummary.fromDoc(doc)).toList();
//       allSummaries.addAll(newEvents);
//       _lastDocument = snap.docs.last;
//       _hasMore = snap.docs.length == _pageSize;

//       _saveToCache();
//       _recalculateNearest();
//       print('✅ Loaded ${newEvents.length} more events');
//     } catch (e) {
//       print('❌ Load more error: $e');
//     } finally {
//       loading.value = false;
//     }
//   }

//   /// ----------------------------
//   /// REFRESH EVENTS
//   /// ----------------------------
//   Future<void> refreshEvents() async {
//     _lastDocument = null;
//     _hasMore = true;
//     allSummaries.clear();
//     nearestSummaries.clear();
//     await loadAllEvents(forceRefresh: true);
//   }

//   /// ----------------------------
//   /// CACHE
//   /// ----------------------------
//   bool _isCacheValid() {
//     final cacheTime = _storage.read<int>(_cacheTimeKey);
//     if (cacheTime == null) return false;

//     final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
//     final now = DateTime.now();

//     return now.difference(cacheDate) < _cacheExpiry;
//   }

//   void _loadFromCache() {
//     try {
//       final cached = _storage.read<String>(_cacheKey);
//       if (cached == null) return;

//       final List<dynamic> decoded = json.decode(cached);
//       allSummaries.value = decoded
//           .map((item) => EventSummary.fromJson(Map<String, dynamic>.from(item)))
//           .toList();
      
//       print('✅ Loaded ${allSummaries.length} events from cache');
//     } catch (e) {
//       print('❌ Cache read error: $e');
//       // Clear corrupted cache
//       _storage.remove(_cacheKey);
//       _storage.remove(_cacheTimeKey);
//     }
//   }

//   void _saveToCache() {
//     try {
//       final encoded = json.encode(
//         allSummaries.map((e) => e.toJson()).toList(),
//       );
//       _storage.write(_cacheKey, encoded);
//       _storage.write(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
//       print('✅ Cache saved');
//     } catch (e) {
//       print('❌ Cache save error: $e');
//     }
//   }

//   /// ----------------------------
//   /// NEAREST EVENTS
//   /// ----------------------------
//   void _recalculateNearest() {
//     if (loc.userLat == null || loc.userLng == null) {
//       nearestSummaries.clear();
//       return;
//     }

//     // Calculate distance for all events
//     for (var e in allSummaries) {
//       e.distanceKm = _calculateDistance(
//         loc.userLat!,
//         loc.userLng!,
//         e.venueLat,
//         e.venueLng,
//       );
//     }

//     // Sort by date first, then by distance
//     final sorted = [...allSummaries];
//     sorted.sort((a, b) {
//       final dateCompare = a.dateTime.compareTo(b.dateTime);
//       if (dateCompare != 0) return dateCompare;
//       return a.distanceKm.compareTo(b.distanceKm);
//     });

//     nearestSummaries.value = sorted.take(10).toList();
//     print('✅ Recalculated ${nearestSummaries.length} nearest events');
//   }

//   double _calculateDistance(
//     double lat1,
//     double lon1,
//     double lat2,
//     double lon2,
//   ) {
//     const R = 6371.0; // Earth radius in km
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);

//     final a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(lat1)) *
//             cos(_deg2rad(lat2)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);

//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _deg2rad(double deg) => deg * (pi / 180);

//   /// ----------------------------
//   /// CLEAR CACHE
//   /// ----------------------------
//   void clearCache() {
//     _storage.remove(_cacheKey);
//     _storage.remove(_cacheTimeKey);
    
//     // Clear all individual event caches
//     final keys = _storage.getKeys();
//     for (var key in keys) {
//       if (key.toString().startsWith('event_full_')) {
//         _storage.remove(key);
//       }
//     }
    
//     print('✅ All cache cleared');
//   }

//   /// ----------------------------
//   /// UTILITY
//   /// ----------------------------
//   bool get hasMore => _hasMore;
  
//   int get totalEvents => allSummaries.length;
// }

// event_controller.dart

import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ticpin/constants/models/event/eventfull.dart';
import 'package:ticpin/constants/models/event/eventsummary.dart';
import 'package:ticpin/services/controllers/location_controller.dart';
import 'package:video_player/video_player.dart';

class EventController extends GetxController {
  final allSummaries = <EventSummary>[].obs;
  final nearestSummaries = <EventSummary>[].obs;
  final forYouEvents = <EventSummary>[].obs; // First 8 events for YouPage
  final loading = false.obs;

  var currentCarouselIndex = 0.obs;

  final LocationController loc = Get.put(LocationController());
  final _storage = GetStorage();
  final _firestore = FirebaseFirestore.instance;

  // Cache settings
  static const String _cacheKey = 'events_cache';
  static const String _cacheTimeKey = 'events_cache_time';
  static const Duration _cacheExpiry = Duration(hours: 6);

  // Pagination
  DocumentSnapshot? _lastDocument;
  final _pageSize = 10;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadAllEvents();
    ever(loc.city, (_) => _recalculateNearest());
    ever(loc.state, (_) => _recalculateNearest());
  }


  RxList<VideoPlayerController?> videoControllers = <VideoPlayerController?>[].obs;

  void initializeController(int index, String url) {
    if (videoControllers.length <= index || videoControllers[index] != null) return;

    final controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        update();
      });

    if (videoControllers.length <= index) {
      videoControllers.add(controller);
    } else {
      videoControllers[index] = controller;
    }
  }

  void playVideo(int index) {
    final controller = videoControllers[index];
    if (controller != null && !controller.value.isPlaying) {
      controller.play();
    }
  }

  void pauseVideo(int index) {
    final controller = videoControllers[index];
    if (controller != null && controller.value.isPlaying) {
      controller.pause();
    }
  }
  
  /// ----------------------------
  /// HELPER: Convert Firestore data for caching
  /// ----------------------------
  dynamic _convertForCache(dynamic value) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is DateTime) return value.toIso8601String();
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map(
          (e) => MapEntry(e.key.toString(), _convertForCache(e.value)),
        ),
      );
    }
    if (value is List) {
      return value.map((v) => _convertForCache(v)).toList();
    }
    return value;
  }

  /// ----------------------------
  /// LOAD ALL EVENTS
  /// ----------------------------
  Future<void> loadAllEvents({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid()) {
      _loadFromCache();
      _updateForYouEvents();
      _recalculateNearest();
      return;
    }

    loading.value = true;
    try {
      final snap = await _firestore
          .collection("events")
          .orderBy("createdAt", descending: true)
          .limit(_pageSize)
          .get();

      if (snap.docs.isEmpty) {
        _hasMore = false;
        loading.value = false;
        return;
      }

      allSummaries.value =
          snap.docs.map((doc) => EventSummary.fromDoc(doc)).toList();

      _lastDocument = snap.docs.last;
      _hasMore = snap.docs.length == _pageSize;

      _saveToCache();
      _updateForYouEvents();
      _recalculateNearest();
      print('✅ Loaded ${allSummaries.length} events from Firestore');
    } catch (e) {
      print('❌ Firestore load error: $e');
    } finally {
      loading.value = false;
    }
  }

  /// ----------------------------
  /// UPDATE FOR YOU EVENTS (8 closest by date)
  /// ----------------------------
  void _updateForYouEvents() {
    final now = DateTime.now();
    
    // Filter future events and sort by date
    final upcoming = allSummaries.where((e) => e.dateTime.isAfter(now)).toList();
    upcoming.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    
    // Take first 8
    forYouEvents.value = upcoming.take(8).toList();
    print('✅ Updated ${forYouEvents.length} for you events');
  }

  /// ----------------------------
  /// LOAD FULL EVENT
  /// ----------------------------
  Future<EventFull?> loadEventFull(String id) async {
    try {
      final cacheKey = 'event_full_$id';
      final cached = _storage.read<String>(cacheKey);

      if (cached != null) {
        try {
          final decoded = json.decode(cached);
          final Map<String, dynamic> rawMap = Map<String, dynamic>.from(decoded);
          
          final converted = _restoreTimestampsFromCache(rawMap);
          
          return EventFull(
            id: id,
            raw: converted,
          );
        } catch (e) {
          print('⚠️ Cache parse error for $id: $e');
          _storage.remove(cacheKey);
        }
      }

      final doc = await _firestore.collection("events").doc(id).get();
      if (!doc.exists || doc.data() == null) {
        print('❌ Event $id not found');
        return null;
      }

      final rawData = doc.data()!;
      final processedData = _convertFirestoreTimestamps(rawData);
      
      try {
        final forCache = _convertForCache(processedData);
        _storage.write(cacheKey, json.encode(forCache));
      } catch (e) {
        print('⚠️ Cache write error for $id: $e');
      }

      return EventFull(id: id, raw: processedData);
    } catch (e) {
      print("❌ Load event full error: $e");
      return null;
    }
  }

  Map<String, dynamic> _convertFirestoreTimestamps(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    
    data.forEach((key, value) {
      if (value is Timestamp) {
        result[key] = value.toDate();
      } else if (value is Map) {
        result[key] = _convertFirestoreTimestamps(Map<String, dynamic>.from(value));
      } else if (value is List) {
        result[key] = value.map((item) {
          if (item is Timestamp) return item.toDate();
          if (item is Map) return _convertFirestoreTimestamps(Map<String, dynamic>.from(item));
          return item;
        }).toList();
      } else {
        result[key] = value;
      }
    });
    
    return result;
  }

  Map<String, dynamic> _restoreTimestampsFromCache(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    
    data.forEach((key, value) {
      if (value is String && _isIso8601(value)) {
        try {
          result[key] = DateTime.parse(value);
        } catch (_) {
          result[key] = value;
        }
      } else if (value is Map) {
        result[key] = _restoreTimestampsFromCache(Map<String, dynamic>.from(value));
      } else if (value is List) {
        result[key] = value.map((item) {
          if (item is String && _isIso8601(item)) {
            try {
              return DateTime.parse(item);
            } catch (_) {
              return item;
            }
          }
          if (item is Map) return _restoreTimestampsFromCache(Map<String, dynamic>.from(item));
          return item;
        }).toList();
      } else {
        result[key] = value;
      }
    });
    
    return result;
  }

  bool _isIso8601(String value) {
    return RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}').hasMatch(value);
  }

  /// ----------------------------
  /// LOAD MORE EVENTS (for full events page)
  /// ----------------------------
  Future<void> loadMoreEvents() async {
    if (!_hasMore || loading.value || _lastDocument == null) return;

    loading.value = true;
    try {
      final snap = await _firestore
          .collection("events")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(_pageSize)
          .get();

      if (snap.docs.isEmpty) {
        _hasMore = false;
        loading.value = false;
        return;
      }

      final newEvents =
          snap.docs.map((doc) => EventSummary.fromDoc(doc)).toList();
      allSummaries.addAll(newEvents);
      _lastDocument = snap.docs.last;
      _hasMore = snap.docs.length == _pageSize;

      _saveToCache();
      _updateForYouEvents();
      _recalculateNearest();
      print('✅ Loaded ${newEvents.length} more events');
    } catch (e) {
      print('❌ Load more error: $e');
    } finally {
      loading.value = false;
    }
  }

  /// ----------------------------
  /// REFRESH EVENTS
  /// ----------------------------
  Future<void> refreshEvents() async {
    _lastDocument = null;
    _hasMore = true;
    allSummaries.clear();
    nearestSummaries.clear();
    forYouEvents.clear();
    await loadAllEvents(forceRefresh: true);
  }

  /// ----------------------------
  /// CACHE
  /// ----------------------------
  bool _isCacheValid() {
    final cacheTime = _storage.read<int>(_cacheTimeKey);
    if (cacheTime == null) return false;

    final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
    final now = DateTime.now();

    return now.difference(cacheDate) < _cacheExpiry;
  }

  void _loadFromCache() {
    try {
      final cached = _storage.read<String>(_cacheKey);
      if (cached == null) return;

      final List<dynamic> decoded = json.decode(cached);
      allSummaries.value = decoded
          .map((item) => EventSummary.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      
      print('✅ Loaded ${allSummaries.length} events from cache');
    } catch (e) {
      print('❌ Cache read error: $e');
      _storage.remove(_cacheKey);
      _storage.remove(_cacheTimeKey);
    }
  }

  void _saveToCache() {
    try {
      final encoded = json.encode(
        allSummaries.map((e) => e.toJson()).toList(),
      );
      _storage.write(_cacheKey, encoded);
      _storage.write(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
      print('✅ Cache saved');
    } catch (e) {
      print('❌ Cache save error: $e');
    }
  }

  /// ----------------------------
  /// NEAREST EVENTS
  /// ----------------------------
  void _recalculateNearest() {
    if (loc.userLat == null || loc.userLng == null) {
      nearestSummaries.clear();
      return;
    }

    for (var e in allSummaries) {
      e.distanceKm = _calculateDistance(
        loc.userLat!,
        loc.userLng!,
        e.venueLat,
        e.venueLng,
      );
    }

    final sorted = [...allSummaries];
    sorted.sort((a, b) {
      final dateCompare = a.dateTime.compareTo(b.dateTime);
      if (dateCompare != 0) return dateCompare;
      return a.distanceKm.compareTo(b.distanceKm);
    });

    nearestSummaries.value = sorted.take(10).toList();
    print('✅ Recalculated ${nearestSummaries.length} nearest events');
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  /// ----------------------------
  /// CLEAR CACHE
  /// ----------------------------
  void clearCache() {
    _storage.remove(_cacheKey);
    _storage.remove(_cacheTimeKey);
    
    final keys = _storage.getKeys();
    for (var key in keys) {
      if (key.toString().startsWith('event_full_')) {
        _storage.remove(key);
      }
    }
    
    print('✅ All cache cleared');
  }

  /// ----------------------------
  /// UTILITY
  /// ----------------------------
  bool get hasMore => _hasMore;
  int get totalEvents => allSummaries.length;
}