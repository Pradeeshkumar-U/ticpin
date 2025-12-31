// //
// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/size.dart';

// class SportsBookingPage extends StatefulWidget {
//   final String turfId;
//   final Map<String, dynamic> turfData;

//   const SportsBookingPage({
//     super.key,
//     required this.turfId,
//     required this.turfData,
//   });

//   @override
//   State<SportsBookingPage> createState() => _SportsBookingPageState();
// }

// class _SportsBookingPageState extends State<SportsBookingPage>
//     with TickerProviderStateMixin {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late TabController _tabController;
//   final PageController _pageController = PageController();

//   int _selectedIndex = 0;
//   int _selectedDayIndex = 0;
//   Sizes size = Sizes();
//   late final List<List<String>> tabs;

//   // Field size selection
//   String selectedFieldSize = '4x4';
//   List<String> availableFieldSizes = ['4x4'];

//   // Sessions
//   final sessions = ["Twilight", "Morning", "Afternoon", "Evening"];
//   Map<String, List<IntervalSlot>> selectedIntervals = {
//     "Twilight": [],
//     "Morning": [],
//     "Afternoon": [],
//     "Evening": [],
//   };

//   Map<String, double> sessionDurations = {
//     "Twilight": 0.0,
//     "Morning": 0.0,
//     "Afternoon": 0.0,
//     "Evening": 0.0,
//   };

//   // Booked slots (fetched from Firestore)
//   Set<String> bookedSlots = {};
//   bool loadingSlots = false;

//   @override
//   void initState() {
//     super.initState();
//     tabs = _generateNextDays(15);
//     _tabController = TabController(length: tabs.length, vsync: this)
//       ..addListener(() {
//         if (mounted) {
//           setState(() {
//             _selectedDayIndex = _tabController.index;
//           });
//           _fetchBookedSlots();
//         }
//       });

//     // Load available field sizes from turf data
//     final sizes = widget.turfData['available_field_sizes'];
//     if (sizes != null && sizes is List && sizes.isNotEmpty) {
//       availableFieldSizes = List<String>.from(sizes);
//       selectedFieldSize = availableFieldSizes.first;
//     }

//     _fetchBookedSlots();
//   }

//   // Fetch booked slots for selected date and field size
//   Future<void> _fetchBookedSlots() async {
//     if (!mounted) return;

//     setState(() {
//       loadingSlots = true;
//     });

//     try {
//       final selectedDate = _getSelectedDate();
//       final docId = '${widget.turfId}_${selectedDate}_$selectedFieldSize';

//       final slotsDoc =
//           await _firestore.collection('turf_slots').doc(docId).get();

//       if (slotsDoc.exists) {
//         final slots = slotsDoc.data()!['slots'] as Map<String, dynamic>?;
//         if (slots != null) {
//           if (mounted) {
//             setState(() {
//               bookedSlots =
//                   slots.entries
//                       .where((e) => e.value == true)
//                       .map((e) => e.key as String)
//                       .toSet();
//             });
//           }
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             bookedSlots = {};
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching booked slots: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           loadingSlots = false;
//         });
//       }
//     }
//   }

//   String _getSelectedDate() {
//     final today = DateTime.now();
//     final selectedDay = today.add(Duration(days: _selectedDayIndex));
//     return DateFormat('yyyy-MM-dd').format(selectedDay);
//   }

//   DateTime parseTime(String t) => DateFormat("h:mm a").parse(t);

//   bool _isSlotInPast(String timeSlot) {
//     final selectedDate = _getSelectedDate();
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

//     // If not today, it's not in the past
//     if (selectedDate != today) return false;

//     // Parse the time slot and check if it's past current time
//     try {
//       final slotTime = parseTime(timeSlot);
//       final now = DateTime.now();
//       final slotDateTime = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         slotTime.hour,
//         slotTime.minute,
//       );
//       return slotDateTime.isBefore(now);
//     } catch (e) {
//       return false;
//     }
//   }

//   void computeDuration(String session) {
//     final list = selectedIntervals[session]!;
//     if (list.isEmpty) {
//       setState(() {
//         sessionDurations[session] = 0.0;
//       });
//       return;
//     }

//     DateTime firstStart = parseTime(list.first.start);
//     DateTime lastEnd = parseTime(list.last.end);
//     Duration diff = lastEnd.difference(firstStart);
//     double hours = diff.inMinutes / 60.0;

//     setState(() {
//       sessionDurations[session] = hours;
//     });
//   }

//   bool areContinuous(List<IntervalSlot> slots) {
//     if (slots.length <= 1) return true;
//     slots.sort((a, b) => parseTime(a.start).compareTo(parseTime(b.start)));
//     for (int i = 0; i < slots.length - 1; i++) {
//       if (slots[i].end != slots[i + 1].start) return false;
//     }
//     return true;
//   }

//   List<IntervalSlot> buildIntervals(List<String> times) {
//     List<IntervalSlot> intervals = [];
//     for (int i = 0; i < times.length - 1; i++) {
//       intervals.add(IntervalSlot(times[i], times[i + 1]));
//     }
//     return intervals;
//   }

//   void onIntervalTap(String session, IntervalSlot interval) {
//     // Check if slot is booked
//     if (bookedSlots.contains(interval.start)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('This time slot is already booked'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Check if slot is in the past
//     if (_isSlotInPast(interval.start)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Cannot book past time slots'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     final list = selectedIntervals[session]!;

//     if (list.contains(interval)) {
//       setState(() {
//         list.remove(interval);
//       });
//       computeDuration(session);
//       return;
//     }

