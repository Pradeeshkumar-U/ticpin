import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ticpin/constants/models/dining/diningsummary.dart';
import 'package:ticpin/constants/models/dining/diningfull.dart';
import 'package:ticpin/services/controllers/location_controller.dart';

class DiningController extends GetxController {
  final allSummaries = <DiningSummary>[].obs;
  final nearestSummaries = <DiningSummary>[].obs;
  final forYouDinings = <DiningSummary>[].obs; // First 8 dinings for YouPage
  final loading = false.obs;

  var currentCarouselIndex = 0.obs;

  final LocationController loc = Get.put(LocationController());
  final _storage = GetStorage();
  final _firestore = FirebaseFirestore.instance;

  // Cache settings
  static const String _cacheKey = 'dinings_cache';
  static const String _cacheTimeKey = 'dinings_cache_time';
  static const Duration _cacheExpiry = Duration(hours: 6);

  // Pagination
  DocumentSnapshot? _lastDocument;
  final _pageSize = 10;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    print('🚀 DiningController initialized');
    loadAllDinings();
    ever(loc.city, (_) {
      print('📍 City changed, recalculating nearest dinings');
      _recalculateNearest();
    });
    ever(loc.state, (_) {
      print('📍 State changed, recalculating nearest dinings');
      _recalculateNearest();
    });
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
  /// LOAD ALL DININGS (sorted by distance)
  /// ----------------------------
  Future<void> loadAllDinings({bool forceRefresh = false}) async {
    print('🔄 loadAllDinings called (forceRefresh: $forceRefresh)');
    
    if (!forceRefresh && _isCacheValid()) {
      print('💾 Loading from cache');
      _loadFromCache();
      _updateForYouDinings();
      _recalculateNearest();
      return;
    }

    loading.value = true;
    print('🌐 Fetching from Firestore...');
    
    try {
      final snap = await _firestore
          .collection("dining")
          .orderBy("created_at", descending: true)
          .limit(_pageSize)
          .get();

      print('📦 Firestore returned ${snap.docs.length} documents');

      if (snap.docs.isEmpty) {
        print('⚠️ No dinings found in Firestore');
        _hasMore = false;
        loading.value = false;
        return;
      }

      allSummaries.value = snap.docs.map((doc) {
        print('  - Processing doc: ${doc.id}');
        return DiningSummary.fromDoc(doc);
      }).toList();
      
      _lastDocument = snap.docs.last;
      _hasMore = snap.docs.length == _pageSize;

      print('✅ Loaded ${allSummaries.length} dinings from Firestore');
      
      _saveToCache();
      _updateForYouDinings();
      _recalculateNearest();
    } catch (e, stackTrace) {
      print('❌ Firestore load error: $e');
      print('Stack trace: $stackTrace');
    } finally {
      loading.value = false;
    }
  }

  /// ----------------------------
  /// UPDATE FOR YOU DININGS (8 closest by distance)
  /// ----------------------------
  void _updateForYouDinings() {
    print('🔍 _updateForYouDinings called');
    print('📊 allSummaries count: ${allSummaries.length}');
    print('📍 User location: lat=${loc.userLat}, lng=${loc.userLng}');
    
    // If no location, just take first 8 dinings without sorting
    if (loc.userLat == null || loc.userLng == null) {
      print('⚠️ No user location - using first 8 dinings without distance sorting');
      forYouDinings.value = allSummaries.take(8).toList();
      print('✅ forYouDinings count (no location): ${forYouDinings.length}');
      return;
    }

    // Calculate distances for all dinings
    print('📏 Calculating distances...');
    for (var dining in allSummaries) {
      dining.distanceKm = _calculateDistance(
        loc.userLat!,
        loc.userLng!,
        dining.venueLat,
        dining.venueLng,
      );
      print('  - ${dining.name}: ${dining.distanceKm.toStringAsFixed(2)} km');
    }

    // Sort by distance and take first 8
    final sorted = [...allSummaries];
    sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    forYouDinings.value = sorted.take(8).toList();
    
    print('✅ Updated ${forYouDinings.length} for you dinings (sorted by distance)');
  }

