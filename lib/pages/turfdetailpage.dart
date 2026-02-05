// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:get/get.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:ticpin_play/pages/turfanalyticspage.dart';

// // // class TurfDetailpage extends StatefulWidget {
// // //   final String turfId;
// // //   final Map<String, dynamic> turfData;

// // //   const TurfDetailpage({
// // //     super.key,
// // //     required this.turfId,
// // //     required this.turfData,
// // //   });

// // //   @override
// // //   State<TurfDetailpage> createState() => _TurfDetailpageState();
// // // }

// // // class _TurfDetailpageState extends State<TurfDetailpage>
// // //     with TickerProviderStateMixin {
// // //   late TabController _tabController;
// // //   int _selectedDayIndex = 0;
// // //   String selectedFieldSize = '4x4';
// // //   List<String> availableFieldSizes = ['4x4'];

// // //   Set<String> bookedSlots = {};
// // //   Set<String> blockedSlots = {};
// // //   bool loadingSlots = false;

// // //   late final List<List<String>> tabs;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     tabs = _generateNextDays(15);
// // //     _tabController = TabController(length: tabs.length, vsync: this)
// // //       ..addListener(() {
// // //         if (mounted) {
// // //           setState(() {
// // //             _selectedDayIndex = _tabController.index;
// // //           });
// // //           _fetchSlots();
// // //         }
// // //       });

// // //     // Load available field sizes
// // //     final sizes = widget.turfData['available_field_sizes'];
// // //     if (sizes != null && sizes is List && sizes.isNotEmpty) {
// // //       availableFieldSizes = List<String>.from(sizes);
// // //       selectedFieldSize = availableFieldSizes.first;
// // //     }

// // //     _fetchSlots();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _tabController.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> _fetchSlots() async {
// // //     if (!mounted) return;

// // //     setState(() {
// // //       loadingSlots = true;
// // //     });

// // //     try {
// // //       final selectedDate = _getSelectedDate();
// // //       final docId = '${widget.turfId}_${selectedDate}_$selectedFieldSize';

// // //       final slotsDoc = await FirebaseFirestore.instance
// // //           .collection('turf_slots')
// // //           .doc(docId)
// // //           .get();

// // //       if (slotsDoc.exists) {
// // //         final data = slotsDoc.data()!;
// // //         final slots = data['slots'] as Map<String, dynamic>? ?? {};
// // //         final blocked = data['blocked_slots'] as Map<String, dynamic>? ?? {};

