// import 'dart:ui' show ImageFilter;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/firebase_options.dart';
// import 'package:ticpin/pages/chat/chating.dart';
// import 'package:ticpin/pages/home/homepage.dart';
// import 'package:ticpin/pages/login/loginpage.dart';
// import 'package:ticpin/services/controllers/dining_controller.dart';
// import 'package:ticpin/services/controllers/event_controller.dart';
// import 'package:ticpin/services/controllers/location_controller.dart';
// import 'package:ticpin/services/controllers/turf_controller.dart';

// import 'services/controllers/videoController.dart';

// Future<void> init() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   double lat = prefs.getDouble('lat') ?? 78.7;
//   double lng = prefs.getDouble('lng') ?? 10.8;

//   prefs.setDouble('lat', lat);
//   prefs.setDouble('lng', lng);
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await init();

//   Get.put(LocationController());
//   Get.put(VideoSoundController(), permanent: true);
//   LocationController().prefetchLocation();
//   Get.put(EventController());
//   Get.put(TurfController());
//   Get.put(DiningController());

//   // .then((value) => Get.put(AuthenticationRepository()));
//   runApp(MyApp());
// }

// // ignore: must_be_immutable
// // class MyApp extends StatelessWidget {
// //   MyApp({super.key});

// //   static int checkValue = 0;

