import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/glass_container.dart';

class Paymentpage extends StatefulWidget {
  const Paymentpage({super.key});

  @override
  State<Paymentpage> createState() => _PaymentpageState();
}

class _PaymentpageState extends State<Paymentpage> {
  static const platform = MethodChannel("razorpay_flutter");
  late final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle success
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle failure
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  var options = {
    'key': '<YOUR_KEY_ID>',
    'amount': 50000,
    'currency': 'INR',
    'name': 'Ticpin',
    'description': 'Booking Payment',
    'timeout': 60,
    'prefill': {'contact': '', 'email': ''},
  };

  void openCheckout() async {
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes();
    return Scaffold(
      backgroundColor: Platform.isIOS ? Colors.black : whiteColor,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Platform.isIOS ? whiteColor : Colors.black,
            fontFamily: 'Regular',
          ),
        ),
        backgroundColor: Platform.isIOS ? Colors.black : whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Platform.isIOS ? whiteColor : Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (Platform.isIOS)
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradient1, gradient2, Colors.black],
                ),
              ),
            ),
          Center(
            child: TicpinGlassContainer(
              width: size.safeWidth * 0.8,
              height: size.safeHeight * 0.45,
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 60,
                      color: Platform.isIOS ? whiteColor : gradient1,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Regular',
                        color: Platform.isIOS ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹ 500.00',
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Bold',
                        fontWeight: FontWeight.bold,
                        color: Platform.isIOS ? whiteColor : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: openCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Platform.isIOS ? whiteColor : gradient1,
                        foregroundColor:
                            Platform.isIOS ? Colors.black : whiteColor,
                        fixedSize: Size(size.safeWidth * 0.6, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(fontFamily: 'Regular', fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
