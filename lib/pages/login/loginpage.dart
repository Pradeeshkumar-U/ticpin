import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/login/otppage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> with WidgetsBindingObserver {
  Sizes size = Sizes();
  final TextEditingController _phoneController = TextEditingController();
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // ignore: deprecated_member_use
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (mounted) {
      setState(() {
        isKeyboardVisible = bottomInset > 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
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
          Align(
            alignment: Alignment(0, -0.3),
            child: SizedBox(
              width: size.safeWidth * 0.6,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          if (keyboard > 0)
            GestureDetector(
              onTap: () => Get.back(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  height: size.safeHeight,
                  width: size.safeWidth,
                  color: Colors.black.withAlpha(100), // Slight dark overlay
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedPadding(
                    duration: const Duration(milliseconds: 5),
                    curve: Curves.easeInCirc,
                    padding: EdgeInsets.only(
                      bottom:
                          keyboard > 0
                              ? (keyboard - size.safeHeight * 0.08).abs()
                              : 20,
                    ),

                    child: Container(
                      height: size.safeHeight * 0.26,
                      width: size.safeWidth,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(30),
                        //   topRight: Radius.circular(30),
                        // ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Log in or Sign up',
                              style: TextStyle(
                                fontSize: size.safeWidth * 0.041,
                                fontFamily: 'Regular',
                                color: whiteColor,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: size.safeHeight * 0.08,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: size.safeWidth * 0.03,
                                        right: size.safeWidth * 0.02,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/images/icons/india.svg',
                                        width: size.safeWidth * 0.05,
                                        height: size.safeWidth * 0.05,
                                      ),
                                    ),
                                    // SizedBox(width: size.safeWidth * 0.01),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: size.safeWidth * 0.03,
                                      ),
                                      child: Text(
                                        '+91',
                                        style: TextStyle(
                                          fontSize: size.safeWidth * 0.035,
                                          fontFamily: 'Regular',
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),

                                    // SizedBox(width: size.safeWidth * 0.01),
                                  ],
                                ),
                              ),
                              Container(
                                height: size.safeHeight * 0.08,
                                width: size.safeWidth * 0.65,
                                margin: EdgeInsets.only(
                                  left: size.safeWidth * 0.02,
                                ),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    // top: size.safeHeight * 0.009,
                                    // bottom: size.safeHeight * 0.009,
                                    left: size.safeWidth * 0.06,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextField(
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            if (value.length >= 10) {
                                              FocusScope.of(
                                                context,
                                              ).unfocus(); // hide keyboard
                                            }
                                          });
                                        }
                                      },
                                      controller: _phoneController,
                                      style: TextStyle(
                                        fontSize: size.safeWidth * 0.04,
                                        fontFamily: 'Regular',
                                        color: Colors.black54,
                                      ),
                                      // textAlign: TextAlign.center,
                                      maxLength: 10,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      buildCounter:
                                          (
                                            BuildContext context, {
                                            required int currentLength,
                                            required bool isFocused,
                                            required int? maxLength,
                                          }) => null,
                                      keyboardType: TextInputType.phone,
                                      autofocus: false,
                                      cursorColor: Colors.black54,
                                      cursorHeight: size.safeWidth * 0.04,
                                      decoration: InputDecoration(
                                        hintText: 'Enter mobile number',
                                        hintStyle: TextStyle(
                                          fontSize: size.safeWidth * 0.035,
                                          fontFamily: 'Regular',
                                          color: Colors.black54,
                                        ),

                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: size.safeWidth * 0.02,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              _phoneController.text.toString().length == 10
                                  ? {
                                    await FirebaseAuth.instance
                                        .verifyPhoneNumber(
                                          phoneNumber:
                                              '+91${_phoneController.text}',
                                          verificationCompleted:
                                              (
                                                PhoneAuthCredential credential,
                                              ) {},
                                          verificationFailed: (
                                            FirebaseAuthException e,
                                          ) {
                                            Get.closeAllSnackbars();
                                            Get.snackbar(
                                              '',
                                              '',
                                              messageText: Text(
                                                e.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize:
                                                      size.safeWidth * 0.03,
                                                  fontFamily: 'Regular',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              maxWidth:
                                                  size.safeWidth *
                                                  0.7, // Adjusted width
                                              titleText: SizedBox.shrink(),
                                              padding: EdgeInsets.only(
                                                // left: size.safeWidth * 0.01,
                                                // right: size.safeWidth * 0.01,
                                                top: size.safeWidth * 0.02,
                                                bottom: size.safeWidth * 0.03,
                                              ),
                                              snackStyle: SnackStyle.FLOATING,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: greyColor,
                                              colorText: Colors.white,
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            );
                                          },
                                          codeSent: (
                                            String verificationId,
                                            int? resendToken,
                                          ) {
                                            Get.to(
                                              () => Otppage(
                                                verificationId: verificationId,
                                                phone: _phoneController.text,
                                              ),
                                            );
                                          },
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {},
                                        ),
                                  }
                                  : {
                                    Get.closeAllSnackbars(),
                                    Get.snackbar(
                                      '',
                                      '',
                                      messageText: Text(
                                        'Please enter a valid phone number',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.safeWidth * 0.03,
                                          fontFamily: 'Regular',
                                          color: Colors.white,
                                        ),
                                      ),
                                      maxWidth:
                                          size.safeWidth *
                                          0.7, // Adjusted width
                                      titleText: SizedBox.shrink(),
                                      padding: EdgeInsets.only(
                                        // left: size.safeWidth * 0.01,
                                        // right: size.safeWidth * 0.01,
                                        top: size.safeWidth * 0.02,
                                        bottom: size.safeWidth * 0.03,
                                      ),
                                      snackStyle: SnackStyle.FLOATING,
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: greyColor,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  };
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _phoneController.text.toString().length == 10
                                      ? Colors.white
                                      : Colors.white.withAlpha(100),

                              elevation: 0,
                              enabledMouseCursor: MouseCursor.defer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              fixedSize: Size(
                                size.safeWidth * 0.868,
                                size.safeWidth * 0.15,
                              ),
                            ),

                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: size.safeWidth * 0.04,
                                fontFamily: 'Regular',
                                color:
                                    _phoneController.text.toString().length ==
                                            10
                                        ? blackColor
                                        : greyColor.withAlpha(100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: size.safeHeight * 0.00),
                  Text(
                    'By continuing, you agree to our',
                    style: TextStyle(
                      fontSize: size.safeWidth * 0.03,
                      fontFamily: 'Regular',
                      color: Colors.white70,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontSize: size.safeWidth * 0.025,
                          fontFamily: 'Regular',
                          color: Colors.white70,
                          decoration: TextDecoration.combine([
                            TextDecoration.underline,
                          ]),

                          decorationStyle: TextDecorationStyle.dashed,
                          decorationColor: Colors.white70,
                        ),
                      ),
                      SizedBox(width: size.safeWidth * 0.05),
                      Text(
                        'Privacy Policy',

                        style: TextStyle(
                          fontSize: size.safeWidth * 0.025,
                          fontFamily: 'Regular',
                          decoration: TextDecoration.combine([
                            TextDecoration.underline,
                          ]),

                          decorationStyle: TextDecorationStyle.dashed,
                          decorationColor: Colors.white70,

                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.safeHeight * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