//     if (list.isEmpty) {
//       setState(() {
//         list.add(interval);
//       });
//       computeDuration(session);
//       return;
//     }

//     List<IntervalSlot> tempList = [...list, interval];
//     if (areContinuous(tempList)) {
//       setState(() {
//         list.add(interval);
//         list.sort((a, b) => parseTime(a.start).compareTo(parseTime(b.start)));
//       });
//       computeDuration(session);
//     } else {
//       setState(() {
//         list.clear();
//         list.add(interval);
//       });
//       computeDuration(session);
//     }
//   }

//   Widget buildIntervalUIUp(String session, List<String> timeLabels) {
//     final intervals = buildIntervals(timeLabels);

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children:
//                 timeLabels.map((t) {
//                   String display =
//                       t.contains(":30") ? "•" : t.replaceAll(":00", "").trim();
//                   return Expanded(
//                     child: Center(
//                       child: Text(
//                         display,
//                         style: TextStyle(
//                           fontSize: display == "•" ? 22 : 14,
//                           fontFamily: 'Regular',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//           ),
//         ),
//         SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:
//               intervals.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 IntervalSlot interval = entry.value;
//                 bool isSelected = selectedIntervals[session]!.contains(
//                   interval,
//                 );
//                 bool isBooked = bookedSlots.contains(interval.start);
//                 bool isPast = _isSlotInPast(interval.start);

//                 return GestureDetector(
//                   onTap: () {
//                     if (!isBooked && !isPast) {
//                       onIntervalTap(session, interval);
//                     }
//                   },
//                   child: Container(
//                     height: 30,
//                     margin:
//                         index == 0
//                             ? EdgeInsets.only(left: 10)
//                             : index == intervals.length - 1
//                             ? EdgeInsets.only(right: 10)
//                             : EdgeInsets.zero,
//                     width: size.safeWidth * 0.14,
//                     decoration: BoxDecoration(
//                       borderRadius:
//                           index == 0
//                               ? BorderRadius.horizontal(
//                                 left: Radius.circular(12),
//                               )
//                               : index == intervals.length - 1
//                               ? BorderRadius.horizontal(
//                                 right: Radius.circular(12),
//                               )
//                               : BorderRadius.zero,
//                       border: Border.all(
//                         width: 1,
//                         color:
//                             isBooked || isPast
//                                 ? Colors.grey.shade400
//                                 : isSelected
//                                 ? const Color.fromARGB(255, 193, 173, 255)
//                                 : Colors.black26,
//                       ),
//                       color:
//                           isBooked
//                               ? Colors.grey.shade300
//                               : isPast
//                               ? Colors.grey.shade200
//                               : isSelected
//                               ? const Color.fromARGB(
//                                 255,
//                                 193,
//                                 173,
//                                 255,
//                               ).withAlpha(150)
//                               : Colors.white,
//                     ),
//                     child:
//                         isBooked
//                             ? Icon(
//                               Icons.lock,
//                               size: 16,
//                               color: Colors.grey.shade600,
//                             )
//                             : isPast
//                             ? Icon(
//                               Icons.access_time,
//                               size: 14,
//                               color: Colors.grey.shade400,
//                             )
//                             : null,
//                   ),
//                 );
//               }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget buildIntervalUIDown(String session, List<String> timeLabels) {
//     final intervals = buildIntervals(timeLabels);

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:
//               intervals.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 IntervalSlot interval = entry.value;
//                 bool isSelected = selectedIntervals[session]!.contains(
//                   interval,
//                 );
//                 bool isBooked = bookedSlots.contains(interval.start);
//                 bool isPast = _isSlotInPast(interval.start);

//                 return GestureDetector(
//                   onTap: () {
//                     if (!isBooked && !isPast) {
//                       onIntervalTap(session, interval);
//                     }
//                   },
//                   child: Container(
//                     height: 30,
//                     margin:
//                         index == 0
//                             ? EdgeInsets.only(left: 10)
//                             : index == intervals.length - 1
//                             ? EdgeInsets.only(right: 10)
//                             : EdgeInsets.zero,
//                     width: size.safeWidth * 0.14,
//                     decoration: BoxDecoration(
//                       borderRadius:
//                           index == 0
//                               ? BorderRadius.horizontal(
//                                 left: Radius.circular(12),
//                               )
//                               : index == intervals.length - 1
//                               ? BorderRadius.horizontal(
//                                 right: Radius.circular(12),
//                               )
//                               : BorderRadius.zero,
//                       border: Border.all(
//                         width: 1,
//                         color:
//                             isBooked || isPast
//                                 ? Colors.grey.shade400
//                                 : isSelected
//                                 ? const Color.fromARGB(255, 193, 173, 255)
//                                 : Colors.black26,
//                       ),
//                       color:
//                           isBooked
//                               ? Colors.grey.shade300
//                               : isPast
//                               ? Colors.grey.shade200
//                               : isSelected
//                               ? const Color.fromARGB(
//                                 255,
//                                 193,
//                                 173,
//                                 255,
//                               ).withAlpha(150)
//                               : Colors.white,
//                     ),
//                     child:
//                         isBooked
//                             ? Icon(
//                               Icons.lock,
//                               size: 16,
//                               color: Colors.grey.shade600,
//                             )
//                             : isPast
//                             ? Icon(
//                               Icons.access_time,
//                               size: 14,
//                               color: Colors.grey.shade400,
//                             )
//                             : null,
//                   ),
//                 );
//               }).toList(),
//         ),
//         SizedBox(height: 8),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children:
//                 timeLabels.map((t) {
//                   String display =
//                       t.contains(":30") ? "•" : t.replaceAll(":00", "").trim();
//                   return Expanded(
//                     child: Center(
//                       child: Text(
//                         display,
//                         style: TextStyle(
//                           fontSize: display == "•" ? 22 : 14,
//                           fontFamily: 'Regular',
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//           ),
//         ),
//         // if (sessionDurations[session]! > 0) ...[
//         //   SizedBox(height: 8),
//         //   Container(
//         //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         //     decoration: BoxDecoration(
//         //       color: Colors.green.shade50,
//         //       borderRadius: BorderRadius.circular(8),
//         //       border: Border.all(color: Colors.green.shade300),
//         //     ),
//         //     child: Row(
//         //       mainAxisSize: MainAxisSize.min,
//         //       children: [
//         //         Icon(Icons.access_time, size: 16, color: Colors.green.shade700),
//         //         SizedBox(width: 6),
//         //         Text(
//         //           'Duration: ${sessionDurations[session]!.toStringAsFixed(1)} hours',
//         //           style: TextStyle(
//         //             fontSize: 13,
//         //             fontWeight: FontWeight.w600,
//         //             color: Colors.green.shade700,
//         //             fontFamily: 'Regular',
//         //           ),
//         //         ),
//         //       ],
//         //     ),
//         // ),
//         // ],
//       ],
//     );
//   }

