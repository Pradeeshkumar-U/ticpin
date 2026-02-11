// import 'package:flutter/material.dart';
// import 'package:ticpin/constants/colors.dart';

// class Musicpage extends StatefulWidget {
//   const Musicpage({super.key});

//   @override
//   State<Musicpage> createState() => _MusicpageState();
// }

// class _MusicpageState extends State<Musicpage> {
//   final ScrollController _scrollController = ScrollController();
//   final GlobalKey _stickyKey = GlobalKey();

//   double _scrollOffset = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       setState(() {
//         _scrollOffset = _scrollController.offset;
//       });
//     });
//   }

//   double _fadeValue() {
//     const maxScroll = 200.0;
//     return (_scrollOffset / maxScroll).clamp(0.0, 1.0);
//   }

//   List<Map<String, dynamic>> filt_but_st = [
//     {"value": "Today", "tapped": false},
//     {"value": "Tomorrow", "tapped": false},
//     {"value": "Music", "tapped": false},
//     {"value": "Concert", "tapped": false},
//   ];
//   Widget filter_butt(int ind) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           filt_but_st[ind]["tapped"] = !filt_but_st[ind]["tapped"];
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//         decoration: BoxDecoration(
//           color:
//               filt_but_st[ind]["tapped"]
//                   ? gradient1.withOpacity(0.2)
//                   : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.black),
//         ),
//         child: Text("${filt_but_st[ind]["value"]}"),
//       ),
//     );
//   }

//   // Sort options (Radio)
//   final List<Map<String, dynamic>> sortOptions = [
//     {"label": "Popularity"},
//     {"label": "Date"},
//     {"label": "Price: High to Low"},
//     {"label": "Price: Low to High"},
//   ];
//   String selectedSort = "Popularity";

//   void filter_window(Size size) {
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
//                         "Filter by",
//                         style: TextStyle(fontFamily:'Regular',
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
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Left menu
//                     Column(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setSheetState(() {});
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             color: Colors.black12,
//                             width: size.safeWidth * 0.3,
//                             height: size.safeHeight * 0.07,
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Sort by",
//                               style: TextStyle(fontFamily:'Regular',
//                                 fontFamily: 'Regular',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: size.safeWidth * 0.04,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Right content
//                     Container(
//                       width: size.safeWidth * 0.7,
//                       color: Colors.black12,
//                       // height: size.safeHeight * 0.5,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             // Sort by (Radio)
//                             ...sortOptions.map((opt) {
//                               return RadioListTile<String>(
//                                 title: Text(
//                                   opt["label"],
//                                   style: TextStyle(fontFamily:'Regular',
//                                     fontFamily: 'Regular',
//                                     fontSize: size.safeWidth * 0.04,
//                                   ),
//                                 ),
//                                 value: opt["label"],
//                                 groupValue: selectedSort,
//                                 onChanged: (val) {
//                                   setSheetState(() {
//                                     selectedSort = val!;
//                                   });
//                                 },
//                               );
//                             }),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 //   Buttons
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text("Clear All"),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           "Apply",
//                           style: TextStyle(fontFamily:'Regular',
//                             fontFamily: 'Regular',
//                             color: Colors.white,
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

//   @override
//   Widget build(BuildContext context) {
//     final siz = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               gradient1.withAlpha(70),
//               gradient2.withAlpha(35),
//               Colors.white10,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: const [0.15, 0.3, 0.45],
//           ).withOpacity((1.0 - _fadeValue()) * 0.2),
//         ),
//         child: CustomScrollView(
//           controller: _scrollController,
//           slivers: [
//             // AppBar with fade
//             SliverAppBar(
//               pinned: true,
//               surfaceTintColor: Colors.transparent,
//               backgroundColor: Colors.white.withOpacity(_fadeValue()),
//               elevation: _fadeValue() > 0.5 ? 2 : 0,
//               iconTheme: IconThemeData(
//                 color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
//               ),
//               leading: IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
//                 ),
//               ),
//               title: AnimatedOpacity(
//                 duration: const Duration(milliseconds: 200),
//                 opacity: _fadeValue(),
//                 child: Text(
//                   'Music Events',
//                   style: TextStyle(fontFamily:'Regular',
//                     fontFamily: 'Regular',
//                     color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
//                   ),
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.search_rounded,
//                     color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
//                   ),
//                 ),
//               ],
//             ),

