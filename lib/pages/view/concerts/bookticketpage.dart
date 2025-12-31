// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/size.dart';

// // ==================== USER BOOKING PAGE ====================

// class UserBookingPage extends StatefulWidget {
//   final String eventId;
//   final Map<String, dynamic> eventData;

//   const UserBookingPage({
//     Key? key,
//     required this.eventId,
//     required this.eventData,
//   }) : super(key: key);

//   @override
//   State<UserBookingPage> createState() => _UserBookingPageState();
// }

// class _UserBookingPageState extends State<UserBookingPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();

//   String? selectedTicketId;
//   int selectedQuantity = 1;
//   bool isBooking = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserData() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       _emailController.text = user.email ?? '';
//       _nameController.text = user.displayName ?? '';
//     }
//   }

//   Future<void> _bookTicket(Map<String, dynamic> ticket) async {
//     if (!_formKey.currentState!.validate()) return;

//     final user = _auth.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Please login to book tickets',
//             style: TextStyle(fontFamily: 'Regular'),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() => isBooking = true);

//     try {
//       final result = await _firestore.runTransaction<Map<String, dynamic>>((
//         transaction,
//       ) async {
//         // Read event document
//         final eventRef = _firestore.collection('events').doc(widget.eventId);
//         final eventDoc = await transaction.get(eventRef);

//         if (!eventDoc.exists) {
//           throw Exception('Event not found');
//         }

//         final eventData = eventDoc.data()!;
//         final List<dynamic> tickets = eventData['tickets'] ?? [];

//         // Find the ticket type
//         int ticketIndex = -1;
//         Map<String, dynamic>? ticketData;

//         for (int i = 0; i < tickets.length; i++) {
//           if (tickets[i]['id'] == ticket['id']) {
//             ticketIndex = i;
//             ticketData = tickets[i];
//             break;
//           }
//         }

//         if (ticketData == null) {
//           throw Exception('Ticket type not found');
//         }

//         // Check booking cutoff
//         final Timestamp? cutoff = ticketData['bookingCutoff'];
//         if (cutoff != null && Timestamp.now().compareTo(cutoff) > 0) {
//           throw Exception('Booking period has ended');
//         }

//         // Get available tickets
//         final int totalQuantity = ticketData['quantity'] ?? 0;
//         final int currentAvailable = ticketData['available'] ?? totalQuantity;

//         // Check availability
//         if (currentAvailable < selectedQuantity) {
//           throw Exception(
//             'Only $currentAvailable tickets available. Requested: $selectedQuantity',
//           );
//         }

//         // Calculate new availability
//         final int newAvailable = currentAvailable - selectedQuantity;

//         // Update ticket availability
//         tickets[ticketIndex]['available'] = newAvailable;
//         transaction.update(eventRef, {'tickets': tickets});

//         // Create booking document
//         final bookingId = _firestore.collection('bookings').doc().id;
//         final totalAmount = (ticketData['price'] ?? 0) * selectedQuantity;

//         final bookingData = {
//           'bookingId': bookingId,
//           'eventId': widget.eventId,
//           'eventName': widget.eventData['name'] ?? '',
//           'userId': user.uid,
//           'ticketId': ticket['id'],
//           'ticketType': ticketData['type'] ?? '',
//           'quantity': selectedQuantity,
//           'totalAmount': totalAmount,
//           'status': 'pending',
//           'createdAt': FieldValue.serverTimestamp(),
//           'userDetails': {
//             'name': _nameController.text.trim(),
//             'email': _emailController.text.trim(),
//             'phone': _phoneController.text.trim(),
//           },
//         };

//         final bookingRef = _firestore.collection('bookings').doc(bookingId);
//         transaction.set(bookingRef, bookingData);

//         return {
//           'success': true,
//           'message': 'Booking successful',
//           'bookingId': bookingId,
//           'totalAmount': totalAmount,
//           'availableTickets': newAvailable,
//         };
//       }, timeout: const Duration(seconds: 10));

//       setState(() => isBooking = false);