//   Widget buildSessionPage(int index) {
//     final session = sessions[index];
//     final slots = allTimes[index];
//     int half = (slots.length / 2).ceil();
//     final firstHalf = slots.sublist(0, half);
//     final secondHalf = slots.sublist(half - 1);

//     return SingleChildScrollView(
//       physics: NeverScrollableScrollPhysics(),
//       child: Column(
//         children: [
//           SizedBox(height: 10),
//           if (loadingSlots)
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//           buildIntervalUIUp(session, firstHalf),
//           SizedBox(height: 20),
//           buildIntervalUIDown(session, secondHalf),
//           SizedBox(height: 20),
//           if (selectedIntervals[session]!.isNotEmpty)
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 193, 173, 255).withAlpha(150),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: const Color.fromARGB(255, 193, 173, 255),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '$session Session Summary:',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Regular',
//                       color: blackColor,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Start: ${selectedIntervals[session]!.first.start}',
//                     style: TextStyle(fontSize: 14, fontFamily: 'Regular'),
//                   ),
//                   Text(
//                     'End: ${selectedIntervals[session]!.last.end}',
//                     style: TextStyle(fontSize: 14, fontFamily: 'Regular'),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Total: ${sessionDurations[session]!.toStringAsFixed(1)} hours',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Regular',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           SizedBox(height: size.safeWidth * 0.05),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               sessions.length,
//               (index) => AnimatedContainer(
//                 duration: Duration(milliseconds: 250),
//                 margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                 width: _selectedIndex == index ? 22 : 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color:
//                       _selectedIndex == index
//                           ? const Color.fromARGB(255, 193, 173, 255)
//                           : Colors.grey,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildTabItem(int index) {
//     final isSelected = _tabController.index == index;
//     return InkWell(
//       enableFeedback: true,
//       borderRadius: BorderRadius.circular(15),
//       onTap: () {
//         HapticFeedback.lightImpact();
//         _tabController.animateTo(index);
//       },
//       child: AnimatedContainer(
//         width: size.safeWidth * 0.19,
//         curve: Curves.bounceIn,
//         duration: Duration(seconds: 4),
//         padding: EdgeInsets.symmetric(vertical: size.safeWidth * 0.02),
//         decoration:
//             isSelected
//                 ? BoxDecoration(
//                   color: Color(0xFFCFCFFA),
//                   borderRadius: BorderRadius.circular(15),
//                 )
//                 : null,
//         child: defaultTab(tabs[index][0], tabs[index][1], isSelected),
//       ),
//     );
//   }

//   static Tab defaultTab(String name, String details, bool isSelected) {
//     return Tab(
//       child: FittedBox(
//         fit: BoxFit.scaleDown,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               name,
//               style: TextStyle(
//                 fontSize: Sizes().width * 0.031,
//                 color: blackColor,
//                 fontFamily: 'Medium',
//               ),
//             ),
//             Text(
//               details,
//               style: TextStyle(
//                 fontSize: Sizes().width * 0.03,
//                 color: blackColor,
//                 fontFamily: 'Medium',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<List<String>> _generateNextDays(int count) {
//     final List<List<String>> days = [];
//     final today = DateTime.now();
//     for (int i = 0; i < count; i++) {
//       final date = today.add(Duration(days: i));
//       final dayString = DateFormat('d MMM').format(date);
//       final weekDayString = DateFormat('EEE').format(date);
//       days.add([dayString, weekDayString]);
//     }
//     return days;
//   }

