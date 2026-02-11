// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ticpin/constants/models/turf/turffull.dart';
// import 'package:ticpin/constants/models/turf/turfsummary.dart';

// class TurfController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   double _calculateDistance(
//       double lat1, double lng1, double lat2, double lng2) {
//     const rad = 0.017453292519943295;
//     final dLat = (lat2 - lat1) * rad;
//     final dLng = (lng2 - lng1) * rad;

//     final a = pow(sin(dLat / 2), 2) +
//         cos(lat1 * rad) * cos(lat2 * rad) * pow(sin(dLng / 2), 2);

//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return 6371 * c; // km
//   }

//   // -------------------------------
//   // GET ALL TURFS SORTED BY DISTANCE
//   // -------------------------------
//   Future<List<TurfSummary>> getNearbyTurfs(
//       double userLat, double userLng) async {
//     final snap = await _firestore.collection("turfs").get();

//     List<TurfSummary> turfs =
//         snap.docs.map((doc) => TurfSummary.fromDoc(doc)).toList();

//     for (var turf in turfs) {
//       turf.distanceKm = _calculateDistance(
//           userLat, userLng, turf.venueLat, turf.venueLng);
//     }

//     turfs.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

//     return turfs;
//   }

//   // -------------------------------
//   // GET TURF BY ID
//   // -------------------------------
//   Future<TurfFull?> getTurfById(String id) async {
//     final doc = await _firestore.collection("turfs").doc(id).get();

//     if (!doc.exists) return null;

//     return TurfFull.fromDoc(doc);
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ticpin/constants/models/turf/turffull.dart';
import 'package:ticpin/constants/models/turf/turfsummary.dart';
import 'package:ticpin/services/controllers/location_controller.dart';

class TurfController extends GetxController {
  final allSummaries = <TurfSummary>[].obs;
  final nearestSummaries = <TurfSummary>[].obs;
  final forYouTurfs = <TurfSummary>[].obs; // First 8 turfs for YouPage
  final loading = false.obs;

  var currentCarouselIndex = 0.obs;

  final LocationController loc = Get.put(LocationController());
  final _storage = GetStorage();
  final _firestore = FirebaseFirestore.instance;

  // Cache settings
  static const String _cacheKey = 'turfs_cache';
  static const String _cacheTimeKey = 'turfs_cache_time';
  static const Duration _cacheExpiry = Duration(hours: 6);

  // Pagination
  DocumentSnapshot? _lastDocument;
  final _pageSize = 100;
  bool _hasMore = true;

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadAllTurfs();
  //   ever(loc.city, (_) => _recalculateNearest());
  //   ever(loc.state, (_) => _recalculateNearest());
  // }

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
  /// LOAD ALL TURFS (sorted by distance)
  /// ----------------------------
  // Future<void> loadAllTurfs({bool forceRefresh = false}) async {
  //   if (!forceRefresh && _isCacheValid()) {
  //     _loadFromCache();
  //     _updateForYouTurfs();
  //     _recalculateNearest();
  //     return;
  //   }

  //   loading.value = true;
  //   try {
  //     final snap = await _firestore
  //         .collection("turfs")
  //         .orderBy("created_at", descending: true)
  //         .limit(_pageSize)
  //         .get();

  //     if (snap.docs.isEmpty) {
  //       _hasMore = false;
  //       loading.value = false;
  //       return;
  //     }

  //     allSummaries.value = snap.docs.map((doc) => TurfSummary.fromDoc(doc)).toList();
  //     _lastDocument = snap.docs.last;
  //     _hasMore = snap.docs.length == _pageSize;

  //     _saveToCache();
  //     _updateForYouTurfs();
  //     _recalculateNearest();
  //     print('✅ Loaded ${allSummaries.length} turfs from Firestore');
  //   } catch (e) {
  //     print('❌ Firestore load error: $e');
  //   } finally {
  //     loading.value = false;
  //   }
  // }

  // Add this debug version to your TurfController