//       if (result['success']) {
//         _showSuccessDialog(result);
//       }
//     } catch (e) {
//       setState(() => isBooking = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString().replaceAll('Exception: ', '')),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _showSuccessDialog(Map<String, dynamic> result) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: FittedBox(
//               fit: BoxFit.fitWidth,
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.check_circle,
//                     color: Colors.green.shade600,
//                     // size: 32,
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Booking Successful!',
//                     style: TextStyle(fontFamily: 'Regular'),
//                   ),
//                 ],
//               ),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Booking ID: ${result['bookingId']}',
//                   style: TextStyle(fontFamily: 'Regular'),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Total Amount: ₹${result['totalAmount']}',
//                   style: TextStyle(fontFamily: 'Regular'),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Your booking is pending. Please proceed to payment.',
//                   style: TextStyle(color: Colors.grey, fontFamily: 'Regular'),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 style: ButtonStyle(
//                   backgroundColor: WidgetStateProperty.all(whiteColor),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//                 child: const Text(
//                   'Done',
//                   style: TextStyle(fontFamily: 'Regular', color: blackColor),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: blackColor),
//                 onPressed: () {
//                   // TODO: Navigate to payment page
//                   Navigator.pop(context);
//                 },
//                 child: const Text(
//                   'Proceed to Pay',
//                   style: TextStyle(fontFamily: 'Regular', color: whiteColor),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         surfaceTintColor: whiteColor,
//         backgroundColor: whiteColor,
//         centerTitle: true,
//         title: Text(
//           widget.eventData['name'] ?? 'Book Tickets',
//           style: TextStyle(fontFamily: 'Regular'),
//         ),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _firestore.collection('events').doc(widget.eventId).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('Event not found'));
//           }

//           final eventData = snapshot.data!.data() as Map<String, dynamic>;
//           final tickets = List<Map<String, dynamic>>.from(
//             eventData['tickets'] ?? [],
//           );

//           if (tickets.isEmpty) {
//             return const Center(child: Text('No tickets available'));
//           }

//           return Column(
//             children: [
//               // Event Header
//               // Container(
//               //   width: double.infinity,
//               //   padding: const EdgeInsets.all(16),
//               //   decoration: BoxDecoration(
//               //     gradient: LinearGradient(
//               //       colors: [Colors.purple.shade400, Colors.blue.shade400],
//               //       begin: Alignment.topLeft,
//               //       end: Alignment.bottomRight,
//               //     ),
//               //   ),
//               //   child: Column(
//               //     crossAxisAlignment: CrossAxisAlignment.start,
//               //     children: [
//               //       Text(
//               //         eventData['name'] ?? '',
//               //         style: const TextStyle(
//               //           color: Colors.white,
//               //           fontSize: 24,
//               //           fontWeight: FontWeight.bold,
//               //         ),
//               //       ),
//               //       const SizedBox(height: 8),
//               //       if (eventData['venue']?['name'] != null)
//               //         Row(
//               //           children: [
//               //             const Icon(Icons.location_on,
//               //                 color: Colors.white, size: 16),
//               //             const SizedBox(width: 4),
//               //             Expanded(
//               //               child: Text(
//               //                 eventData['venue']['name'],
//               //                 style: const TextStyle(
//               //                   color: Colors.white,
//               //                   fontSize: 14,
//               //                 ),
//               //               ),
//               //             ),
//               //           ],
//               //         ),
//               //     ],
//               //   ),
//               // ),

