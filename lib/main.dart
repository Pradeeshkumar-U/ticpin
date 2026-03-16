import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/firebase_options.dart';
import 'package:ticpin/pages/home/homepage.dart';
import 'package:ticpin/pages/login/loginpage.dart';
import 'package:ticpin/services/controllers/dining_controller.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/services/controllers/location_controller.dart';
import 'package:ticpin/services/fcm_service.dart';
import 'package:ticpin/services/controllers/turf_controller.dart';
import 'package:ticpin/services/controllers/videoController.dart';

Future<void> init() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double lat = prefs.getDouble('lat') ?? 78.7;
  double lng = prefs.getDouble('lng') ?? 10.8;

  prefs.setDouble('lat', lat);
  prefs.setDouble('lng', lng);
}

// Initialize controllers - will be called after user is authenticated
Future<void> initializeControllers() async {
  // Only initialize if not already initialized
  if (!Get.isRegistered<LocationController>()) {
    Get.put(LocationController());
  }
  if (!Get.isRegistered<VideoSoundController>()) {
    Get.put(VideoSoundController(), permanent: true);
  }
  if (!Get.isRegistered<EventController>()) {
    Get.put(EventController());
  }
  if (!Get.isRegistered<TurfController>()) {
    Get.put(TurfController());
  }
  if (!Get.isRegistered<DiningController>()) {
    Get.put(DiningController());
  }

  // Prefetch location after controllers are initialized
  await Get.find<LocationController>().prefetchLocation();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  await FCMService().initializeFCM();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<int> checker() async {
    try {
      final url = Uri.parse('https://lazypanda-upk.github.io/radio/check.txt');
      final response = await http.get(url);
      return int.parse(response.body.trim());
    } catch (e) {
      print('Error checking status: $e');
      return 200; // Default to allowing access if check fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: checker(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final check = snapshot.data!;

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: gradient1),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // User is logged in and check passed
              if (snapshot.hasData && check == 200) {
                // Initialize controllers and load data after authentication
                return FutureBuilder(
                  future: initializeControllers(),
                  builder: (context, controllersSnapshot) {
                    if (controllersSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Loading data...',
                                style: TextStyle(fontFamily: 'Regular'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Controllers initialized, show homepage
                    return Homepage();
                  },
                );
              }

              // User not logged in or check failed
              return Loginpage();
            },
          ),
        );
      },
    );
  }
}