// //   static Future<void> checkerStatic() async {
// //     final url = Uri.parse('https://lazypanda-upk.github.io/radio/check.txt');
// //     final response = await http.get(url);
// //     checkValue = int.parse(response.body.trim());
// //   }
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {

// //     return GetMaterialApp(
// //       theme: ThemeData(
// //         scaffoldBackgroundColor: Colors.white,
// //         bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
// //       ),
// //       home: StreamBuilder<User?>(
// //         stream: FirebaseAuth.instance.authStateChanges(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Scaffold(
// //               body: Center(child: CircularProgressIndicator()),
// //             );
// //           }

// //           if (snapshot.hasData && check == 200) {
// //             return Homepage(); // user logged in
// //           }

// //           return Loginpage(); // user not logged in
// //         },
// //       ),
// //     );
// //   }
// // }

// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   Future<int> checker() async {
//     final url = Uri.parse('https://lazypanda-upk.github.io/radio/check.txt');
//     final response = await http.get(url);
//     return int.parse(response.body.trim());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<int>(
//       future: checker(), // ✔ Wait for check BEFORE app starts
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const MaterialApp(
//             home: Scaffold(body: Center(child: CircularProgressIndicator())),
//           );
//         }

//         final check = snapshot.data!;

//         return GetMaterialApp(
//           theme: ThemeData(
//             scaffoldBackgroundColor: Colors.white,
//             bottomSheetTheme: BottomSheetThemeData(
//               backgroundColor: Colors.white,
//             ),
//           ),
//           home: StreamBuilder<User?>(
//             stream: FirebaseAuth.instance.authStateChanges(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Scaffold(
//                   body: Center(child: CircularProgressIndicator()),
//                 );
//               }

//               if (snapshot.hasData && check == 200) {
//                 return Homepage(); // user logged in
//               }

//               return Loginpage(); // user not logged in or check != 200
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// // class Loginpage extends StatefulWidget {
// //   const Loginpage({super.key});

// //   @override
// //   State<Loginpage> createState() => _LoginpageState();
// // }

// // class _LoginpageState extends State<Loginpage> with WidgetsBindingObserver {
// //   Sizes size = Sizes();
// //   final TextEditingController email = TextEditingController();
// //   final TextEditingController password = TextEditingController();

// //   bool isKeyboardVisible = false;
// //   bool loading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addObserver(this);
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     email.dispose();
// //     password.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   void didChangeMetrics() {
// //     final bottom = WidgetsBinding.instance.window.viewInsets.bottom;
// //     if (mounted) {
// //       setState(() => isKeyboardVisible = bottom > 0);
// //     }
// //   }

// //   Future<void> login() async {
// //     if (email.text.isEmpty || password.text.isEmpty) {
// //       Get.closeAllSnackbars();
// //       Get.snackbar(
// //         "Error",
// //         "Email and Password are required",
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //       return;
// //     }

// //     try {
// //       setState(() => loading = true);

// //       UserCredential user;

// //       try {
// //         // Try login
// //         user = await FirebaseAuth.instance.signInWithEmailAndPassword(
// //           email: email.text.trim(),
// //           password: password.text.trim(),
// //         );
// //       } catch (e) {
// //         // If user doesn't exist — create account
// //         user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
// //           email: email.text.trim(),
// //           password: password.text.trim(),
// //         );
// //       }

// //       Get.offAll(() => Homepage());
// //     } catch (e) {
// //       Get.closeAllSnackbars();
// //       Get.snackbar(
// //         "Login Failed",
// //         e.toString(),
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //     } finally {
// //       if (mounted) setState(() => loading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double keyboard = MediaQuery.of(context).viewInsets.bottom;

// //     return WillPopScope(
// //       onWillPop: () async => false,
// //       child: Scaffold(
// //         resizeToAvoidBottomInset: false,
// //         backgroundColor: blackColor,
// //         body: Stack(
// //           children: [
// //             // BG gradient
// //             Container(
// //               height: size.safeHeight,
// //               width: size.safeWidth,
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [gradient1, gradient2, blackColor],
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomRight,
// //                 ),
// //               ),
// //             ),

// //             // Logo
// //             Align(
// //               alignment: Alignment(0, -0.3),
// //               child: SizedBox(
// //                 width: size.safeWidth * 0.6,
// //                 child: Image.asset("assets/images/logo.png"),
// //               ),
// //             ),

// //             // Blur when keyboard opens
// //             if (keyboard > 0)
// //               BackdropFilter(
// //                 filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
// //                 child: Container(
// //                   height: size.safeHeight,
// //                   width: size.safeWidth,
// //                   color: Colors.black.withOpacity(0.4),
// //                 ),
// //               ),

// //             // Login UI (bottom sheet style)
// //             Align(
// //               alignment: Alignment.bottomCenter,
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.end,
// //                 children: [
// //                   AnimatedPadding(
// //                     duration: const Duration(milliseconds: 250),
// //                     padding: EdgeInsets.only(
// //                       bottom: keyboard > 0 ? (keyboard) : 20,
// //                     ),
// //                     child: Container(
// //                       height: size.safeHeight * 0.32,
// //                       width: size.safeWidth,
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                         children: [
// //                           Text(
// //                             "Login",
// //                             style: TextStyle(
// //                               fontSize: size.safeWidth * 0.045,
// //                               color: whiteColor,
// //                               fontFamily: 'Regular',
// //                             ),
// //                           ),

// //                           // EMAIL FIELD
// //                           Container(
// //                             width: size.safeWidth * 0.88,
// //                             height: size.safeHeight * 0.07,
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(18),
// //                             ),
// //                             child: Align(
// //                               alignment: Alignment.center,
// //                               child: TextField(
// //                                 controller: email,
// //                                 style: TextStyle(
// //                                   fontSize: size.safeWidth * 0.04,
// //                                   color: Colors.black,
// //                                   fontFamily: 'Regular',
// //                                 ),
// //                                 decoration: InputDecoration(
// //                                   contentPadding: EdgeInsets.symmetric(
// //                                     horizontal: 20,
// //                                     // vertical: 16,
// //                                   ),
// //                                   hintText: "Email",
// //                                   border: InputBorder.none,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),

// //                           // PASSWORD FIELD
// //                           Container(
// //                             width: size.safeWidth * 0.88,
// //                             height: size.safeHeight * 0.07,
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(18),
// //                             ),
// //                             child: Align(
// //                               alignment: Alignment.center,
// //                               child: TextField(
// //                                 controller: password,
// //                                 obscureText: true,
// //                                 style: TextStyle(
// //                                   fontSize: size.safeWidth * 0.04,
// //                                   color: Colors.black,
// //                                   fontFamily: 'Regular',
// //                                 ),
// //                                 decoration: InputDecoration(
// //                                   contentPadding: EdgeInsets.symmetric(
// //                                     horizontal: 20,
// //                                     // vertical: 16,
// //                                   ),
// //                                   hintText: "Password",
// //                                   border: InputBorder.none,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),

// //                           // BUTTON
// //                           loading
// //                               ? CircularProgressIndicator(color: Colors.white)
// //                               : ElevatedButton(
// //                                 onPressed: loading ? null : login,
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor:
// //                                       loading ? Colors.white10 : Colors.white,
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(20),
// //                                   ),
// //                                   fixedSize: Size(
// //                                     size.safeWidth * 0.88,
// //                                     size.safeWidth * 0.14,
// //                                   ),
// //                                 ),
// //                                 child:
// //                                     loading
// //                                         ? Text(
// //                                           "Continue",
// //                                           style: TextStyle(
// //                                             color: Colors.black,
// //                                             fontFamily: 'Regular',
// //                                             fontSize: size.safeWidth * 0.04,
// //                                           ),
// //                                         )
// //                                         : Text(
// //                                           "Continue",
// //                                           style: TextStyle(
// //                                             color: Colors.black,
// //                                             fontFamily: 'Regular',
// //                                             fontSize: size.safeWidth * 0.04,
// //                                           ),
// //                                         ),
// //                               ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),

// //                   SizedBox(height: size.safeHeight * 0.03),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // // class PhoneLoginScreen extends StatefulWidget {
// // // //   @override
// // // //   State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
// // // // }

// // // // class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
// // // //   final _phoneController = TextEditingController();
// // // //   final _otpController = TextEditingController();

// // // //   String _verificationId = '';
// // // //   bool _otpSent = false;
// // // //   bool _loading = false;

// // // //   void _sendOtp() async {
// // // //     setState(() => _loading = true);

// // // //     await FirebaseAuth.instance.verifyPhoneNumber(
// // // //       phoneNumber: _phoneController.text.trim(),
// // // //       timeout: const Duration(seconds: 60),
// // // //       verificationCompleted: (PhoneAuthCredential credential) async {
// // // //         await FirebaseAuth.instance.signInWithCredential(credential);
// // // //         _navigate();
// // // //       },

// // // //       verificationFailed: (FirebaseAuthException e) {
// // // //         setState(() => _loading = false);
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(content: Text('Verification failed: ${e.message}')),
// // // //         );
// // // //       },
// // // //       codeSent: (String verificationId, int? resendToken) {
// // // //         setState(() {
// // // //           _otpSent = true;
// // // //           _verificationId = verificationId;
// // // //           _loading = false;
// // // //         });
// // // //       },
// // // //       codeAutoRetrievalTimeout: (String verificationId) {
// // // //         _verificationId = verificationId;
// // // //       },
// // // //     );
// // // //   }

// // // //   void _verifyOtp() async {
// // // //     setState(() => _loading = true);

// // // //     try {
// // // //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
// // // //         verificationId: _verificationId,
// // // //         smsCode: _otpController.text.trim(),
// // // //       );

// // // //       UserCredential userCredential = await FirebaseAuth.instance
// // // //           .signInWithCredential(credential);

// // // //       // Check if new or existing
// // // //       bool isNew =
// // // //           userCredential.user!.metadata.creationTime ==
// // // //           userCredential.user!.metadata.lastSignInTime;

// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text(isNew ? 'Welcome!' : 'Welcome back!')),
// // // //       );

// // // //       _navigate();
// // // //     } catch (e) {
// // // //       setState(() => _loading = false);
// // // //       ScaffoldMessenger.of(
// // // //         context,
// // // //       ).showSnackBar(SnackBar(content: Text('OTP verification failed')));
// // // //     }
// // // //   }

// // // //   void _navigate() {
// // // //     Navigator.pushReplacement(
// // // //       context,
// // // //       MaterialPageRoute(builder: (_) => HomeScreen()),
// // // //     );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text("Phone Auth")),
// // // //       body: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child:
// // // //             _loading
// // // //                 ? Center(child: CircularProgressIndicator())
// // // //                 : Column(
// // // //                   children: [
// // // //                     TextField(
// // // //                       controller: _phoneController,
// // // //                       decoration: InputDecoration(
// // // //                         labelText: 'Phone (+91xxxxxxxxxx)',
// // // //                       ),
// // // //                       keyboardType: TextInputType.phone,
// // // //                     ),
// // // //                     if (_otpSent)
// // // //                       TextField(
// // // //                         controller: _otpController,
// // // //                         decoration: InputDecoration(labelText: 'OTP'),
// // // //                         keyboardType: TextInputType.number,
// // // //                       ),
// // // //                     SizedBox(height: 20),
// // // //                     ElevatedButton(
// // // //                       onPressed: _otpSent ? _verifyOtp : _sendOtp,
// // // //                       child: Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // class HomeScreen extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final user = FirebaseAuth.instance.currentUser;

// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text("Home"),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: Icon(Icons.logout),
// // // //             onPressed: () async {
// // // //               await FirebaseAuth.instance.signOut();
// // // //               Navigator.pushReplacement(
// // // //                 context,
// // // //                 MaterialPageRoute(builder: (_) => PhoneLoginScreen()),
// // // //               );
// // // //             },
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: Center(child: Text("Logged in as: ${user?.phoneNumber}")),
// // // //     );
// // // //   }
// // // // }

// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(title: 'Firebase OTP Auth', home: AuthGate());
// //   }
// // }

// // class AuthGate extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<User?>(
// //       stream: FirebaseAuth.instance.authStateChanges(),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return Scaffold(body: Center(child: CircularProgressIndicator()));
// //         }
// //         return snapshot.hasData ? HomeScreen() : PhoneLoginScreen();
// //       },
// //     );
// //   }
// // }

// // class PhoneLoginScreen extends StatefulWidget {
// //   @override
// //   State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
// // }

// // class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
// //   final _phoneController = TextEditingController();
// //   final _otpController = TextEditingController();

// //   String _verificationId = '';
// //   bool _otpSent = false;
// //   bool _loading = false;

// //   void _sendOtp() async {
// //     setState(() => _loading = true);

// //     await FirebaseAuth.instance.verifyPhoneNumber(
// //       phoneNumber: _phoneController.text.trim(),
// //       timeout: const Duration(seconds: 60),
// //       verificationCompleted: (PhoneAuthCredential credential) async {
// //         await FirebaseAuth.instance.signInWithCredential(credential);
// //         _navigate();
// //       },
// //       verificationFailed: (FirebaseAuthException e) {
// //         setState(() => _loading = false);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Verification failed: ${e.message}')),
// //         );
// //         print('Verification failed: ${e.message}');
// //       },
// //       codeSent: (String verificationId, int? resendToken) {
// //         setState(() {
// //           _otpSent = true;
// //           _verificationId = verificationId;
// //           _loading = false;
// //         });
// //       },
// //       codeAutoRetrievalTimeout: (String verificationId) {
// //         _verificationId = verificationId;
// //       },
// //     );
// //   }

// //   void _verifyOtp() async {
// //     setState(() => _loading = true);

// //     try {
// //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
// //         verificationId: _verificationId,
// //         smsCode: _otpController.text.trim(),
// //       );

// //       UserCredential userCredential = await FirebaseAuth.instance
// //           .signInWithCredential(credential);

// //       // Check if new or existing
// //       bool isNew =
// //           userCredential.user!.metadata.creationTime ==
// //           userCredential.user!.metadata.lastSignInTime;

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(isNew ? 'New user!' : 'Welcome back!')),
// //       );

// //       _navigate();
// //     } catch (e) {
// //       setState(() => _loading = false);
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('OTP verification failed')));
// //     }
// //   }

