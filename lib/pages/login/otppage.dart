// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:ticpin_dining/constants/colors.dart';
// import 'package:ticpin_dining/constants/size.dart';
// import 'package:ticpin_dining/pages/homepage.dart';

// // ignore: must_be_immutable
// class Otppage extends StatefulWidget {
//   Otppage({super.key, required this.phone});
//   String phone;

//   @override
//   State<Otppage> createState() => _OtppageState();
// }

// class _OtppageState extends State<Otppage> with CodeAutoFill {
//   String otpCode = '';

//   TextEditingController _controller = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     // listenForCode();
//   }

//   @override
//   void codeUpdated() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {
//           otpCode = code ?? '';
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     cancel();
//     super.dispose();
//   }

//   void onSubmit(String code) {
//     Get.offAll(DiningHomepage());
//   }

//   Sizes size = Sizes();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       extendBodyBehindAppBar: true,

//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () => Get.back(),
//           child: Icon(Icons.arrow_back, color: whiteColor),
//         ),
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//         title: Text(
//           ' OTP verification',
//           style: TextStyle(
//             fontSize: size.width * 0.05,
//             fontWeight: FontWeight.bold,
//             color: whiteColor,
//             fontFamily: 'Regular',
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [gradient1, gradient2, blackColor],
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: size.height * 0.12),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: size.width * 0.05,
//                         ),
//                         child: FittedBox(
//                           fit: BoxFit.scaleDown,
//                           child: Text(
//                             "We have sent a verification code to",
//                             style: TextStyle(
//                               fontSize: size.width * 0.045,
//                               color: whiteColor,
//                               fontFamily: 'Regular',
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: size.width * 0.05,
//                         ),
//                         child: Text(
//                           '+91 ${widget.phone}',
//                           style: TextStyle(
//                             fontSize: size.width * 0.05,
//                             color: whiteColor,
//                             fontFamily: 'Regular',
//                           ),
//                         ),
//                       ),

//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           vertical: size.height * 0.04,
//                           horizontal: size.width * 0.05,
//                         ),
//                         child: PinFieldAutoFill(
//                           controller: _controller,
//                           codeLength: 6,
//                           currentCode: otpCode,

//                           onCodeChanged: (code) {
//                             if (!mounted) return;

//                             if (code != null) {
//                               setState(() {
//                                 otpCode = code;
//                               });

//                               if (code.length == 6) {
//                                 WidgetsBinding.instance.addPostFrameCallback((
//                                   _,
//                                 ) {
//                                   onSubmit(code);
//                                 });
//                               }
//                             }
//                           },

//                           decoration: BoxLooseDecoration(
//                             strokeWidth: 1,
//                             bgColorBuilder: FixedColorBuilder(
//                               Colors.grey.withAlpha(100),
//                             ),
//                             radius: Radius.circular(12),
//                             strokeColorBuilder: FixedColorBuilder(Colors.white),
//                             textStyle: TextStyle(
//                               fontSize: size.width * 0.05,
//                               fontFamily: 'Regular',
//                               color: whiteColor,
//                             ),
//                           ),
//                         ),
//                       ),

//                       FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(left: size.width * 0.05),
//                               child: Text(
//                                 'Didn\'t get the OTP?',
//                                 style: TextStyle(
//                                   fontSize: size.width * 0.05,
//                                   color: whiteColor,
//                                   fontFamily: 'Regular',
//                                 ),
//                               ),
//                             ),

//                             FittedBox(
//                               fit: BoxFit.scaleDown,

