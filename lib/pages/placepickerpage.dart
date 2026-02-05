// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:ticpin_partner/constants/apikeys.dart';

// class PlacePickerPage extends StatefulWidget {
//   @override
//   _PlacePickerPageState createState() => _PlacePickerPageState();
// }

// class _PlacePickerPageState extends State<PlacePickerPage> {
//   GoogleMapController? mapController;
//   LatLng? selectedLatLng;

//   final searchController = TextEditingController();
//   final String apiKey = placesApiKey;

//   bool loadingLocation = true;

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }

//   /// 🔥 GET USER LOCATION & MOVE MAP
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location service enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (mounted) {
//         setState(() => loadingLocation = false);
//       }
//       return;
//     }

//     permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.deniedForever) {
//       if (mounted) {
//         setState(() => loadingLocation = false);
//       }
//       return;
//     }

//     // Get location
//     final Position pos = await Geolocator.getCurrentPosition();

//     final LatLng userPos = LatLng(pos.latitude, pos.longitude);

//     selectedLatLng = userPos;

//     if (mounted) {
//       setState(() => loadingLocation = false);
//     }

//     // Move map if created
//     if (mapController != null) {
//       mapController!.animateCamera(CameraUpdate.newLatLngZoom(userPos, 15));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Pick Location",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E1E82),
//           ),
//         ),
//       ),

//       body: Stack(
//         children: [
//           loadingLocation
//               ? Center(child: CircularProgressIndicator())
//               : GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: selectedLatLng ?? LatLng(20, 78),
//                   zoom: selectedLatLng == null ? 4 : 15,
//                 ),
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//                 onMapCreated: (controller) {
//                   mapController = controller;

//                   if (selectedLatLng != null) {
//                     controller.animateCamera(
//                       CameraUpdate.newLatLngZoom(selectedLatLng!, 15),
//                     );
//                   }
//                 },
//                 onTap: (pos) {
//                   if (mounted) {
//                     setState(() => selectedLatLng = pos);
//                   }
//                 },
//                 markers:
//                     selectedLatLng == null
//                         ? {}
//                         : {
//                           Marker(
//                             markerId: MarkerId("selected"),
//                             position: selectedLatLng!,
//                           ),
//                         },
//               ),

//           // 🔍 AUTOCOMPLETE SEARCH BAR
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: GooglePlaceAutoCompleteTextField(
//                 textEditingController: searchController,
//                 googleAPIKey: apiKey,

//                 inputDecoration: InputDecoration(
//                   hintText: "Search place...",
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.all(12),
//                 ),

//                 debounceTime: 500,

//                 getPlaceDetailWithLatLng: (prediction) {
//                   double lat = double.parse(prediction.lat!);
//                   double lng = double.parse(prediction.lng!);

//                   LatLng pos = LatLng(lat, lng);

//                   if (mounted) {
//                     setState(() => selectedLatLng = pos);
//                   }

//                   mapController?.animateCamera(
//                     CameraUpdate.newLatLngZoom(pos, 16),
//                   );
//                 },

//                 itemClick: (prediction) {
//                   searchController.text = prediction.description!;
//                 },
//               ),
//             ),
//           ),

//           // SAVE BUTTON
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 if (selectedLatLng != null) {
//                   Navigator.pop(context, {
//                     "lat": selectedLatLng!.latitude,
//                     "lng": selectedLatLng!.longitude,
//                   });
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1E1E82),
//                 disabledBackgroundColor: Colors.grey.shade400,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 "Select Location",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ticpin_partner/constants/apikeys.dart';
import 'package:ticpin_partner/constants/colors.dart';

class PlacePickerPage extends StatefulWidget {
  @override
  _PlacePickerPageState createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  GoogleMapController? mapController;
  LatLng? selectedLatLng;
  String? selectedPlaceName;
  String? selectedAddress;

  final searchController = TextEditingController();
  final String apiKey = placesApiKey;

  bool loadingLocation = true;

  // ✅ Optimize map performance
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20, 78),
    zoom: 4,
  );

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    mapController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// 🔥 GET USER LOCATION & MOVE MAP
  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => loadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => loadingLocation = false);
        return;
      }

      // Get location with timeout
      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(Duration(seconds: 10));

      final LatLng userPos = LatLng(pos.latitude, pos.longitude);

      if (mounted) {
        setState(() {
          selectedLatLng = userPos;
          loadingLocation = false;
        });

        // Move map if created
        mapController?.animateCamera(CameraUpdate.newLatLngZoom(userPos, 15));
      }
    } catch (e) {
      if (mounted) setState(() => loadingLocation = false);
      print('Error getting location: $e');
    }
  }

  /// ✅ Generate Google Maps link
  String _generateMapsLink(LatLng latLng) {
    return 'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text(
          "Pick Location",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E82),
          ),
        ),
      ),
      body: Stack(
        children: [
          // ✅ OPTIMIZED GOOGLE MAP
          loadingLocation
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF1E1E82)),
                    SizedBox(height: 16),
                    Text('Getting your location...'),
                  ],
                ),
              )
              : GoogleMap(
                initialCameraPosition: _initialPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                // ✅ Performance optimizations
                mapType: MapType.normal,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled:
                    false, // Disable tilt for better performance
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                buildingsEnabled: true,
                trafficEnabled: false, // Disable traffic for speed

                onMapCreated: (controller) {
                  mapController = controller;

                  // ✅ Apply dark mode or custom styling if needed
                  // controller.setMapStyle(yourMapStyle);

                  if (selectedLatLng != null) {
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(selectedLatLng!, 15),
                    );
                  }
                },
                onTap: (pos) {
                  if (mounted) {
                    setState(() {
                      selectedLatLng = pos;
                      selectedPlaceName =
                          null; // Clear place name on manual tap
                      selectedAddress = null;
                    });
                  }
                },
                markers:
                    selectedLatLng == null
                        ? {}
                        : {
                          Marker(
                            markerId: MarkerId("selected"),
                            position: selectedLatLng!,
                            infoWindow: InfoWindow(
                              title: selectedPlaceName ?? "Selected Location",
                              snippet: selectedAddress,
                            ),
                          ),
                        },
              ),

          // 🔍 AUTOCOMPLETE SEARCH BAR
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: searchController,
                googleAPIKey: apiKey,
                inputDecoration: InputDecoration(
                  hintText: "Search place...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                          )
                          : Icon(Icons.search),
                ),
                debounceTime: 500,
                countries: [
                  "in",
                ], // ✅ Limit to India for faster results (optional)
                isLatLngRequired: true,

                // ✅ FIXED: Properly handle place selection
                getPlaceDetailWithLatLng: (prediction) {
                  print('Selected place: ${prediction.description}');
                  print('Lat: ${prediction.lat}, Lng: ${prediction.lng}');

                  if (prediction.lat != null && prediction.lng != null) {
                    double lat = double.parse(prediction.lat!);
                    double lng = double.parse(prediction.lng!);

                    LatLng pos = LatLng(lat, lng);

                    if (mounted) {
                      setState(() {
                        selectedLatLng = pos;
                        selectedPlaceName =
                            prediction.structuredFormatting?.mainText ??
                            prediction.description?.split(',').first;
                        selectedAddress = prediction.description;
                      });
                    }

                    // ✅ Animate to selected location with proper zoom
                    mapController?.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: pos, zoom: 16, tilt: 0),
                      ),
                    );
                  } else {
                    print('⚠️ Warning: Lat/Lng is null in prediction');
                  }
                },
                itemClick: (prediction) {
                  searchController.text = prediction.description ?? '';
                  searchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: searchController.text.length),
                  );
                },
                seperatedBuilder: Divider(height: 1),
                containerHorizontalPadding: 10,

                // ✅ Custom item builder for better UI
                itemBuilder: (context, index, prediction) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xFF1E1E82)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prediction.structuredFormatting?.mainText ??
                                    prediction.description ??
                                    '',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              if (prediction
                                      .structuredFormatting
                                      ?.secondaryText !=
                                  null)
                                Text(
                                  prediction
                                      .structuredFormatting!
                                      .secondaryText!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // ✅ SELECTED LOCATION INFO CARD (Optional)
          if (selectedLatLng != null && selectedPlaceName != null)
            Positioned(
              bottom: 90,
              left: 20,
              right: 20,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedPlaceName!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (selectedAddress != null)
                        Text(
                          selectedAddress!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      SizedBox(height: 4),
                      Text(
                        'Lat: ${selectedLatLng!.latitude.toStringAsFixed(6)}, Lng: ${selectedLatLng!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ✅ SELECT BUTTON WITH FULL DATA
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed:
                  selectedLatLng == null
                      ? null
                      : () {
                        final mapsLink = _generateMapsLink(selectedLatLng!);

                        Navigator.pop(context, {
                          "lat": selectedLatLng!.latitude,
                          "lng": selectedLatLng!.longitude,
                          "mapsLink": mapsLink,
                          "placeName": selectedPlaceName ?? "Selected Location",
                          "address": selectedAddress ?? "",
                        });
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E82),
                disabledBackgroundColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                selectedLatLng == null
                    ? "Tap on map or search to select"
                    : "Select Location",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