//   final List<List<String>> allTimes = [
//     [
//       "12:00 AM",
//       "12:30 AM",
//       "1:00 AM",
//       "1:30 AM",
//       "2:00 AM",
//       "2:30 AM",
//       "3:00 AM",
//       "3:30 AM",
//       "4:00 AM",
//       "4:30 AM",
//       "5:00 AM",
//       "5:30 AM",
//       "6:00 AM",
//     ],
//     [
//       "6:00 AM",
//       "6:30 AM",
//       "7:00 AM",
//       "7:30 AM",
//       "8:00 AM",
//       "8:30 AM",
//       "9:00 AM",
//       "9:30 AM",
//       "10:00 AM",
//       "10:30 AM",
//       "11:00 AM",
//       "11:30 AM",
//       "12:00 PM",
//     ],
//     [
//       "12:00 PM",
//       "12:30 PM",
//       "1:00 PM",
//       "1:30 PM",
//       "2:00 PM",
//       "2:30 PM",
//       "3:00 PM",
//       "3:30 PM",
//       "4:00 PM",
//       "4:30 PM",
//       "5:00 PM",
//       "5:30 PM",
//       "6:00 PM",
//     ],
//     [
//       "6:00 PM",
//       "6:30 PM",
//       "7:00 PM",
//       "7:30 PM",
//       "8:00 PM",
//       "8:30 PM",
//       "9:00 PM",
//       "9:30 PM",
//       "10:00 PM",
//       "10:30 PM",
//       "11:00 PM",
//       "11:30 PM",
//       "12:00 AM",
//     ],
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         surfaceTintColor: whiteColor,
//         backgroundColor: whiteColor,
//         centerTitle: true,
//         title: Text(
//           widget.turfData['name'] ?? 'Book Turf',
//           style: TextStyle(fontFamily: 'Regular'),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Text(
//               "Select Field Size, Day and Time",
//               style: TextStyle(
//                 fontFamily: 'Regular',
//                 fontSize: size.safeWidth * 0.045,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),

//           // Field Size Selection
//           if (availableFieldSizes.length > 1)
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     availableFieldSizes.map((size) {
//                       final isSelected = selectedFieldSize == size;
//                       return Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: ChoiceChip(
//                           label: Text(
//                             size,
//                             style: TextStyle(fontFamily: 'Regular'),
//                           ),
//                           selected: isSelected,
//                           onSelected: (selected) {
//                             if (selected) {
//                               setState(() {
//                                 selectedFieldSize = size;
//                                 // Clear selections when changing field size
//                                 selectedIntervals.forEach((key, value) {
//                                   value.clear();
//                                 });
//                                 sessionDurations.forEach((key, value) {
//                                   sessionDurations[key] = 0.0;
//                                 });
//                               });
//                               _fetchBookedSlots();
//                             }
//                           },
//                           selectedColor: Color.fromARGB(255, 193, 173, 255),
//                           backgroundColor: Colors.grey.shade200,
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ),

//           SizedBox(height: size.safeWidth * 0.02),

//           // Day Selection
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 SizedBox(width: size.safeWidth * 0.01),
//                 SizedBox(
//                   child: ButtonsTabBar(
//                     controller: _tabController,
//                     unselectedBackgroundColor: Colors.black12,
//                     unselectedBorderColor: Colors.transparent,
//                     backgroundColor: Color.fromARGB(255, 193, 173, 255),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: size.safeWidth * 0.01,
//                     ),
//                     contentCenter: true,
//                     borderColor: Colors.black,
//                     borderWidth: 1,
//                     onTap: (index) {},
//                     width: size.safeWidth * 0.22,
//                     radius: 15,
//                     height: size.safeWidth * 0.17,
//                     buttonMargin: EdgeInsets.symmetric(horizontal: 12),
//                     splashColor: Colors.transparent,
//                     duration: 0,
//                     tabs: List.generate(tabs.length, (index) {
//                       return Tab(
//                         child: Expanded(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 5.0),
//                             child: defaultTab(
//                               tabs[index][0],
//                               tabs[index][1],
//                               _tabController.index == index,
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//                 SizedBox(width: size.safeWidth * 0.01),
//               ],
//             ),
//           ),

//           // Session Selection
//           Padding(
//             padding: EdgeInsets.only(
//               top: size.safeWidth * 0.06,
//               left: size.safeWidth * 0.05,
//               right: size.safeWidth * 0.05,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: List.generate(sessions.length, (index) {
//                 final isSelected = _selectedIndex == index;
//                 return Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: size.safeWidth * 0.01,
//                     ),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() => _selectedIndex = index);
//                         _pageController.jumpToPage(index);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color:
//                               isSelected
//                                   ? const Color.fromARGB(255, 193, 173, 255)
//                                   : Colors.black12,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Center(
//                           child: FittedBox(
//                             child: Text(
//                               sessions[index],
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: size.safeWidth * 0.03,
//                                 fontFamily: 'Regular',
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),

//           SizedBox(height: 8),

//           // Time Slots
//           SizedBox(
//             width: double.infinity,
//             height: size.safeHeight * 0.5,
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: sessions.length,
//               onPageChanged: (i) => setState(() => _selectedIndex = i),
//               itemBuilder: (context, index) => buildSessionPage(index),
//             ),
//           ),

//           // Page Indicators
//         ],
//       ),
//     );
//   }
// }

// // IntervalSlot class
// class IntervalSlot {
//   final String start;
//   final String end;

//   IntervalSlot(this.start, this.end);

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is IntervalSlot &&
//           runtimeType == other.runtimeType &&
//           start == other.start &&
//           end == other.end;

//   @override
//   int get hashCode => start.hashCode ^ end.hashCode;
// }

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/sports/checkoutpage.dart';
import 'package:ticpin/pages/view/sports/snacksbar.dart';

class SportsBookingPage extends StatefulWidget {
  final String turfId;
  final Map<String, dynamic> turfData;

  const SportsBookingPage({
    super.key,
    required this.turfId,
    required this.turfData,
  });

  @override
  State<SportsBookingPage> createState() => _SportsBookingPageState();
}