//               // Tickets List
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: tickets.length,
//                   itemBuilder: (context, index) {
//                     final ticket = tickets[index];
//                     return _buildTicketCard(ticket);
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTicketCard(Map<String, dynamic> ticket) {
//     final quantity = ticket['quantity'] ?? 0;
//     final available = ticket['available'] ?? quantity;
//     final price = ticket['price'] ?? 0;
//     final isAvailable = available > 0;

//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: gradient2, // border color
//           width: 1.5, // border width
//         ),
//       ),
//       surfaceTintColor: whiteColor,
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 4,

//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         ticket['type'] ?? 'Unknown',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontFamily: 'Regular',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '₹$price',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontFamily: 'Regular',
//                           color: Colors.green.shade700,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color:
//                         isAvailable
//                             ? Colors.green.shade100
//                             : Colors.red.shade100,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     isAvailable ? '$available Available' : 'SOLD OUT',
//                     style: TextStyle(
//                       color:
//                           isAvailable
//                               ? Colors.green.shade900
//                               : Colors.red.shade900,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Regular',
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             if (ticket['seatingType'] != null) ...[
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.event_seat, size: 16, color: Colors.grey.shade600),
//                   const SizedBox(width: 4),
//                   Text(
//                     ticket['seatingType'],
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontFamily: 'Regular',
//                     ),
//                   ),
//                 ],
//               ),
//             ],

//             // Inclusions
//             if (ticket['inclusions'] != null &&
//                 (ticket['inclusions'] as List).isNotEmpty) ...[
//               const SizedBox(height: 12),
//               const Text(
//                 'Includes:',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontFamily: 'Regular',
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 4,
//                 children:
//                     (ticket['inclusions'] as List)
//                         .map(
//                           (inclusion) => Chip(
//                             label: Text(
//                               inclusion,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontFamily: 'Regular',
//                               ),
//                             ),
//                             backgroundColor: Colors.grey.shade200,
//                             materialTapTargetSize:
//                                 MaterialTapTargetSize.shrinkWrap,
//                           ),
//                         )
//                         .toList(),
//               ),
//             ],

//             const SizedBox(height: 16),

//             // Book Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed:
//                     isAvailable && !isBooking
//                         ? () => _showBookingDialog(ticket)
//                         : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: blackColor,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   isAvailable ? 'Book Now' : 'Sold Out',
//                   style: TextStyle(
//                     fontSize: Sizes().width * 0.045,
//                     color: whiteColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showBookingDialog(Map<String, dynamic> ticket) {
//     final available = ticket['available'] ?? ticket['quantity'] ?? 0;
//     selectedQuantity = 1;
//     selectedTicketId = ticket['id'];

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder:
//           (context) => Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Text(
//                       'Book ${ticket['type']}',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontFamily: 'Regular',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Quantity Selector
//                     const Text(
//                       'Select Quantity',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 8),
//                     StatefulBuilder(
//                       builder: (context, setDialogState) {
//                         return Row(
//                           children: [
//                             IconButton(
//                               onPressed:
//                                   selectedQuantity > 1
//                                       ? () => setDialogState(
//                                         () => selectedQuantity--,
//                                       )
//                                       : null,
//                               icon: const Icon(Icons.remove_circle),
//                               iconSize: 32,
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 24,
//                                 vertical: 8,
//                               ),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey.shade300),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 '$selectedQuantity',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontFamily: 'Regular',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed:
//                                   selectedQuantity < available.clamp(1, 10)
//                                       ? () => setDialogState(
//                                         () => selectedQuantity++,
//                                       )
//                                       : null,
//                               icon: const Icon(Icons.add_circle),
//                               iconSize: 32,
//                             ),
//                             const Spacer(),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 const Text('Total'),
//                                 Text(
//                                   '₹${(ticket['price'] ?? 0) * selectedQuantity}',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontFamily: 'Regular',
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green.shade700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       },
//                     ),

//                     const SizedBox(height: 24),
//                     const Divider(),
//                     const SizedBox(height: 16),

//                     // User Details Form
//                     const Text(
//                       'Your Details',
//                       style: TextStyle(
//                         fontFamily: 'Regular',
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Full Name',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.person),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter your name';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(
//                         labelText: 'Email',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.email),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         if (!value.contains('@')) {
//                           return 'Please enter a valid email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     TextFormField(
//                       controller: _phoneController,
//                       decoration: const InputDecoration(
//                         labelText: 'Phone Number',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.phone),
//                       ),
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter your phone number';
//                         }
//                         if (value.length < 10) {
//                           return 'Please enter a valid phone number';
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 24),

//                     // Confirm Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed:
//                             isBooking
//                                 ? null
//                                 : () {
//                                   Navigator.pop(context);
//                                   _bookTicket(ticket);
//                                 },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: blackColor,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child:
//                             isBooking
//                                 ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                                 : Text(
//                                   'Confirm Booking',
//                                   style: TextStyle(
//                                     color: whiteColor,
//                                     fontFamily: 'Regular',
//                                     fontSize: Sizes().width * 0.04,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/concerts/checkoutpage.dart';

class UserBookingPage extends StatefulWidget {
  final String eventId;
  final Map<String, dynamic> eventData;

  const UserBookingPage({
    Key? key,
    required this.eventId,
    required this.eventData,
  }) : super(key: key);

  @override
  State<UserBookingPage> createState() => _UserBookingPageState();
}