  /// ----------------------------
  /// UPDATE FOR YOU TURFS (8 closest by distance) - DEBUG VERSION
  /// ----------------------------
  void _updateForYouTurfs() {
    print('🔍 _updateForYouTurfs called');
    print('📊 allSummaries count: ${allSummaries.length}');
    print('📍 User location: lat=${loc.userLat}, lng=${loc.userLng}');

    // If no location, just take first 8 turfs without sorting
    if (loc.userLat == null || loc.userLng == null) {
      print(
        '⚠️ No user location - using first 8 turfs without distance sorting',
      );
      forYouTurfs.value = allSummaries.take(8).toList();
      print('✅ forYouTurfs count (no location): ${forYouTurfs.length}');
      return;
    }

    // Calculate distances for all turfs
    print('📏 Calculating distances...');
    for (var turf in allSummaries) {
      turf.distanceKm = _calculateDistance(
        loc.userLat!,
        loc.userLng!,
        turf.venueLat,
        turf.venueLng,
      );
      print('  - ${turf.name}: ${turf.distanceKm.toStringAsFixed(2)} km');
    }

    // Sort by distance and take first 8
    final sorted = [...allSummaries];
    sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    forYouTurfs.value = sorted.take(8).toList();

    print('✅ Updated ${forYouTurfs.length} for you turfs (sorted by distance)');
  }

  // ALSO ADD THIS TO CHECK IF CONTROLLER IS PROPERLY INITIALIZED
  @override
  void onInit() {
    super.onInit();
    print('🚀 TurfController initialized');
    loadAllTurfs();
    ever(loc.city, (_) {
      print('📍 City changed, recalculating nearest turfs');
      _recalculateNearest();
    });
    ever(loc.state, (_) {
      print('📍 State changed, recalculating nearest turfs');
      _recalculateNearest();
    });
  }

  /// ----------------------------
  /// LOAD ALL TURFS - DEBUG VERSION
  /// ----------------------------
  Future<void> loadAllTurfs({bool forceRefresh = false}) async {
    print('🔄 loadAllTurfs called (forceRefresh: $forceRefresh)');

    if (!forceRefresh && _isCacheValid()) {
      print('💾 Loading from cache');
      _loadFromCache();
      _updateForYouTurfs();
      _recalculateNearest();
      return;
    }

    loading.value = true;
    print('🌐 Fetching from Firestore...');

    try {
      final snap =
          await _firestore
              .collection("turfs")
              .orderBy("created_at", descending: true)
              .limit(_pageSize)
              .get();

      print('📦 Firestore returned ${snap.docs.length} documents');

      if (snap.docs.isEmpty) {
        print('⚠️ No turfs found in Firestore');
        _hasMore = false;
        loading.value = false;
        return;
      }

      allSummaries.value =
          snap.docs.map((doc) {
            print('  - Processing doc: ${doc.id}');
            return TurfSummary.fromDoc(doc);
          }).toList();

      _lastDocument = snap.docs.last;
      _hasMore = snap.docs.length == _pageSize;

      print('✅ Loaded ${allSummaries.length} turfs from Firestore');

      _saveToCache();
      _updateForYouTurfs();
      _recalculateNearest();
    } catch (e, stackTrace) {
      print('❌ Firestore load error: $e');
      print('Stack trace: $stackTrace');
    } finally {
      loading.value = false;
    }
  }

  /// ----------------------------
  /// UPDATE FOR YOU TURFS (8 closest by distance)
  /// ----------------------------
  // void _updateForYouTurfs() {
  //   if (loc.userLat == null || loc.userLng == null) {
  //     forYouTurfs.value = allSummaries.take(8).toList();
  //     return;
  //   }

  //   // Calculate distances for all turfs
  //   for (var turf in allSummaries) {
  //     turf.distanceKm = _calculateDistance(
  //       loc.userLat!,
  //       loc.userLng!,
  //       turf.venueLat,
  //       turf.venueLng,
  //     );
  //   }

  //   // Sort by distance and take first 8
  //   final sorted = [...allSummaries];
  //   sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  //   forYouTurfs.value = sorted.take(8).toList();

  //   print('✅ Updated ${forYouTurfs.length} for you turfs (sorted by distance)');
  // }