//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                   right: size.width * 0.05,
//                                 ),
//                                 child: Text(
//                                   '  (request again in 0.28s)',
//                                   style: TextStyle(
//                                     fontSize: size.width * 0.032,
//                                     color: whiteColor,
//                                     fontFamily: 'Regular',
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: size.width * 0.04),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (otpCode.length == 6) {
//                       onSubmit(otpCode);
//                     } else {
//                       Get.closeAllSnackbars();
//                       Get.snackbar(
//                         '',
//                         '',
//                         messageText: Text(
//                           'Please fill the code',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: size.width * 0.03,
//                             fontFamily: 'Regular',
//                             color: Colors.white,
//                           ),
//                         ),
//                         maxWidth: size.width * 0.4, // Adjusted width
//                         titleText: SizedBox.shrink(),
//                         padding: EdgeInsets.only(
//                           // left: size.width * 0.01,
//                           // right: size.width * 0.01,
//                           top: size.width * 0.02,
//                           bottom: size.width * 0.03,
//                         ),
//                         snackStyle: SnackStyle.FLOATING,
//                         snackPosition: SnackPosition.BOTTOM,
//                         backgroundColor: greyColor,
//                         colorText: Colors.white,
//                         duration: const Duration(seconds: 2),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: otpCode.length == 6
//                         ? Colors.white
//                         : Colors.white.withAlpha(100),

//                     elevation: 0,
//                     enabledMouseCursor: MouseCursor.defer,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),

//                     fixedSize: Size(size.width * 0.868, size.width * 0.15),
//                   ),

//                   child: Text(
//                     'Continue',
//                     style: TextStyle(
//                       fontSize: size.width * 0.04,
//                       fontFamily: 'Regular',
//                       color: otpCode.length == 6
//                           ? blackColor
//                           : greyColor.withAlpha(100),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:ticpin_dining/constants/colors.dart';
import 'package:ticpin_dining/constants/size.dart';
import 'package:ticpin_dining/pages/homepage.dart';
import 'package:ticpin_dining/services/adminservice.dart';
// import 'package:ticpin_dining/services/adminservice.dart';

// ignore: must_be_immutable
class Otppage extends StatefulWidget {
  Otppage({super.key, required this.phone, required this.verificationId});
  String phone;
  String verificationId;

  @override
  State<Otppage> createState() => _OtppageState();
}

class _OtppageState extends State<Otppage> with CodeAutoFill {
  String otpCode = '';
  bool isVerifying = false;
  String? errorMessage;
  final DiningPartnerAdminService _adminService = DiningPartnerAdminService();
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  void codeUpdated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          otpCode = code ?? '';
        });
      }
    });
  }

  Future<void> verifyOtpAndSignIn(String otp) async {
    if (isVerifying) return;

    setState(() {
      isVerifying = true;
      errorMessage = null;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // Sign in with the credential
      final userCredential = await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Create admin document in Firestore
        await _adminService.createAdminDocument('+91${widget.phone}');

        // Check admin status
        final adminData = await _adminService.getAdminData();

        if (adminData == null) {
          throw Exception('Failed to create admin profile');
        }

        // Navigate to admin dashboard
        Get.offAll(() => DiningHomepage());

        Get.snackbar(
          '',
          '',
          messageText: Text(
            'Login Successful',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.safeWidth * 0.03,
              fontFamily: 'Regular',
              color: Colors.white,
            ),
          ),
          maxWidth: size.safeWidth * 0.7,
          titleText: SizedBox.shrink(),
          padding: EdgeInsets.only(
            top: size.safeWidth * 0.02,
            bottom: size.safeWidth * 0.03,
          ),
          snackStyle: SnackStyle.FLOATING,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: greyColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Verification failed';
      if (e.code == 'invalid-verification-code') {
        message = 'Invalid OTP. Please try again';
      } else if (e.code == 'session-expired') {
        message = 'Session expired. Please request a new OTP';
      }

      setState(() {
        errorMessage = message;
        isVerifying = false;
      });

      Get.snackbar(
        '',
        '',
        messageText: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size.safeWidth * 0.03,
            fontFamily: 'Regular',
            color: Colors.white,
          ),
        ),
        maxWidth: size.safeWidth * 0.7,
        titleText: SizedBox.shrink(),
        padding: EdgeInsets.only(
          top: size.safeWidth * 0.02,
          bottom: size.safeWidth * 0.03,
        ),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: greyColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred';
        isVerifying = false;
      });

      Get.snackbar(
        '',
        '',
        messageText: Text(
          'An error occurred: ${e.toString()}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size.safeWidth * 0.03,
            fontFamily: 'Regular',
            color: Colors.white,
          ),
        ),
        maxWidth: size.safeWidth * 0.7,
        titleText: SizedBox.shrink(),
        padding: EdgeInsets.only(
          top: size.safeWidth * 0.02,
          bottom: size.safeWidth * 0.03,
        ),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: greyColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void dispose() {
    cancel();
    _controller.dispose();
    super.dispose();
  }

  Sizes size = Sizes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: whiteColor),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradient1, gradient2, blackColor],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.safeHeight * 0.12),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.safeWidth * 0.05,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "We have sent a verification code to",
                              style: TextStyle(
                                fontSize: size.safeWidth * 0.045,
                                color: whiteColor,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.safeWidth * 0.05,
                          ),
                          child: Text(
                            '+91 ${widget.phone}',
                            style: TextStyle(
                              fontSize: size.safeWidth * 0.05,
                              color: whiteColor,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.safeHeight * 0.04,
                            horizontal: size.safeWidth * 0.05,
                          ),
                          child: PinFieldAutoFill(
                            controller: _controller,
                            codeLength: 6,
                            currentCode: otpCode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onCodeChanged: (code) {
                              if (!mounted) return;

                              if (code != null) {
                                setState(() {
                                  otpCode = code;
                                });

                                if (code.length == 6) {
                                  // Auto-verify when 6 digits entered
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    verifyOtpAndSignIn(code);
                                  });
                                }
                              }
                            },
                            decoration: BoxLooseDecoration(
                              strokeWidth: 1,
                              bgColorBuilder: FixedColorBuilder(
                                Colors.grey.withAlpha(100),
                              ),
                              radius: Radius.circular(12),
                              strokeColorBuilder: FixedColorBuilder(
                                Colors.white,
                              ),
                              textStyle: TextStyle(
                                fontSize: size.safeWidth * 0.05,
                                fontFamily: 'Regular',
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                        if (errorMessage != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.safeWidth * 0.05,
                            ),
                            child: Text(
                              errorMessage!,
                              style: TextStyle(
                                fontSize: size.safeWidth * 0.035,
                                color: Colors.red[300],
                                fontFamily: 'Regular',
                              ),
                            ),
                          ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.safeWidth * 0.05,
                                ),
                                child: Text(
                                  'Didn\'t get the OTP?',
                                  style: TextStyle(
                                    fontSize: size.safeWidth * 0.05,
                                    color: whiteColor,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: size.safeWidth * 0.05,
                                  ),
                                  child: Text(
                                    '  (request again in 0.28s)',
                                    style: TextStyle(
                                      fontSize: size.safeWidth * 0.032,
                                      color: whiteColor,
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.safeHeight * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.safeWidth * 0.05,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(size.safeWidth * 0.04),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withAlpha(50),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white70,
                                  size: size.safeWidth * 0.05,
                                ),
                                SizedBox(width: size.safeWidth * 0.03),
                                Expanded(
                                  child: Text(
                                    'You are logging in as a Ticpin Dining Partner. Your account will be reviewed before approval.',
                                    style: TextStyle(
                                      fontSize: size.safeWidth * 0.032,
                                      color: Colors.white70,
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.safeWidth * 0.04),
                  child: ElevatedButton(
                    onPressed: isVerifying
                        ? null
                        : () async {
                            if (otpCode.length == 6) {
                              await verifyOtpAndSignIn(_controller.text);
                            } else {
                              Get.closeAllSnackbars();
                              Get.snackbar(
                                '',
                                '',
                                messageText: Text(
                                  'Please enter the 6-digit OTP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: size.safeWidth * 0.03,
                                    fontFamily: 'Regular',
                                    color: Colors.white,
                                  ),
                                ),
                                maxWidth: size.safeWidth * 0.7,
                                titleText: SizedBox.shrink(),
                                padding: EdgeInsets.only(
                                  top: size.safeWidth * 0.02,
                                  bottom: size.safeWidth * 0.03,
                                ),
                                snackStyle: SnackStyle.FLOATING,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: greyColor,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: otpCode.length == 6 && !isVerifying
                          ? Colors.white
                          : Colors.white.withAlpha(100),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fixedSize: Size(
                        size.safeWidth * 0.868,
                        size.safeWidth * 0.15,
                      ),
                    ),
                    child: isVerifying
                        ? SizedBox(
                            width: size.safeWidth * 0.05,
                            height: size.safeWidth * 0.05,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                blackColor,
                              ),
                            ),
                          )
                        : Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: size.safeWidth * 0.04,
                              fontFamily: 'Regular',
                              color: otpCode.length == 6
                                  ? blackColor
                                  : greyColor.withAlpha(100),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