class _UserBookingPageState extends State<UserBookingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Map to store selected quantities for each ticket type
  Map<String, int> selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    _initializeQuantities();
  }

  void _initializeQuantities() {
    final tickets = List<Map<String, dynamic>>.from(
      widget.eventData['tickets'] ?? [],
    );
    for (var ticket in tickets) {
      selectedQuantities[ticket['id']] = 0;
    }
  }

  int getTotalTickets() {
    return selectedQuantities.values.fold(0, (sum, qty) => sum + qty);
  }

  int getTotalAmount(List<Map<String, dynamic>> tickets) {
    int total = 0;
    for (var ticket in tickets) {
      final qty = selectedQuantities[ticket['id']] ?? 0;
      final price = ticket['price'] ?? 0;
      total += ((price as num).toInt() * (qty as num).toInt());
    }
    return total;
  }

  void _proceedToCheckout(List<Map<String, dynamic>> tickets) {
    final totalTickets = getTotalTickets();
    if (totalTickets == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one ticket'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Build selected tickets data
    List<Map<String, dynamic>> selectedTickets = [];
    for (var ticket in tickets) {
      final qty = selectedQuantities[ticket['id']] ?? 0;
      if (qty > 0) {
        selectedTickets.add({
          'ticketId': ticket['id'],
          'ticketType': ticket['type'],
          'price': ticket['price'],
          'quantity': qty,
          'subtotal': (ticket['price'] ?? 0) * qty,
        });
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EventCheckoutPage(
              eventId: widget.eventId,
              eventData: widget.eventData,
              selectedTickets: selectedTickets,
              totalAmount: getTotalAmount(tickets),
            ),
      ),
    ).then((_) {
      // Reset selections after returning
      setState(() {
        _initializeQuantities();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: whiteColor,
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text(
          widget.eventData['name'] ?? 'Book Tickets',
          style: TextStyle(fontFamily: 'Regular'),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('events').doc(widget.eventId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Event not found'));
          }

          final eventData = snapshot.data!.data() as Map<String, dynamic>;
          final tickets = List<Map<String, dynamic>>.from(
            eventData['tickets'] ?? [],
          );

          if (tickets.isEmpty) {
            return const Center(child: Text('No tickets available'));
          }

          return Column(
            children: [
              Text(
                'Choose Tickets',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return _buildTicketCard(ticket);
                  },
                ),
              ),

              // Checkout Button
              if (getTotalTickets() > 0)
                Container(
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: ${getTotalTickets()} ticket(s)',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${getTotalAmount(tickets)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _proceedToCheckout(tickets),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blackColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Proceed to Checkout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular',
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final quantity = ticket['quantity'] ?? 0;
    final available = ticket['available'] ?? quantity;
    final price = ticket['price'] ?? 0;
    final isAvailable = available > 0;
    final selectedQty = selectedQuantities[ticket['id']] ?? 0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: gradient2, width: 1.5),
      ),
      surfaceTintColor: whiteColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['type'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹$price',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Regular',
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isAvailable
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isAvailable ? '$available Available' : 'SOLD OUT',
                    style: TextStyle(
                      color:
                          isAvailable
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            if (ticket['seatingType'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.event_seat, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    ticket['seatingType'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'Regular',
                    ),
                  ),
                ],
              ),
            ],

            if (ticket['inclusions'] != null &&
                (ticket['inclusions'] as List).isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Includes:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Regular',
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    (ticket['inclusions'] as List)
                        .map(
                          (inclusion) => Chip(
                            label: Text(
                              inclusion,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                              ),
                            ),
                            backgroundColor: Colors.grey.shade200,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
              ),
            ],

            const SizedBox(height: 16),

            // Quantity Selector
            if (isAvailable)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed:
                        selectedQty > 0
                            ? () {
                              setState(() {
                                selectedQuantities[ticket['id']] =
                                    selectedQty - 1;
                              });
                            }
                            : null,
                    icon: const Icon(Icons.remove_circle),
                    iconSize: 32,
                    color: selectedQty > 0 ? blackColor : Colors.grey,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$selectedQty',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:
                        selectedQty < available.clamp(1, 10)
                            ? () {
                              setState(() {
                                selectedQuantities[ticket['id']] =
                                    selectedQty + 1;
                              });
                            }
                            : null,
                    icon: const Icon(Icons.add_circle),
                    iconSize: 32,
                    color:
                        selectedQty < available.clamp(1, 10)
                            ? blackColor
                            : Colors.grey,
                  ),
                  if (selectedQty > 0) ...[
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Subtotal', style: TextStyle(fontSize: 12)),
                        Text(
                          '₹${price * selectedQty}',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              )
            else
              Center(
                child: Text(
                  'SOLD OUT',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Regular',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