  /// ----------------------------
  /// LOAD FULL DINING
  /// ----------------------------
  Future<DiningFull?> loadDiningFull(String id) async {
    try {
      final cacheKey = 'dining_full_$id';
      final cached = _storage.read<String>(cacheKey);

      if (cached != null) {
        try {
          final decoded = json.decode(cached);
          final Map<String, dynamic> rawMap = Map<String, dynamic>.from(decoded);
          
          final converted = _restoreTimestampsFromCache(rawMap);
          
          return DiningFull(
            id: id,
            raw: converted,
          );
        } catch (e) {
          print('⚠️ Cache parse error for $id: $e');
          _storage.remove(cacheKey);
        }
      }

      final doc = await _firestore.collection("dining").doc(id).get();
      if (!doc.exists || doc.data() == null) {
        print('❌ Dining $id not found');
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

      return DiningFull(id: id, raw: processedData);
    } catch (e) {
      print("❌ Load dining full error: $e");
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
  /// LOAD MORE DININGS (for full dinings page)
  /// ----------------------------
  Future<void> loadMoreDinings() async {
    if (!_hasMore || loading.value || _lastDocument == null) return;

    loading.value = true;
    try {
      final snap = await _firestore
          .collection("dining")
          .orderBy("created_at", descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(_pageSize)
          .get();

      if (snap.docs.isEmpty) {
        _hasMore = false;
        loading.value = false;
        return;
      }

      final newDinings = snap.docs.map((doc) => DiningSummary.fromDoc(doc)).toList();
      allSummaries.addAll(newDinings);
      _lastDocument = snap.docs.last;
      _hasMore = snap.docs.length == _pageSize;

      _saveToCache();
      _updateForYouDinings();
      _recalculateNearest();
      print('✅ Loaded ${newDinings.length} more dinings');
    } catch (e) {
      print('❌ Load more error: $e');
    } finally {
      loading.value = false;
    }
  }

  /// ----------------------------
  /// REFRESH DININGS
  /// ----------------------------
  Future<void> refreshDinings() async {
    _lastDocument = null;
    _hasMore = true;
    allSummaries.clear();
    nearestSummaries.clear();
    forYouDinings.clear();
    await loadAllDinings(forceRefresh: true);
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
          .map((item) => DiningSummary.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      
      print('✅ Loaded ${allSummaries.length} dinings from cache');
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
      print('✅ Cache saved with ${allSummaries.length} dinings');
    } catch (e) {
      print('❌ Cache save error: $e');
    }
  }

  /// ----------------------------
  /// NEAREST DININGS (sorted by distance only)
  /// ----------------------------
  void _recalculateNearest() {
    if (loc.userLat == null || loc.userLng == null) {
      nearestSummaries.clear();
      return;
    }

    for (var dining in allSummaries) {
      dining.distanceKm = _calculateDistance(
        loc.userLat!,
        loc.userLng!,
        dining.venueLat,
        dining.venueLng,
      );
    }

    final sorted = [...allSummaries];
    sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    nearestSummaries.value = sorted.take(10).toList();
    print('✅ Recalculated ${nearestSummaries.length} nearest dinings');
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
      if (key.toString().startsWith('dining_full_')) {
        _storage.remove(key);
      }
    }
    
    print('✅ All dining cache cleared');
  }

  /// ----------------------------
  /// FILTER BY CUISINE
  /// ----------------------------
  List<DiningSummary> filterByCuisine(String cuisine) {
    return allSummaries.where((dining) {
      // Assuming DiningSummary has a cuisines field
      return dining.cuisines?.contains(cuisine) ?? false;
    }).toList();
  }

  /// ----------------------------
  /// FILTER BY CATEGORY
  /// ----------------------------
  List<DiningSummary> filterByCategory(String category) {
    return allSummaries.where((dining) {
      // Assuming DiningSummary has a categories field
      return dining.categories?.contains(category) ?? false;
    }).toList();
  }

  /// ----------------------------
  /// SEARCH BY NAME
  /// ----------------------------
  List<DiningSummary> searchByName(String query) {
    if (query.isEmpty) return allSummaries;
    
    final lowerQuery = query.toLowerCase();
    return allSummaries.where((dining) {
      return dining.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// ----------------------------
  /// UTILITY
  /// ----------------------------
  bool get hasMore => _hasMore;
  int get totalDinings => allSummaries.length;
}