// //   void _navigate() {
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (_) => HomeScreen()),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Phone Auth")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child:
// //             _loading
// //                 ? Center(child: CircularProgressIndicator())
// //                 : Column(
// //                   children: [
// //                     TextField(
// //                       controller: _phoneController,
// //                       decoration: InputDecoration(
// //                         labelText: 'Phone (+91xxxxxxxxxx)',
// //                       ),
// //                       keyboardType: TextInputType.phone,
// //                     ),
// //                     if (_otpSent)
// //                       TextField(
// //                         controller: _otpController,
// //                         decoration: InputDecoration(labelText: 'OTP'),
// //                         keyboardType: TextInputType.number,
// //                       ),
// //                     SizedBox(height: 20),
// //                     ElevatedButton(
// //                       onPressed: _otpSent ? _verifyOtp : _sendOtp,
// //                       child: Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
// //                     ),
// //                   ],
// //                 ),
// //       ),
// //     );
// //   }
// // }

// // class HomeScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final user = FirebaseAuth.instance.currentUser;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Home"),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.logout),
// //             onPressed: () async {
// //               await FirebaseAuth.instance.signOut();
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (_) => PhoneLoginScreen()),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Center(child: Text("Logged in as: ${user?.phoneNumber}")),
// //     );
// //   }
// // }