//             // Top content
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Flexible(
//                       child: Image.asset(
//                         "assets/images/music.png",
//                         fit: BoxFit.contain,
//                         width: siz.safeWidth * 0.5,
//                       ),
//                     ),
//                     Text(
//                       'Music',
//                       style: TextStyle(fontFamily:'Regular',
//                         fontFamily: 'Regular',
//                         fontWeight: FontWeight.w600,
//                         fontSize: siz.safeWidth * 0.1,
//                       ),
//                     ),
//                     SizedBox.shrink(),
//                   ],
//                 ),
//                 const SizedBox(height: 100),
//               ]),
//             ),

//             // Sticky Row
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: _StickyRowDelegate(
//                 minHeight: 90,
//                 maxHeight: 90,
//                 child: Container(
//                   key: _stickyKey,
//                   color: Colors.white.withOpacity(_fadeValue()),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   child: Column(
//                     children: [
//                       // Text(
//                       //   'Music Events',
//                       //   style: TextStyle(fontFamily:'Regular',
//                       //     fontFamily: 'Regular',
//                       //     fontWeight: FontWeight.w600,
//                       //     fontSize: siz.safeWidth * 0.05,
//                       //   ),
//                       // ),
//                       // const Spacer(),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           spacing: 15,
//                           children: [
//                             const SizedBox(),
//                             InkWell(
//                               onTap: () {
//                                 filter_window(siz);
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(color: Colors.black),
//                                 ),
//                                 child: Row(
//                                   spacing: 5,
//                                   children: [
//                                     Icon(Icons.filter_alt),
//                                     Text("Filters"),
//                                     Icon(Icons.keyboard_arrow_down),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             ...List.generate(
//                               filt_but_st.length,
//                               (ind) => filter_butt(ind),
//                             ),
//                             const SizedBox(),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Scrollable List
//             SliverList(
//               delegate: SliverChildBuilderDelegate((context, index) {
//                 return Container(
//                   color: whiteColor,
//                   child: Padding(
//                     padding: EdgeInsets.only(bottom: 25.0),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: siz.safeHeight * 0.5,
//                           width: siz.safeWidth * 0.85,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(15),
//                               topRight: Radius.circular(15),
//                             ),
//                             border: Border(
//                               top: BorderSide(),
//                               left: BorderSide(),
//                               right: BorderSide(),
//                             ),
//                           ),
//                           alignment: Alignment.center,
//                           child: Text("Poster or Video"),
//                         ),
//                         Container(
//                           width: siz.safeWidth * 0.85,
//                           height: siz.safeHeight * 0.1,
//                           decoration: BoxDecoration(
//                             border: Border.all(),
//                             borderRadius: BorderRadius.only(
//                               bottomRight: Radius.circular(15),
//                               bottomLeft: Radius.circular(15),
//                             ),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 5,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Date"),
//                               Text(
//                                 "Concert Name",
//                                 style: TextStyle(fontFamily:'Regular',
//                                   fontFamily: 'Regular',
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               Text("Location"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }, childCount: 5),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _StickyRowDelegate extends SliverPersistentHeaderDelegate {
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;

//   _StickyRowDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });

//   @override
//   double get minExtent => minHeight;

//   @override
//   double get maxExtent => maxHeight;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return SizedBox.expand(child: child);
//   }

//   @override
//   bool shouldRebuild(covariant _StickyRowDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }

import 'package:flutter/material.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';

class Musicpage extends StatefulWidget {
  final int eve_cat_ind;
  const Musicpage({super.key, required this.eve_cat_ind});

  @override
  State<Musicpage> createState() => _MusicpageState();
}

class _MusicpageState extends State<Musicpage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _stickyKey = GlobalKey();
  late int eve_cate_ind;

  double _scrollOffset = 0.0;
  List<Map<String, String>> eve_cate_data = [
    {"name": "Music", "img": "assets/images/music.png"},
    {"name": "Comedy", "img": "assets/images/movies.png"},
    {"name": "Performance", "img": "assets/images/event.png"},
    {"name": "Sports", "img": "assets/images/sports.png"},
  ];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    eve_cate_ind = widget.eve_cat_ind;
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
        child: Text("${filt_but_st[ind]["value"]}"),
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
                      child: Text("Clear All"),
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
                  eve_cate_data[eve_cate_ind]["name"]!,
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
                    Flexible(
                      child: Image.asset(
                        eve_cate_data[eve_cate_ind]["img"]!,
                        fit: BoxFit.fitHeight,
                        width: siz.safeWidth * 0.5,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        eve_cate_data[eve_cate_ind]["name"]!,
                        style: TextStyle(
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.w600,
                          fontSize: siz.safeWidth * 0.06,
                        ),
                      ),
                    ),
                    SizedBox(width: siz.safeWidth * 0.02),
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
                      // const Spacer(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 15,
                          children: [
                            const SizedBox(),
                            InkWell(
                              onTap: () {
                                filter_window(siz);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Icon(Icons.filter_alt),
                                    Text("Filters"),
                                    Icon(Icons.keyboard_arrow_down),
                                  ],
                                ),
                              ),
                            ),
                            ...List.generate(
                              filt_but_st.length,
                              (ind) => filter_butt(ind),
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable List
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    children: [
                      Container(
                        height: siz.safeHeight * 0.5,
                        width: siz.safeWidth * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          border: Border(
                            top: BorderSide(),
                            left: BorderSide(),
                            right: BorderSide(),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text("Poster or Video"),
                      ),
                      Container(
                        width: siz.safeWidth * 0.85,
                        height: siz.safeHeight * 0.1,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date"),
                            Text(
                              "Concert Name",
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text("Location"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: 5),
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
