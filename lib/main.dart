// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_partner/firebase_options.dart';
// import 'package:ticpin_partner/pages/homepage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     if (Firebase.apps.isEmpty) {
//       await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       );
//       debugPrint('Firebase initialized');
//     } else {
//       debugPrint(
//         'Firebase already initialized: ${Firebase.apps.map((a) => a.name).toList()}',
//       );
//     }
//   } on FirebaseException catch (e) {
//     if (e.code != 'duplicate-app') rethrow;
//     debugPrint('Ignored duplicate-app: ${e.message}');
//   }

//   // ensure anonymous sign-in for storage / rules that require auth
//   if (FirebaseAuth.instance.currentUser == null) {
//     await FirebaseAuth.instance.signInAnonymously();
//   }
//   runApp(
//     MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => EventFormProvider())],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       theme: ThemeData(
//         actionIconTheme: ActionIconThemeData(
//           backButtonIconBuilder:
//               (context) => Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 color: Color(0xFF1E1E82),
//               ),
//         ),
//       ),
//       home: Homepage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ticpin_partner/firebase_options.dart';
import 'package:ticpin_partner/pages/homepage.dart';
import 'package:ticpin_partner/pages/login/loginpage.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint("Firebase initialized");
    }
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventFormProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder: (context) => const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E1E82),
          ),
        ),
      ),

      // 🚀 AUTH STATE ROUTING
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading during connection
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Not logged in → Login screen
          if (!snapshot.hasData) {
            return const Loginpage();
          }

          // Logged in → Homepage
          return Homepage();
        },
      ),
    );
  }
}