// // //         if (mounted) {
// // //           setState(() {
// // //             bookedSlots = slots.entries
// // //                 .where((e) => e.value == true)
// // //                 .map((e) => e.key)
// // //                 .toSet();
// // //             blockedSlots = blocked.entries
// // //                 .where((e) => e.value == true)
// // //                 .map((e) => e.key)
// // //                 .toSet();
// // //           });
// // //         }
// // //       } else {
// // //         if (mounted) {
// // //           setState(() {
// // //             bookedSlots = {};
// // //             blockedSlots = {};
// // //           });
// // //         }
// // //       }
// // //     } catch (e) {
// // //       print('Error fetching slots: $e');
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() {
// // //           loadingSlots = false;
// // //         });
// // //       }
// // //     }
// // //   }

// // //   String _getSelectedDate() {
// // //     final today = DateTime.now();
// // //     final selectedDay = today.add(Duration(days: _selectedDayIndex));
// // //     return DateFormat('yyyy-MM-dd').format(selectedDay);
// // //   }

// // //   List<List<String>> _generateNextDays(int count) {
// // //     final List<List<String>> days = [];
// // //     final today = DateTime.now();
// // //     for (int i = 0; i < count; i++) {
// // //       final date = today.add(Duration(days: i));
// // //       final dayString = DateFormat('d MMM').format(date);
// // //       final weekDayString = DateFormat('EEE').format(date);
// // //       days.add([dayString, weekDayString]);
// // //     }
// // //     return days;
// // //   }

// // //   Future<void> _toggleBlockSlot(String timeSlot) async {
// // //     try {
// // //       final selectedDate = _getSelectedDate();
// // //       final docId = '${widget.turfId}_${selectedDate}_$selectedFieldSize';

// // //       final isBlocked = blockedSlots.contains(timeSlot);

// // //       await FirebaseFirestore.instance
// // //           .collection('turf_slots')
// // //           .doc(docId)
// // //           .set({
// // //         'turfId': widget.turfId,
// // //         'date': selectedDate,
// // //         'fieldSize': selectedFieldSize,
// // //         'blocked_slots': {
// // //           timeSlot: !isBlocked,
// // //         },
// // //       }, SetOptions(merge: true));

// // //       setState(() {
// // //         if (isBlocked) {
// // //           blockedSlots.remove(timeSlot);
// // //         } else {
// // //           blockedSlots.add(timeSlot);
// // //         }
// // //       });

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text(
// // //             isBlocked ? 'Slot unblocked successfully' : 'Slot blocked successfully',
// // //           ),
// // //           backgroundColor: Colors.green,
// // //         ),
// // //       );
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('Failed to update slot: $e'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   Future<void> _cancelBooking(String timeSlot) async {
// // //     // Show confirmation dialog
// // //     final confirm = await showDialog<bool>(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: Text('Cancel Booking'),
// // //         content: Text(
// // //           'Are you sure you want to cancel this booking? This will initiate a refund.',
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context, false),
// // //             child: Text('No'),
// // //           ),
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context, true),
// // //             style: TextButton.styleFrom(foregroundColor: Colors.red),
// // //             child: Text('Yes, Cancel'),
// // //           ),
// // //         ],
// // //       ),
// // //     );

// // //     if (confirm != true) return;

// // //     try {
// // //       // Find the booking for this slot
// // //       final selectedDate = _getSelectedDate();
// // //       final bookingsQuery = await FirebaseFirestore.instance
// // //           .collection('turf_bookings')
// // //           .where('turfId', isEqualTo: widget.turfId)
// // //           .where('date', isEqualTo: selectedDate)
// // //           .where('fieldSize', isEqualTo: selectedFieldSize)
// // //           .where('status', isEqualTo: 'confirmed')
// // //           .get();

// // //       // Find booking containing this time slot
// // //       DocumentSnapshot? bookingDoc;
// // //       for (var doc in bookingsQuery.docs) {
// // //         final data = doc.data();
// // //         final slots = List<Map<String, dynamic>>.from(data['slots'] ?? []);
// // //         if (slots.any((s) => s['start'] == timeSlot)) {
// // //           bookingDoc = doc;
// // //           break;
// // //         }
// // //       }

// // //       if (bookingDoc == null) {
// // //         throw Exception('Booking not found');
// // //       }

// // //       final bookingData = bookingDoc.data() as Map<String, dynamic>;

// // //       // Update booking status
// // //       await FirebaseFirestore.instance
// // //           .collection('turf_bookings')
// // //           .doc(bookingDoc.id)
// // //           .update({
// // //         'status': 'cancelled_by_admin',
// // //         'cancelledAt': FieldValue.serverTimestamp(),
// // //         'refundStatus': 'pending',
// // //         'refundInitiatedAt': FieldValue.serverTimestamp(),
// // //       });

// // //       // Release the slots
// // //       // final selectedDate = _getSelectedDate();
// // //       final docId = '${widget.turfId}_${selectedDate}_$selectedFieldSize';

// // //       final slots = List<Map<String, dynamic>>.from(bookingData['slots'] ?? []);
// // //       Map<String, dynamic> slotsToRelease = {};
// // //       for (var slot in slots) {
// // //         slotsToRelease['slots.${slot['start']}'] = FieldValue.delete();
// // //       }

// // //       await FirebaseFirestore.instance
// // //           .collection('turf_slots')
// // //           .doc(docId)
// // //           .update(slotsToRelease);

// // //       // Create refund record
// // //       await FirebaseFirestore.instance
// // //           .collection('refunds')
// // //           .add({
// // //         'bookingId': bookingDoc.id,
// // //         'userId': bookingData['userId'],
// // //         'turfId': widget.turfId,
// // //         'amount': bookingData['totalAmount'],
// // //         'status': 'pending',
// // //         'reason': 'Cancelled by admin',
// // //         'createdAt': FieldValue.serverTimestamp(),
// // //         'processedAt': null,
// // //       });

// // //       _fetchSlots();

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('Booking cancelled. Refund initiated.'),
// // //           backgroundColor: Colors.green,
// // //         ),
// // //       );
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('Failed to cancel booking: $e'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     // final size = MediaQuery.of(context).size;

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           widget.turfData['name'] ?? 'Turf Details',
// // //           style: TextStyle(fontFamily: 'Regular'),
// // //         ),
// // //         backgroundColor: Color(0xFF1E1E82),
// // //         foregroundColor: Colors.white,
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(Icons.analytics),
// // //             onPressed: () {
// // //               Get.to(
// // //                 () => TurfAnalyticspage(
// // //                   turfId: widget.turfId,
// // //                   turfData: widget.turfData,
// // //                 ),
// // //               );
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // Turf Info Card
// // //           Container(
// // //             width: double.infinity,
// // //             padding: EdgeInsets.all(16),
// // //             color: Colors.grey.shade100,
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   widget.turfData['name'] ?? 'Untitled',
// // //                   style: TextStyle(
// // //                     fontSize: 20,
// // //                     fontWeight: FontWeight.bold,
// // //                     fontFamily: 'Regular',
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 4),
// // //                 Text(
// // //                   widget.turfData['city'] ?? 'No city',
// // //                   style: TextStyle(fontFamily: 'Regular'),
// // //                 ),
// // //                 SizedBox(height: 8),
// // //                 Row(
// // //                   children: [
// // //                     Icon(Icons.star, size: 16, color: Colors.amber),
// // //                     SizedBox(width: 4),
// // //                     Text(
// // //                       '${widget.turfData['rating'] ?? 0.0}',
// // //                       style: TextStyle(fontFamily: 'Regular'),
// // //                     ),
// // //                     SizedBox(width: 16),
// // //                     Icon(Icons.currency_rupee, size: 16),
// // //                     Text(
// // //                       '${widget.turfData['half_hour_price'] ?? 0}/30min',
// // //                       style: TextStyle(fontFamily: 'Regular'),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),

// // //           // Field Size Selection
// // //           if (availableFieldSizes.length > 1)
// // //             Padding(
// // //               padding: EdgeInsets.all(16),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     'Field Size',
// // //                     style: TextStyle(
// // //                       fontWeight: FontWeight.bold,
// // //                       fontFamily: 'Regular',
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: 8),
// // //                   Row(
// // //                     children: availableFieldSizes.map((size) {
// // //                       final isSelected = selectedFieldSize == size;
// // //                       return Padding(
// // //                         padding: EdgeInsets.only(right: 8),
// // //                         child: ChoiceChip(
// // //                           label: Text(
// // //                             size,
// // //                             style: TextStyle(fontFamily: 'Regular'),
// // //                           ),
// // //                           selected: isSelected,
// // //                           onSelected: (selected) {
// // //                             if (selected) {
// // //                               setState(() {
// // //                                 selectedFieldSize = size;
// // //                               });
// // //                               _fetchSlots();
// // //                             }
// // //                           },
// // //                           selectedColor: Color(0xFF1E1E82),
// // //                           labelStyle: TextStyle(
// // //                             color: isSelected ? Colors.white : Colors.black,
// // //                           ),
// // //                         ),
// // //                       );
// // //                     }).toList(),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),

// // //           // Date Selection
// // //           Padding(
// // //             padding: EdgeInsets.symmetric(horizontal: 16),
// // //             child: Text(
// // //               'Select Date',
// // //               style: TextStyle(
// // //                 fontWeight: FontWeight.bold,
// // //                 fontFamily: 'Regular',
// // //               ),
// // //             ),
// // //           ),
// // //           SizedBox(height: 8),
// // //           SingleChildScrollView(
// // //             scrollDirection: Axis.horizontal,
// // //             child: Row(
// // //               children: List.generate(tabs.length, (index) {
// // //                 final isSelected = _selectedDayIndex == index;
// // //                 return GestureDetector(
// // //                   onTap: () {
// // //                     _tabController.animateTo(index);
// // //                   },
// // //                   child: Container(
// // //                     margin: EdgeInsets.symmetric(horizontal: 4),
// // //                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //                     decoration: BoxDecoration(
// // //                       color:
// // //                           isSelected
// // //                               ? Color(0xFF1E1E82)
// // //                               : Colors.grey.shade200,
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     child: Column(
// // //                       children: [
// // //                         Text(
// // //                           tabs[index][0],
// // //                           style: TextStyle(
// // //                             fontFamily: 'Regular',
// // //                             color: isSelected ? Colors.white : Colors.black,
// // //                           ),
// // //                         ),
// // //                         Text(
// // //                           tabs[index][1],
// // //                           style: TextStyle(
// // //                             fontSize: 12,
// // //                             fontFamily: 'Regular',
// // //                             color: isSelected ? Colors.white70 : Colors.black54,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 );
// // //               }),
// // //             ),
// // //           ),

// // //           SizedBox(height: 16),

// // //           // Slot Management
// // //           Padding(
// // //             padding: EdgeInsets.symmetric(horizontal: 16),
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 Text(
// // //                   'Manage Time Slots',
// // //                   style: TextStyle(
// // //                     fontWeight: FontWeight.bold,
// // //                     fontFamily: 'Regular',
// // //                   ),
// // //                 ),
// // //                 Row(
// // //                   children: [
// // //                     _buildLegendItem(Colors.grey.shade300, 'Booked'),
// // //                     SizedBox(width: 8),
// // //                     _buildLegendItem(Colors.red.shade200, 'Blocked'),
// // //                     SizedBox(width: 8),
// // //                     _buildLegendItem(Colors.white, 'Free'),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),

// // //           SizedBox(height: 16),

// // //           if (loadingSlots)
// // //             Padding(
// // //               padding: EdgeInsets.all(20),
// // //               child: CircularProgressIndicator(),
// // //             )
// // //           else
// // //             Expanded(
// // //               child: SlotManagementGrid(
// // //                 bookedSlots: bookedSlots,
// // //                 blockedSlots: blockedSlots,
// // //                 onSlotTap: (timeSlot) {
// // //                   _showSlotOptions(timeSlot);
// // //                 },
// // //               ),
// // //             ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildLegendItem(Color color, String label) {
// // //     return Row(
// // //       children: [
// // //         Container(
// // //           width: 16,
// // //           height: 16,
// // //           decoration: BoxDecoration(
// // //             color: color,
// // //             border: Border.all(color: Colors.black26),
// // //             borderRadius: BorderRadius.circular(4),
// // //           ),
// // //         ),
// // //         SizedBox(width: 4),
// // //         Text(
// // //           label,
// // //           style: TextStyle(fontSize: 12, fontFamily: 'Regular'),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   void _showSlotOptions(String timeSlot) {
// // //     final isBooked = bookedSlots.contains(timeSlot);
// // //     final isBlocked = blockedSlots.contains(timeSlot);

// // //     showModalBottomSheet(
// // //       context: context,
// // //       builder: (context) => Container(
// // //         padding: EdgeInsets.all(20),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               'Manage Slot: $timeSlot',
// // //               style: TextStyle(
// // //                 fontSize: 18,
// // //                 fontWeight: FontWeight.bold,
// // //                 fontFamily: 'Regular',
// // //               ),
// // //             ),
// // //             SizedBox(height: 20),
// // //             if (isBooked) ...[
// // //               ListTile(
// // //                 leading: Icon(Icons.cancel, color: Colors.red),
// // //                 title: Text(
// // //                   'Cancel Booking & Initiate Refund',
// // //                   style: TextStyle(fontFamily: 'Regular'),
// // //                 ),
// // //                 onTap: () {
// // //                   Navigator.pop(context);
// // //                   _cancelBooking(timeSlot);
// // //                 },
// // //               ),
// // //             ] else ...[
// // //               ListTile(
// // //                 leading: Icon(
// // //                   isBlocked ? Icons.lock_open : Icons.block,
// // //                   color: isBlocked ? Colors.green : Colors.orange,
// // //                 ),
// // //                 title: Text(
// // //                   isBlocked ? 'Unblock Slot' : 'Block Slot',
// // //                   style: TextStyle(fontFamily: 'Regular'),
// // //                 ),
// // //                 onTap: () {
// // //                   Navigator.pop(context);
// // //                   _toggleBlockSlot(timeSlot);
// // //                 },
// // //               ),
// // //             ],
// // //             ListTile(
// // //               leading: Icon(Icons.close),
// // //               title: Text(
// // //                 'Cancel',
// // //                 style: TextStyle(fontFamily: 'Regular'),
// // //               ),
// // //               onTap: () => Navigator.pop(context),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // Slot Management Grid Widget
// // // class SlotManagementGrid extends StatelessWidget {
// // //   final Set<String> bookedSlots;
// // //   final Set<String> blockedSlots;
// // //   final Function(String) onSlotTap;

// // //   const SlotManagementGrid({
// // //     super.key,
// // //     required this.bookedSlots,
// // //     required this.blockedSlots,
// // //     required this.onSlotTap,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final allTimeSlots = _generateAllTimeSlots();

// // //     return ListView.builder(
// // //       padding: EdgeInsets.all(16),
// // //       itemCount: allTimeSlots.length,
// // //       itemBuilder: (context, index) {
// // //         final timeSlot = allTimeSlots[index];
// // //         final isBooked = bookedSlots.contains(timeSlot);
// // //         final isBlocked = blockedSlots.contains(timeSlot);

// // //         return Card(
// // //           margin: EdgeInsets.only(bottom: 8),
// // //           child: ListTile(
// // //             title: Text(
// // //               timeSlot,
// // //               style: TextStyle(fontFamily: 'Regular'),
// // //             ),
// // //             trailing: _buildStatusChip(isBooked, isBlocked),
// // //             onTap: () => onSlotTap(timeSlot),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   Widget _buildStatusChip(bool isBooked, bool isBlocked) {
// // //     if (isBooked) {
// // //       return Chip(
// // //         label: Text(
// // //           'Booked',
// // //           style: TextStyle(color: Colors.white, fontSize: 12),
// // //         ),
// // //         backgroundColor: Colors.grey.shade600,
// // //         padding: EdgeInsets.zero,
// // //       );
// // //     } else if (isBlocked) {
// // //       return Chip(
// // //         label: Text(
// // //           'Blocked',
// // //           style: TextStyle(color: Colors.white, fontSize: 12),
// // //         ),
// // //         backgroundColor: Colors.red,
// // //         padding: EdgeInsets.zero,
// // //       );
// // //     } else {
// // //       return Chip(
// // //         label: Text(
// // //           'Available',
// // //           style: TextStyle(color: Colors.white, fontSize: 12),
// // //         ),
// // //         backgroundColor: Colors.green,
// // //         padding: EdgeInsets.zero,
// // //       );
// // //     }
// // //   }

// // //   List<String> _generateAllTimeSlots() {
// // //     return [
// // //       "12:00 AM", "12:30 AM", "1:00 AM", "1:30 AM", "2:00 AM", "2:30 AM",
// // //       "3:00 AM", "3:30 AM", "4:00 AM", "4:30 AM", "5:00 AM", "5:30 AM",
// // //       "6:00 AM", "6:30 AM", "7:00 AM", "7:30 AM", "8:00 AM", "8:30 AM",
// // //       "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM",
// // //       "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM",
// // //       "3:00 PM", "3:30 PM", "4:00 PM", "4:30 PM", "5:00 PM", "5:30 PM",
// // //       "6:00 PM", "6:30 PM", "7:00 PM", "7:30 PM", "8:00 PM", "8:30 PM",
// // //       "9:00 PM", "9:30 PM", "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM",
// // //     ];
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:flutter/src/widgets/framework.dart';

// // // ─────────────────────────────────────────────────────────────
// // // ASSUMES these are defined elsewhere in your project:
// // //   - TurfFormProvider (your ChangeNotifier from the provider file)
// // //   - AddTurfPage
// // //   - FirebaseFirestore / FirebaseAuth (firebase_core, firebase_auth, cloud_firestore)
// // // ─────────────────────────────────────────────────────────────

// // class TurfDetailpage extends StatefulWidget {
// //   final String turfId;
// //   final Map<String, dynamic> turfData;

// //   const TurfDetailpage({
// //     super.key,
// //     required this.turfId,
// //     required this.turfData,
// //   });

// //   @override
// //   State<TurfDetailpage> createState() => _TurfDetailpageState();
// // }

// // class _TurfDetailpageState extends State<TurfDetailpage> {
// //   // ───── Parsed grounds from Firestore ─────
// //   // Each entry: { 'name': 'Turf 1', 'fieldSize': '5-a-side' }
// //   List<Map<String, String>> _grounds = [];

// //   // ───── Selection state ─────
// //   int _selectedGroundIndex = 0;

// //   // ───── All unique a-side options across every ground (for reference) ─────
// //   // Per-ground sizes are derived on the fly from _grounds[_selectedGroundIndex]
// //   // But since each ground already HAS a single fieldSize (e.g. "5-a-side"),
// //   // the "team size" selector shows all grounds that share the same venue
// //   // grouped by their fieldSize.
// //   //
// //   // ► DESIGN DECISION based on your schema:
// //   //   available_grounds = [
// //   //     {"name":"Turf 1","fieldSize":"4-a-side"},
// //   //     {"name":"Turf 2","fieldSize":"6-a-side"},
// //   //     {"name":"Turf 3","fieldSize":"4-a-side"}
// //   //   ]
// //   //   → Step 1: User picks a FIELD SIZE  (4-a-side | 6-a-side)
// //   //   → Step 2: User picks a GROUND name among grounds that match that size
// //   //   This mirrors real-world turf booking UX.

// //   List<String> _uniqueFieldSizes = [];
// //   String? _selectedFieldSize;
// //   List<Map<String, String>> _filteredGrounds = [];
// //   int _selectedFilteredGroundIndex = 0;

// //   // ───── Poster images ─────
// //   List<String> _posterUrls = [];
// //   int _currentPosterIndex = 0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _parseData();
// //   }

// //   void _parseData() {
// //     final raw = widget.turfData['available_grounds'];
// //     if (raw is List) {
// //       _grounds = raw.map((item) {
// //         if (item is Map) {
// //           return {
// //             'name': item['name']?.toString() ?? 'Ground',
// //             'fieldSize': item['fieldSize']?.toString() ?? '',
// //           };
// //         }
// //         return {'name': 'Ground', 'fieldSize': ''};
// //       }).toList();
// //     }

// //     // Dedupe field sizes preserving order
// //     final seen = <String>{};
// //     for (final g in _grounds) {
// //       final fs = g['fieldSize'] ?? '';
// //       if (fs.isNotEmpty && seen.add(fs)) {
// //         _uniqueFieldSizes.add(fs);
// //       }
// //     }

// //     // Default selection
// //     if (_uniqueFieldSizes.isNotEmpty) {
// //       _selectedFieldSize = _uniqueFieldSizes.first;
// //     }
// //     _applyGroundFilter();

// //     // Posters
// //     _posterUrls = List<String>.from(widget.turfData['poster_urls'] ?? []);
// //   }

// //   void _applyGroundFilter() {
// //     _filteredGrounds = _grounds
// //         .where((g) => g['fieldSize'] == _selectedFieldSize)
// //         .toList();
// //     _selectedFilteredGroundIndex = 0;
// //   }

// //   // ───── Helpers ─────
// //   double get _halfHourPrice =>
// //       (widget.turfData['half_hour_price'] ?? 0.0).toDouble();

// //   String get _turfName => widget.turfData['name'] ?? 'Turf';
// //   String get _city => widget.turfData['city'] ?? '';
// //   String get _address => widget.turfData['address'] ?? '';
// //   String get _contact => widget.turfData['contact'] ?? '';
// //   List<String> get _amenities =>
// //       List<String>.from(widget.turfData['amenities'] ?? []);
// //   List<String> get _venueInfo =>
// //       List<String>.from(widget.turfData['venue_info'] ?? []);
// //   List<String> get _venueRules =>
// //       List<String>.from(widget.turfData['venue_rules'] ?? []);
// //   List<String> get _playground =>
// //       List<String>.from(widget.turfData['playground'] ?? []);

// //   Map<String, dynamic> get _schedule =>
// //       widget.turfData['schedule'] as Map<String, dynamic>? ?? {};

// //   // ─────────────────────────────────────────────
// //   // BUILD
// //   // ─────────────────────────────────────────────
// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F7FA),
// //       body: CustomScrollView(
// //         physics: const BouncingScrollPhysics(),
// //         slivers: [
// //           // ── Sliver App Bar with poster carousel ──
// //           _buildSliverAppBar(size),

// //           // ── Content ──
// //           SliverPadding(
// //             padding: EdgeInsets.only(top: size.width * 0.04, bottom: 100),
// //             sliver: SliverList(
// //               delegate: SliverChildListDelegate([
// //                 // Title + location
// //                 _buildHeaderInfo(size),
// //                 SizedBox(height: size.width * 0.05),

// //                 // ════════════════════════════════════
// //                 // FIELD SIZE SELECTOR  (Step 1)
// //                 // ════════════════════════════════════
// //                 if (_uniqueFieldSizes.isNotEmpty) ...[
// //                   _buildSectionLabel('Select Field Size', size),
// //                   SizedBox(height: size.width * 0.025),
// //                   _buildFieldSizeSelector(size),
// //                   SizedBox(height: size.width * 0.05),
// //                 ],

// //                 // ════════════════════════════════════
// //                 // GROUND SELECTOR  (Step 2)
// //                 // ════════════════════════════════════
// //                 if (_filteredGrounds.isNotEmpty) ...[
// //                   _buildSectionLabel('Select Ground', size),
// //                   SizedBox(height: size.width * 0.025),
// //                   _buildGroundSelector(size),
// //                   SizedBox(height: size.width * 0.05),
// //                 ],

// //                 // ── Pricing card ──
// //                 _buildPricingCard(size),
// //                 SizedBox(height: size.width * 0.05),

// //                 // ── Schedule ──
// //                 if (_schedule.isNotEmpty) ...[
// //                   _buildSectionLabel('Weekly Schedule', size),
// //                   SizedBox(height: size.width * 0.025),
// //                   _buildScheduleGrid(size),
// //                   SizedBox(height: size.width * 0.05),
// //                 ],

// //                 // ── Amenities ──
// //                 if (_amenities.isNotEmpty) ...[
// //                   _buildSectionLabel('Amenities', size),
// //                   SizedBox(height: size.width * 0.025),
// //                   _buildChipList(_amenities, size),
// //                   SizedBox(height: size.width * 0.05),
// //                 ],

// //                 // ── Venue Info ──
// //                 if (_venueInfo.isNotEmpty) ...[
// //                   _buildSectionLabel('Venue Info', size),
// //                   SizedBox(height: size.width * 0.025),
// //                   _buildBulletList(_venueInfo, size),
// //                   SizedBox(height: size.width * 0.05),
// //                 ],

// //                 // ── Playground ──
// //                 if (_playground.isNotEmpty) ...[
// //                   _buildSectionLabel('Playground Details', size),
// //                   SizedBox(height: size.width * 0.025),
// //                   _buildBulletList(_playground, size),
// //                   SizedBox(height: size.width * 0.05),
// //                 ],

// //                 // ── Venue Rules ──
// //                 if (_venueRules.isNotEmpty) ...[
// //                   _buildSectionLabel('Venue Rules', size),
// //                   SizedBox(height: size.width * 0.025),
// //                   _buildBulletList(_venueRules, size),
// //                   SizedBox(height: size.width * 0.05),
// //                 ],

// //                 // ── Contact ──
// //                 if (_contact.isNotEmpty) ...[
// //                   _buildSectionLabel('Contact', size),
// //                   SizedBox(height: size.width * 0.025),
// //                   _buildContactCard(size),
// //                 ],
// //               ]),
// //             ),
// //           ),
// //         ],
// //       ),
// //       // ── Bottom bar: Book Now ──
// //       bottomNavigationBar: _buildBottomBar(size),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // SLIVER APP BAR  (poster carousel + back button)
// //   // ─────────────────────────────────────────────
// //   Widget _buildSliverAppBar(Size size) {
// //     final hasPoster = _posterUrls.isNotEmpty;

// //     return SliverAppBar(
// //       expandedHeight: hasPoster ? size.width * 0.55 : 120.0,
// //       pinned: true,
// //       stretch: true,
// //       backgroundColor: const Color(0xFF1E1E82),
// //       leading: Padding(
// //         padding: const EdgeInsets.only(left: 8),
// //         child: Container(
// //           margin: EdgeInsets.only(
// //             // top: MediaQuery.of(context).padding.top * 0.3,
// //           ),
// //           // decoration: BoxDecoration(
// //           //   color: Colors.black.withAlpha(140),
// //           //   shape: BoxShape.circle,
// //           // ),
// //           child: IconButton(
// //             icon: const Icon(
// //               Icons.arrow_back_ios_new_rounded,
// //               color: Colors.white,
// //             ),
// //             onPressed: () => Get.back(),
// //           ),
// //         ),
// //       ),
// //       flexibleSpace: FlexibleSpaceBar(
// //         titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
// //         // title: Text(
// //         //   _turfName,
// //         //   style: const TextStyle(
// //         //     fontFamily: 'Medium',
// //         //     color: Colors.white,
// //         //     fontSize: 18,
// //         //     shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
// //         //   ),
// //         // ),
// //         background: hasPoster
// //             ? _buildPosterCarousel(size)
// //             : Container(
// //                 decoration: const BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [Color(0xFF1E1E82), Color(0xFF3636B8)],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                 ),
// //                 child: Center(
// //                   child: Icon(
// //                     Icons.sports_soccer_outlined,
// //                     size: 64,
// //                     color: Colors.white.withAlpha(80),
// //                   ),
// //                 ),
// //               ),
// //       ),
// //     );
// //   }

// //   Widget _buildPosterCarousel(Size size) {
// //     return Stack(
// //       children: [
// //         // Image pages
// //         PageView.builder(
// //           itemCount: _posterUrls.length,
// //           onPageChanged: (index) {
// //             setState(() {
// //               _currentPosterIndex = index;
// //             });
// //           },
// //           itemBuilder: (context, index) => Image.network(
// //             _posterUrls[index],
// //             fit: BoxFit.cover,
// //             errorBuilder: (_, __, ___) => Container(
// //               color: const Color(0xFF1E1E82),
// //               child: const Center(
// //                 child: Icon(Icons.broken_image_outlined, color: Colors.white54),
// //               ),
// //             ),
// //           ),
// //         ),
// //         // Gradient overlay at bottom for title readability
// //         Positioned(
// //           bottom: 0,
// //           left: 0,
// //           right: 0,
// //           height: size.width * 0.28,
// //           child: Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [Colors.transparent, Colors.black.withAlpha(180)],
// //                 begin: Alignment.topCenter,
// //                 end: Alignment.bottomCenter,
// //               ),
// //             ),
// //           ),
// //         ),
// //         // Dot indicators
// //         if (_posterUrls.length > 1)
// //           Positioned(
// //             bottom: 40,
// //             left: 0,
// //             right: 0,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: List.generate(
// //                 _posterUrls.length,
// //                 (i) => AnimatedContainer(
// //                   duration: const Duration(milliseconds: 300),
// //                   margin: const EdgeInsets.symmetric(horizontal: 4),
// //                   width: i == _currentPosterIndex ? 24 : 8,
// //                   height: 8,
// //                   decoration: BoxDecoration(
// //                     color: i == _currentPosterIndex
// //                         ? Colors.white
// //                         : Colors.white.withAlpha(100),
// //                     borderRadius: BorderRadius.circular(4),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // HEADER INFO  (name, city, address)
// //   // ─────────────────────────────────────────────
// //   Widget _buildHeaderInfo(Size size) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             _turfName,
// //             style: TextStyle(
// //               fontSize: size.width * 0.065,
// //               fontFamily: 'Medium',
// //               color: const Color(0xFF1E1E82),
// //             ),
// //           ),
// //           SizedBox(height: size.width * 0.015),
// //           Row(
// //             children: [
// //               const Icon(
// //                 Icons.location_on_outlined,
// //                 size: 18,
// //                 color: Color(0xFF3636B8),
// //               ),
// //               SizedBox(width: 4),
// //               Expanded(
// //                 child: Text(
// //                   [_city, _address].where((s) => s.isNotEmpty).join(', '),
// //                   style: TextStyle(
// //                     fontSize: size.width * 0.035,
// //                     fontFamily: 'Regular',
// //                     color: Colors.grey.shade600,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // SECTION LABEL
// //   // ─────────────────────────────────────────────
// //   Widget _buildSectionLabel(String title, Size size) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Text(
// //         title,
// //         style: TextStyle(
// //           fontSize: size.width * 0.042,
// //           fontFamily: 'Medium',
// //           color: const Color(0xFF1E1E82),
// //         ),
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // STEP 1: FIELD SIZE SELECTOR
// //   // e.g.  [ 4-a-side ]  [ 6-a-side ]  [ 8-a-side ]
// //   // ─────────────────────────────────────────────
// //   Widget _buildFieldSizeSelector(Size size) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Row(
// //         children: _uniqueFieldSizes.map((fs) {
// //           final isSelected = _selectedFieldSize == fs;
// //           // Parse the numeric part for big display, e.g. "5" from "5-a-side"
// //           final numStr = fs.split('-').first;

// //           return Expanded(
// //             child: GestureDetector(
// //               onTap: () {
// //                 setState(() {
// //                   _selectedFieldSize = fs;
// //                   _applyGroundFilter();
// //                 });
// //               },
// //               child: AnimatedContainer(
// //                 duration: const Duration(milliseconds: 220),
// //                 margin: EdgeInsets.only(right: size.width * 0.03),
// //                 decoration: BoxDecoration(
// //                   color: isSelected ? const Color(0xFF1E1E82) : Colors.white,
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(
// //                     color: isSelected
// //                         ? const Color(0xFF1E1E82)
// //                         : Colors.grey.shade300,
// //                     width: 1.5,
// //                   ),
// //                   boxShadow: isSelected
// //                       ? [
// //                           BoxShadow(
// //                             color: const Color(0xFF1E1E82).withAlpha(90),
// //                             blurRadius: 8,
// //                             offset: const Offset(0, 3),
// //                           ),
// //                         ]
// //                       : [
// //                           BoxShadow(
// //                             color: Colors.black.withAlpha(20),
// //                             blurRadius: 4,
// //                             offset: const Offset(0, 1),
// //                           ),
// //                         ],
// //                 ),
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(
// //                     vertical: size.width * 0.035,
// //                     horizontal: size.width * 0.02,
// //                   ),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       // Big number
// //                       Text(
// //                         numStr,
// //                         style: TextStyle(
// //                           fontSize: size.width * 0.065,
// //                           fontFamily: 'Medium',
// //                           color: isSelected
// //                               ? Colors.white
// //                               : const Color(0xFF1E1E82),
// //                         ),
// //                       ),
// //                       // "a side" label
// //                       Text(
// //                         'a side',
// //                         style: TextStyle(
// //                           fontSize: size.width * 0.028,
// //                           fontFamily: 'Regular',
// //                           color: isSelected
// //                               ? Colors.white.withAlpha(200)
// //                               : Colors.grey.shade500,
// //                         ),
// //                       ),
// //                       // Small badge: how many grounds available for this size
// //                       SizedBox(height: size.width * 0.015),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 8,
// //                           vertical: 2,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: isSelected
// //                               ? Colors.white.withAlpha(30)
// //                               : const Color(0xFF1E1E82).withAlpha(12),
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         child: Text(
// //                           '${_grounds.where((g) => g['fieldSize'] == fs).length} ground${_grounds.where((g) => g['fieldSize'] == fs).length == 1 ? '' : 's'}',
// //                           style: TextStyle(
// //                             fontSize: size.width * 0.022,
// //                             fontFamily: 'Regular',
// //                             color: isSelected
// //                                 ? Colors.white.withAlpha(210)
// //                                 : const Color(0xFF1E1E82).withAlpha(160),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // STEP 2: GROUND SELECTOR
// //   // Horizontal scrolling chips for grounds matching _selectedFieldSize
// //   // ─────────────────────────────────────────────
// //   Widget _buildGroundSelector(Size size) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Wrap(
// //         spacing: size.width * 0.025,
// //         runSpacing: size.width * 0.025,
// //         children: _filteredGrounds.asMap().entries.map((entry) {
// //           final index = entry.key;
// //           final ground = entry.value;
// //           final isSelected = _selectedFilteredGroundIndex == index;
// //           final name = ground['name'] ?? 'Ground';

// //           return GestureDetector(
// //             onTap: () {
// //               setState(() {
// //                 _selectedFilteredGroundIndex = index;
// //               });
// //             },
// //             child: AnimatedContainer(
// //               duration: const Duration(milliseconds: 220),
// //               decoration: BoxDecoration(
// //                 color: isSelected ? const Color(0xFF3636B8) : Colors.white,
// //                 borderRadius: BorderRadius.circular(40),
// //                 border: Border.all(
// //                   color: isSelected
// //                       ? const Color(0xFF3636B8)
// //                       : Colors.grey.shade300,
// //                   width: 1.5,
// //                 ),
// //                 boxShadow: isSelected
// //                     ? [
// //                         BoxShadow(
// //                           color: const Color(0xFF3636B8).withAlpha(100),
// //                           blurRadius: 6,
// //                           offset: const Offset(0, 2),
// //                         ),
// //                       ]
// //                     : [
// //                         BoxShadow(
// //                           color: Colors.black.withAlpha(15),
// //                           blurRadius: 3,
// //                           offset: const Offset(0, 1),
// //                         ),
// //                       ],
// //               ),
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(
// //                   horizontal: size.width * 0.05,
// //                   vertical: size.width * 0.025,
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Icon(
// //                       Icons.sports_soccer,
// //                       size: size.width * 0.045,
// //                       color: isSelected
// //                           ? Colors.white
// //                           : const Color(0xFF3636B8),
// //                     ),
// //                     SizedBox(width: size.width * 0.02),
// //                     Text(
// //                       name,
// //                       style: TextStyle(
// //                         fontSize: size.width * 0.035,
// //                         fontFamily: 'Medium',
// //                         color: isSelected
// //                             ? Colors.white
// //                             : const Color(0xFF1E1E82),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // PRICING CARD
// //   // ─────────────────────────────────────────────
// //   Widget _buildPricingCard(Size size) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withAlpha(18),
// //               blurRadius: 6,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.all(size.width * 0.045),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'Price',
// //                     style: TextStyle(
// //                       fontSize: size.width * 0.033,
// //                       fontFamily: 'Regular',
// //                       color: Colors.grey.shade500,
// //                     ),
// //                   ),
// //                   SizedBox(height: 2),
// //                   Row(
// //                     crossAxisAlignment: CrossAxisAlignment.end,
// //                     children: [
// //                       Text(
// //                         '₹${_halfHourPrice.toStringAsFixed(0)}',
// //                         style: TextStyle(
// //                           fontSize: size.width * 0.07,
// //                           fontFamily: 'Medium',
// //                           color: const Color(0xFF1E1E82),
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.only(bottom: 4, left: 4),
// //                         child: Text(
// //                           '/ 30 min',
// //                           style: TextStyle(
// //                             fontSize: size.width * 0.028,
// //                             fontFamily: 'Regular',
// //                             color: Colors.grey.shade500,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //               // Selected ground summary badge
// //               if (_filteredGrounds.isNotEmpty)
// //                 Container(
// //                   padding: EdgeInsets.symmetric(
// //                     horizontal: size.width * 0.04,
// //                     vertical: size.width * 0.025,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF1E1E82).withAlpha(12),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         _filteredGrounds[_selectedFilteredGroundIndex]['name'] ??
// //                             '',
// //                         style: TextStyle(
// //                           fontSize: size.width * 0.032,
// //                           fontFamily: 'Medium',
// //                           color: const Color(0xFF1E1E82),
// //                         ),
// //                       ),
// //                       Text(
// //                         _selectedFieldSize ?? '',
// //                         style: TextStyle(
// //                           fontSize: size.width * 0.026,
// //                           fontFamily: 'Regular',
// //                           color: Colors.grey.shade500,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // WEEKLY SCHEDULE GRID
// //   // ─────────────────────────────────────────────
// //   Widget _buildScheduleGrid(Size size) {
// //     final dayOrder = [
// //       'monday',
// //       'tuesday',
// //       'wednesday',
// //       'thursday',
// //       'friday',
// //       'saturday',
// //       'sunday',
// //     ];
// //     final dayLabels = {
// //       'monday': 'Mon',
// //       'tuesday': 'Tue',
// //       'wednesday': 'Wed',
// //       'thursday': 'Thu',
// //       'friday': 'Fri',
// //       'saturday': 'Sat',
// //       'sunday': 'Sun',
// //     };

// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withAlpha(18),
// //               blurRadius: 6,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.all(size.width * 0.04),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: dayOrder.map((day) {
// //               final dayData = _schedule[day];
// //               final isOpen = dayData is Map
// //                   ? (dayData['isOpen'] ?? true)
// //                   : true;

// //               return Column(
// //                 children: [
// //                   Text(
// //                     dayLabels[day] ?? day.substring(0, 3),
// //                     style: TextStyle(
// //                       fontSize: size.width * 0.026,
// //                       fontFamily: 'Regular',
// //                       color: Colors.grey.shade500,
// //                     ),
// //                   ),
// //                   SizedBox(height: size.width * 0.015),
// //                   Container(
// //                     width: size.width * 0.085,
// //                     height: size.width * 0.085,
// //                     decoration: BoxDecoration(
// //                       color: isOpen
// //                           ? const Color(0xFF1E1E82)
// //                           : Colors.grey.shade200,
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: Center(
// //                       child: Icon(
// //                         isOpen ? Icons.check_rounded : Icons.close_rounded,
// //                         size: size.width * 0.04,
// //                         color: isOpen ? Colors.white : Colors.grey.shade500,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               );
// //             }).toList(),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // CHIP LIST  (amenities)
// //   // ─────────────────────────────────────────────
// //   Widget _buildChipList(List<String> items, Size size) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Wrap(
// //         spacing: size.width * 0.025,
// //         runSpacing: size.width * 0.02,
// //         children: items
// //             .map(
// //               (item) => Container(
// //                 padding: EdgeInsets.symmetric(
// //                   horizontal: size.width * 0.04,
// //                   vertical: size.width * 0.02,
// //                 ),
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFF3636B8).withAlpha(14),
// //                   borderRadius: BorderRadius.circular(30),
// //                   border: Border.all(
// //                     color: const Color(0xFF3636B8).withAlpha(50),
// //                     width: 1,
// //                   ),
// //                 ),
// //                 child: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Icon(
// //                       Icons.check_circle_outline,
// //                       size: 16,
// //                       color: const Color(0xFF3636B8),
// //                     ),
// //                     SizedBox(width: 6),
// //                     Text(
// //                       item,
// //                       style: TextStyle(
// //                         fontSize: size.width * 0.032,
// //                         fontFamily: 'Regular',
// //                         color: const Color(0xFF1E1E82),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             )
// //             .toList(),
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // BULLET LIST  (venue info / rules / playground)
// //   // ─────────────────────────────────────────────
// //   Widget _buildBulletList(List<String> items, Size size) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(14),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withAlpha(15),
// //               blurRadius: 4,
// //               offset: const Offset(0, 1),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: List.generate(items.length, (index) {
// //             final item = items[index];
// //             return Column(
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(
// //                     horizontal: size.width * 0.045,
// //                     vertical: size.width * 0.03,
// //                   ),
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Padding(
// //                         padding: EdgeInsets.only(top: 6),
// //                         child: Container(
// //                           width: 6,
// //                           height: 6,
// //                           decoration: const BoxDecoration(
// //                             color: Color(0xFF3636B8),
// //                             shape: BoxShape.circle,
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: size.width * 0.03),
// //                       Expanded(
// //                         child: Text(
// //                           item,
// //                           style: TextStyle(
// //                             fontSize: size.width * 0.033,
// //                             fontFamily: 'Regular',
// //                             color: Colors.grey.shade700,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 if (index < items.length - 1)
// //                   Divider(height: 1, color: Colors.grey.shade200),
// //               ],
// //             );
// //           }),
// //         ),
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // CONTACT CARD
// //   // ─────────────────────────────────────────────
// //   Widget _buildContactCard(Size size) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(14),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withAlpha(15),
// //               blurRadius: 4,
// //               offset: const Offset(0, 1),
// //             ),
// //           ],
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.all(size.width * 0.04),
// //           child: Row(
// //             children: [
// //               Container(
// //                 width: size.width * 0.11,
// //                 height: size.width * 0.11,
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFF1E1E82).withAlpha(12),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Center(
// //                   child: Icon(
// //                     Icons.phone_outlined,
// //                     size: size.width * 0.05,
// //                     color: const Color(0xFF1E1E82),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(width: size.width * 0.04),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'Contact',
// //                     style: TextStyle(
// //                       fontSize: size.width * 0.03,
// //                       fontFamily: 'Regular',
// //                       color: Colors.grey.shade500,
// //                     ),
// //                   ),
// //                   Text(
// //                     _contact,
// //                     style: TextStyle(
// //                       fontSize: size.width * 0.042,
// //                       fontFamily: 'Medium',
// //                       color: const Color(0xFF1E1E82),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ─────────────────────────────────────────────
// //   // BOTTOM BAR  (Book Now button)
// //   // ─────────────────────────────────────────────
// //   Widget _buildBottomBar(Size size) {
// //     final canBook = _filteredGrounds.isNotEmpty && _selectedFieldSize != null;

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withAlpha(12),
// //             blurRadius: 10,
// //             offset: const Offset(0, -3),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: EdgeInsets.all(size.width * 0.045),
// //         child: Row(
// //           children: [
// //             // Price summary
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text(
// //                   '₹${_halfHourPrice.toStringAsFixed(0)}',
// //                   style: TextStyle(
// //                     fontSize: size.width * 0.055,
// //                     fontFamily: 'Medium',
// //                     color: const Color(0xFF1E1E82),
// //                   ),
// //                 ),
// //                 Text(
// //                   'per 30 min',
// //                   style: TextStyle(
// //                     fontSize: size.width * 0.027,
// //                     fontFamily: 'Regular',
// //                     color: Colors.grey.shade500,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(width: size.width * 0.04),
// //             // Book button
// //             Expanded(
// //               child: GestureDetector(
// //                 onTap: canBook
// //                     ? () {
// //                         // ── TODO: Navigate to booking page ──
// //                         // Pass selected ground & field size:
// //                         final selectedGround =
// //                             _filteredGrounds[_selectedFilteredGroundIndex];
// //                         debugPrint(
// //                           'Booking → Ground: ${selectedGround['name']}, Size: ${selectedGround['fieldSize']}',
// //                         );

// //                         // Example:
// //                         // Get.to(() => BookingPage(
// //                         //   turfId: widget.turfId,
// //                         //   turfData: widget.turfData,
// //                         //   groundName: selectedGround['name']!,
// //                         //   fieldSize: selectedGround['fieldSize']!,
// //                         // ));
// //                       }
// //                     : null,
// //                 child: AnimatedContainer(
// //                   duration: const Duration(milliseconds: 200),
// //                   height: size.width * 0.145,
// //                   decoration: BoxDecoration(
// //                     color: canBook
// //                         ? const Color(0xFF1E1E82)
// //                         : Colors.grey.shade300,
// //                     borderRadius: BorderRadius.circular(16),
// //                     boxShadow: canBook
// //                         ? [
// //                             BoxShadow(
// //                               color: const Color(0xFF1E1E82).withAlpha(100),
// //                               blurRadius: 8,
// //                               offset: const Offset(0, 3),
// //                             ),
// //                           ]
// //                         : [],
// //                   ),
// //                   child: Center(
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         const Icon(
// //                           Icons.calendar_month_outlined,
// //                           color: Colors.white,
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Text(
// //                           'Book Now',
// //                           style: TextStyle(
// //                             fontSize: size.width * 0.042,
// //                             fontFamily: 'Medium',
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ticpin_play/pages/turfanalyticspage.dart';

// // ─────────────────────────────────────────────────────────────
// // Assumes these exist elsewhere in your project:
// //   TurfAnalyticspage(turfId, turfData)
// // ─────────────────────────────────────────────────────────────

// class TurfDetailpage extends StatefulWidget {
//   final String turfId;
//   final Map<String, dynamic> turfData;

//   const TurfDetailpage({
//     super.key,
//     required this.turfId,
//     required this.turfData,
//   });

//   @override
//   State<TurfDetailpage> createState() => _TurfDetailpageState();
// }

// class _TurfDetailpageState extends State<TurfDetailpage> {
//   // ───── Grounds parsed from available_grounds ─────
//   List<Map<String, String>> _grounds = [];
//   List<String> _uniqueFieldSizes = [];

//   // ───── Selection state ─────
//   String? _selectedFieldSize;
//   List<Map<String, String>> _filteredGrounds = [];
//   int _selectedGroundIndex = 0;

//   // ───── Date selection ─────
//   int _selectedDayIndex = 0;
//   late final List<List<String>> _tabs;

//   // ───── Slot state ─────
//   Set<String> _bookedSlots = {};
//   Set<String> _blockedSlots = {};
//   bool _loadingSlots = false;

//   // ───── Poster carousel ─────
//   List<String> _posterUrls = [];
//   int _currentPosterIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _tabs = _generateNextDays(15);
//     _parseGrounds();
//     _posterUrls = List<String>.from(widget.turfData['poster_urls'] ?? []);
//     _fetchSlots();
//   }

//   // ─────────────────────────────────────────────
//   // GROUND PARSING
//   // ─────────────────────────────────────────────
//   void _parseGrounds() {
//     final raw = widget.turfData['available_grounds'];
//     if (raw is List) {
//       _grounds = raw.map((item) {
//         if (item is Map) {
//           return {
//             'name': item['name']?.toString() ?? 'Ground',
//             'fieldSize': item['fieldSize']?.toString() ?? '',
//           };
//         }
//         return {'name': 'Ground', 'fieldSize': ''};
//       }).toList();
//     }

//     // Backward compat: old available_field_sizes list
//     if (_grounds.isEmpty) {
//       final oldSizes = widget.turfData['available_field_sizes'];
//       if (oldSizes is List) {
//         for (int i = 0; i < oldSizes.length; i++) {
//           _grounds.add({
//             'name': 'Ground ${i + 1}',
//             'fieldSize': oldSizes[i].toString(),
//           });
//         }
//       }
//     }

//     // Dedupe field sizes preserving order
//     final seen = <String>{};
//     for (final g in _grounds) {
//       final fs = g['fieldSize'] ?? '';
//       if (fs.isNotEmpty && seen.add(fs)) {
//         _uniqueFieldSizes.add(fs);
//       }
//     }

//     if (_uniqueFieldSizes.isNotEmpty) {
//       _selectedFieldSize = _uniqueFieldSizes.first;
//     }
//     _applyGroundFilter();
//   }

//   void _applyGroundFilter() {
//     _filteredGrounds = _grounds
//         .where((g) => g['fieldSize'] == _selectedFieldSize)
//         .toList();
//     _selectedGroundIndex = 0;
//   }

//   // Current ground name used in slot doc ID
//   String get _currentGroundName {
//     if (_filteredGrounds.isEmpty) return '';
//     return _filteredGrounds[_selectedGroundIndex]['name'] ?? '';
//   }

//   // ─────────────────────────────────────────────
//   // DATE HELPERS
//   // ─────────────────────────────────────────────
//   List<List<String>> _generateNextDays(int count) {
//     final List<List<String>> days = [];
//     final today = DateTime.now();
//     for (int i = 0; i < count; i++) {
//       final date = today.add(Duration(days: i));
//       days.add([
//         DateFormat('d MMM').format(date),
//         DateFormat('EEE').format(date),
//       ]);
//     }
//     return days;
//   }

//   String _getSelectedDate() {
//     final today = DateTime.now();
//     final selectedDay = today.add(Duration(days: _selectedDayIndex));
//     return DateFormat('yyyy-MM-dd').format(selectedDay);
//   }

//   // ─────────────────────────────────────────────
//   // SLOT FETCHING
//   // doc pattern: {turfId}_{date}_{groundName}
//   // ─────────────────────────────────────────────
//   Future<void> _fetchSlots() async {
//     if (!mounted) return;
//     setState(() {
//       _loadingSlots = true;
//     });

//     try {
//       final selectedDate = _getSelectedDate();
//       final docId = '${widget.turfId}_${selectedDate}_$_currentGroundName';

//       final slotsDoc = await FirebaseFirestore.instance
//           .collection('turf_slots')
//           .doc(docId)
//           .get();

//       if (slotsDoc.exists) {
//         final data = slotsDoc.data()!;
//         final slots = data['slots'] as Map<String, dynamic>? ?? {};
//         final blocked = data['blocked_slots'] as Map<String, dynamic>? ?? {};

//         if (mounted) {
//           setState(() {
//             _bookedSlots = slots.entries
//                 .where((e) => e.value == true)
//                 .map((e) => e.key)
//                 .toSet();
//             _blockedSlots = blocked.entries
//                 .where((e) => e.value == true)
//                 .map((e) => e.key)
//                 .toSet();
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             _bookedSlots = {};
//             _blockedSlots = {};
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Error fetching slots: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _loadingSlots = false;
//         });
//       }
//     }
//   }

//   // ─────────────────────────────────────────────
//   // BLOCK / UNBLOCK SLOT
//   // ─────────────────────────────────────────────
//   Future<void> _toggleBlockSlot(String timeSlot) async {
//     try {
//       final selectedDate = _getSelectedDate();
//       final docId = '${widget.turfId}_${selectedDate}_$_currentGroundName';
//       final isBlocked = _blockedSlots.contains(timeSlot);

//       await FirebaseFirestore.instance.collection('turf_slots').doc(docId).set({
//         'turfId': widget.turfId,
//         'date': selectedDate,
//         'groundName': _currentGroundName,
//         'fieldSize': _selectedFieldSize,
//         'blocked_slots': {timeSlot: !isBlocked},
//       }, SetOptions(merge: true));

//       if (mounted) {
//         setState(() {
//           if (isBlocked) {
//             _blockedSlots.remove(timeSlot);
//           } else {
//             _blockedSlots.add(timeSlot);
//           }
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(isBlocked ? 'Slot unblocked' : 'Slot blocked'),
//             backgroundColor: Colors.green,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }

//   // ─────────────────────────────────────────────
//   // CANCEL BOOKING (admin)
//   // ─────────────────────────────────────────────
//   Future<void> _cancelBooking(String timeSlot) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Cancel Booking',
//           style: TextStyle(fontFamily: 'Medium'),
//         ),
//         content: const Text(
//           'Are you sure you want to cancel this booking? A refund will be initiated.',
//           style: TextStyle(fontFamily: 'Regular'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text('No', style: TextStyle(fontFamily: 'Regular')),
//           ),
//           TextButton(
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text(
//               'Yes, Cancel',
//               style: TextStyle(fontFamily: 'Regular'),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final selectedDate = _getSelectedDate();

//       final bookingsQuery = await FirebaseFirestore.instance
//           .collection('turf_bookings')
//           .where('turfId', isEqualTo: widget.turfId)
//           .where('date', isEqualTo: selectedDate)
//           .where('groundName', isEqualTo: _currentGroundName)
//           .where('status', isEqualTo: 'confirmed')
//           .get();

//       DocumentSnapshot? bookingDoc;
//       for (var doc in bookingsQuery.docs) {
//         final data = doc.data();
//         final slots = List<Map<String, dynamic>>.from(data['slots'] ?? []);
//         if (slots.any((s) => s['start'] == timeSlot)) {
//           bookingDoc = doc;
//           break;
//         }
//       }

//       if (bookingDoc == null) throw Exception('Booking not found');

//       final bookingData = bookingDoc.data() as Map<String, dynamic>;

//       // Mark booking cancelled
//       await FirebaseFirestore.instance
//           .collection('turf_bookings')
//           .doc(bookingDoc.id)
//           .update({
//             'status': 'cancelled_by_admin',
//             'cancelledAt': FieldValue.serverTimestamp(),
//             'refundStatus': 'pending',
//             'refundInitiatedAt': FieldValue.serverTimestamp(),
//           });

//       // Release slots from turf_slots doc
//       final docId = '${widget.turfId}_${selectedDate}_$_currentGroundName';
//       final slots = List<Map<String, dynamic>>.from(bookingData['slots'] ?? []);
//       Map<String, dynamic> slotsToRelease = {};
//       for (var slot in slots) {
//         slotsToRelease['slots.${slot['start']}'] = FieldValue.delete();
//       }
//       await FirebaseFirestore.instance
//           .collection('turf_slots')
//           .doc(docId)
//           .update(slotsToRelease);

//       // Create refund record
//       await FirebaseFirestore.instance.collection('refunds').add({
//         'bookingId': bookingDoc.id,
//         'userId': bookingData['userId'],
//         'turfId': widget.turfId,
//         'groundName': _currentGroundName,
//         'amount': bookingData['totalAmount'],
//         'status': 'pending',
//         'reason': 'Cancelled by admin',
//         'createdAt': FieldValue.serverTimestamp(),
//         'processedAt': null,
//       });

//       _fetchSlots();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Booking cancelled. Refund initiated.'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to cancel: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   // ─────────────────────────────────────────────
//   // SLOT OPTIONS BOTTOM SHEET
//   // ─────────────────────────────────────────────
//   void _showSlotOptions(String timeSlot) {
//     final isBooked = _bookedSlots.contains(timeSlot);
//     final isBlocked = _blockedSlots.contains(timeSlot);

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       builder: (ctx) => Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Handle bar
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             Text(
//               timeSlot,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontFamily: 'Medium',
//                 color: Color(0xFF1E1E82),
//               ),
//             ),
//             Text(
//               '$_currentGroundName • ${_selectedFieldSize ?? ''}',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontFamily: 'Regular',
//                 color: Colors.grey.shade500,
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (isBooked) ...[
//               _buildBottomSheetOption(
//                 icon: Icons.cancel_outlined,
//                 iconColor: Colors.red,
//                 label: 'Cancel Booking & Initiate Refund',
//                 onTap: () {
//                   Navigator.pop(ctx);
//                   _cancelBooking(timeSlot);
//                 },
//               ),
//             ] else ...[
//               _buildBottomSheetOption(
//                 icon: isBlocked
//                     ? Icons.lock_open_outlined
//                     : Icons.lock_outlined,
//                 iconColor: isBlocked ? Colors.green : Colors.orange,
//                 label: isBlocked ? 'Unblock Slot' : 'Block Slot',
//                 onTap: () {
//                   Navigator.pop(ctx);
//                   _toggleBlockSlot(timeSlot);
//                 },
//               ),
//             ],
//             const SizedBox(height: 8),
//             _buildBottomSheetOption(
//               icon: Icons.close_outlined,
//               iconColor: Colors.grey.shade500,
//               label: 'Close',
//               onTap: () => Navigator.pop(ctx),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomSheetOption({
//     required IconData icon,
//     required Color iconColor,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         margin: const EdgeInsets.only(bottom: 4),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: iconColor.withAlpha(20),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(child: Icon(icon, color: iconColor, size: 20)),
//             ),
//             const SizedBox(width: 14),
//             Text(
//               label,
//               style: const TextStyle(fontFamily: 'Regular', fontSize: 15),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // TIME SLOTS LIST  (6 AM → 11:30 PM)
//   // ─────────────────────────────────────────────
//   static const List<String> _allTimeSlots = [
//     "6:00 AM",
//     "6:30 AM",
//     "7:00 AM",
//     "7:30 AM",
//     "8:00 AM",
//     "8:30 AM",
//     "9:00 AM",
//     "9:30 AM",
//     "10:00 AM",
//     "10:30 AM",
//     "11:00 AM",
//     "11:30 AM",
//     "12:00 PM",
//     "12:30 PM",
//     "1:00 PM",
//     "1:30 PM",
//     "2:00 PM",
//     "2:30 PM",
//     "3:00 PM",
//     "3:30 PM",
//     "4:00 PM",
//     "4:30 PM",
//     "5:00 PM",
//     "5:30 PM",
//     "6:00 PM",
//     "6:30 PM",
//     "7:00 PM",
//     "7:30 PM",
//     "8:00 PM",
//     "8:30 PM",
//     "9:00 PM",
//     "9:30 PM",
//     "10:00 PM",
//     "10:30 PM",
//     "11:00 PM",
//     "11:30 PM",
//   ];

//   /// Parses a slot label like "6:30 AM" into a DateTime on the given date.
//   DateTime _slotToDateTime(String slot, DateTime date) {
//     final parts = slot.split(' '); // ["6:30", "AM"]
//     final timeParts = parts[0].split(':'); // ["6",  "30"]
//     int hour = int.parse(timeParts[0]);
//     final int minute = int.parse(timeParts[1]);
//     final bool isPm = parts[1] == 'PM';

//     // 12-hour → 24-hour
//     if (hour == 12) hour = 0;
//     if (isPm) hour += 12;

//     return DateTime(date.year, date.month, date.day, hour, minute);
//   }

//   /// Returns only slots that haven't passed yet.
//   /// Future dates → show everything.  Today → hide slots at or before now.
//   List<String> get _visibleSlots {
//     final now = DateTime.now();
//     final selectedDate = now.add(Duration(days: _selectedDayIndex));
//     final isToday = _selectedDayIndex == 0;

//     if (!isToday) return _allTimeSlots;

//     return _allTimeSlots.where((slot) {
//       return _slotToDateTime(slot, selectedDate).isAfter(now);
//     }).toList();
//   }

//   // ─────────────────────────────────────────────
//   // BUILD
//   // ─────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: Column(
//         children: [
//           // ── Header with poster / gradient ──
//           _buildHeader(size),

//           // ── Scrollable body ──
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: size.width * 0.04),

//                   // Field Size Selector (Step 1)
//                   if (_uniqueFieldSizes.isNotEmpty) ...[
//                     _buildSectionLabel('Select Field Size', size),
//                     SizedBox(height: size.width * 0.025),
//                     _buildFieldSizeSelector(size),
//                     SizedBox(height: size.width * 0.045),
//                   ],

//                   // Ground Selector (Step 2)
//                   if (_filteredGrounds.isNotEmpty) ...[
//                     _buildSectionLabel('Select Ground', size),
//                     SizedBox(height: size.width * 0.025),
//                     _buildGroundSelector(size),
//                     SizedBox(height: size.width * 0.045),
//                   ],

//                   // Date Selector
//                   _buildSectionLabel('Select Date', size),
//                   SizedBox(height: size.width * 0.025),
//                   _buildDateSelector(size),
//                   SizedBox(height: size.width * 0.045),

//                   // Legend
//                   _buildLegend(size),
//                   SizedBox(height: size.width * 0.03),

//                   // Time Slots
//                   _loadingSlots
//                       ? Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: size.width * 0.1,
//                           ),
//                           child: const Center(
//                             child: CircularProgressIndicator(
//                               color: Color(0xFF1E1E82),
//                             ),
//                           ),
//                         )
//                       : _buildSlotGrid(size),

//                   SizedBox(height: size.width * 0.06),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // HEADER  (poster carousel or gradient fallback)
//   // ─────────────────────────────────────────────
//   Widget _buildHeader(Size size) {
//     final hasPoster = _posterUrls.isNotEmpty;
//     final headerHeight = hasPoster ? size.width * 0.45 : size.width * 0.28;

//     return SizedBox(
//       height: headerHeight,
//       child: Stack(
//         children: [
//           // Background
//           hasPoster
//               ? PageView.builder(
//                   itemCount: _posterUrls.length,
//                   onPageChanged: (i) => setState(() {
//                     _currentPosterIndex = i;
//                   }),
//                   itemBuilder: (_, i) => Image.network(
//                     _posterUrls[i],
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       color: const Color(0xFF1E1E82),
//                       child: const Center(
//                         child: Icon(
//                           Icons.broken_image_outlined,
//                           color: Colors.white54,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF1E1E82), Color(0xFF3636B8)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.sports_soccer_outlined,
//                       size: 56,
//                       color: Colors.white.withAlpha(60),
//                     ),
//                   ),
//                 ),

//           // Bottom gradient overlay
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: headerHeight * 0.6,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.transparent, Colors.black.withAlpha(180)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),

//           // Poster dots
//           if (_posterUrls.length > 1)
//             Positioned(
//               bottom: 44,
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   _posterUrls.length,
//                   (i) => AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: const EdgeInsets.symmetric(horizontal: 3),
//                     width: i == _currentPosterIndex ? 20 : 7,
//                     height: 7,
//                     decoration: BoxDecoration(
//                       color: i == _currentPosterIndex
//                           ? Colors.white
//                           : Colors.white.withAlpha(100),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//           // Title block
//           Positioned(
//             bottom: 16,
//             left: 20,
//             right: 80,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.turfData['name'] ?? 'Turf',
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontFamily: 'Medium',
//                     color: Colors.white,
//                     shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on_outlined,
//                       size: 15,
//                       color: Colors.white70,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       widget.turfData['city'] ?? '',
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontFamily: 'Regular',
//                         color: Colors.white70,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Icon(
//                       Icons.currency_rupee,
//                       size: 14,
//                       color: Colors.white70,
//                     ),
//                     Text(
//                       '${(widget.turfData['half_hour_price'] ?? 0).toStringAsFixed(0)}/30min',
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontFamily: 'Regular',
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Back button
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 8,
//             left: 8,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withAlpha(130),
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back_ios_new_rounded,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 onPressed: () => Get.back(),
//               ),
//             ),
//           ),

//           // Analytics button
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 8,
//             right: 8,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withAlpha(130),
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.analytics_outlined,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 onPressed: () {
//                   Get.to(
//                     () => TurfAnalyticspage(
//                       turfId: widget.turfId,
//                       turfData: widget.turfData,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // SECTION LABEL
//   // ─────────────────────────────────────────────
//   Widget _buildSectionLabel(String title, Size size) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: size.width * 0.04,
//           fontFamily: 'Medium',
//           color: const Color(0xFF1E1E82),
//         ),
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // FIELD SIZE SELECTOR  (Step 1)
//   // ─────────────────────────────────────────────
//   Widget _buildFieldSizeSelector(Size size) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,

//       child: Row(
//         children: [
//           SizedBox(width: size.width * 0.045),
//           Row(
//             children: _uniqueFieldSizes.map((fs) {
//               final isSelected = _selectedFieldSize == fs;
//               final numStr = fs.split('-').first;
//               final groundCount = _grounds
//                   .where((g) => g['fieldSize'] == fs)
//                   .length;

//               return Container(
//                 height: size.width * 0.2,
//                 padding: EdgeInsets.only(right: size.width * 0.045),
//                 width: size.width * 0.3,
//                 child: GestureDetector(
//                   onTap: () {
//                     if (_selectedFieldSize == fs) return;
//                     setState(() {
//                       _selectedFieldSize = fs;
//                       _applyGroundFilter();
//                       _bookedSlots = {};
//                       _blockedSlots = {};
//                     });
//                     _fetchSlots();
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 220),
//                     // margin: EdgeInsets.only(right: size.width * 0.03),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? const Color(0xFF1E1E82)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: isSelected
//                             ? const Color(0xFF1E1E82)
//                             : Colors.grey.shade300,
//                         width: 1.5,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: isSelected
//                               ? const Color(0xFF1E1E82).withAlpha(90)
//                               : Colors.black.withAlpha(15),
//                           blurRadius: isSelected ? 8 : 3,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         // vertical: size.width * 0.035,
//                         horizontal: size.width * 0.02,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             maxLines: 2,
//                             textAlign: TextAlign.center,
//                             fs,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: size.width * 0.03,
//                               fontFamily: 'Medium',
//                               color: isSelected
//                                   ? Colors.white
//                                   : const Color(0xFF1E1E82),
//                             ),
//                           ),
//                           // Text(
//                           //   'a side',
//                           //   style: TextStyle(
//                           //     fontSize: size.width * 0.028,
//                           //     fontFamily: 'Regular',
//                           //     color: isSelected
//                           //         ? Colors.white.withAlpha(200)
//                           //         : Colors.grey.shade500,
//                           //   ),
//                           // ),
//                           // SizedBox(height: size.width * 0.015),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? Colors.white.withAlpha(30)
//                                   : const Color(0xFF1E1E82).withAlpha(12),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               '$groundCount ground${groundCount == 1 ? '' : 's'}',
//                               style: TextStyle(
//                                 fontSize: size.width * 0.022,
//                                 fontFamily: 'Regular',
//                                 color: isSelected
//                                     ? Colors.white.withAlpha(210)
//                                     : const Color(0xFF1E1E82).withAlpha(160),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // GROUND SELECTOR  (Step 2)
//   // ─────────────────────────────────────────────
//   Widget _buildGroundSelector(Size size) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
//       child: Wrap(
//         spacing: size.width * 0.025,
//         runSpacing: size.width * 0.025,
//         children: _filteredGrounds.asMap().entries.map((entry) {
//           final index = entry.key;
//           final ground = entry.value;
//           final isSelected = _selectedGroundIndex == index;
//           final name = ground['name'] ?? 'Ground';

//           return GestureDetector(
//             onTap: () {
//               if (_selectedGroundIndex == index) return;
//               setState(() {
//                 _selectedGroundIndex = index;
//                 _bookedSlots = {};
//                 _blockedSlots = {};
//               });
//               _fetchSlots();
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 220),
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xFF1E1E82) : Colors.white,
//                 borderRadius: BorderRadius.circular(40),
//                 border: Border.all(
//                   color: isSelected
//                       ? const Color(0xFF1E1E82)
//                       : Colors.grey.shade300,
//                   width: 1.5,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isSelected
//                         ? const Color(0xFF1E1E82).withAlpha(100)
//                         : Colors.black.withAlpha(12),
//                     blurRadius: isSelected ? 6 : 3,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.width * 0.05,
//                   vertical: size.width * 0.025,
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.sports_soccer,
//                       size: size.width * 0.045,
//                       color: isSelected
//                           ? Colors.white
//                           : const Color(0xFF1E1E82),
//                     ),
//                     SizedBox(width: size.width * 0.02),
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: size.width * 0.035,
//                         fontFamily: 'Medium',
//                         color: isSelected
//                             ? Colors.white
//                             : const Color(0xFF1E1E82),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // DATE SELECTOR
//   // ─────────────────────────────────────────────
//   Widget _buildDateSelector(Size size) {
//     return SizedBox(
//       height: size.width * 0.14,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
//         itemCount: _tabs.length,
//         itemBuilder: (_, index) {
//           final isSelected = _selectedDayIndex == index;
//           final isToday = index == 0;

//           return GestureDetector(
//             onTap: () {
//               if (_selectedDayIndex == index) return;
//               setState(() {
//                 _selectedDayIndex = index;
//                 _bookedSlots = {};
//                 _blockedSlots = {};
//               });
//               _fetchSlots();
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 220),
//               margin: _tabs.length - 1 != index
//                   ? EdgeInsets.only(right: size.width * 0.03)
//                   : EdgeInsets.only(right: 0),
//               width: size.width * 0.2,
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xFF1E1E82) : Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(
//                   color: isSelected
//                       ? const Color(0xFF1E1E82)
//                       : isToday
//                       ? const Color(0xFF3636B8)
//                       : Colors.grey.shade300,
//                   width: isToday && !isSelected ? 2 : 1.5,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isSelected
//                         ? const Color(0xFF1E1E82).withAlpha(80)
//                         : Colors.black.withAlpha(12),
//                     blurRadius: isSelected ? 6 : 3,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: size.width * 0.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _tabs[index][0].split(' ').first,
//                         style: TextStyle(
//                           fontSize: size.width * 0.05,
//                           fontFamily: 'Medium',
//                           color: isSelected
//                               ? Colors.white
//                               : const Color(0xFF1E1E82),
//                         ),
//                       ),
//                     ),
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(
//                         _tabs[index][0].split(' ').last,
//                         style: TextStyle(
//                           fontSize: size.width * 0.024,
//                           fontFamily: 'Regular',
//                           color: isSelected
//                               ? Colors.white.withAlpha(180)
//                               : Colors.grey.shade500,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: size.width * 0.015),
//                     // Container(
//                     //   padding: const EdgeInsets.symmetric(
//                     //     horizontal: 6,
//                     //     vertical: 2,
//                     //   ),
//                     //   decoration: BoxDecoration(
//                     //     color: isSelected
//                     //         ? Colors.white.withAlpha(25)
//                     //         : isToday
//                     //         ? const Color(0xFF3636B8).withAlpha(15)
//                     //         : Colors.grey.shade100,
//                     //     borderRadius: BorderRadius.circular(6),
//                     //   ),
//                     //   child: Text(
//                     //     _tabs[index][1],
//                     //     style: TextStyle(
//                     //       fontSize: size.width * 0.022,
//                     //       fontFamily: 'Regular',
//                     //       color: isSelected
//                     //           ? Colors.white.withAlpha(200)
//                     //           : isToday
//                     //           ? const Color(0xFF3636B8)
//                     //           : Colors.grey.shade500,
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // LEGEND
//   // ─────────────────────────────────────────────
//   Widget _buildLegend(Size size) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
//       child: Row(
//         children: [
//           _legendItem(Colors.green.shade400, 'Free', size),
//           SizedBox(width: size.width * 0.05),
//           _legendItem(Colors.red.shade300, 'Blocked', size),
//           SizedBox(width: size.width * 0.05),
//           _legendItem(Colors.grey.shade400, 'Booked', size),
//         ],
//       ),
//     );
//   }

//   Widget _legendItem(Color color, String label, Size size) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(3),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: size.width * 0.028,
//             fontFamily: 'Regular',
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }

//   // ─────────────────────────────────────────────
//   // SLOT GRID
//   // ─────────────────────────────────────────────
//   Widget _buildSlotGrid(Size size) {
//     final slotsToShow = _visibleSlots;

//     if (slotsToShow.isEmpty) {
//       return Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: size.width * 0.045,
//           vertical: size.width * 0.08,
//         ),
//         child: Center(
//           child: Column(
//             children: [
//               Icon(
//                 Icons.access_time_filled,
//                 size: size.width * 0.12,
//                 color: Colors.grey.shade300,
//               ),
//               SizedBox(height: size.width * 0.04),
//               Text(
//                 'No slots available',
//                 style: TextStyle(
//                   fontSize: size.width * 0.04,
//                   fontFamily: 'Medium',
//                   color: Colors.grey.shade500,
//                 ),
//               ),
//               SizedBox(height: size.width * 0.015),
//               Text(
//                 'All slots for today have passed.\nPick a future date to manage slots.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: size.width * 0.03,
//                   fontFamily: 'Regular',
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
//       child: Column(
//         children: slotsToShow.map((slot) {
//           final isBooked = _bookedSlots.contains(slot);
//           final isBlocked = _blockedSlots.contains(slot);

//           final Color bgColor;
//           final Color borderColor;
//           final Color textColor;
//           final Color iconColor;
//           IconData? statusIcon;
//           String statusLabel;

//           if (isBooked) {
//             bgColor = Colors.grey.shade300;
//             borderColor = Colors.grey.shade400;
//             textColor = Colors.grey.shade700;
//             iconColor = Colors.grey.shade600;
//             statusIcon = Icons.person_outlined;
//             statusLabel = 'Booked';
//           } else if (isBlocked) {
//             bgColor = Colors.red.shade100;
//             borderColor = Colors.red.shade300;
//             textColor = Colors.red.shade800;
//             iconColor = Colors.red.shade600;
//             statusIcon = Icons.lock_outlined;
//             statusLabel = 'Blocked';
//           } else {
//             bgColor = Colors.white;
//             borderColor = Colors.grey.shade200;
//             textColor = const Color(0xFF1E1E82);
//             iconColor = Colors.green.shade500;
//             statusIcon = null;
//             statusLabel = 'Free';
//           }

//           return GestureDetector(
//             onTap: () => _showSlotOptions(slot),
//             child: Container(
//               margin: EdgeInsets.only(bottom: size.width * 0.022),
//               decoration: BoxDecoration(
//                 color: bgColor,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: borderColor, width: 1),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.width * 0.04,
//                   vertical: size.width * 0.03,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       slot,
//                       style: TextStyle(
//                         fontSize: size.width * 0.038,
//                         fontFamily: 'Medium',
//                         color: textColor,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         if (statusIcon != null)
//                           Icon(
//                             statusIcon,
//                             size: size.width * 0.04,
//                             color: iconColor,
//                           ),
//                         SizedBox(width: size.width * 0.02),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 3,
//                           ),
//                           decoration: BoxDecoration(
//                             color: iconColor.withAlpha(20),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             statusLabel,
//                             style: TextStyle(
//                               fontSize: size.width * 0.025,
//                               fontFamily: 'Regular',
//                               color: iconColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticpin_play/pages/turfanalyticspage.dart';

// ─────────────────────────────────────────────────────────────
// Assumes TurfAnalyticspage(turfId, turfData) exists elsewhere.
// ─────────────────────────────────────────────────────────────

class TurfDetailpage extends StatefulWidget {
  final String turfId;
  final Map<String, dynamic> turfData;

  const TurfDetailpage({
    super.key,
    required this.turfId,
    required this.turfData,
  });

  @override
  State<TurfDetailpage> createState() => _TurfDetailpageState();
}

class _TurfDetailpageState extends State<TurfDetailpage> {
  // ───── Grounds ─────
  List<Map<String, String>> _grounds = [];
  List<String> _uniqueFieldSizes = [];

  // ───── Selection ─────
  String? _selectedFieldSize;
  List<Map<String, String>> _filteredGrounds = [];
  int _selectedGroundIndex = 0;

  // ───── Date ─────
  int _selectedDayIndex = 0;
  late final List<List<String>> _tabs;

  // ───── Slots ─────
  Set<String> _bookedSlots = {};
  Set<String> _blockedSlots = {};
  bool _loadingSlots = false;

  // ───── Poster carousel ─────
  List<String> _posterUrls = [];
  int _currentPosterIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = _generateNextDays(15);
    _parseGrounds();
    _posterUrls = List<String>.from(widget.turfData['poster_urls'] ?? []);
    _fetchSlots();
  }

  // ─────────────────────────────────────────────
  // GROUND PARSING
  // ─────────────────────────────────────────────
  void _parseGrounds() {
    final raw = widget.turfData['available_grounds'];
    if (raw is List) {
      _grounds = raw.map((item) {
        if (item is Map) {
          return {
            'name': item['name']?.toString() ?? 'Ground',
            'fieldSize': item['fieldSize']?.toString() ?? '',
          };
        }
        return {'name': 'Ground', 'fieldSize': ''};
      }).toList();
    }

    if (_grounds.isEmpty) {
      final oldSizes = widget.turfData['available_field_sizes'];
      if (oldSizes is List) {
        for (int i = 0; i < oldSizes.length; i++) {
          _grounds.add({
            'name': 'Ground ${i + 1}',
            'fieldSize': oldSizes[i].toString(),
          });
        }
      }
    }

    final seen = <String>{};
    for (final g in _grounds) {
      final fs = g['fieldSize'] ?? '';
      if (fs.isNotEmpty && seen.add(fs)) _uniqueFieldSizes.add(fs);
    }

    if (_uniqueFieldSizes.isNotEmpty)
      _selectedFieldSize = _uniqueFieldSizes.first;
    _applyGroundFilter();
  }

  void _applyGroundFilter() {
    _filteredGrounds = _grounds
        .where((g) => g['fieldSize'] == _selectedFieldSize)
        .toList();
    _selectedGroundIndex = 0;
  }

  String get _currentGroundName {
    if (_filteredGrounds.isEmpty) return '';
    return _filteredGrounds[_selectedGroundIndex]['name'] ?? '';
  }

  // ─────────────────────────────────────────────
  // DATE HELPERS
  // ─────────────────────────────────────────────
  List<List<String>> _generateNextDays(int count) {
    final List<List<String>> days = [];
    final today = DateTime.now();
    for (int i = 0; i < count; i++) {
      final date = today.add(Duration(days: i));
      days.add([
        DateFormat('d MMM').format(date),
        DateFormat('EEE').format(date),
      ]);
    }
    return days;
  }

  String _getSelectedDate() {
    final today = DateTime.now();
    return DateFormat(
      'yyyy-MM-dd',
    ).format(today.add(Duration(days: _selectedDayIndex)));
  }

  /// Returns the lowercase weekday key ("monday", "tuesday", …) for the currently selected date.
  String _getSelectedDayKey() {
    final today = DateTime.now();
    final date = today.add(Duration(days: _selectedDayIndex));
    const keys = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    // DateTime.weekday: 1=Monday … 7=Sunday
    return keys[date.weekday - 1];
  }

  // ─────────────────────────────────────────────
  // DYNAMIC SLOT GENERATION from schedule
  // ─────────────────────────────────────────────

  /// Read the schedule map stored in turfData and return the start/end
  /// TimeOfDay for the selected weekday.  Falls back to 6 AM – 10 PM.
  _DayBounds _getBoundsForSelectedDay() {
    final schedule = widget.turfData['schedule'] as Map<String, dynamic>? ?? {};
    final dayKey = _getSelectedDayKey();
    final dayData = schedule[dayKey];

    if (dayData is Map) {
      final isOpen = dayData['isOpen'] ?? true;
      if (!isOpen) return _DayBounds(isOpen: false);

      return _DayBounds(
        isOpen: true,
        startHour: dayData['startHour'] ?? 6,
        startMinute: dayData['startMinute'] ?? 0,
        endHour: dayData['endHour'] ?? 22,
        endMinute: dayData['endMinute'] ?? 0,
      );
    }
    // Legacy / missing → default full day
    return _DayBounds(isOpen: true);
  }

  /// Generate every 30-min slot label between start and end (exclusive of end).
  /// E.g. start=6:00 end=8:00 → ["6:00 AM", "6:30 AM", "7:00 AM", "7:30 AM"]
  List<String> _generateSlots(_DayBounds bounds) {
    if (!bounds.isOpen) return [];

    final startMin = bounds.startHour * 60 + bounds.startMinute;
    final endMin = bounds.endHour * 60 + bounds.endMinute;
    final List<String> slots = [];

    for (int m = startMin; m < endMin; m += 30) {
      slots.add(_minutesToLabel(m));
    }
    return slots;
  }

  /// Convert total minutes since midnight into a label like "6:30 AM".
  String _minutesToLabel(int totalMinutes) {
    int h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    final ampm = h < 12 ? 'AM' : 'PM';
    h = h % 12;
    if (h == 0) h = 12;
    return '$h:${m.toString().padLeft(2, '0')} $ampm';
  }

  /// Parse a slot label back into a DateTime on a given date (for past-check).
  DateTime _slotToDateTime(String slot, DateTime date) {
    final parts = slot.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPm = parts[1] == 'PM';
    if (hour == 12) hour = 0;
    if (isPm) hour += 12;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  /// All slots for the selected day (respects schedule hours).
  List<String> get _allTimeSlots => _generateSlots(_getBoundsForSelectedDay());

  /// Filters out past slots on today; future dates show everything.
  List<String> get _visibleSlots {
    final now = DateTime.now();
    final selectedDate = now.add(Duration(days: _selectedDayIndex));
    final isToday = _selectedDayIndex == 0;

    final all = _allTimeSlots;
    if (!isToday) return all;

    return all
        .where((slot) => _slotToDateTime(slot, selectedDate).isAfter(now))
        .toList();
  }

  // ─────────────────────────────────────────────
  // SLOT FETCHING
  // ─────────────────────────────────────────────
  Future<void> _fetchSlots() async {
    if (!mounted) return;
    setState(() {
      _loadingSlots = true;
    });

    try {
      final selectedDate = _getSelectedDate();
      final docId = '${widget.turfId}_${selectedDate}_$_currentGroundName';

      final slotsDoc = await FirebaseFirestore.instance
          .collection('turf_slots')
          .doc(docId)
          .get();

      if (slotsDoc.exists) {
        final data = slotsDoc.data()!;
        final slots = data['slots'] as Map<String, dynamic>? ?? {};
        final blocked = data['blocked_slots'] as Map<String, dynamic>? ?? {};

        if (mounted) {
          setState(() {
            _bookedSlots = slots.entries
                .where((e) => e.value == true)
                .map((e) => e.key)
                .toSet();
            _blockedSlots = blocked.entries
                .where((e) => e.value == true)
                .map((e) => e.key)
                .toSet();
          });
        }
      } else {
        if (mounted)
          setState(() {
            _bookedSlots = {};
            _blockedSlots = {};
          });
      }
    } catch (e) {
      debugPrint('Error fetching slots: $e');
    } finally {
      if (mounted)
        setState(() {
          _loadingSlots = false;
        });
    }
  }

  // ─────────────────────────────────────────────
  // BLOCK / UNBLOCK
  // ─────────────────────────────────────────────
  Future<void> _toggleBlockSlot(String timeSlot) async {
    try {
      final selectedDate = _getSelectedDate();
      final docId = '${widget.turfId}_${selectedDate}_$_currentGroundName';
      final isBlocked = _blockedSlots.contains(timeSlot);

      await FirebaseFirestore.instance.collection('turf_slots').doc(docId).set({
        'turfId': widget.turfId,
        'date': selectedDate,
        'groundName': _currentGroundName,
        'fieldSize': _selectedFieldSize,
        'blocked_slots': {timeSlot: !isBlocked},
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          isBlocked
              ? _blockedSlots.remove(timeSlot)
              : _blockedSlots.add(timeSlot);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isBlocked ? 'Slot unblocked' : 'Slot blocked'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ─────────────────────────────────────────────
  // CANCEL BOOKING
  // ─────────────────────────────────────────────
  Future<void> _cancelBooking(String timeSlot) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Booking',
          style: TextStyle(fontFamily: 'Medium'),
        ),
        content: const Text(
          'Are you sure you want to cancel this booking? A refund will be initiated.',
          style: TextStyle(fontFamily: 'Regular'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No', style: TextStyle(fontFamily: 'Regular')),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(fontFamily: 'Regular'),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final selectedDate = _getSelectedDate();

      final bookingsQuery = await FirebaseFirestore.instance
          .collection('turf_bookings')
          .where('turfId', isEqualTo: widget.turfId)
          .where('date', isEqualTo: selectedDate)
          .where('groundName', isEqualTo: _currentGroundName)
          .where('status', isEqualTo: 'confirmed')
          .get();

      DocumentSnapshot? bookingDoc;
      for (var doc in bookingsQuery.docs) {
        final slots = List<Map<String, dynamic>>.from(
          doc.data()['slots'] ?? [],
        );
        if (slots.any((s) => s['start'] == timeSlot)) {
          bookingDoc = doc;
          break;
        }
      }

      if (bookingDoc == null) throw Exception('Booking not found');
      final bookingData = bookingDoc.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance
          .collection('turf_bookings')
          .doc(bookingDoc.id)
          .update({
            'status': 'cancelled_by_admin',
            'cancelledAt': FieldValue.serverTimestamp(),
            'refundStatus': 'pending',
            'refundInitiatedAt': FieldValue.serverTimestamp(),
          });

      final docId = '${widget.turfId}_${selectedDate}_$_currentGroundName';
      final slots = List<Map<String, dynamic>>.from(bookingData['slots'] ?? []);
      Map<String, dynamic> release = {};
      for (var slot in slots)
        release['slots.${slot['start']}'] = FieldValue.delete();
      await FirebaseFirestore.instance
          .collection('turf_slots')
          .doc(docId)
          .update(release);

      await FirebaseFirestore.instance.collection('refunds').add({
        'bookingId': bookingDoc.id,
        'userId': bookingData['userId'],
        'turfId': widget.turfId,
        'groundName': _currentGroundName,
        'amount': bookingData['totalAmount'],
        'status': 'pending',
        'reason': 'Cancelled by admin',
        'createdAt': FieldValue.serverTimestamp(),
        'processedAt': null,
      });

      _fetchSlots();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled. Refund initiated.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ─────────────────────────────────────────────
  // BOTTOM SHEET
  // ─────────────────────────────────────────────
  void _showSlotOptions(String timeSlot) {
    final isBooked = _bookedSlots.contains(timeSlot);
    final isBlocked = _blockedSlots.contains(timeSlot);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              timeSlot,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Medium',
                color: Color(0xFF1E1E82),
              ),
            ),
            Text(
              '$_currentGroundName • ${_selectedFieldSize ?? ''}',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Regular',
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),
            if (isBooked) ...[
              _buildBottomSheetOption(
                icon: Icons.cancel_outlined,
                iconColor: Colors.red,
                label: 'Cancel Booking & Initiate Refund',
                onTap: () {
                  Navigator.pop(ctx);
                  _cancelBooking(timeSlot);
                },
              ),
            ] else ...[
              _buildBottomSheetOption(
                icon: isBlocked
                    ? Icons.lock_open_outlined
                    : Icons.lock_outlined,
                iconColor: isBlocked ? Colors.green : Colors.orange,
                label: isBlocked ? 'Unblock Slot' : 'Block Slot',
                onTap: () {
                  Navigator.pop(ctx);
                  _toggleBlockSlot(timeSlot);
                },
              ),
            ],
            const SizedBox(height: 8),
            _buildBottomSheetOption(
              icon: Icons.close_outlined,
              iconColor: Colors.grey.shade500,
              label: 'Close',
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 20)),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(fontFamily: 'Regular', fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bounds = _getBoundsForSelectedDay();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(size),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.width * 0.04),

                  if (_uniqueFieldSizes.isNotEmpty) ...[
                    _buildSectionLabel('Select Field Size', size),
                    SizedBox(height: size.width * 0.025),
                    _buildFieldSizeSelector(size),
                    SizedBox(height: size.width * 0.045),
                  ],

                  if (_filteredGrounds.isNotEmpty) ...[
                    _buildSectionLabel('Select Ground', size),
                    SizedBox(height: size.width * 0.025),
                    _buildGroundSelector(size),
                    SizedBox(height: size.width * 0.045),
                  ],

                  _buildSectionLabel('Select Date', size),
                  SizedBox(height: size.width * 0.025),
                  _buildDateSelector(size),
                  SizedBox(height: size.width * 0.045),

                  // ── Closed-day banner ──
                  if (!bounds.isOpen)
                    _buildClosedDayBanner(size)
                  else ...[
                    // ── Hours badge ──
                    _buildHoursBadge(bounds, size),
                    SizedBox(height: size.width * 0.03),

                    _buildLegend(size),
                    SizedBox(height: size.width * 0.03),

                    _loadingSlots
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: size.width * 0.1,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1E1E82),
                              ),
                            ),
                          )
                        : _buildSlotGrid(size),
                  ],

                  SizedBox(height: size.width * 0.06),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────
  Widget _buildHeader(Size size) {
    final hasPoster = _posterUrls.isNotEmpty;
    final headerHeight = hasPoster ? size.width * 0.45 : size.width * 0.28;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          hasPoster
              ? PageView.builder(
                  itemCount: _posterUrls.length,
                  onPageChanged: (i) => setState(() {
                    _currentPosterIndex = i;
                  }),
                  itemBuilder: (_, i) => Image.network(
                    _posterUrls[i],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF1E1E82),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E1E82), Color(0xFF3636B8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.sports_soccer_outlined,
                      size: 56,
                      color: Colors.white.withAlpha(60),
                    ),
                  ),
                ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: headerHeight * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withAlpha(180)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          if (_posterUrls.length > 1)
            Positioned(
              bottom: 44,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _posterUrls.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _currentPosterIndex ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == _currentPosterIndex
                          ? Colors.white
                          : Colors.white.withAlpha(100),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 16,
            left: 20,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.turfData['name'] ?? 'Turf',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Medium',
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.turfData['city'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Regular',
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.currency_rupee,
                      size: 14,
                      color: Colors.white70,
                    ),
                    Text(
                      '${(widget.turfData['half_hour_price'] ?? 0).toStringAsFixed(0)}/30min',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Regular',
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(130),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(130),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Get.to(
                  () => TurfAnalyticspage(
                    turfId: widget.turfId,
                    turfData: widget.turfData,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION LABEL
  // ─────────────────────────────────────────────
  Widget _buildSectionLabel(String title, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.width * 0.04,
          fontFamily: 'Medium',
          color: const Color(0xFF1E1E82),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FIELD SIZE SELECTOR
  // ─────────────────────────────────────────────
  Widget _buildFieldSizeSelector(Size size) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: size.width * 0.045),
          Row(
            children: _uniqueFieldSizes.map((fs) {
              final isSelected = _selectedFieldSize == fs;
              final groundCount = _grounds
                  .where((g) => g['fieldSize'] == fs)
                  .length;

              return Container(
                height: size.width * 0.2,
                padding: EdgeInsets.only(right: size.width * 0.045),
                width: size.width * 0.3,
                child: GestureDetector(
                  onTap: () {
                    if (_selectedFieldSize == fs) return;
                    setState(() {
                      _selectedFieldSize = fs;
                      _applyGroundFilter();
                      _bookedSlots = {};
                      _blockedSlots = {};
                    });
                    _fetchSlots();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1E1E82)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1E1E82)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? const Color(0xFF1E1E82).withAlpha(90)
                              : Colors.black.withAlpha(15),
                          blurRadius: isSelected ? 8 : 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            fs,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: size.width * 0.03,
                              fontFamily: 'Medium',
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1E1E82),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withAlpha(30)
                                  : const Color(0xFF1E1E82).withAlpha(12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$groundCount ground${groundCount == 1 ? '' : 's'}',
                              style: TextStyle(
                                fontSize: size.width * 0.022,
                                fontFamily: 'Regular',
                                color: isSelected
                                    ? Colors.white.withAlpha(210)
                                    : const Color(0xFF1E1E82).withAlpha(160),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GROUND SELECTOR
  // ─────────────────────────────────────────────
  Widget _buildGroundSelector(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Wrap(
        spacing: size.width * 0.025,
        runSpacing: size.width * 0.025,
        children: _filteredGrounds.asMap().entries.map((entry) {
          final index = entry.key;
          final ground = entry.value;
          final isSelected = _selectedGroundIndex == index;

          return GestureDetector(
            onTap: () {
              if (_selectedGroundIndex == index) return;
              setState(() {
                _selectedGroundIndex = index;
                _bookedSlots = {};
                _blockedSlots = {};
              });
              _fetchSlots();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E1E82) : Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E1E82)
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFF1E1E82).withAlpha(100)
                        : Colors.black.withAlpha(12),
                    blurRadius: isSelected ? 6 : 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.width * 0.025,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sports_soccer,
                      size: size.width * 0.045,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1E1E82),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Text(
                      ground['name'] ?? 'Ground',
                      style: TextStyle(
                        fontSize: size.width * 0.035,
                        fontFamily: 'Medium',
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1E1E82),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DATE SELECTOR
  // ─────────────────────────────────────────────
  Widget _buildDateSelector(Size size) {
    return SizedBox(
      height: size.width * 0.14,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
        itemCount: _tabs.length,
        itemBuilder: (_, index) {
          final isSelected = _selectedDayIndex == index;
          final isToday = index == 0;

          return GestureDetector(
            onTap: () {
              if (_selectedDayIndex == index) return;
              setState(() {
                _selectedDayIndex = index;
                _bookedSlots = {};
                _blockedSlots = {};
              });
              _fetchSlots();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: index < _tabs.length - 1
                  ? EdgeInsets.only(right: size.width * 0.03)
                  : EdgeInsets.zero,
              width: size.width * 0.2,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E1E82) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E1E82)
                      : isToday
                      ? const Color(0xFF3636B8)
                      : Colors.grey.shade300,
                  width: isToday && !isSelected ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFF1E1E82).withAlpha(80)
                        : Colors.black.withAlpha(12),
                    blurRadius: isSelected ? 6 : 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.width * 0.005),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        _tabs[index][0].split(' ').first,
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontFamily: 'Medium',
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1E1E82),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _tabs[index][0].split(' ').last,
                        style: TextStyle(
                          fontSize: size.width * 0.024,
                          fontFamily: 'Regular',
                          color: isSelected
                              ? Colors.white.withAlpha(180)
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.015),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CLOSED DAY BANNER
  // ─────────────────────────────────────────────
  Widget _buildClosedDayBanner(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.045,
        vertical: size.width * 0.06,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.orange.shade300, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: size.width * 0.12,
              color: Colors.orange.shade500,
            ),
            SizedBox(height: size.width * 0.03),
            Text(
              'Holiday',
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontFamily: 'Medium',
                color: Colors.orange.shade800,
              ),
            ),
            SizedBox(height: size.width * 0.015),
            Text(
              'This turf is closed on ${_capitalize(_getSelectedDayKey())}s.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.03,
                fontFamily: 'Regular',
                color: Colors.orange.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HOURS BADGE  (shows "6:00 AM – 10:00 PM" for the selected day)
  // ─────────────────────────────────────────────
  Widget _buildHoursBadge(_DayBounds bounds, Size size) {
    final startLabel = _minutesToLabel(
      bounds.startHour * 60 + bounds.startMinute,
    );
    final endLabel = _minutesToLabel(bounds.endHour * 60 + bounds.endMinute);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.width * 0.025,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E82).withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E1E82).withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_filled,
              size: 18,
              color: Color(0xFF1E1E82),
            ),
            const SizedBox(width: 10),
            Text(
              'Operating Hours:',
              style: TextStyle(
                fontSize: size.width * 0.03,
                fontFamily: 'Regular',
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$startLabel – $endLabel',
              style: TextStyle(
                fontSize: size.width * 0.035,
                fontFamily: 'Medium',
                color: const Color(0xFF1E1E82),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // LEGEND
  // ─────────────────────────────────────────────
  Widget _buildLegend(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Row(
        children: [
          _legendItem(Colors.green.shade400, 'Free', size),
          SizedBox(width: size.width * 0.05),
          _legendItem(Colors.red.shade300, 'Blocked', size),
          SizedBox(width: size.width * 0.05),
          _legendItem(Colors.grey.shade400, 'Booked', size),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, Size size) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: size.width * 0.028,
            fontFamily: 'Regular',
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SLOT GRID
  // ─────────────────────────────────────────────
  Widget _buildSlotGrid(Size size) {
    final slotsToShow = _visibleSlots;

    if (slotsToShow.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.045,
          vertical: size.width * 0.08,
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.access_time_filled,
                size: size.width * 0.12,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: size.width * 0.04),
              Text(
                'No slots available',
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontFamily: 'Medium',
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: size.width * 0.015),
              Text(
                'All slots for today have passed.\nPick a future date to manage slots.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.03,
                  fontFamily: 'Regular',
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
      child: Column(
        children: slotsToShow.map((slot) {
          final isBooked = _bookedSlots.contains(slot);
          final isBlocked = _blockedSlots.contains(slot);

          final Color bgColor, borderColor, textColor, iconColor;
          IconData? statusIcon;
          String statusLabel;

          if (isBooked) {
            bgColor = Colors.grey.shade300;
            borderColor = Colors.grey.shade400;
            textColor = Colors.grey.shade700;
            iconColor = Colors.grey.shade600;
            statusIcon = Icons.person_outlined;
            statusLabel = 'Booked';
          } else if (isBlocked) {
            bgColor = Colors.red.shade100;
            borderColor = Colors.red.shade300;
            textColor = Colors.red.shade800;
            iconColor = Colors.red.shade600;
            statusIcon = Icons.lock_outlined;
            statusLabel = 'Blocked';
          } else {
            bgColor = Colors.white;
            borderColor = Colors.grey.shade200;
            textColor = const Color(0xFF1E1E82);
            iconColor = Colors.green.shade500;
            statusIcon = null;
            statusLabel = 'Free';
          }

          return GestureDetector(
            onTap: () => _showSlotOptions(slot),
            child: Container(
              margin: EdgeInsets.only(bottom: size.width * 0.022),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.width * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      slot,
                      style: TextStyle(
                        fontSize: size.width * 0.038,
                        fontFamily: 'Medium',
                        color: textColor,
                      ),
                    ),
                    Row(
                      children: [
                        if (statusIcon != null)
                          Icon(
                            statusIcon,
                            size: size.width * 0.04,
                            color: iconColor,
                          ),
                        SizedBox(width: size.width * 0.02),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: iconColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: size.width * 0.025,
                              fontFamily: 'Regular',
                              color: iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

// ─────────────────────────────────────────────
// Simple data holder returned by _getBoundsForSelectedDay
// ─────────────────────────────────────────────
class _DayBounds {
  final bool isOpen;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  const _DayBounds({
    this.isOpen = true,
    this.startHour = 6,
    this.startMinute = 0,
    this.endHour = 22,
    this.endMinute = 0,
  });
}
