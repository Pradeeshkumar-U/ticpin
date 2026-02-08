import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:ticpin_dining/constants/colors.dart';
import 'package:ticpin_dining/constants/size.dart';
import 'package:ticpin_dining/pages/homepage.dart';

// ignore: must_be_immutable
class Otppage extends StatefulWidget {
  Otppage({super.key, required this.phone});
  String phone;

  @override
  State<Otppage> createState() => _OtppageState();
}

class _OtppageState extends State<Otppage> with CodeAutoFill {
  String otpCode = '';

  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    // listenForCode();
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

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  void onSubmit(String code) {
    Get.offAll(DiningHomepage());
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
        title: Text(
          ' OTP verification',
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: whiteColor,
            fontFamily: 'Regular',
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradient1, gradient2, blackColor],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.12),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "We have sent a verification code to",
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              color: whiteColor,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Text(
                          '+91 ${widget.phone}',
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            color: whiteColor,
                            fontFamily: 'Regular',
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.04,
                          horizontal: size.width * 0.05,
                        ),
                        child: PinFieldAutoFill(
                          controller: _controller,
                          codeLength: 6,
                          currentCode: otpCode,

                          onCodeChanged: (code) {
                            if (!mounted) return;

                            if (code != null) {
                              setState(() {
                                otpCode = code;
                              });

                              if (code.length == 6) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  onSubmit(code);
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
                            strokeColorBuilder: FixedColorBuilder(Colors.white),
                            textStyle: TextStyle(
                              fontSize: size.width * 0.05,
                              fontFamily: 'Regular',
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: size.width * 0.05),
                              child: Text(
                                'Didn\'t get the OTP?',
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  color: whiteColor,
                                  fontFamily: 'Regular',
                                ),
                              ),
                            ),

                            FittedBox(
                              fit: BoxFit.scaleDown,

                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: size.width * 0.05,
                                ),
                                child: Text(
                                  '  (request again in 0.28s)',
                                  style: TextStyle(
                                    fontSize: size.width * 0.032,
                                    color: whiteColor,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: size.width * 0.04),
                child: ElevatedButton(
                  onPressed: () {
                    if (otpCode.length == 6) {
                      onSubmit(otpCode);
                    } else {
                      Get.closeAllSnackbars();
                      Get.snackbar(
                        '',
                        '',
                        messageText: Text(
                          'Please fill the code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.03,
                            fontFamily: 'Regular',
                            color: Colors.white,
                          ),
                        ),
                        maxWidth: size.width * 0.4, // Adjusted width
                        titleText: SizedBox.shrink(),
                        padding: EdgeInsets.only(
                          // left: size.width * 0.01,
                          // right: size.width * 0.01,
                          top: size.width * 0.02,
                          bottom: size.width * 0.03,
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
                    backgroundColor: otpCode.length == 6
                        ? Colors.white
                        : Colors.white.withAlpha(100),

                    elevation: 0,
                    enabledMouseCursor: MouseCursor.defer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    fixedSize: Size(size.width * 0.868, size.width * 0.15),
                  ),

                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: size.width * 0.04,
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
        ],
      ),
    );
  }
}
