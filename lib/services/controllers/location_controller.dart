// import 'package:get/get.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get_storage/get_storage.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:ticpin/constants/constant.dart';

// class LocationController extends GetxController {
//   double? userLat;
//   double? userLng;
//   final box = GetStorage();
//   RxString city = "".obs;
//   RxString state = "".obs;

//   bool manualLocationSelected = false;

//   @override
//   void onInit() {
//     super.onInit();
//     city.value = box.read("city") ?? "";
//     state.value = box.read("state") ?? "";
//     fetchDeviceLocation();
//   }

//   /// FETCH DEVICE LOCATION
//   Future<void> fetchDeviceLocation() async {
//     if (manualLocationSelected) return;

//     final pos = await Geolocator.getCurrentPosition();

//     userLat = pos.latitude;
//     userLng = pos.longitude;

//     await updateReverseGeocode(userLat!, userLng!);
//   }

//   /// SET USER LOCATION MANUALLY
//   Future<void> setUserLocation(double lat, double lng) async {
//     userLat = lat;
//     userLng = lng;
//     manualLocationSelected = true;

//     await updateReverseGeocode(lat, lng);
//   }

//   /// SET USER CITY NAME → convert to coords
//   Future<void> setUserCity(String cityName) async {
//     try {
//       final res = await locationFromAddress(cityName);
//       if (res.isNotEmpty) {
//         manualLocationSelected = true;
//         await setUserLocation(res.first.latitude, res.first.longitude);
//       }
//     } catch (e) {
//       print("City geocode error: $e");
//     }
//   }





// Future<void> updateReverseGeocode(double lat, double lng) async {
//   final url = Uri.parse(
//     "https://maps.googleapis.com/maps/api/geocode/json"
//     "?latlng=$lat,$lng&key=$placesApiKey",
//   );

//   try {
//     final res = await http.get(url);

//     if (res.statusCode == 200) {
//       final data = json.decode(res.body);

//       if (data["status"] == "OK") {
//         final components =
//             data["results"][0]["address_components"] as List<dynamic>;

//         String? cityName;
//         String? stateName;

//         // Priority search
//         for (var c in components) {
//           final types = List<String>.from(c["types"]);

//           if (types.contains("locality")) {
//             cityName = c["long_name"];
//           }

//           if (types.contains("administrative_area_level_1")) {
//             stateName = c["long_name"];
//           }
//         }

//         // Backup
//         cityName ??= components.firstWhere(
//           (c) => (c["types"] as List).contains("administrative_area_level_3"),
//           orElse: () => {"long_name": ""},
//         )["long_name"];

//         city.value = cityName ?? "";
//         state.value = stateName ?? "";
//       }
//     }
//   } catch (e) {
//     print("Google geocode failed: $e");
//   }
// }


//   // /// REVERSE GEOCODE (coords → city, state)
//   // Future<void> updateReverseGeocode(double lat, double lng) async {
//   //   try {
//   //     final placemarks = await placemarkFromCoordinates(lat, lng);

//   //     if (placemarks.isNotEmpty) {
//   //       final p = placemarks.first;

//   //       city.value =
//   //           p.locality?.isNotEmpty == true
//   //               ? p.locality!
//   //               : (p.subAdministrativeArea ?? "");

//   //       state.value = p.administrativeArea ?? "";

//   //       box.write("city", city.value);
//   //       box.write("state", state.value);
//   //     }
//   //   } catch (e) {
//   //     print("Reverse geocoding failed: $e");
//   //   }
//   // }
// }

import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticpin/constants/constant.dart';
import 'dart:async';

class LocationController extends GetxController {
  double? userLat;
  double? userLng;
  final box = GetStorage();
  RxString city = "".obs;
  RxString state = "".obs;
  RxBool isLoading = false.obs;

  bool manualLocationSelected = false;

  // Cache for geocoding results
  final Map<String, Map<String, dynamic>> _geocodeCache = {};
  final Map<String, Map<String, dynamic>> _reverseGeocodeCache = {};

  // HTTP client with timeout
  final http.Client _httpClient = http.Client();
  
