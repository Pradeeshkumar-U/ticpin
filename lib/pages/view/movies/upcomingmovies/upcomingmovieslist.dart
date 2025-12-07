// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/services.dart';
// import 'package:ticpin/constants/shapes/containers.dart';
// import 'package:ticpin/constants/size.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:ticpin/constants/styles.dart';
// import 'package:ticpin/constants/temporary.dart';

// // ignore: must_be_immutable
// class UpcomingMoviesList extends StatefulWidget {
//   const UpcomingMoviesList({super.key});

//   @override
//   State<UpcomingMoviesList> createState() => _UpcomingMoviesListState();
// }

// class _UpcomingMoviesListState extends State<UpcomingMoviesList>
//     with TickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   late TabController _tabController;

//   double _opacity = 0.0;
//   int _carouselCurrent = 0;

//   final CarouselSliderController _carouselSliderController =
//       CarouselSliderController();

//   static Tab defaultTab(String name, bool isSelected) {
//     return Tab(
//       child: Row(
//         children: [
//           // Padding(
//           //   padding: EdgeInsets.only(right: Sizes().width * 0.015),
//           //   child: SvgPicture.asset(
//           //     // ignore: deprecated_member_use
//           //     color: isSelected ? Color(0xFF000070) : Colors.black45,
//           //     icon,
//           //     width: Sizes().width * 0.06,
//           //     height: Sizes().width * 0.06,
//           //   ),
//           // ),
//           Text(
//             name,
//             style: TextStyle(
//               fontSize: Sizes().width * 0.025,
//               color: isSelected ? Color(0xFF000070) : Colors.black45,
//               fontFamily: 'Semibold',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   int tabIndex = 0;
//   @override
//   void initState() {
//     super.initState();

//     _tabController = TabController(length: 4, vsync: this);

//     _scrollController.addListener(() {
//       double offset = _scrollController.offset;

//       // Adjust this value depending on when you want the title to fade in
//       double fadeStart = size.safeHeight * 0.3;
//       double fadeEnd = size.safeHeight * 0.35;

//       double newOpacity = (offset - fadeStart) / (fadeEnd - fadeStart);
//       newOpacity = newOpacity.clamp(0.0, 1.0);
//       if (_opacity != newOpacity) {
//         if (mounted) {
//           setState(() {
//             _opacity = newOpacity;
//           });
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();

//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<List<String>> getTopTracks(String artist) async {
//     final apiKey = '32fc48456591478c3a309c204c65e477';
//     final url = Uri.parse(
//       'http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=${Uri.encodeComponent(artist)}&api_key=$apiKey&format=json&limit=5',
//     );

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final tracks = data['toptracks']['track'] as List;
//       return tracks.map((track) => track['name'] as String).toList();
//     } else {
//       throw Exception('Failed to load top tracks');
//     }
//   }

//   Sizes size = Sizes();
//   @override
//   Widget build(BuildContext context) {
//     final wid = size.safeWidth * 0.9;
//     final tabs = ['Filters', 'This Week', 'This Month', 'Next Month'];
//     return Material(
//       child: Stack(
//         children: [
//           Container(
//             height: size.safeHeight * 0.6,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 // begin: Alignment.topLeft,
//                 // end: Alignment.bottomRight,
//                 // stops: [0.45, 1],
//                 // colors: [
//                 //   Color(0xFF2cd5d9).withAlpha(30),
//                 //   Color(0xff2323ff).withAlpha(30),
//                 // ],
//                 colors: [
//                   gradient1.withAlpha(70),
//                   gradient2.withAlpha(35),
//                   Colors.white10,
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 stops: const [0.15, 0.3, 0.45],
//               ),
//             ),
//           ),
//           // Container(
//           //   color: whiteColor,
//           //   child:
//           // ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: size.safeHeight * 0.1,
//               width: size.safeWidth,
//               decoration: BoxDecoration(
//                 color: whiteColor,
//                 border: Border(top: BorderSide(color: blackColor)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: size.safeWidth * 0.08),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           ' Starts from',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: size.safeWidth * 0.03,
//                             fontFamily: 'Regular',
//                           ),
//                         ),
//                         Text(
//                           ' Rupees',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: size.safeWidth * 0.035,
//                             fontFamily: 'Medium',
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: size.safeWidth * 0.08),
//                     child: Container(
//                       width: size.safeWidth * 0.26,
//                       height: size.safeWidth * 0.08,
//                       decoration: BoxDecoration(
//                         color: blackColor,
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Book Tickets',
//                           style: TextStyle(
//                             color: whiteColor,
//                             fontSize: size.safeWidth * 0.03,
//                             fontFamily: 'Regular',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Scaffold(
//             appBar: AppBar(
//               backgroundColor: _opacity > 0.1 ? whiteColor : Colors.transparent,
//               surfaceTintColor: Colors.transparent,