  /// ----------------------------
  /// LOAD FULL TURF
  /// ----------------------------
  Future<TurfFull?> loadTurfFull(String id) async {
    try {
      final cacheKey = 'turf_full_$id';
      final cached = _storage.read<String>(cacheKey);

      if (cached != null) {
        try {
          final decoded = json.decode(cached);
          final Map<String, dynamic> rawMap = Map<String, dynamic>.from(
            decoded,
          );

          final converted = _restoreTimestampsFromCache(rawMap);

          return TurfFull(id: id, raw: converted);
        } catch (e) {
          print('⚠️ Cache parse error for $id: $e');
          _storage.remove(cacheKey);
        }
      }

      final doc = await _firestore.collection("turfs").doc(id).get();
      if (!doc.exists || doc.data() == null) {
        print('❌ Turf $id not found');
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

      return TurfFull(id: id, raw: processedData);
    } catch (e) {
      print("❌ Load turf full error: $e");
      return null;
    }
  }

  Map<String, dynamic> _convertFirestoreTimestamps(Map<String, dynamic> data) {
    final result = <String, dynamic>{};

    data.forEach((key, value) {
      if (value is Timestamp) {
        result[key] = value.toDate();
      } else if (value is Map) {
        result[key] = _convertFirestoreTimestamps(
          Map<String, dynamic>.from(value),
        );
      } else if (value is List) {
        result[key] =
            value.map((item) {
              if (item is Timestamp) return item.toDate();
              if (item is Map)
                return _convertFirestoreTimestamps(
                  Map<String, dynamic>.from(item),
                );
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
        result[key] = _restoreTimestampsFromCache(
          Map<String, dynamic>.from(value),
        );
      } else if (value is List) {
        result[key] =
            value.map((item) {
              if (item is String && _isIso8601(item)) {
                try {
                  return DateTime.parse(item);
                } catch (_) {
                  return item;
                }
              }
              if (item is Map)
                return _restoreTimestampsFromCache(
                  Map<String, dynamic>.from(item),
                );
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
  /// LOAD MORE TURFS (for full turfs page)
  /// ----------------------------
  Future<void> loadMoreTurfs() async {
    if (!_hasMore || loading.value || _lastDocument == null) return;

    loading.value = true;
    try {
      final snap =
          await _firestore
              .collection("turfs")
              .orderBy("created_at", descending: true)
              .startAfterDocument(_lastDocument!)
              .limit(_pageSize)
              .get();

      if (snap.docs.isEmpty) {
        _hasMore = false;
        loading.value = false;
        return;
      }

      final newTurfs =
          snap.docs.map((doc) => TurfSummary.fromDoc(doc)).toList();
      allSummaries.addAll(newTurfs);
      _lastDocument = snap.docs.last;
      _hasMore = snap.docs.length == _pageSize;

      _saveToCache();
      _updateForYouTurfs();
      _recalculateNearest();
      print('✅ Loaded ${newTurfs.length} more turfs');
    } catch (e) {
      print('❌ Load more error: $e');
    } finally {
      loading.value = false;
    }
  }

  /// ----------------------------
  /// REFRESH TURFS
  /// ----------------------------
  Future<void> refreshTurfs() async {
    _lastDocument = null;
    _hasMore = true;
    allSummaries.clear();
    nearestSummaries.clear();
    forYouTurfs.clear();
    await loadAllTurfs(forceRefresh: true);
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
      allSummaries.value =
          decoded
              .map(
                (item) => TurfSummary.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();

      print('✅ Loaded ${allSummaries.length} turfs from cache');
    } catch (e) {
      print('❌ Cache read error: $e');
      _storage.remove(_cacheKey);
      _storage.remove(_cacheTimeKey);
    }
  }

  void _saveToCache() {
    try {
      final encoded = json.encode(allSummaries.map((e) => e.toJson()).toList());
      _storage.write(_cacheKey, encoded);
      _storage.write(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
      print('✅ Cache saved with ${allSummaries.length} turfs');
    } catch (e) {
      print('❌ Cache save error: $e');
    }
  }

  /// ----------------------------
  /// NEAREST TURFS (sorted by distance only)
  /// ----------------------------
  void _recalculateNearest() {
    if (loc.userLat == null || loc.userLng == null) {
      nearestSummaries.clear();
      return;
    }

    for (var turf in allSummaries) {
      turf.distanceKm = _calculateDistance(
        loc.userLat!,
        loc.userLng!,
        turf.venueLat,
        turf.venueLng,
      );
    }

    final sorted = [...allSummaries];
    sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    nearestSummaries.value = sorted.take(10).toList();
    print('✅ Recalculated ${nearestSummaries.length} nearest turfs');
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

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
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
      if (key.toString().startsWith('turf_full_')) {
        _storage.remove(key);
      }
    }

    print('✅ All cache cleared');
  }

  /// ----------------------------
  /// UTILITY
  /// ----------------------------
  bool get hasMore => _hasMore;
  int get totalTurfs => allSummaries.length;
}
