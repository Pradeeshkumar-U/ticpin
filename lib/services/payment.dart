import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/* ------------------------- Way to call the payment service inside any widget -------------------------
PaymentService.openCheckout(
    context: context,
    key: 'rzp_test_Rj9I3sa8RFEXxz', // replace with original key , this is test api key
    amount: 200, // INR
    name: 'Ticpin App',
    description: 'Ticket Booking Payment',
    contact: '9025381459',
    email: 'user@test.com',
    onSuccess: (resp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paid: ${resp.paymentId}')));
    },
  );
},
*/
 
class PaymentService {
  static void openCheckout({
    required BuildContext context,
    required String key,
    required int amount,
    String name = 'Ticpin App',
    String description = '',
    String contact = '',
    String email = '',
    Map<String, bool>? methods,
    List<String>? wallets,
    void Function(PaymentSuccessResponse)? onSuccess,
    void Function(PaymentFailureResponse)? onError,
    void Function(ExternalWalletResponse)? onExternal,
  }) {
    final razorpay = Razorpay();

    void _cleanup() {
      try {
        razorpay.clear();
      } catch (_) {}
    }

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (resp) {
      final r = resp as PaymentSuccessResponse;
      if (onSuccess != null) {
        onSuccess(r);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment successful: ${r.paymentId}')));
      }
      _cleanup();
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (resp) {
      final r = resp as PaymentFailureResponse;
      if (onError != null) {
        onError(r);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: ${r.message}')));
      }
      _cleanup();
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (resp) {
      final r = resp as ExternalWalletResponse;
      if (onExternal != null) {
        onExternal(r);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('External wallet: ${r.walletName}')));
      }
      _cleanup();
    });

    final options = {
      'key': key,
      'amount': amount * 100,
      'name': name,
      'description': description,
      'prefill': {'contact': contact, 'email': email},
      'method': methods ?? {'upi': true, 'netbanking': true, 'card': true, 'wallet': true},
      'external': {'wallets': wallets ?? ['paytm', 'phonepe', 'gpay']},
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay open error: $e');
      _cleanup();
    }
  }
}




// ------------------------- Dummy main function and MyApp class to test the payment button functionality -------------------------
// void main() {
//   runApp(const MyApp());
// }

// // Dummy class to test the button flunctionality , just no needs to use MyApp class if starts payment integration in existing app
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Ticpin Payment',
//       theme: ThemeData(primarySwatch: Colors.deepPurple),
//       home: const PaymentPage(),
//     );
//   }
// }

// class PaymentPage extends StatelessWidget {
//   const PaymentPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Ticpin Payment')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Call PaymentService with all required info as parameters
//             PaymentService.openCheckout(
//               context: context,
//               key: 'rzp_test_Rj9I3sa8RFEXxz', // replace with original key , this is test api key
//               amount: 200, // INR
//               name: 'Ticpin App',
//               description: 'Ticket Booking Payment',
//               contact: '9025381459',
//               email: 'user@test.com',
//               onSuccess: (resp) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paid: ${resp.paymentId}')));
//               },
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepPurple,
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           child: Text('Pay ₹200', style: const TextStyle(fontSize: 18, color: Colors.white)),
//         ),
//       ),
//     );
//   }
// }