class _SportsBookingPageState extends State<SportsBookingPage>
    with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TabController _tabController;
  final BookingTimerService _timerService = BookingTimerService();
  bool _hasPendingBooking = false;

  final PageController _pageController = PageController();

  int _selectedIndex = 0;
  int _selectedDayIndex = 0;
  Sizes size = Sizes();
  late final List<List<String>> tabs;

  // Field size selection
  String selectedFieldSize = '4x4';
  List<String> availableFieldSizes = ['4x4'];

  // Sessions
  final sessions = ["Twilight", "Morning", "Afternoon", "Evening"];
  Map<String, List<IntervalSlot>> selectedIntervals = {
    "Twilight": [],
    "Morning": [],
    "Afternoon": [],
    "Evening": [],
  };

  Map<String, double> sessionDurations = {
    "Twilight": 0.0,
    "Morning": 0.0,
    "Afternoon": 0.0,
    "Evening": 0.0,
  };

  // Booked slots (fetched from Firestore)
  Set<String> bookedSlots = {};
  bool loadingSlots = false;

  Future<void> _checkPendingBooking() async {
    await _timerService.checkPendingBookings();

    final pendingBooking = _timerService.currentPendingBooking;

    if (pendingBooking != null && pendingBooking.turfId == widget.turfId) {
      setState(() {
        _hasPendingBooking = true;
      });

      // Show dialog and redirect to checkout
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: Text(
                  'Pending Payment',
                  style: TextStyle(fontFamily: 'Regular'),
                ),
                content: Text(
                  'You have a pending payment for this turf. Please complete the payment or wait for it to expire before making a new booking.',
                  style: TextStyle(fontFamily: 'Regular'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to turf page
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontFamily: 'Regular'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TurfCheckoutPage(
                                turfId: widget.turfId,
                                turfData: widget.turfData,
                                selectedDate: pendingBooking.date,
                                fieldSize: pendingBooking.fieldSize,
                                session: pendingBooking.session,
                                slots:
                                    pendingBooking.slots
                                        .map(
                                          (s) => IntervalSlot(
                                            s['start'] as String,
                                            s['end'] as String,
                                          ),
                                        )
                                        .toList(),
                                totalHours: pendingBooking.totalHours,
                                totalAmount: pendingBooking.totalAmount,
                                existingBookingId: pendingBooking.bookingId,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blackColor,
                    ),
                    child: Text(
                      'Complete Payment',
                      style: TextStyle(
                        fontFamily: 'Regular',
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tabs = _generateNextDays(15);
    _checkPendingBooking();
    _tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(() {
        if (mounted) {
          setState(() {
            _selectedDayIndex = _tabController.index;
            // Clear all selections when switching dates
            _clearAllSelections();
          });
          _fetchBookedSlots();
        }
      });

    // Load available field sizes from turf data
    final sizes = widget.turfData['available_field_sizes'];
    if (sizes != null && sizes is List && sizes.isNotEmpty) {
      availableFieldSizes = List<String>.from(sizes);
      selectedFieldSize = availableFieldSizes.first;
    }

    _fetchBookedSlots();
  }

  void _clearAllSelections() {
    selectedIntervals.forEach((key, value) {
      value.clear();
    });
    sessionDurations.forEach((key, value) {
      sessionDurations[key] = 0.0;
    });
  }

  // Fetch booked slots for selected date and field size
  Future<void> _fetchBookedSlots() async {
    if (!mounted) return;

    setState(() {
      loadingSlots = true;
    });

    try {
      final selectedDate = _getSelectedDate();
      final docId = '${widget.turfId}_${selectedDate}_$selectedFieldSize';

      final slotsDoc =
          await _firestore.collection('turf_slots').doc(docId).get();

      if (slotsDoc.exists) {
        final slots = slotsDoc.data()!['slots'] as Map<String, dynamic>?;
        if (slots != null) {
          if (mounted) {
            setState(() {
              bookedSlots =
                  slots.entries
                      .where((e) => e.value == true)
                      .map((e) => e.key as String)
                      .toSet();
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            bookedSlots = {};
          });
        }
      }
    } catch (e) {
      print('Error fetching booked slots: $e');
    } finally {
      if (mounted) {
        setState(() {
          loadingSlots = false;
        });
      }
    }
  }

  String _getSelectedDate() {
    final today = DateTime.now();
    final selectedDay = today.add(Duration(days: _selectedDayIndex));
    return DateFormat('yyyy-MM-dd').format(selectedDay);
  }

  DateTime parseTime(String t) => DateFormat("h:mm a").parse(t);

  bool _isSlotInPast(String timeSlot) {
    final selectedDate = _getSelectedDate();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (selectedDate != today) return false;

    try {
      final slotTime = parseTime(timeSlot);
      final now = DateTime.now();
      final slotDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        slotTime.hour,
        slotTime.minute,
      );
      return slotDateTime.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  void computeDuration(String session) {
    final list = selectedIntervals[session]!;
    if (list.isEmpty) {
      setState(() {
        sessionDurations[session] = 0.0;
      });
      return;
    }

    DateTime firstStart = parseTime(list.first.start);
    DateTime lastEnd = parseTime(list.last.end);
    Duration diff = lastEnd.difference(firstStart);
    double hours = diff.inMinutes / 60.0;

    setState(() {
      sessionDurations[session] = hours;
    });
  }

  bool areContinuous(List<IntervalSlot> slots) {
    if (slots.length <= 1) return true;
    slots.sort((a, b) => parseTime(a.start).compareTo(parseTime(b.start)));
    for (int i = 0; i < slots.length - 1; i++) {
      if (slots[i].end != slots[i + 1].start) return false;
    }
    return true;
  }

  List<IntervalSlot> buildIntervals(List<String> times) {
    List<IntervalSlot> intervals = [];
    for (int i = 0; i < times.length - 1; i++) {
      intervals.add(IntervalSlot(times[i], times[i + 1]));
    }
    return intervals;
  }

  void onIntervalTap(String session, IntervalSlot interval) {
    if (bookedSlots.contains(interval.start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This time slot is already booked'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isSlotInPast(interval.start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot book past time slots'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final list = selectedIntervals[session]!;

    if (list.contains(interval)) {
      setState(() {
        list.remove(interval);
      });
      computeDuration(session);
      return;
    }

    if (list.isEmpty) {
      setState(() {
        list.add(interval);
      });
      computeDuration(session);
      return;
    }

    List<IntervalSlot> tempList = [...list, interval];
    if (areContinuous(tempList)) {
      setState(() {
        list.add(interval);
        list.sort((a, b) => parseTime(a.start).compareTo(parseTime(b.start)));
      });
      computeDuration(session);
    } else {
      setState(() {
        list.clear();
        list.add(interval);
      });
      computeDuration(session);
    }
  }

  // Check if any session has selections
  bool hasAnySelections() {
    return selectedIntervals.values.any((list) => list.isNotEmpty);
  }

  // Get total selected hours across all sessions
  double getTotalHours() {
    return sessionDurations.values.fold(0.0, (sum, hours) => sum + hours);
  }

  // void _proceedToCheckout() {
  //   // Find which session has selections
  //   String? selectedSession;
  //   for (var entry in selectedIntervals.entries) {
  //     if (entry.value.isNotEmpty) {
  //       selectedSession = entry.key;
  //       break;
  //     }
  //   }

  //   if (selectedSession == null) return;

  //   final slots = selectedIntervals[selectedSession]!;
  //   final pricePerHour = widget.turfData['half_hour_price'] * 2;
  //   final totalHours = sessionDurations[selectedSession]!;
  //   final totalAmount = (pricePerHour * totalHours).round();

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder:
  //           (context) => TurfCheckoutPage(
  //             turfId: widget.turfId,
  //             turfData: widget.turfData,
  //             selectedDate: _getSelectedDate(),
  //             fieldSize: selectedFieldSize,
  //             session: selectedSession!,
  //             slots: slots,
  //             totalHours: totalHours,
  //             totalAmount: totalAmount,
  //           ),
  //     ),
  //   ).then((_) {
  //     // Refresh slots after returning from checkout
  //     _fetchBookedSlots();
  //     _clearAllSelections();
  //   });
  // }

  Widget buildIntervalUIUp(String session, List<String> timeLabels) {
    final intervals = buildIntervals(timeLabels);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                timeLabels.map((t) {
                  String display =
                      t.contains(":30") ? "•" : t.replaceAll(":00", "").trim();
                  return Expanded(
                    child: Center(
                      child: Text(
                        display,
                        style: TextStyle(
                          fontSize: display == "•" ? 22 : 14,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              intervals.asMap().entries.map((entry) {
                int index = entry.key;
                IntervalSlot interval = entry.value;
                bool isSelected = selectedIntervals[session]!.contains(
                  interval,
                );
                bool isBooked = bookedSlots.contains(interval.start);
                bool isPast = _isSlotInPast(interval.start);

                return GestureDetector(
                  onTap: () {
                    if (!isBooked && !isPast) {
                      onIntervalTap(session, interval);
                    }
                  },
                  child: Container(
                    height: 30,
                    margin:
                        index == 0
                            ? EdgeInsets.only(left: 10)
                            : index == intervals.length - 1
                            ? EdgeInsets.only(right: 10)
                            : EdgeInsets.zero,
                    width: size.safeWidth * 0.14,
                    decoration: BoxDecoration(
                      borderRadius:
                          index == 0
                              ? BorderRadius.horizontal(
                                left: Radius.circular(12),
                              )
                              : index == intervals.length - 1
                              ? BorderRadius.horizontal(
                                right: Radius.circular(12),
                              )
                              : BorderRadius.zero,
                      border: Border.all(
                        width: 1,
                        color:
                            isBooked || isPast
                                ? Colors.grey.shade400
                                : isSelected
                                ? const Color.fromARGB(255, 193, 173, 255)
                                : Colors.black26,
                      ),
                      color:
                          isBooked
                              ? Colors.grey.shade300
                              : isPast
                              ? Colors.grey.shade200
                              : isSelected
                              ? const Color.fromARGB(
                                255,
                                193,
                                173,
                                255,
                              ).withAlpha(150)
                              : Colors.white,
                    ),
                    child:
                        isBooked
                            ? Icon(
                              Icons.lock,
                              size: 16,
                              color: Colors.grey.shade600,
                            )
                            : isPast
                            ? Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade400,
                            )
                            : null,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget buildIntervalUIDown(String session, List<String> timeLabels) {
    final intervals = buildIntervals(timeLabels);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              intervals.asMap().entries.map((entry) {
                int index = entry.key;
                IntervalSlot interval = entry.value;
                bool isSelected = selectedIntervals[session]!.contains(
                  interval,
                );
                bool isBooked = bookedSlots.contains(interval.start);
                bool isPast = _isSlotInPast(interval.start);

                return GestureDetector(
                  onTap: () {
                    if (!isBooked && !isPast) {
                      onIntervalTap(session, interval);
                    }
                  },
                  child: Container(
                    height: 30,
                    margin:
                        index == 0
                            ? EdgeInsets.only(left: 10)
                            : index == intervals.length - 1
                            ? EdgeInsets.only(right: 10)
                            : EdgeInsets.zero,
                    width: size.safeWidth * 0.14,
                    decoration: BoxDecoration(
                      borderRadius:
                          index == 0
                              ? BorderRadius.horizontal(
                                left: Radius.circular(12),
                              )
                              : index == intervals.length - 1
                              ? BorderRadius.horizontal(
                                right: Radius.circular(12),
                              )
                              : BorderRadius.zero,
                      border: Border.all(
                        width: 1,
                        color:
                            isBooked || isPast
                                ? Colors.grey.shade400
                                : isSelected
                                ? const Color.fromARGB(255, 193, 173, 255)
                                : Colors.black26,
                      ),
                      color:
                          isBooked
                              ? Colors.grey.shade300
                              : isPast
                              ? Colors.grey.shade200
                              : isSelected
                              ? const Color.fromARGB(
                                255,
                                193,
                                173,
                                255,
                              ).withAlpha(150)
                              : Colors.white,
                    ),
                    child:
                        isBooked
                            ? Icon(
                              Icons.lock,
                              size: 16,
                              color: Colors.grey.shade600,
                            )
                            : isPast
                            ? Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade400,
                            )
                            : null,
                  ),
                );
              }).toList(),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                timeLabels.map((t) {
                  String display =
                      t.contains(":30") ? "•" : t.replaceAll(":00", "").trim();
                  return Expanded(
                    child: Center(
                      child: Text(
                        display,
                        style: TextStyle(
                          fontSize: display == "•" ? 22 : 14,
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildSessionPage(int index) {
    final session = sessions[index];
    final slots = allTimes[index];
    int half = (slots.length / 2).ceil();
    final firstHalf = slots.sublist(0, half);
    final secondHalf = slots.sublist(half - 1);

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 10),
          if (loadingSlots)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          buildIntervalUIUp(session, firstHalf),
          SizedBox(height: 20),
          buildIntervalUIDown(session, secondHalf),
          SizedBox(height: 20),
          if (selectedIntervals[session]!.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 193, 173, 255).withAlpha(150),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(255, 193, 173, 255),
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$session Session Summary:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                      color: blackColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start: ${selectedIntervals[session]!.first.start}',
                    style: TextStyle(fontSize: 14, fontFamily: 'Regular'),
                  ),
                  Text(
                    'End: ${selectedIntervals[session]!.last.end}',
                    style: TextStyle(fontSize: 14, fontFamily: 'Regular'),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Total: ${sessionDurations[session]!.toStringAsFixed(1)} hours',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: size.safeWidth * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              sessions.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 250),
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                width: _selectedIndex == index ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      _selectedIndex == index
                          ? const Color.fromARGB(255, 193, 173, 255)
                          : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabItem(int index) {
    final isSelected = _tabController.index == index;
    return InkWell(
      enableFeedback: true,
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        HapticFeedback.lightImpact();
        _tabController.animateTo(index);
      },
      child: AnimatedContainer(
        width: size.safeWidth * 0.19,
        curve: Curves.bounceIn,
        duration: Duration(seconds: 4),
        padding: EdgeInsets.symmetric(vertical: size.safeWidth * 0.02),
        decoration:
            isSelected
                ? BoxDecoration(
                  color: Color(0xFFCFCFFA),
                  borderRadius: BorderRadius.circular(15),
                )
                : null,
        child: defaultTab(tabs[index][0], tabs[index][1], isSelected),
      ),
    );
  }

  static Tab defaultTab(String name, String details, bool isSelected) {
    return Tab(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: Sizes().width * 0.031,
                color: blackColor,
                fontFamily: 'Medium',
              ),
            ),
            Text(
              details,
              style: TextStyle(
                fontSize: Sizes().width * 0.03,
                color: blackColor,
                fontFamily: 'Medium',
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<List<String>> _generateNextDays(int count) {
    final List<List<String>> days = [];
    final today = DateTime.now();
    for (int i = 0; i < count; i++) {
      final date = today.add(Duration(days: i));
      final dayString = DateFormat('d MMM').format(date);
      final weekDayString = DateFormat('EEE').format(date);
      days.add([dayString, weekDayString]);
    }
    return days;
  }

  final List<List<String>> allTimes = [
    [
      "12:00 AM",
      "12:30 AM",
      "1:00 AM",
      "1:30 AM",
      "2:00 AM",
      "2:30 AM",
      "3:00 AM",
      "3:30 AM",
      "4:00 AM",
      "4:30 AM",
      "5:00 AM",
      "5:30 AM",
      "6:00 AM",
    ],
    [
      "6:00 AM",
      "6:30 AM",
      "7:00 AM",
      "7:30 AM",
      "8:00 AM",
      "8:30 AM",
      "9:00 AM",
      "9:30 AM",
      "10:00 AM",
      "10:30 AM",
      "11:00 AM",
      "11:30 AM",
      "12:00 PM",
    ],
    [
      "12:00 PM",
      "12:30 PM",
      "1:00 PM",
      "1:30 PM",
      "2:00 PM",
      "2:30 PM",
      "3:00 PM",
      "3:30 PM",
      "4:00 PM",
      "4:30 PM",
      "5:00 PM",
      "5:30 PM",
      "6:00 PM",
    ],
    [
      "6:00 PM",
      "6:30 PM",
      "7:00 PM",
      "7:30 PM",
      "8:00 PM",
      "8:30 PM",
      "9:00 PM",
      "9:30 PM",
      "10:00 PM",
      "10:30 PM",
      "11:00 PM",
      "11:30 PM",
      "12:00 AM",
    ],
  ];

  @override
  Widget build(BuildContext context) {
    if (_hasPendingBooking) {
      return Scaffold(
        appBar: AppBar(
          surfaceTintColor: whiteColor,
          backgroundColor: whiteColor,
          centerTitle: true,
          title: Text(
            widget.turfData['name'] ?? 'Book Turf',
            style: TextStyle(fontFamily: 'Regular'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Checking pending bookings...',
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: whiteColor,
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text(
          widget.turfData['name'] ?? 'Book Turf',
          style: TextStyle(fontFamily: 'Regular'),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
              // vertical: 10,
              horizontal: size.safeWidth * 0.05,
            ),
            child: Row(
              children: [
                Text(
                  "Select Field Size",
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: size.safeWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Field Size Selection
          if (availableFieldSizes.length > 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children:
                    availableFieldSizes.map((size) {
                      final isSelected = selectedFieldSize == size;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: ChoiceChip(
                          label: Text(
                            size,
                            style: TextStyle(fontFamily: 'Regular'),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedFieldSize = size;
                                _clearAllSelections();
                              });
                              _fetchBookedSlots();
                            }
                          },
                          selectedColor: Color.fromARGB(255, 193, 173, 255),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      );
                    }).toList(),
              ),
            ),

          SizedBox(height: size.safeWidth * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
              // vertical: 10,
              horizontal: size.safeWidth * 0.05,
            ),
            child: Row(
              children: [
                Text(
                  "Select Day and Time",
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: size.safeWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.safeWidth * 0.04),

          // Day Selection
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: size.safeWidth * 0.01),
                SizedBox(
                  child: ButtonsTabBar(
                    controller: _tabController,
                    unselectedBackgroundColor: Colors.black12,
                    unselectedBorderColor: Colors.transparent,
                    backgroundColor: Color.fromARGB(255, 193, 173, 255),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: size.safeWidth * 0.01,
                    ),
                    contentCenter: true,
                    borderColor: Colors.black,
                    borderWidth: 1,
                    onTap: (index) {},
                    width: size.safeWidth * 0.22,
                    radius: 15,
                    height: size.safeWidth * 0.17,
                    buttonMargin: EdgeInsets.symmetric(horizontal: 12),
                    splashColor: Colors.transparent,
                    duration: 0,
                    tabs: List.generate(tabs.length, (index) {
                      return Tab(
                        child: Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: defaultTab(
                              tabs[index][0],
                              tabs[index][1],
                              _tabController.index == index,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(width: size.safeWidth * 0.01),
              ],
            ),
          ),

          // Session Selection
          Padding(
            padding: EdgeInsets.only(
              top: size.safeWidth * 0.06,
              left: size.safeWidth * 0.05,
              right: size.safeWidth * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(sessions.length, (index) {
                final isSelected = _selectedIndex == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.safeWidth * 0.01,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Clear selections from other sessions when switching
                        for (var i = 0; i < sessions.length; i++) {
                          if (i != index) {
                            selectedIntervals[sessions[i]]!.clear();
                            sessionDurations[sessions[i]] = 0.0;
                          }
                        }
                        setState(() => _selectedIndex = index);
                        _pageController.jumpToPage(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color.fromARGB(255, 193, 173, 255)
                                  : Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              sessions[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.safeWidth * 0.03,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 8),

          // Time Slots
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: sessions.length,
              onPageChanged: (i) {
                // Clear other sessions when swiping
                for (var j = 0; j < sessions.length; j++) {
                  if (j != i) {
                    selectedIntervals[sessions[j]]!.clear();
                    sessionDurations[sessions[j]] = 0.0;
                  }
                }
                setState(() => _selectedIndex = i);
              },
              itemBuilder: (context, index) => buildSessionPage(index),
            ),
          ),

          // Checkout Button
          if (hasAnySelections())
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceedToCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blackColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Proceed to Checkout (${getTotalHours().toStringAsFixed(1)} hrs)',
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
        ],
      ),
    );
  }

  void _proceedToCheckout() {
    // Check for pending bookings one more time before proceeding
    _timerService.checkPendingBookings().then((_) {
      final pendingBooking = _timerService.currentPendingBooking;

      if (pendingBooking != null && pendingBooking.turfId == widget.turfId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please complete your pending payment first'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Go to Checkout',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TurfCheckoutPage(
                          turfId: widget.turfId,
                          turfData: widget.turfData,
                          selectedDate: pendingBooking.date,
                          fieldSize: pendingBooking.fieldSize,
                          session: pendingBooking.session,
                          slots:
                              pendingBooking.slots
                                  .map(
                                    (s) => IntervalSlot(
                                      s['start'] as String,
                                      s['end'] as String,
                                    ),
                                  )
                                  .toList(),
                          totalHours: pendingBooking.totalHours,
                          totalAmount: pendingBooking.totalAmount,
                          existingBookingId: pendingBooking.bookingId,
                        ),
                  ),
                );
              },
            ),
          ),
        );
        return;
      }

      // Find which session has selections
      String? selectedSession;
      for (var entry in selectedIntervals.entries) {
        if (entry.value.isNotEmpty) {
          selectedSession = entry.key;
          break;
        }
      }

      if (selectedSession == null) return;

      final slots = selectedIntervals[selectedSession]!;
      final pricePerHour = widget.turfData['half_hour_price'] * 2;
      final totalHours = sessionDurations[selectedSession]!;
      final totalAmount = (pricePerHour * totalHours).round();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => TurfCheckoutPage(
                turfId: widget.turfId,
                turfData: widget.turfData,
                selectedDate: _getSelectedDate(),
                fieldSize: selectedFieldSize,
                session: selectedSession!,
                slots: slots,
                totalHours: totalHours,
                totalAmount: totalAmount,
              ),
        ),
      ).then((_) {
        // Refresh slots after returning from checkout
        _fetchBookedSlots();
        _clearAllSelections();
        _checkPendingBooking(); // Check again
      });
    });
  }
}

// IntervalSlot class
class IntervalSlot {
  final String start;
  final String end;

  IntervalSlot(this.start, this.end);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntervalSlot &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