// // // -----------------------------------------  MSG91 SMS Provider -------------------------------------------------------
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // //
// // // class SendOtpScreen extends StatefulWidget {
// // //   @override
// // //   _SendOtpScreenState createState() => _SendOtpScreenState();
// // // }
// // //
// // // class _SendOtpScreenState extends State<SendOtpScreen> {
// // //   final TextEditingController _phoneController = TextEditingController();
// // //   final String _authKey = 'YOUR_MSG91_AUTH_KEY'; // Replace with your MSG91 auth key
// // //   final String _senderId = 'YOUR_SENDER_ID'; // Get this from MSG91 dashboard (e.g., "MSGIND")
// // //   final String _otpTemplateId = 'YOUR_TEMPLATE_ID'; // Required for DLT compliance in India
// // //
// // //   Future<void> sendOtp(String phoneNumber) async {
// // //     final uri = Uri.parse('https://control.msg91.com/api/v5/otp');
// // //
// // //     final body = jsonEncode({
// // //       "template_id": _otpTemplateId,
// // //       "mobile": "+91$phoneNumber",
// // //       "authkey": _authKey,
// // //       "sender": _senderId,
// // //       "otp_length": "6",
// // //       "otp_expiry": "5"
// // //     });
// // //
// // //     final response = await http.post(
// // //       uri,
// // //       headers: {
// // //         "Content-Type": "application/json",
// // //       },
// // //       body: body,
// // //     );
// // //
// // //     print('Response Code: ${response.statusCode}');
// // //     print('Response Body: ${response.body}');
// // //
// // //     if (response.statusCode == 200) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("OTP sent successfully to +91$phoneNumber")),
// // //       );
// // //     } else {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("Failed to send OTP")),
// // //       );
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('Send OTP via MSG91')),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           children: [
// // //             TextField(
// // //               controller: _phoneController,
// // //               decoration: InputDecoration(labelText: 'Enter Phone Number'),
// // //               keyboardType: TextInputType.phone,
// // //             ),
// // //             SizedBox(height: 20),
// // //             ElevatedButton(
// // //               onPressed: () => sendOtp(_phoneController.text.trim()),
// // //               child: Text('Send OTP'),
// // //             )
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // -------------------------------  Main.dart ( No need to delete )  -----------------------------------------

import 'dart:ui' show ImageFilter;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/firebase_options.dart';
import 'package:ticpin/pages/chat/chating.dart';
import 'package:ticpin/pages/home/homepage.dart';
import 'package:ticpin/pages/login/loginpage.dart';
import 'package:ticpin/services/controllers/dining_controller.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/services/controllers/location_controller.dart';
import 'package:ticpin/services/controllers/turf_controller.dart';

import 'services/controllers/videoController.dart';

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

  // Don't initialize controllers here - wait until after login
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final check = snapshot.data!;

        return GetMaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white,
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
                              Text('Loading data...'),
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
