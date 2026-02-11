// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/pages/view/dining/timeselectpage.dart';

// class DiningBillpage extends StatefulWidget {
//   const DiningBillpage({super.key});

//   @override
//   State<DiningBillpage> createState() => _DiningBillpageState();
// }

// class _DiningBillpageState extends State<DiningBillpage> {
//   Sizes size = Sizes();
//   TextEditingController _controller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: whiteColor,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Dining name',
//               style: TextStyle(
//                 fontSize: size.safeWidth * 0.035,
//                 fontFamily: 'Regular',
//               ),
//             ),
//             Text(
//               'Location',
//               style: TextStyle(
//                 fontSize: size.safeWidth * 0.03,
//                 fontFamily: 'Regular',
//                 color: Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: whiteColor,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               SizedBox(height: size.safeHeight * 0.05),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.safeWidth * 0.06,
//                   vertical: size.safeWidth * 0.05,
//                 ),
//                 child: Row(
//                   children: [
//                     Text(
//                       'Enter your bill amount to pay',
//                       style: TextStyle(
//                         fontSize: size.safeWidth * 0.04,
//                         fontFamily: 'Regular',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.safeWidth * 0.06,
//                 ),
//                 child: Container(
//                   height: size.safeHeight * 0.07,
//                   decoration: BoxDecoration(
//                     border: Border.all(width: 1.5, color: blackColor),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         icon: Padding(
//                           padding: EdgeInsets.only(left: size.safeWidth * 0.05),
//                           child: Text(
//                             '₹',
//                             style: TextStyle(
//                               fontSize: size.safeWidth * 0.04,
//                               // fontFamily: 'Regular',
//                             ),
//                           ),
//                         ),
//                         contentPadding: EdgeInsets.all(0),

//                         border: InputBorder.none,
//                         hintText: '0.00',
//                       ),
//                       maxLines: 1,
//                       cursorColor: Colors.black54,
//                       cursorHeight: size.safeWidth * 0.06,

//                       style: TextStyle(
//                         fontSize: size.safeWidth * 0.04,
//                         fontFamily: 'Regular',
//                       ),
//                       keyboardType: TextInputType.numberWithOptions(),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: size.safeHeight * 0.05),
//               SizedBox(
//                 // height: size.safeHeight * 0.2,
//                 child: GridView.builder(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.safeWidth * 0.05,
//                   ),
//                   shrinkWrap: true,
//                   itemCount: 4,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: size.safeWidth * 0.05,
//                     // mainAxisSpacing: size.safeWidth * 0.0,
//                     mainAxisExtent: size.safeWidth * 0.28,
//                   ),
//                   itemBuilder: (context, index) {
//                     return Column(
//                       children: [
//                         Container(
//                           height: size.safeWidth * 0.11,
//                           width: size.safeWidth * 0.4,
//                           decoration: BoxDecoration(
//                             color: gradient2,
//                             borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(12),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   left: size.safeWidth * 0.03,
//                                 ),
//                                 child: Text(
//                                   'Offer name',
//                                   style: TextStyle(
//                                     fontSize: size.safeWidth * 0.03,
//                                     fontFamily: 'Regular',
//                                     color: whiteColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: size.safeWidth * 0.1,
//                           width: size.safeWidth * 0.4,
//                           decoration: BoxDecoration(
//                             color: whiteColor,
//                             border: Border(
//                               left: BorderSide(width: 1, color: Colors.black87),
//                               right: BorderSide(
//                                 width: 1,
//                                 color: Colors.black87,
//                               ),
//                               bottom: BorderSide(
//                                 width: 1,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             borderRadius: BorderRadius.vertical(
//                               bottom: Radius.circular(12),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   left: size.safeWidth * 0.03,
//                                 ),
//                                 child: Text(
//                                   'Details',
//                                   style: TextStyle(
//                                     fontSize: size.safeWidth * 0.03,
//                                     fontFamily: 'Regular',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: EdgeInsets.only(bottom: size.safeWidth * 0.08),
//               child: InkWell(
//                 onTap: () {
//                   Get.to(SelectTimingpage());
//                 },
//                 child: Container(
//                   width: size.safeWidth * 0.9,
//                   height: size.safeWidth * 0.13,
//                   // padding: EdgeInsets.symmetric(
//                   //   horizontal: 30,
//                   //   vertical: 10,
//                   // ),
//                   decoration: BoxDecoration(
//                     color: Colors.black26,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Proceed to Pay",
//                       style: TextStyle(
//                         fontFamily: 'Regular',
//                         color: Colors.black,
//                         fontSize: size.safeWidth * 0.04,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// dining_bill_payment_page.dart
import 'package:flutter/material.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/user/userservice.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/dining/diningservice.dart';