  // Debounce timer for rapid location changes
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    _loadCachedLocation();
    fetchDeviceLocation();
  }

  @override
  void onClose() {
    _httpClient.close();
    _debounceTimer?.cancel();
    super.onClose();
  }

  /// LOAD CACHED LOCATION
  void _loadCachedLocation() {
    city.value = box.read("city") ?? "";
    state.value = box.read("state") ?? "";
    userLat = box.read("userLat");
    userLng = box.read("userLng");
  }

  /// FETCH DEVICE LOCATION (Optimized)
  Future<void> fetchDeviceLocation() async {
    if (manualLocationSelected) return;

    try {
      isLoading.value = true;

      // Get last known position first (instant)
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      
      if (lastKnown != null) {
        // Use cached location immediately
        userLat = lastKnown.latitude;
        userLng = lastKnown.longitude;
        
        // Check if we have cached geocode data
        String cacheKey = "${lastKnown.latitude.toStringAsFixed(3)},${lastKnown.longitude.toStringAsFixed(3)}";
        if (_reverseGeocodeCache.containsKey(cacheKey)) {
          _applyCachedGeocode(cacheKey);
        } else {
          // Fetch in background
          _debouncedReverseGeocode(lastKnown.latitude, lastKnown.longitude);
        }
      }

      // Get current position in background (more accurate but slower)
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Changed from high to medium
        timeLimit: Duration(seconds: 5), // Add timeout
      );

      userLat = pos.latitude;
      userLng = pos.longitude;

      // Save to storage immediately
      box.write("userLat", userLat);
      box.write("userLng", userLng);

      await updateReverseGeocode(userLat!, userLng!);
    } catch (e) {
      print("Location fetch error: $e");
      // Use cached location if available
      if (userLat != null && userLng != null) {
        print("Using cached location");
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// DEBOUNCED REVERSE GEOCODE
  void _debouncedReverseGeocode(double lat, double lng) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      updateReverseGeocode(lat, lng);
    });
  }

  /// APPLY CACHED GEOCODE
  void _applyCachedGeocode(String cacheKey) {
    final cached = _reverseGeocodeCache[cacheKey]!;
    city.value = cached['city'] ?? "";
    state.value = cached['state'] ?? "";
  }

  /// SET USER LOCATION MANUALLY (Optimized)
  Future<void> setUserLocation(double lat, double lng) async {
    userLat = lat;
    userLng = lng;
    manualLocationSelected = true;

    // Save immediately
    box.write("userLat", userLat);
    box.write("userLng", userLng);

    await updateReverseGeocode(lat, lng);
  }

  /// SET USER CITY NAME (Optimized with cache)
  Future<void> setUserCity(String cityName) async {
    try {
      isLoading.value = true;

      // Check cache first
      if (_geocodeCache.containsKey(cityName)) {
        final cached = _geocodeCache[cityName]!;
        manualLocationSelected = true;
        await setUserLocation(cached['lat'], cached['lng']);
        return;
      }

      // Use Google Geocoding API directly (faster than geocoding package)
      final coords = await _geocodeWithGoogle(cityName);
      
      if (coords != null) {
        // Cache the result
        _geocodeCache[cityName] = {
          'lat': coords['lat'],
          'lng': coords['lng'],
        };

        manualLocationSelected = true;
        await setUserLocation(coords['lat']!, coords['lng']!);
      }
    } catch (e) {
      print("City geocode error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// GOOGLE GEOCODING (faster than geocoding package)
  Future<Map<String, double>?> _geocodeWithGoogle(String address) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json"
      "?address=${Uri.encodeComponent(address)}&key=$placesApiKey",
    );

    try {
      final res = await _httpClient.get(url).timeout(Duration(seconds: 5));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data["status"] == "OK" && data["results"].isNotEmpty) {
          final location = data["results"][0]["geometry"]["location"];
          return {
            'lat': location["lat"],
            'lng': location["lng"],
          };
        }
      }
    } catch (e) {
      print("Google geocode error: $e");
    }
    return null;
  }

  /// REVERSE GEOCODE (Optimized with cache)
  Future<void> updateReverseGeocode(double lat, double lng) async {
    // Round to 3 decimals for caching (~100m precision)
    String cacheKey = "${lat.toStringAsFixed(3)},${lng.toStringAsFixed(3)}";

    // Check cache first
    if (_reverseGeocodeCache.containsKey(cacheKey)) {
      _applyCachedGeocode(cacheKey);
      return;
    }

    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json"
      "?latlng=$lat,$lng&key=$placesApiKey",
    );

    try {
      final res = await _httpClient.get(url).timeout(Duration(seconds: 5));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data["status"] == "OK" && data["results"].isNotEmpty) {
          final components = data["results"][0]["address_components"] as List<dynamic>;

          String? cityName;
          String? stateName;

          // Optimized single-pass search
          for (var c in components) {
            final types = List<String>.from(c["types"]);

            if (cityName == null && types.contains("locality")) {
              cityName = c["long_name"];
            }

            if (stateName == null && types.contains("administrative_area_level_1")) {
              stateName = c["long_name"];
            }

            // Early exit if both found
            if (cityName != null && stateName != null) break;
          }

          // Backup for city
          if (cityName == null) {
            cityName = components.firstWhere(
              (c) => (c["types"] as List).contains("administrative_area_level_3"),
              orElse: () => {"long_name": "Unknown"},
            )["long_name"];
          }

          city.value = cityName ?? "Unknown";
          state.value = stateName ?? "";

          // Cache the result
          _reverseGeocodeCache[cacheKey] = {
            'city': city.value,
            'state': state.value,
          };

          // Save to persistent storage
          box.write("city", city.value);
          box.write("state", state.value);
        }
      }
    } catch (e) {
      print("Reverse geocode error: $e");
      // Keep existing values on error
    }
  }

  /// CLEAR CACHE (call this periodically or when memory is low)
  void clearCache() {
    _geocodeCache.clear();
    _reverseGeocodeCache.clear();
  }

  /// PREFETCH LOCATION (call this on app start for faster first load)
  Future<void> prefetchLocation() async {
    if (userLat != null && userLng != null) {
      await updateReverseGeocode(userLat!, userLng!);
    }
  }

  
}

