import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Paymentpage extends StatefulWidget {
  const Paymentpage({super.key});

  @override
  State<Paymentpage> createState() => _PaymentpageState();
}

class _PaymentpageState extends State<Paymentpage> {
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }
  var options = {
  'key': '<YOUR_KEY_ID>',
  'amount': 50000, 
  'currency': '<currency>',
  'name': 'Acme Corp.',
  'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
  'description': 'Fine T-Shirt',
  'timeout': 60, // in seconds
  'prefill': {
    'contact': '<phone>',
    'email': '<email>'
  }
};

  void openCheckout() async {
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Page')),
      body: Center(
        child: ElevatedButton(onPressed: openCheckout, child: Text('Pay Now')),
      ),
    );
  }
}