class DiningBillPaymentPage extends StatefulWidget {
  final String diningId;
  final Map<String, dynamic> diningData;

  const DiningBillPaymentPage({
    Key? key,
    required this.diningId,
    required this.diningData,
  }) : super(key: key);

  @override
  State<DiningBillPaymentPage> createState() => _DiningBillPaymentPageState();
}

class _DiningBillPaymentPageState extends State<DiningBillPaymentPage> {
  final DiningBookingService _bookingService = DiningBookingService();
  final UserService _userService = UserService();
  
  final _formKey = GlobalKey<FormState>();
  final _billController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isLoading = false;
  String? selectedOffer;

  // Mock offers data
  final List<Map<String, dynamic>> offers = [
    {
      'name': 'Flat 10% Off',
      'description': 'Get 10% off on bills above ₹1000',
      'minAmount': 1000,
      'discount': 0.10,
    },
    {
      'name': 'Flat 15% Off',
      'description': 'Get 15% off on bills above ₹2000',
      'minAmount': 2000,
      'discount': 0.15,
    },
    {
      'name': 'Weekend Special',
      'description': 'Get 20% off on weekends',
      'minAmount': 500,
      'discount': 0.20,
      'isWeekendOnly': true,
    },
    {
      'name': 'Early Bird',
      'description': 'Get 25% off for breakfast bookings',
      'minAmount': 0,
      'discount': 0.25,
      'isBreakfastOnly': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _billController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.getUserData();
      if (userData != null && mounted) {
        setState(() {
          _nameController.text = userData.name ?? '';
          _emailController.text = userData.email ?? '';
          _phoneController.text = userData.phoneNumber;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  int _calculateFinalAmount() {
    final billAmount = int.tryParse(_billController.text) ?? 0;
    if (billAmount == 0 || selectedOffer == null) return billAmount;

    final offer = offers.firstWhere(
      (o) => o['name'] == selectedOffer,
      orElse: () => {},
    );

    if (offer.isEmpty) return billAmount;

    // Check if offer is applicable
    if (billAmount < (offer['minAmount'] ?? 0)) return billAmount;

    // Check weekend condition
    if (offer['isWeekendOnly'] == true) {
      final now = DateTime.now();
      if (now.weekday != DateTime.saturday && 
          now.weekday != DateTime.sunday) {
        return billAmount;
      }
    }

    // Check breakfast condition
    if (offer['isBreakfastOnly'] == true) {
      final now = DateTime.now();
      if (now.hour < 7 || now.hour >= 11) {
        return billAmount;
      }
    }

    final discount = billAmount * (offer['discount'] ?? 0);
    return (billAmount - discount).round();
  }

  int _getDiscountAmount() {
    final billAmount = int.tryParse(_billController.text) ?? 0;
    return billAmount - _calculateFinalAmount();
  }

  Future<void> _proceedToPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final billAmount = int.tryParse(_billController.text);
    if (billAmount == null || billAmount <= 0) {
      _showErrorSnackbar('Please enter a valid bill amount');
      return;
    }

    setState(() => isLoading = true);

    try {
      final finalAmount = _calculateFinalAmount();
      
      final userDetails = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      // Show payment confirmation dialog
      final confirmed = await _showPaymentDialog(
        billAmount: billAmount,
        finalAmount: finalAmount,
        discount: _getDiscountAmount(),
      );

      if (!confirmed) {
        setState(() => isLoading = false);
        return;
      }

      // Create bill payment booking
      final bookingId = await _bookingService.createBillPayment(
        diningId: widget.diningId,
        diningName: widget.diningData['name'] ?? 'Restaurant',
        billAmount: finalAmount,
        userDetails: userDetails,
      );

      if (bookingId != null && mounted) {
        Navigator.pop(context);
        _showSuccessDialog(bookingId, finalAmount);
      }
    } catch (e) {
      _showErrorSnackbar('Payment failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<bool> _showPaymentDialog({
    required int billAmount,
    required int finalAmount,
    required int discount,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Payment',
          style: TextStyle(fontFamily: 'Regular'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Summary:',
              style: TextStyle(
                fontFamily: 'Regular',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildDetailRow('Bill Amount', '₹$billAmount'),
            if (discount > 0)
              _buildDetailRow(
                'Discount',
                '-₹$discount',
                color: Colors.green,
              ),
            Divider(height: 24),
            _buildDetailRow(
              'Total Amount',
              '₹$finalAmount',
              isBold: true,
            ),
            if (selectedOffer != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer, 
                        size: 16, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Offer: $selectedOffer',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Regular',
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(fontFamily: 'Regular')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text(
              'Pay ₹$finalAmount',
              style: TextStyle(fontFamily: 'Regular', color: Colors.white),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSuccessDialog(String bookingId, int amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Payment Successful!', 
                style: TextStyle(fontFamily: 'Regular')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your payment has been processed successfully.',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            SizedBox(height: 16),
            Text(
              'Transaction ID: ${bookingId.substring(0, 12)}...',
              style: TextStyle(
                fontFamily: 'Regular',
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Amount Paid: ₹$amount',
              style: TextStyle(
                fontFamily: 'Regular',
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: blackColor,
            ),
            child: Text(
              'Done',
              style: TextStyle(fontFamily: 'Regular', color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? (isBold ? Colors.green.shade700 : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Sizes size = Sizes();

  @override
  Widget build(BuildContext context) {
    final billAmount = int.tryParse(_billController.text) ?? 0;
    final finalAmount = _calculateFinalAmount();
    final discount = _getDiscountAmount();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        centerTitle: true,
        title: Text(
          'Pay Bill',
          style: TextStyle(fontFamily: 'Regular'),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Restaurant Info
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.restaurant, color: gradient1),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.diningData['name'] ?? 'Restaurant',
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Quick bill payment',
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Bill Amount Input
                        Text(
                          'Enter Bill Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  '₹',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _billController,
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Regular',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => setState(() {}),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter bill amount';
                                    }
                                    final amount = int.tryParse(value);
                                    if (amount == null || amount <= 0) {
                                      return 'Please enter valid amount';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Available Offers
                        Text(
                          'Available Offers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 12),

                        ...offers.map((offer) {
                          final isSelected = selectedOffer == offer['name'];
                          final isApplicable = billAmount >= 
                              (offer['minAmount'] ?? 0);

                          return GestureDetector(
                            onTap: isApplicable
                                ? () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedOffer = null;
                                      } else {
                                        selectedOffer = offer['name'];
                                      }
                                    });
                                  }
                                : null,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? gradient1.withAlpha(50)
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? gradient1
                                      : isApplicable
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.local_offer,
                                    color: isSelected
                                        ? gradient1
                                        : isApplicable
                                            ? gradient2
                                            : Colors.grey,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          offer['name'],
                                          style: TextStyle(
                                            fontFamily: 'Regular',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isApplicable
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          offer['description'],
                                          style: TextStyle(
                                            fontFamily: 'Regular',
                                            fontSize: 12,
                                            color: isApplicable
                                                ? Colors.grey.shade700
                                                : Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

                        // Price Summary
                        if (billAmount > 0) ...[
                          SizedBox(height: 24),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                _buildDetailRow('Bill Amount', '₹$billAmount'),
                                if (discount > 0) ...[
                                  SizedBox(height: 8),
                                  _buildDetailRow(
                                    'Discount',
                                    '-₹$discount',
                                    color: Colors.green,
                                  ),
                                ],
                                Divider(height: 24),
                                _buildDetailRow(
                                  'Total Payable',
                                  '₹$finalAmount',
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 24),

                        // User Details
                        Text(
                          'Your Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: size.safeHeight * 0.15),
                      ],
                    ),
                  ),
                ),

                // Bottom Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: billAmount > 0 ? _proceedToPayment : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blackColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Colors.grey.shade300,
                          ),
                          child: Text(
                            billAmount > 0
                                ? 'Pay ₹$finalAmount'
                                : 'Enter Bill Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}