//               automaticallyImplyLeading: true,
//               leading: Padding(
//                 padding: EdgeInsets.only(left: size.safeWidth * 0.05),
//                 child: Container(
//                   width: size.safeWidth * 0.09,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: greyColor.withAlpha(60),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Icon(Icons.arrow_back, size: size.safeWidth * 0.05),
//                   ),
//                 ),
//               ),
//               toolbarHeight: size.safeHeight * 0.08,
//               actions: [
//                 Padding(
//                   padding: EdgeInsets.only(right: size.safeWidth * 0.05),
//                   child: Container(
//                     width: size.safeWidth * 0.085,
//                     height: size.safeWidth * 0.085,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: greyColor.withAlpha(60),
//                     ),
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Icon(
//                         CupertinoIcons.search,
//                         size: size.safeWidth * 0.05,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//               title:
//                   _opacity > 0.1
//                       ? Text(
//                         'Upcoming Movies',
//                         style: TextStyle(
//                           fontSize: size.safeWidth * 0.05,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Regular',
//                         ),
//                       )
//                       : null,
//               // title: AnimatedOpacity(
//               //   opacity: _opacity,
//               //   duration: Duration(milliseconds: 300),
//               //   child: Text("Movie Title"),
//               // ),
//               // flexibleSpace: FlexibleSpaceBar(
//               //   title: Opacity(
//               //     opacity: _opacity,
//               //     child: Text(
//               //       'Upcoming Movies',
//               //       style: TextStyle(
//               //         fontSize: size.safeWidth * 0.05,
//               //         fontWeight: FontWeight.bold,
//               //         fontFamily: 'Regular',
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ),
//             backgroundColor: Colors.transparent,
//             body: CustomScrollView(
//               controller: _scrollController,
//               slivers: [
//                 // SliverAppBar(
//                 //   backgroundColor:
//                 //       _opacity > 0.1 ? whiteColor : Colors.transparent,
//                 //   surfaceTintColor: Colors.transparent,
//                 //   pinned: true,
//                 //   floating: false,
//                 //   automaticallyImplyLeading: true,
//                 //   actions: [
//                 //     SvgPicture.asset(
//                 //       'assets/images/icons/fire.svg',
//                 //       width: size.safeWidth * 0.06,
//                 //       height: size.safeWidth * 0.07,
//                 //     ),
//                 //     SizedBox(width: size.safeWidth * 0.04),
//                 //     SvgPicture.asset(
//                 //       'assets/images/icons/share.svg',
//                 //       width: size.safeWidth * 0.06,
//                 //       height: size.safeWidth * 0.06,
//                 //     ),
//                 //     SizedBox(width: size.safeWidth * 0.05),
//                 //   ],
//                 //   // title: AnimatedOpacity(
//                 //   //   opacity: _opacity,
//                 //   //   duration: Duration(milliseconds: 300),
//                 //   //   child: Text("Movie Title"),
//                 //   // ),
//                 //   flexibleSpace: FlexibleSpaceBar(
//                 //     title: Opacity(
//                 //       opacity: _opacity,
//                 //       child: Text(
//                 //         'Upcoming Movies',
//                 //         style: TextStyle(
//                 //           fontSize: size.safeWidth * 0.05,
//                 //           fontWeight: FontWeight.bold,
//                 //           fontFamily: 'Regular',
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 SliverToBoxAdapter(
//                   child: SizedBox(
//                     height: size.safeHeight * 0.3,
//                     width: double.infinity,
//                     child: Align(
//                       alignment: Alignment(0.75, -0.3),
//                       child: Text(
//                         'Upcoming\nmovies',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: size.safeWidth * 0.045,
//                           fontFamily: 'Medium',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SliverPersistentHeader(
//                   pinned: true,
//                   floating: true,
//                   delegate: _StickyTabBarDelegate(
//                     child: Container(
//                       color: _opacity > 0.1 ? whiteColor : Colors.transparent,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 0.01 * size.safeWidth,
//                         vertical: 8,
//                       ),
//                       child: ButtonsTabBar(
//                         controller: _tabController,
//                         unselectedBackgroundColor: whiteColor,
//                         unselectedBorderColor: Colors.black45,
//                         backgroundColor: Color(0xFFCFCFFA),
//                         borderWidth: 1.5,
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: size.safeWidth * 0.02,
//                         ),
//                         contentCenter: true,
//                         borderColor: Color(0xFF000070),
//                         onTap: (index) {
//                           setState(() {
//                             tabIndex = _tabController.index;
//                           });
//                         },

//                         width: size.safeWidth * 0.33,
//                         radius: 15,
//                         height: size.safeWidth * 0.09,
//                         // physics: NeverScrollableScrollPhysics(),
//                         buttonMargin: EdgeInsets.symmetric(horizontal: 12),

//                         tabs: List.generate(tabs.length, (index) {
//                           return Tab(
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 10.0),
//                               child: defaultTab(
//                                 tabs[index],
//                                 _tabController.index == index,
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                       // child: TabBar(
//                       //   indicator: BoxDecoration(),
//                       //   controller: _tabController,
//                       //   dividerHeight: 0,
//                       //   // padding: EdgeInsets.all(size.safeWidth * 0.02),
//                       //   // tabs: [
//                       //   //   concertElevatedButton('About', section1Key),
//                       //   //   concertElevatedButton('Artist', section2Key),
//                       //   //   concertElevatedButton('Gallery', section3Key),
//                       //   //   concertElevatedButton('Venue', section4Key),
//                       //   // ]
//                       //   onTap: (value) {},
//                       //   tabs: List.generate(
//                       //     tabs.length,
//                       //     (index) => Center(
//                       //       child: concertElevatedButton(tabs[index][0], index),
//                       //     ),
//                       //   ),
//                       // ),
//                     ),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Container(
//                     color: whiteColor,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(
//                             top: size.safeWidth * 0.06,
//                             bottom: size.safeWidth * 0.05,
//                           ),
//                           child: Text('COMING SOON', style: mainTitleTextStyle),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: size.safeWidth * 0.01,
//                           ),
//                           child: gridViewer(),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(
//                             top: size.safeWidth * 0.01,
//                             bottom: size.safeWidth * 0.05,
//                           ),
//                           child: Text('AUGUST 2025', style: mainTitleTextStyle),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: size.safeWidth * 0.01,
//                           ),
//                           child: gridViewer(),
//                         ),
//                         SizedBox(height: size.safeHeight * 0.03),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Padding contentTiles(IconData icon, String title, String subtitle) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: size.safeWidth * 0.035,
//         horizontal: size.safeWidth * 0.03,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: size.safeWidth * 0.06),
//             child: Container(
//               height: size.safeWidth * 0.12,
//               width: size.safeWidth * 0.12,
//               decoration: BoxDecoration(
//                 color: greyColor.withAlpha(50),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: Colors.black54, size: size.safeWidth * 0.06),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: size.safeWidth * 0.033,
//                   fontFamily: 'Regular',
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: size.safeWidth * 0.031,
//                   fontFamily: 'Regular',
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Future<void> _onScroll() async {
//   //   List<Map<String, dynamic>> sections = [
//   //     {'key': section1Key, 'index': 0},
//   //     {'key': section2Key, 'index': 1},
//   //     {'key': section3Key, 'index': 2},
//   //     {'key': section4Key, 'index': 3},
//   //   ];

//   //   for (var section in sections) {
//   //     final keyContext = section['key'].currentContext;
//   //     if (keyContext != null) {
//   //       final box = keyContext.findRenderObject() as RenderBox;
//   //       final position = box.localToGlobal(Offset.zero, ancestor: null).dy;

//   //       if (position <= size.safeHeight * 0.5 && position >= -box.size.safeHeight / 5) {
//   //         if (_selectedIndex != section['index']) {
//   //           _selectedIndex = section['index'];
//   //         }
//   //         break;
//   //       }

//   //       // if (mounted) {
//   //       //   setState(() {});
//   //       // }
//   //     }
//   //   }
//   // }

//   int _selectedIndex = 0;
//   ElevatedButton concertElevatedButton(String label, int index) {
//     bool isSelected = _selectedIndex == index;
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         fixedSize: Size.fromWidth(size.safeWidth * 0.2),
//         elevation: 0,
//         padding: EdgeInsets.all(size.safeWidth * 0.02),
//         backgroundColor: isSelected ? Color(0xFFCFCFFA) : whiteColor,
//         // side: BorderSide(color: Colors.black12.withAlpha(30), width: 1.2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
//       ),
//       onPressed: () {
//         // update tab highlight
//         setState(() {});
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
// }

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
//   double get maxExtent =>
//       child is PreferredSizeWidget
//           ? (child as PreferredSizeWidget).preferredsize.safeHeight
//           : kToolbarHeight;

//   @override
//   double get minExtent => maxExtent;

//   @override
//   bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
//     return oldDelegate.child != child;
//   }
// }
// // Container(
// //                     color: whiteColor,
// //                     child: Column(
// //                       children: [
// //                         Padding(
// //                           padding: EdgeInsets.only(
// //                             top: size.safeWidth * 0.06,
// //                             bottom: size.safeWidth * 0.05,
// //                           ),
// //                           child: Text('COMING SOON', style: mainTitleTextStyle),
// //                         ),
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: size.safeWidth * 0.01,
// //                           ),
// //                           child: gridViewer(),
// //                         ),
// //                         Padding(
// //                           padding: EdgeInsets.only(
// //                             top: size.safeWidth * 0.01,
// //                             bottom: size.safeWidth * 0.05,
// //                           ),
// //                           child: Text('AUGUST 2025', style: mainTitleTextStyle),
// //                         ),
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: size.safeWidth * 0.01,
// //                           ),
// //                           child: gridViewer(),
// //                         ),
// //                         SizedBox(height: size.safeHeight * 0.03),
// //                       ],
// //                     ),
// //                   ),

import 'package:flutter/material.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/shapes/containers.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';

class UpcomingMoviesList extends StatefulWidget {
  const UpcomingMoviesList({super.key});

  @override
  State<UpcomingMoviesList> createState() => _UpcomingMoviesListState();
}

class _UpcomingMoviesListState extends State<UpcomingMoviesList> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _stickyKey = GlobalKey();
  late int eve_cate_ind;

  double _scrollOffset = 0.0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  double _fadeValue() {
    const maxScroll = 200.0;
    return (_scrollOffset / maxScroll).clamp(0.0, 1.0);
  }

  List<Map<String, dynamic>> filt_but_st = [
    {"value": "Today", "tapped": false},
    {"value": "Tomorrow", "tapped": false},
    {"value": "Music", "tapped": false},
    {"value": "Concert", "tapped": false},
  ];
  Widget filter_butt(int ind) {
    return InkWell(
      onTap: () {
        setState(() {
          filt_but_st[ind]["tapped"] = !filt_but_st[ind]["tapped"];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color:
              filt_but_st[ind]["tapped"]
                  ? gradient1.withOpacity(0.2)
                  : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          "${filt_but_st[ind]["value"]}",
          style: TextStyle(fontFamily: 'Regular'),
        ),
      ),
    );
  }

  // Sort options (Radio)
  final List<Map<String, dynamic>> sortOptions = [
    {"label": "Popularity"},
    {"label": "Date"},
    {"label": "Price: High to Low"},
    {"label": "Price: Low to High"},
  ];
  String selectedSort = "Popularity";

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
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        "Filter by",
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

                // Tabs + content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left menu
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setSheetState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color: Colors.black12,
                            width: size.safeWidth * 0.3,
                            height: size.safeHeight * 0.07,
                            alignment: Alignment.center,
                            child: Text(
                              "Sort by",
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: size.safeWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Right content
                    Container(
                      width: size.safeWidth * 0.7,
                      color: Colors.black12,
                      // height: size.safeHeight * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Sort by (Radio)
                            ...sortOptions.map((opt) {
                              return RadioListTile<String>(
                                title: Text(
                                  opt["label"],
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: size.safeWidth * 0.04,
                                  ),
                                ),
                                value: opt["label"],
                                groupValue: selectedSort,
                                onChanged: (val) {
                                  setSheetState(() {
                                    selectedSort = val!;
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //   Buttons
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Clear All",
                        style: TextStyle(fontFamily: 'Regular'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Apply",
                          style: TextStyle(
                            fontFamily: 'Regular',
                            color: Colors.white,
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

  final siz = Sizes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient1.withAlpha(70),
              gradient2.withAlpha(35),
              Colors.white10,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.15, 0.3, 0.45],
          ).withOpacity((1.0 - _fadeValue()) * 0.2),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // AppBar with fade
            SliverAppBar(
              pinned: true,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white.withOpacity(_fadeValue()),
              elevation: _fadeValue() > 0.5 ? 2 : 0,
              iconTheme: IconThemeData(
                color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
                ),
              ),
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _fadeValue(),
                child: Text(
                  'Upcoming Movies',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search_rounded,
                    color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
                  ),
                ),
              ],
            ),

            // Top content
            SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Flexible(
                    //   child: Image.asset(
                    //     ,
                    //     fit: BoxFit.fitHeight,
                    //     width: siz.safeWidth * 0.5,
                    //   ),
                    // ),
                    FittedBox(
                      child: Text(
                        'Upcoming\nMovies',
                        style: TextStyle(
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600,
                          fontSize: siz.safeWidth * 0.08,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 100),
              ]),
            ),

            // Sticky Row
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyRowDelegate(
                minHeight: 80,
                maxHeight: 80,
                child: Container(
                  key: _stickyKey,
                  color: Colors.white.withOpacity(_fadeValue()),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      // Text(
                      //   '${eve_cate_data[eve_cate_ind]["name"]} Events',
                      //   style: TextStyle(
                      //     fontFamily: 'Regular',
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: siz.safeWidth * 0.05,
                      //   ),
                      // ),
                      const Spacer(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 15,
                          children: [
                            SizedBox(width: siz.safeWidth * 0.01),
                            InkWell(
                              onTap: () {
                                filter_window(siz);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Icon(Icons.filter_alt),
                                    Text(
                                      "Filters",
                                      style: TextStyle(fontFamily: 'Regular'),
                                    ),
                                    Icon(Icons.keyboard_arrow_down),
                                  ],
                                ),
                              ),
                            ),
                            ...List.generate(
                              filt_but_st.length,
                              (ind) => filter_butt(ind),
                            ),
                            SizedBox(width: siz.safeWidth * 0.01),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable List
            SliverToBoxAdapter(
              child: Column(
                // padding: EdgeInsets.only(bottom: 15.0),
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: siz.safeWidth * 0.06,
                      // bottom: siz.safeWidth * 0.05,
                    ),
                    child: Text('COMING SOON', style: mainTitleTextStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: siz.safeWidth * 0.0,
                    ),
                    child: gridViewer(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: siz.safeWidth * 0.01,
                      // bottom: siz.safeWidth * 0.05,
                    ),
                    child: Text('AUGUST 2025', style: mainTitleTextStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: siz.safeWidth * 0.0,
                    ),
                    child: gridViewer(),
                  ),
                  SizedBox(height: siz.safeHeight * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyRowDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyRowDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyRowDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
