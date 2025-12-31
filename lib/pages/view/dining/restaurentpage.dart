// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/constants/temporary.dart';
// import 'package:ticpin/pages/view/dining/billpaypage.dart';

// class Restaurentpage extends StatefulWidget {
//   const Restaurentpage({super.key});

//   @override
//   State<Restaurentpage> createState() => _RestaurentpageState();
// }

// class _RestaurentpageState extends State<Restaurentpage>
//     with TickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   double _appBarOpacity = 0.0;

//   String name = "Dining name",
//       details = "Dining details",
//       time = 'opens on time',
//       about_content = "Content\nContent\nContent\nContent";

//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);

//     _scrollController.addListener(() {
//       Sizes size = Sizes();
//       _onScroll().then((sectionkey) {
//         setState(() {});
//       });
//       double offset = _scrollController.offset;

//       // Adjust this value depending on when you want the title to fade in
//       double fadeStart = size.safeHeight * 0.3;
//       double fadeEnd = size.safeHeight * 0.4;

//       double newOpacity = (offset - fadeStart) / (fadeEnd - fadeStart);
//       newOpacity = newOpacity.clamp(0.0, 1.0);

//       if (newOpacity != _appBarOpacity) {
//         if (mounted) {
//           setState(() {
//             _appBarOpacity = newOpacity;
//           });
//         }
//       }
//     });
//   }

//   ElevatedButton concertElevatedButton(
//     String label,
//     GlobalKey sectionKey,
//     int index,
//   ) {
//     Sizes size = Sizes();
//     bool isSelected = _selectedIndex == index;
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         splashFactory: NoSplash.splashFactory,
//         fixedSize: Size.fromWidth(size.safeWidth * 0.23),
//         elevation: 0,

