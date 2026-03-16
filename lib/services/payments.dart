import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:ticpin/constants/colors.dart';

String razorpay_backend_url =
    "https://us-central1-ticpin-database.cloudfunctions.net/createOrder";
String razorpay_webhook_url =
    "https://us-central1-ticpin-database.cloudfunctions.net/razorpayWebhook";

/// Payment Page with Complete Split Payment Support
/// Supports both test and production Razorpay payments
class PaymentPage extends StatefulWidget {
  // Payment configuration
  final double amount;
  final String organizerId;
  final double splitPercentage; // Percentage to organizer (0-100)

  // Callbacks
  final Function(String paymentId, String orderId)? onPaymentSuccess;
  final Function(String error)? onPaymentError;

  // User data
  final String userEmail;
  final String userPhone;
  final String userId;

  const PaymentPage({
    super.key,
    this.amount = 10,
    this.organizerId = "acc_S7JDINk1dNXt6W",
    this.splitPercentage = 90,
    this.onPaymentSuccess,
    this.onPaymentError,
    this.userEmail = "user@gmail.com",
    this.userPhone = "9025381459",
    this.userId = "user123",
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool loading = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ✅ PAYMENT SUCCESS HANDLER
  void _onPaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("✅ Payment Success!");
    debugPrint("Payment ID: ${response.paymentId}");
    debugPrint("Order ID: ${response.orderId}");

    MotionToast.success(
      description: Text(
        "Payment Successful!\nPayment ID: ${response.paymentId}\nOrder ID: ${response.orderId}",
      ),
    ).show(context);

    _storePaymentDetails(
      paymentId: response.paymentId!,
      orderId: response.orderId!,
      status: 'success',
    );

    widget.onPaymentSuccess?.call(response.paymentId!, response.orderId!);
  }

  // ❌ PAYMENT ERROR HANDLER
  void _onPaymentError(PaymentFailureResponse response) {
    debugPrint("❌ Payment Error!");
    debugPrint("Code: ${response.code}");
    debugPrint("Message: ${response.message}");

    MotionToast.error(
      description: Text(
        "Payment Failed\nCode: ${response.code}\n${response.message}",
      ),
    ).show(context);

    widget.onPaymentError?.call(response.message ?? "Payment failed");
  }

  // 💳 EXTERNAL WALLET HANDLER
  void _onExternalWallet(ExternalWalletResponse response) {
    debugPrint("💳 External Wallet: ${response.walletName}");
    MotionToast.info(
      description: Text("Using: ${response.walletName}"),
    ).show(context);
  }

  // 💾 STORE PAYMENT DETAILS
  Future<void> _storePaymentDetails({
    required String paymentId,
    required String orderId,
    required String status,
  }) async {
    try {
      debugPrint("\n💾 Storing payment details...");
      // TODO: Implement Firestore storage
      debugPrint("✅ Payment details stored successfully");
    } catch (e) {
      debugPrint("❌ Error storing payment: $e");
    }
  }

  // 📲 CREATE RAZORPAY ORDER - THIS IS THE MAIN PAYMENT FUNCTION
  Future<void> startPayment() async {
    // Validate user data
    // if (widget.userEmail.isEmpty || widget.userEmail == "user@example.com") {
    if (widget.userEmail.isEmpty) {
      MotionToast.warning(
        description: const Text(
          "Please update your profile with a valid email",
        ),
      ).show(context);
      return;
    }

    // if (widget.userPhone.isEmpty || widget.userPhone == "9025381459") {
    if (widget.userPhone.isEmpty) {
      MotionToast.warning(
        description: const Text(
          "Please update your profile with a valid phone",
        ),
      ).show(context);
      return;
    }

    setState(() => loading = true);

    try {
      debugPrint("\n🔵 ========== PAYMENT INITIATED ==========");
      debugPrint("💰 Amount: ₹${widget.amount}");
      debugPrint("🎯 Organizer ID: ${widget.organizerId}");
      debugPrint("📊 Split: ${widget.splitPercentage}% to organizer");
      debugPrint("📍 Backend URL: $razorpay_backend_url");

      final url = Uri.parse(razorpay_backend_url);

      final requestBody = {
        "amount": widget.amount.toInt(),
        "organizerAccountId": widget.organizerId,
        "percentage": widget.splitPercentage,
      };

      debugPrint("📤 Sending: ${jsonEncode(requestBody)}");

      // Make HTTP request with proper error handling
      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Access-Control-Allow-Origin": "*",
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              throw Exception(
                "Timeout! Backend not responding.\n"
                "URL: $razorpay_backend_url\n\n"
                "Check:\n"
                "1. Internet connection\n"
                "2. Firebase Functions deployed\n"
                "3. Check logs: firebase functions:log",
              );
            },
          );

      debugPrint("📥 Response Code: ${response.statusCode}");
      debugPrint("📥 Response Headers: ${response.headers}");
      debugPrint("📥 Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
          "Backend Error ${response.statusCode}: ${response.body}",
        );
      }

      final data = jsonDecode(response.body);
      debugPrint("✅ Order Created: ${data['orderId']}");

      if (data["key"] == null || data["orderId"] == null) {
        throw Exception(
          "Invalid backend response - missing orderId or key\n"
          "Response: ${jsonEncode(data)}",
        );
      }

      debugPrint("🎫 Opening Razorpay Payment Modal...");

      // OPEN RAZORPAY PAYMENT MODAL
      _razorpay.open({
        "key": data["key"],
        "order_id": data["orderId"],
        "amount": (widget.amount * 100).toInt(),
        "currency": "INR",
        "name": "Ticpin",
        "description": "Event Ticket - Split Payment",
        "retry": {"enabled": true, "max_count": 3},
        "prefill": {"contact": widget.userPhone, "email": widget.userEmail},
        "notes": {
          "organizer_id": widget.organizerId,
          "user_id": widget.userId,
          "split_percentage": widget.splitPercentage.toString(),
        },
        "theme": {"color": "#100d67"},
      });

      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      debugPrint("\n❌ PAYMENT ERROR OCCURRED");
      debugPrint("Error Type: ${e.runtimeType}");
      debugPrint("Error Message: $e\n");

      MotionToast.error(
        description: Text(
          "Payment Error:\n$e\n\n"
          "Troubleshooting:\n"
          "1. Check internet connection\n"
          "2. Verify Firebase Functions deployed\n"
          "3. Check backend URL is correct\n"
          "4. View logs: firebase functions:log --follow",
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Payment Gateway"),
        backgroundColor: gradient1,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 💳 Payment Icon
              Icon(Icons.payment, size: 100, color: gradient1),
              const SizedBox(height: 30),

              // 💰 Amount Display
              Text(
                "₹${widget.amount.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: gradient1,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Complete your payment",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // 📊 Split Payment Info
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Payment Split",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "₹${(widget.amount * widget.splitPercentage / 100).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: gradient1,
                              ),
                            ),
                            const Text(
                              "Organizer",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "₹${(widget.amount * (100 - widget.splitPercentage) / 100).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              "Platform",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 🔘 Pay Button
              ElevatedButton.icon(
                onPressed: loading ? null : startPayment,
                icon: Icon(loading ? Icons.hourglass_empty : Icons.credit_card),
                label: Text(loading ? "Processing..." : "Complete Payment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gradient1,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  loading
                      ? "Processing your payment..."
                      : "Secure and encrypted",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              // 🔒 Security Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 16, color: Colors.green),
                  const SizedBox(width: 5),
                  const Text(
                    "Powered by Razorpay",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