//         padding: EdgeInsets.all(size.safeWidth * 0.015),
//         backgroundColor: isSelected ? gradient1.withAlpha(80) : whiteColor,
//         // side: BorderSide(color: Colors.black12.withAlpha(30), width: 1.2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
//       ),
//       onPressed: () {
//         // update tab highlight
//         scrollToSection(sectionKey).then((_) {
//           _tabController.animateTo(index);
//         });
//       },
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: size.safeWidth * 0.03,
//           fontFamily: 'Regular',
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Future<void> scrollToSection(GlobalKey key) async {
//     final context = key.currentContext;
//     if (context != null) {
//       Scrollable.ensureVisible(
//         alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
//         context,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   // //
//   // Widget buildStarRating(double rating) {
//   //   return Row(
//   //     children: List.generate(5, (i) {
//   //       String emoji;
//   //       if (i < rating.floor()) {
//   //         emoji = "⭐";
//   //       } else if (i < rating && rating - i >= 0.5) {
//   //         emoji = "🌟"; // optional: half-star look
//   //       } else {
//   //         emoji = "☆";
//   //       }

//   //       final iconWidget =
//   //           Platform.isIOS
//   //               ? Text(
//   //                 emoji,
//   //                 style: const TextStyle(fontFamily: 'Regular', fontSize: 24),
//   //               )
//   //               : Icon(
//   //                 i < rating.floor()
//   //                     ? Icons.star
//   //                     : (i < rating && rating - i >= 0.5)
//   //                     ? Icons.star_half
//   //                     : Icons.star_border,
//   //                 size: 28,
//   //                 color: Colors.white,
//   //               );

//   //       return ShaderMask(
//   //         shaderCallback:
//   //             (bounds) => const LinearGradient(
//   //               colors: [Colors.orange, Colors.red],
//   //             ).createShader(bounds),
//   //         child: iconWidget,
//   //       );
//   //     }),
//   //   );
//   // }

//   final GlobalKey section1Key = GlobalKey();
//   final GlobalKey section2Key = GlobalKey();
//   final GlobalKey section3Key = GlobalKey();
//   final GlobalKey section4Key = GlobalKey();

//   int _selectedIndex = 0;

//   Future<void> _onScroll() async {
//     List<Map<String, dynamic>> sections = [
//       {'key': section1Key, 'index': 0},
//       {'key': section2Key, 'index': 1},
//       {'key': section3Key, 'index': 2},
//       {'key': section4Key, 'index': 3},
//     ];

//     Sizes size = Sizes();

//     for (var section in sections) {
//       final keyContext = section['key'].currentContext;
//       if (keyContext != null) {
//         final box = keyContext.findRenderObject() as RenderBox;
//         final position = box.localToGlobal(Offset.zero, ancestor: null).dy;

//         if (position <= size.safeHeight * 0.5 &&
//             position >= -box.size.height / 5) {
//           if (_selectedIndex != section['index']) {
//             _selectedIndex = section['index'];
//           }
//           break;
//         }

//         // if (mounted) {
//         //   setState(() {});
//         // }
//       }
//     }
//   }

//   int _seatNumber = 0;

//   bool isGlowing = false;
//   bool isSelected = false;

//   void filter_window(Sizes size) {
//     showModalBottomSheet(
//       backgroundColor: Colors.white,
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Header
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     children: [
//                       Text(
//                         "Select number of seats",
//                         style: TextStyle(
//                           fontFamily: 'Regular',
//                           fontWeight: FontWeight.w600,
//                           fontSize: size.safeWidth * 0.05,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(Icons.close),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Tabs + content
//                 //
//                 // Right content
//                 Container(
//                   width: size.safeWidth,
//                   height: size.safeHeight * 0.3,
//                   child: GridView.builder(
//                     itemCount: 18,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: size.safeWidth * 0.15,
//                     ),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: size.safeWidth * 0.07,
//                       mainAxisSpacing: size.safeWidth * 0.07,
//                     ),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setSheetState(() {
//                             _seatNumber = index + 1;
//                           });
//                         },
//                         child: Container(
//                           height: size.safeWidth * 0.27,
//                           width: size.safeWidth * 0.27,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               width: 1,
//                               color:
//                                   index + 1 == _seatNumber
//                                       ? primaryColor.withAlpha(200)
//                                       : blackColor,
//                             ),
//                             color:
//                                 index + 1 == _seatNumber
//                                     ? primaryColor.withAlpha(60)
//                                     : whiteColor,
//                           ),
//                           child: Center(
//                             child: Text(
//                               (index + 1).toString(),
//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontSize: size.safeWidth * 0.035,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 //   Buttons
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     // TextButton(
//                     //   onPressed: () {
//                     //     Navigator.pop(context);
//                     //   },
//                     //   child: Text(
//                     //     "Clear All",
//                     //     style: TextStyle(fontFamily: 'Regular'),
//                     //   ),
//                     // ),
//                     InkWell(
//                       onTap: () {
//                         Get.to(DiningBillpage());
//                       },
//                       child: Container(
//                         width: size.safeWidth * 0.9,
//                         height: size.safeWidth * 0.13,
//                         // padding: EdgeInsets.symmetric(
//                         //   horizontal: 30,
//                         //   vertical: 10,
//                         // ),
//                         decoration: BoxDecoration(
//                           color: Colors.black26,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Proceed to Pay",
//                             style: TextStyle(
//                               fontFamily: 'Regular',
//                               color: Colors.black,
//                               fontSize: size.safeWidth * 0.04,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   //
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// Sizes size = Sizes();
//   //
//   @override
//   Widget build(BuildContext context) {
//     final List<List> tabs = [
//       ['Menu', section1Key],
//       ['Gallery', section2Key],
//       ['Reviews', section3Key],
//       ['About', section4Key],
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Positioned(
//             child: CustomScrollView(
//               controller: _scrollController,
//               slivers: [
//                 SliverAppBar(
//                   leading: IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: CircleAvatar(
//                       backgroundColor: Colors.white54,
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: Color.lerp(
//                           blackColor.withAlpha(200),
//                           blackColor,
//                           _appBarOpacity,
//                         ),
//                       ),
//                     ),
//                   ),
//                   actions: [
//                     Row(
//                       children: [
//                         // IconButton(
//                         //   onPressed: () {},
//                         //   icon: CircleAvatar(
//                         //     backgroundColor: Colors.white54,
//                         //     child: Icon(
//                         //       Icons.search,
//                         //       color: Color.lerp(
//                         //         blackColor.withAlpha(200),
//                         //         blackColor,
//                         //         _appBarOpacity,
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                         IconButton(
//                           onPressed: () {},
//                           icon: CircleAvatar(
//                             backgroundColor: Colors.white54,
//                             child: StatefulBuilder(
//                               builder: (context, set) {
//                                 glowOff() => Future.delayed(
//                                   const Duration(milliseconds: 700),
//                                   () {
//                                     if (context.mounted)
//                                       set(() => isGlowing = false);
//                                   },
//                                 );

//                                 return InkWell(
//                                   splashFactory: NoSplash.splashFactory,
//                                   onTap: () {
//                                     set(() {
//                                       isSelected = !isSelected;
//                                     });
//                                     if (isSelected) {
//                                       isGlowing = true;
//                                       glowOff();
//                                     }
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(
//                                       size.safeWidth * 0.01,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.transparent,
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         AnimatedOpacity(
//                                           opacity: isGlowing ? 1 : 0,
//                                           duration: const Duration(
//                                             milliseconds: 300,
//                                           ),
//                                           child: Icon(
//                                             Icons.local_fire_department_sharp,
//                                             size: size.safeWidth * 0.07 + 3,
//                                             color: Colors.orangeAccent
//                                                 .withOpacity(0.5),
//                                             shadows: [
//                                               Shadow(
//                                                 color: Colors.orangeAccent
//                                                     .withOpacity(0.8),
//                                                 blurRadius: 25,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         isSelected
//                                             ? ShaderMask(
//                                               shaderCallback:
//                                                   (r) => const LinearGradient(
//                                                     colors: [
//                                                       Color(0xFFFFBF00),
//                                                       Color(0xFFFF0000),
//                                                     ],
//                                                     begin: Alignment.topCenter,
//                                                     end: Alignment.bottomCenter,
//                                                   ).createShader(r),
//                                               child: Icon(
//                                                 Icons
//                                                     .local_fire_department_sharp,
//                                                 color: Colors.white,
//                                                 size: size.safeWidth * 0.07,
//                                               ),
//                                             )
//                                             : Icon(
//                                               Icons
//                                                   .local_fire_department_outlined,
//                                               color: Color.lerp(
//                                                 blackColor.withAlpha(200),
//                                                 blackColor.withAlpha(200),
//                                                 _appBarOpacity,
//                                               ),
//                                               size: size.safeWidth * 0.07,
//                                             ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         CircleAvatar(
//                           backgroundColor: Colors.white54,
//                           child: SvgPicture.asset(
//                             'assets/images/icons/share.svg',
//                             width: size.safeWidth * 0.06,
//                             height: size.safeWidth * 0.06,
//                             color: Color.lerp(
//                               blackColor.withAlpha(200),
//                               blackColor,
//                               _appBarOpacity,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: size.safeWidth * 0.02),
//                       ],
//                     ),
//                   ],
//                   pinned: true,

//                   snap: false,
//                   floating: false,
//                   surfaceTintColor: whiteColor,
//                   shadowColor: Colors.transparent,
//                   expandedHeight:
//                       size.safeWidth - MediaQuery.of(context).padding.top,
//                   backgroundColor: Color.lerp(
//                     Colors.transparent,
//                     whiteColor,
//                     _appBarOpacity,
//                   ),

//                   elevation: _appBarOpacity > 0.1 ? 4 : 0,
//                   stretchTriggerOffset: 0.1,
//                   title: Opacity(
//                     opacity: _appBarOpacity,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: TextStyle(
//                             fontFamily: 'Regular',
//                             fontSize: size.safeWidth * 0.045,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           details,
//                           style: TextStyle(
//                             fontFamily: 'Regular',
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black.withOpacity(0.75),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   foregroundColor: Color.lerp(
//                     Colors.transparent,
//                     whiteColor,
//                     _appBarOpacity,
//                   ),
//                   flexibleSpace: FlexibleSpaceBar(
//                     collapseMode: CollapseMode.pin,
//                     background: Container(
//                       height: size.safeWidth,
//                       width: size.safeWidth,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [gradient1, gradient2],
//                         ),
//                       ), // child: Stack(
//                       //   fit: StackFit.expand,
//                       //   children: [
//                       //     if (_isPlaying)
//                       //       YoutubePlayer(controller: _controller)
//                       //     else
//                       //       Stack(
//                       //         fit: StackFit.expand,
//                       //         children: [
//                       //           // Thumbnail image
//                       //           Image.network(
//                       //             "https://img.youtube.com/vi/${getYoutubeVideoId(you_tu_url)}/hqdefault.jpg",
//                       //             fit: BoxFit.cover,
//                       //           ),
//                       //           // Custom play button
//                       //           GestureDetector(
//                       //             onTap: () {
//                       //               setState(() => _isPlaying = true);
//                       //               _controller.loadVideoById(
//                       //                 videoId: videoId,
//                       //                 startSeconds: 0,
//                       //               );
//                       //             },
//                       //             child: Icon(
//                       //               Icons.play_circle_fill,
//                       //               size: 60,
//                       //               color: Colors.white70,
//                       //             ),
//                       //           ),
//                       //         ],
//                       //       ),
//                       //   ],
//                       // ),
//                     ),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: AnimatedOpacity(
//                     opacity: 1 - _appBarOpacity,
//                     duration: Duration(milliseconds: 300),
//                     child: Container(
//                       padding: EdgeInsets.only(left: 20, top: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: size.safeWidth * 0.05),
//                           Text(
//                             name,
//                             style: TextStyle(
//                               fontFamily: 'Regular',

//                               fontSize: size.safeWidth * 0.045,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 children: [
//                                   Text(
//                                     details,
//                                     style: TextStyle(
//                                       fontFamily: 'Regular',

//                                       fontSize: size.safeWidth * 0.035,
//                                       color: Colors.black.withAlpha(190),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     time,
//                                     style: TextStyle(
//                                       fontFamily: 'Regular',

//                                       fontSize: size.safeWidth * 0.035,
//                                       color: Colors.black.withAlpha(210),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               GestureDetector(
//                                 onTap: () {},
//                                 child: Container(
//                                   margin: EdgeInsets.symmetric(
//                                     horizontal: 15,
//                                     vertical: 8,
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 15,
//                                     vertical: 8,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.black.withAlpha(40),
//                                     borderRadius: BorderRadius.circular(13),
//                                   ),
//                                   child: Text(
//                                     "Call Now",
//                                     style: TextStyle(
//                                       fontFamily: 'Regular',
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: size.safeWidth * 0.01),
//                           // Row(
//                           //   mainAxisAlignment: MainAxisAlignment.end,
//                           //   children: [

//                           //   ],
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 /// 🔻 Sticky Tab Row
//                 SliverPersistentHeader(
//                   pinned: true,
//                   delegate: _StickyTabBarDelegate(
//                     child: Container(
//                       color: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: TabBar(
//                           controller: _tabController,
//                           dividerHeight: 0,
//                           // padding: EdgeInsets.all(size.safeWidth * 0.02),
//                           // tabs: [
//                           //   concertElevatedButton('About', section1Key),
//                           //   concertElevatedButton('Artist', section2Key),
//                           //   concertElevatedButton('Gallery', section3Key),
//                           //   concertElevatedButton('Venue', section4Key),
//                           // ]
//                           onTap: (value) {},
//                           indicator: BoxDecoration(),
//                           tabs: List.generate(
//                             tabs.length,
//                             (index) => Center(
//                               child: concertElevatedButton(
//                                 tabs[index][0],
//                                 tabs[index][1],
//                                 index,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 SliverToBoxAdapter(
//                   child: Container(
//                     // padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 15),
//                         Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 20),
//                                   child: Text(
//                                     "Menu",
//                                     key: section1Key,
//                                     style: TextStyle(
//                                       fontFamily: 'Regular',
//                                       fontSize: size.safeWidth * 0.045,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: size.safeWidth * 0.05),
//                             SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Row(
//                                 children: [
//                                   SizedBox(width: size.safeWidth * 0.026),
//                                   Row(
//                                     children: List.generate(colors.length, (
//                                       ind,
//                                     ) {
//                                       final menu = [
//                                         'Food',
//                                         'Beverages',
//                                         'Bar',
//                                         'Snacks',
//                                         'Sauce',
//                                       ];
//                                       return Column(
//                                         spacing: 5.0,
//                                         children: [
//                                           Container(
//                                             decoration: BoxDecoration(
//                                               color: colors[ind],
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             margin: EdgeInsets.symmetric(
//                                               horizontal: 10,
//                                             ),
//                                             height: size.safeWidth * 0.3,
//                                             width: size.safeWidth * 0.3,
//                                           ),
//                                           Text(
//                                             menu[ind],
//                                             style: TextStyle(
//                                               fontSize: Sizes().width * 0.03,
//                                               fontWeight: FontWeight.w500,
//                                               fontFamily: 'Regular',
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     }),
//                                   ),
//                                   SizedBox(width: size.safeWidth * 0.026),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: size.safeWidth * 0.07),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             "Gallery",
//                             key: section2Key,
//                             style: TextStyle(
//                               fontFamily: 'Regular',
//                               fontSize: size.safeWidth * 0.045,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.05),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               SizedBox(width: size.safeWidth * 0.026),
//                               Row(
//                                 children: List.generate(colors.length, (ind) {
//                                   return Column(
//                                     spacing: 5.0,
//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           color: colors[ind],
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                         margin: EdgeInsets.symmetric(
//                                           horizontal: 10,
//                                         ),
//                                         height: size.safeWidth * 0.3,
//                                         width: size.safeWidth * 0.3,
//                                       ),
//                                     ],
//                                   );
//                                 }),
//                               ),
//                               SizedBox(width: size.safeWidth * 0.026),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.07),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             "Reviews",
//                             key: section3Key,
//                             style: TextStyle(
//                               fontFamily: 'Regular',
//                               fontSize: size.safeWidth * 0.045,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.05),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(left: 20),
//                                 child: Row(
//                                   children:
//                                       colors
//                                           .map(
//                                             (i) => Padding(
//                                               padding: EdgeInsets.only(
//                                                 right: 20,
//                                               ),
//                                               child: Container(
//                                                 width: size.safeWidth * 0.7,
//                                                 height: size.safeWidth * 0.55,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.black12,
//                                                   borderRadius:
//                                                       BorderRadius.circular(17),
//                                                 ),
//                                                 child: Column(
//                                                   children: [
//                                                     Padding(
//                                                       padding: EdgeInsets.only(
//                                                         top:
//                                                             size.safeWidth *
//                                                             0.015,
//                                                         left:
//                                                             size.safeWidth *
//                                                             0.01,
//                                                       ),
//                                                       child: ListTile(
//                                                         leading: CircleAvatar(
//                                                           radius:
//                                                               size.safeWidth *
//                                                               0.06,
//                                                           backgroundColor:
//                                                               Colors.black38,
//                                                         ),
//                                                         contentPadding:
//                                                             EdgeInsets.only(
//                                                               left:
//                                                                   size.safeWidth *
//                                                                   0.03,
//                                                               right:
//                                                                   size.safeWidth *
//                                                                   0.03,
//                                                             ),
//                                                         title: Text(
//                                                           'Username',

//                                                           style: TextStyle(
//                                                             fontFamily:
//                                                                 'Regular',
//                                                             fontSize:
//                                                                 size.safeWidth *
//                                                                 0.035,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                         subtitle: Text(
//                                                           'Time',

//                                                           style: TextStyle(
//                                                             fontFamily:
//                                                                 'Regular',
//                                                             fontSize:
//                                                                 size.safeWidth *
//                                                                 0.03,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                         trailing: Container(
//                                                           width:
//                                                               size.safeWidth *
//                                                               0.13,
//                                                           height:
//                                                               size.safeWidth *
//                                                               0.06,

//                                                           decoration: BoxDecoration(
//                                                             color:
//                                                                 Colors
//                                                                     .lightGreenAccent
//                                                                     .shade700,
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                   8,
//                                                                 ),
//                                                           ),
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceEvenly,
//                                                             children: [
//                                                               Text(
//                                                                 '2.5',

//                                                                 style: TextStyle(
//                                                                   fontFamily:
//                                                                       'Semibold',
//                                                                   fontSize:
//                                                                       size.safeWidth *
//                                                                       0.028,
//                                                                   color:
//                                                                       blackColor,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                 ),
//                                                               ),
//                                                               SizedBox.shrink(),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                             horizontal:
//                                                                 size.safeWidth *
//                                                                 0.04,
//                                                             vertical:
//                                                                 size.safeWidth *
//                                                                 0.02,
//                                                           ),
//                                                       child: Row(
//                                                         children: [
//                                                           SizedBox(
//                                                             width:
//                                                                 size.safeWidth *
//                                                                 0.62,
//                                                             height:
//                                                                 size.safeWidth *
//                                                                 0.3,
//                                                             child: Text(
//                                                               'Hi how are you iam fine lets build something funny start from abcdefghijklmnopqrstuvwxyz 0123456789 what the hill is this comment section currently typing content for ticpin review builder now lets see if it works ahh shit it is not working lets see again now it is working',
//                                                               maxLines: 8,

//                                                               softWrap: true,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,

//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     'Semibold',
//                                                                 fontSize:
//                                                                     size.safeWidth *
//                                                                     0.03,
//                                                                 color:
//                                                                     blackColor,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                           .toList(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.07),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             "About",
//                             key: section4Key,
//                             style: TextStyle(
//                               fontFamily: 'Regular',

//                               fontSize: size.safeWidth * 0.045,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.05),
//                         Column(
//                           children: List.generate(15, (i) {
//                             return Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 20),
//                               child: Text(
//                                 'About the Restaurent in bulletins',
//                                 style: TextStyle(
//                                   fontSize: size.safeWidth * 0.035,
//                                   fontFamily: 'Regular',
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.05),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             "Available Facilities",
//                             style: TextStyle(
//                               fontFamily: 'Regular',

//                               fontSize: size.safeWidth * 0.045,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.05),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               SizedBox(width: size.safeWidth * 0.035),
//                               Row(
//                                 children: List.generate(colors.length, (ind) {
//                                   return Padding(
//                                     padding: EdgeInsets.only(
//                                       right: size.safeWidth * 0.035,
//                                     ),
//                                     child: Column(
//                                       // spacing: 5.0,
//                                       children: [
//                                         Text(
//                                           "Dinner",
//                                           style: TextStyle(
//                                             fontFamily: 'Regular',

//                                             fontSize: size.safeWidth * 0.033,
//                                             // fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Lunch",
//                                           style: TextStyle(
//                                             fontFamily: 'Regular',

//                                             fontSize: size.safeWidth * 0.033,
//                                             // fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Delivery",
//                                           style: TextStyle(
//                                             fontFamily: 'Regular',

//                                             fontSize: size.safeWidth * 0.033,
//                                             // fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Full bar",
//                                           style: TextStyle(
//                                             fontFamily: 'Regular',

//                                             fontSize: size.safeWidth * 0.033,
//                                             // fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }),
//                               ),

//                               SizedBox(width: size.safeWidth * 0.026),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.05),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             "Similar Restaurents",
//                             style: TextStyle(
//                               fontFamily: 'Regular',

//                               fontSize: size.safeWidth * 0.045,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.safeWidth * 0.05),
//                         SizedBox(
//                           height: size.safeHeight * 0.3,
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     left: size.safeWidth * 0.045,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: diningColorSlider,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.safeHeight * 0.1),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               width: size.safeWidth,
//               padding: EdgeInsets.only(top: 10, bottom: 18),
//               color: Colors.white,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       filter_window(size);
//                     },
//                     child: Container(
//                       width: size.safeWidth * 0.45,
//                       height: size.safeWidth * 0.12,
//                       // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                       padding: EdgeInsets.symmetric(
//                         // horizontal: 15,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withAlpha(60),
//                         borderRadius: BorderRadius.circular(13),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Book a Table",
//                           style: TextStyle(
//                             fontFamily: 'Regular',
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Get.to(DiningBillpage());
//                     },
//                     child: Container(
//                       width: size.safeWidth * 0.45,
//                       height: size.safeWidth * 0.12,
//                       // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                       padding: EdgeInsets.symmetric(
//                         // horizontal: 15,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(13),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Pay Bill",
//                           style: TextStyle(
//                             fontFamily: 'Regular',
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Sticky header class
// class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;

//   _StickyTabBarDelegate({required this.child});

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return child;
//   }

//   @override
//   double get maxExtent => 70;

//   @override
//   double get minExtent => maxExtent;

//   @override
//   bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
//     return oldDelegate.child != child;
//   }
// }

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/user/user.dart';
import 'package:ticpin/constants/shapes/ticbutton.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/dining/billpaypage.dart';
import 'package:ticpin/services/controllers/dining_controller.dart';
import 'package:ticpin/constants/models/dining/diningfull.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Restaurentpage extends StatefulWidget {
  final String diningId;

  const Restaurentpage({super.key, required this.diningId});

  @override
  State<Restaurentpage> createState() => _RestaurentpageState();
}

class _RestaurentpageState extends State<Restaurentpage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final DiningController diningController = Get.find<DiningController>();
  CarouselSliderController _diningController = CarouselSliderController();
  int _diningCurrent = 0;
  double _appBarOpacity = 0.0;

  DiningFull? diningData;
  bool isLoading = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDiningData();

    _scrollController.addListener(() {
      Sizes size = Sizes();
      _onScroll().then((sectionkey) {
        setState(() {});
      });
      double offset = _scrollController.offset;

      double fadeStart = size.safeHeight * 0.2;
      double fadeEnd = size.safeHeight * 0.3;

      double newOpacity = (offset - fadeStart) / (fadeEnd - fadeStart);
      newOpacity = newOpacity.clamp(0.0, 1.0);

      if (newOpacity != _appBarOpacity) {
        if (mounted) {
          setState(() {
            _appBarOpacity = newOpacity;
          });
        }
      }
    });
  }

  // OPTIMIZATION: Separate loading state widget
  Widget _buildLoadingState() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: whiteColor,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 20),
                  LoadingShimmer(
                    width: size.safeWidth,
                    height: size.safeHeight * 0.35,
                    isCircle: false,
                  ),
                  SizedBox(height: 60),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.6,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.7,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.3,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.9,
                      height: size.safeHeight * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.3,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.9,
                      height: size.safeHeight * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.3,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  // SizedBox(height: 20),
                  // Padding(
                  //   padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                  //   child: LoadingShimmer(
                  //     width: size.safeWidth * 0.9,
                  //     height: size.safeHeight * 0.1,
                  //     isCircle: false,
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // OPTIMIZATION: Separate error state widget
  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: gradient1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Turf Not Found',
          style: TextStyle(color: whiteColor, fontFamily: 'Regular'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Unable to load turf details',
              style: TextStyle(fontSize: 18, fontFamily: 'Regular'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _loadDiningData(); // Retry loading
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blackColor,
                padding: EdgeInsets.symmetric(
                  horizontal: size.safeWidth * 0.1,
                  vertical: size.safeWidth * 0.03,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(fontFamily: 'Regular', color: whiteColor),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _loadDiningData() async {
    final data = await diningController.loadDiningFull(widget.diningId);
    if (mounted) {
      setState(() {
        diningData = data;
        isLoading = false;
      });
    }
  }

  ElevatedButton concertElevatedButton(
    String label,
    GlobalKey sectionKey,
    int index,
  ) {
    Sizes size = Sizes();
    bool isSelected = _selectedIndex == index;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        fixedSize: Size.fromWidth(size.safeWidth * 0.23),
        elevation: 0,
        surfaceTintColor: whiteColor,
        shadowColor: whiteColor,
        overlayColor: whiteColor,
        padding: EdgeInsets.all(size.safeWidth * 0.015),
        backgroundColor: isSelected ? gradient1.withAlpha(80) : whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
      onPressed: () {
        scrollToSection(sectionKey).then((_) {
          _tabController.animateTo(index);
        });
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: size.safeWidth * 0.03,
          fontFamily: 'Regular',
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> scrollToSection(GlobalKey key) async {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
        context,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  final GlobalKey section1Key = GlobalKey();
  final GlobalKey section2Key = GlobalKey();
  final GlobalKey section3Key = GlobalKey();
  final GlobalKey section4Key = GlobalKey();

  int _selectedIndex = 0;

  Future<void> _onScroll() async {
    List<Map<String, dynamic>> sections = [
      {'key': section1Key, 'index': 0},
      {'key': section2Key, 'index': 1},
      {'key': section3Key, 'index': 2},
      {'key': section4Key, 'index': 3},
    ];

    Sizes size = Sizes();

    for (var section in sections) {
      final keyContext = section['key'].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero, ancestor: null).dy;

        if (position <= size.safeHeight * 0.5 &&
            position >= -box.size.height / 5) {
          if (_selectedIndex != section['index']) {
            _selectedIndex = section['index'];
          }
          break;
        }
      }
    }
  }

  int _seatNumber = 0;
  bool isGlowing = false;
  bool isSelected = false;

  void filter_window(Sizes size) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        "Select number of seats",
                        style: TextStyle(
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600,
                          fontSize: size.safeWidth * 0.05,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.safeWidth,
                  height: size.safeHeight * 0.3,
                  child: GridView.builder(
                    itemCount: 18,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.safeWidth * 0.15,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: size.safeWidth * 0.07,
                      mainAxisSpacing: size.safeWidth * 0.07,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            _seatNumber = index + 1;
                          });
                        },
                        child: Container(
                          height: size.safeWidth * 0.27,
                          width: size.safeWidth * 0.27,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color:
                                  index + 1 == _seatNumber
                                      ? primaryColor.withAlpha(200)
                                      : blackColor,
                            ),
                            color:
                                index + 1 == _seatNumber
                                    ? primaryColor.withAlpha(60)
                                    : whiteColor,
                          ),
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: size.safeWidth * 0.035,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(DiningBillpage());
                      },
                      child: Container(
                        width: size.safeWidth * 0.9,
                        height: size.safeWidth * 0.13,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Proceed to Pay",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              color: Colors.black,
                              fontSize: size.safeWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Sizes size = Sizes();

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (diningData == null) {
      return _buildErrorState();
    }

    final List<List> tabs = [
      ['Menu', section1Key],
      ['Gallery', section2Key],
      ['Reviews', section3Key],
      ['About', section4Key],
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.white54,
                      child: Icon(
                        Icons.arrow_back,
                        color: Color.lerp(
                          blackColor.withAlpha(200),
                          blackColor,
                          _appBarOpacity,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: CircleAvatar(
                            backgroundColor: Colors.white54,
                            child: TicListButton(
                              itemId: diningData!.diningId,
                              itemType: TicListItemType.dining,
                              // isInTicList: isInTicList,
                              isBackground: false,
                              // wid: size.width,
                              color: Color.lerp(
                                blackColor.withAlpha(170),
                                blackColor.withAlpha(200),
                                _appBarOpacity,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white54,
                          child: SvgPicture.asset(
                            'assets/images/icons/share.svg',
                            width: size.safeWidth * 0.06,
                            height: size.safeWidth * 0.06,
                            color: Color.lerp(
                              blackColor.withAlpha(200),
                              blackColor,
                              _appBarOpacity,
                            ),
                          ),
                        ),
                        SizedBox(width: size.safeWidth * 0.02),
                      ],
                    ),
                  ],
                  pinned: true,
                  snap: false,
                  floating: false,
                  surfaceTintColor: whiteColor,
                  shadowColor: Colors.transparent,
                  expandedHeight:
                      size.safeWidth * 0.7 + MediaQuery.of(context).padding.top,
                  backgroundColor: whiteColor,
                  elevation: _appBarOpacity > 0.1 ? 4 : 0,
                  stretchTriggerOffset: 0.1,
                  title: Opacity(
                    opacity: _appBarOpacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          diningData!.name,
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          diningData!.briefDescription,
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  foregroundColor: Color.lerp(
                    Colors.transparent,
                    whiteColor,
                    _appBarOpacity,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Column(
                      children: [
                        CarouselSlider.builder(
                          carouselController: _diningController,
                          itemCount: diningData!.carouselImages.length,
                          itemBuilder: (context, index, realIndex) {
                            return SizedBox(
                              // height:
                              //     size.safeWidth * 0.6 +
                              //     MediaQuery.of(context).padding.top,
                              // -MediaQuery.of(context).padding.top,
                              width: size.safeWidth,
                              child: Image.network(
                                diningData!.carouselImages[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            scrollPhysics:
                                diningData!.carouselImages.length == 1
                                    ? NeverScrollableScrollPhysics()
                                    : AlwaysScrollableScrollPhysics(),
                            viewportFraction: 1,
                            height:
                                size.safeWidth * 0.7 +
                                MediaQuery.of(context).padding.top,
                          ),
                        ),
                        diningData!.carouselImages.length == 1
                            ? SizedBox.shrink()
                            : Padding(
                              padding: EdgeInsets.only(
                                top: size.width * 0.01,
                                bottom: size.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  diningData!.carouselImages.length,
                                  (index) {
                                    return Container(
                                      width:
                                          _diningCurrent == index
                                              ? size.width * 0.03
                                              : size.width * 0.02,
                                      height: size.width * 0.02,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                            .withAlpha(
                                              _diningCurrent == index
                                                  ? 255
                                                  : 100,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AnimatedOpacity(
                    opacity: 1 - _appBarOpacity,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: size.safeWidth * 0.05),
                          Text(
                            diningData!.name,
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: size.safeWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      diningData!.briefDescription,
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: size.safeWidth * 0.035,
                                        color: Colors.black.withAlpha(190),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: size.safeWidth * 0.04,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${diningData!.formattedRating} (${diningData!.totalReviews} reviews)',
                                          style: TextStyle(
                                            fontFamily: 'Regular',
                                            fontSize: size.safeWidth * 0.035,
                                            color: Colors.black.withAlpha(210),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      diningData!.formattedTimings,
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: size.safeWidth * 0.035,
                                        color: Colors.black.withAlpha(210),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Add call functionality
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(40),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Text(
                                    "Call Now",
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.safeWidth * 0.03),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Sticky Tab Row
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          dividerHeight: 0,
                          onTap: (value) {},
                          indicator: BoxDecoration(),
                          tabs: List.generate(
                            tabs.length,
                            (index) => Center(
                              child: concertElevatedButton(
                                tabs[index][0],
                                tabs[index][1],
                                index,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),

                      // Menu Section
                      if (diningData!.hasMenuImages) ...[
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "Menu",
                                    key: section1Key,
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: size.safeWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.safeWidth * 0.05),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(width: size.safeWidth * 0.026),
                                  Row(
                                    children:
                                        diningData!.menuImages.map((imageUrl) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                height: size.safeWidth * 0.4,
                                                width: size.safeWidth * 0.4,
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    (context, url) => Container(
                                                      height:
                                                          size.safeWidth * 0.4,
                                                      width:
                                                          size.safeWidth * 0.4,
                                                      color: Colors.grey[300],
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Container(
                                                      height:
                                                          size.safeWidth * 0.4,
                                                      width:
                                                          size.safeWidth * 0.4,
                                                      color: Colors.grey[400],
                                                      child: Icon(
                                                        Icons.restaurant_menu,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                  SizedBox(width: size.safeWidth * 0.026),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.safeWidth * 0.07),
                      ],

                      // Gallery Section
                      if (diningData!.hasAboutImages) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Gallery",
                            key: section2Key,
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: size.safeWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: size.safeWidth * 0.05),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: size.safeWidth * 0.026),
                              Row(
                                children:
                                    diningData!.aboutImages.map((imageUrl) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            height: size.safeWidth * 0.3,
                                            width: size.safeWidth * 0.3,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Container(
                                                  height: size.safeWidth * 0.3,
                                                  width: size.safeWidth * 0.3,
                                                  color: Colors.grey[300],
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  height: size.safeWidth * 0.3,
                                                  width: size.safeWidth * 0.3,
                                                  color: Colors.grey[400],
                                                  child: Icon(Icons.image),
                                                ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                              SizedBox(width: size.safeWidth * 0.026),
                            ],
                          ),
                        ),
                        SizedBox(height: size.safeWidth * 0.07),
                      ],

                      // Reviews Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Reviews",
                          key: section3Key,
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.safeWidth * 0.05),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: EdgeInsets.all(size.safeWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: size.safeWidth * 0.08,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    diningData!.formattedRating,
                                    style: TextStyle(
                                      fontFamily: 'Semibold',
                                      fontSize: size.safeWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '(${diningData!.totalReviews} reviews)',
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: size.safeWidth * 0.035,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              if (diningData!.reviewSource.isNotEmpty) ...[
                                SizedBox(height: 8),
                                Text(
                                  'Source: ${diningData!.reviewSource}',
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: size.safeWidth * 0.03,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.safeWidth * 0.07),

                      // About Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "About",
                          key: section4Key,
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.safeWidth * 0.05),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          diningData!.description,
                          style: TextStyle(
                            fontSize: size.safeWidth * 0.035,
                            fontFamily: 'Regular',
                            height: 1.5,
                          ),
                        ),
                      ),

                      if (diningData!.cuisines.isNotEmpty) ...[
                        SizedBox(height: size.safeWidth * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Cuisines",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: size.safeWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: size.safeWidth * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                diningData!.cuisines.map((cuisine) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: gradient1.withAlpha(40),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      cuisine,
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: size.safeWidth * 0.03,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],

                      // Available Facilities
                      if (diningData!.facilities.isNotEmpty) ...[
                        SizedBox(height: size.safeWidth * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Available Facilities",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: size.safeWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: size.safeWidth * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Wrap(
                            spacing: size.safeWidth * 0.04,
                            runSpacing: 8,
                            children:
                                diningData!.facilities.map((facility) {
                                  return Text(
                                    "• $facility",
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: size.safeWidth * 0.033,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],

                      SizedBox(height: size.safeWidth * 0.05),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Similar Restaurants",
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.safeWidth * 0.05),

                      Obx(() {
                        final similarDinings =
                            diningController.nearestSummaries
                                .where((d) => d.id != widget.diningId)
                                .take(5)
                                .toList();

                        return SizedBox(
                          height: size.safeHeight * 0.3,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: size.safeWidth * 0.045,
                                  ),
                                  child: Row(
                                    children:
                                        similarDinings.map((dining) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: size.safeWidth * 0.055,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  () => Restaurentpage(
                                                    diningId: dining.id,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: size.safeWidth * 0.45,
                                                height: size.safeHeight * 0.28,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  15,
                                                                ),
                                                          ),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            dining
                                                                .carouselImage,
                                                        height:
                                                            size.safeHeight *
                                                            0.18,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (
                                                              context,
                                                              url,
                                                            ) => Container(
                                                              color:
                                                                  Colors
                                                                      .grey[300],
                                                            ),
                                                        errorWidget:
                                                            (
                                                              context,
                                                              url,
                                                              error,
                                                            ) => Container(
                                                              color: gradient1
                                                                  .withAlpha(
                                                                    80,
                                                                  ),
                                                              child: Icon(
                                                                Icons
                                                                    .restaurant,
                                                                size: 50,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                        size.safeWidth * 0.025,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            dining.name,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Medium',
                                                              fontSize:
                                                                  size.safeWidth *
                                                                  0.035,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(height: 4),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color:
                                                                    Colors
                                                                        .amber,
                                                                size:
                                                                    size.safeWidth *
                                                                    0.035,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                dining.rating
                                                                    .toStringAsFixed(
                                                                      1,
                                                                    ),
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Regular',
                                                                  fontSize:
                                                                      size.safeWidth *
                                                                      0.03,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                dining
                                                                    .formattedDistance,
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Regular',
                                                                  fontSize:
                                                                      size.safeWidth *
                                                                      0.03,
                                                                  color:
                                                                      Colors
                                                                          .black54,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: size.safeHeight * 0.1),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: size.safeWidth,
              padding: EdgeInsets.only(top: 10, bottom: 18),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      filter_window(size);
                    },
                    child: Container(
                      width: size.safeWidth * 0.45,
                      height: size.safeWidth * 0.12,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(60),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: Text(
                          "Book a Table",
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(DiningBillpage());
                    },
                    child: Container(
                      width: size.safeWidth * 0.45,
                      height: size.safeWidth * 0.12,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: Text(
                          "Pay Bill",
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sticky header class
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
