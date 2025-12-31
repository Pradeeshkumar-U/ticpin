// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:ticpin/constants/colors.dart';
// // import 'package:ticpin/constants/size.dart';
// // import 'package:ticpin/constants/styles.dart';
// // import 'package:ticpin/constants/temporary.dart';
// // import 'package:ticpin/pages/view/music/musicpage.dart';

// // class Eventspagepage extends StatefulWidget {
// //   const Eventspagepage({super.key});

// //   @override
// //   State<Eventspagepage> createState() => _EventspagepageState();
// // }

// // class _EventspagepageState extends State<Eventspagepage> {
// //   List<Map<String, String>> eve_cate_data = [
// //   {"name": "Music", "img": "assets/image/music_ca.png"},
// //   {"name": "Comedy", "img": "assets/image/comedy_ca.png"},
// //   {"name": "Performance", "img": "assets/image/performance_ca.png"},
// //   {"name": "Sports", "img": "assets/image/sport_ca.png"},
// // ];
// //   Widget eve_cate(String name, String loc, final size, Widget desti) {
// //     return GestureDetector(
// //       onTap: () => Get.to(desti),
// //       child: Container(
// //         padding: EdgeInsets.all(size.safeWidth * 0.027),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(15),
// //           border: Border.all(color: Colors.black26, width: 0.5),
// //           // gradient: LinearGradient(
// //           //   colors: [gradient1.withOpacity(0.2), gradient2.withOpacity(0.2)],
// //           //   begin: Alignment.topLeft,
// //           //   end: Alignment.bottomRight,
// //           // ),
// //         ),
// //         width: size.safeWidth * 0.3,
// //         height: size.safeHeight * 0.15,
// //         child: Column(
// //           children: [
// //             Text(
// //               name,
// //               style: TextStyle(fontFamily:'Regular',
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: size.safeWidth * 0.031,
// //                 fontFamily: 'Regular',
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             Flexible(
// //               fit: FlexFit.tight,
// //               child: Image.asset(loc, fit: BoxFit.scaleDown),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   //
// //   List<Map<String, dynamic>> filt_but_st = [
// //     {"value": "Today", "tapped": false},
// //     {"value": "Tomorrow", "tapped": false},
// //     {"value": "Music", "tapped": false},
// //     {"value": "Concert", "tapped": false},
// //   ];
// //   Widget filter_butt(int ind) {
// //     return InkWell(
// //       onTap: () {
// //         setState(() {
// //           filt_but_st[ind]["tapped"] = !filt_but_st[ind]["tapped"];
// //         });
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
// //         decoration: BoxDecoration(
// //           color:
// //               filt_but_st[ind]["tapped"]
// //                   ? gradient1.withOpacity(0.2)
// //                   : Colors.white,
// //           borderRadius: BorderRadius.circular(10),
// //           border: Border.all(color: Colors.black),
// //         ),
// //         child: Text("${filt_but_st[ind]["value"]}"),
// //       ),
// //     );
// //   }

// //   //
// //   bool sort_by_fil_vis = true;
// //   bool genre_fil_vis = false;

// //   // Sort options (Radio)
// //   final List<Map<String, dynamic>> sortOptions = [
// //     {"label": "Popularity"},
// //     {"label": "Date"},
// //     {"label": "Price: High to Low"},
// //     {"label": "Price: Low to High"},
// //   ];
// //   String selectedSort = "Popularity"; // default selected

// //   // Genre options (Checkbox)
// //   final List<Map<String, dynamic>> genreOptions = [
// //     {"label": "Action", "isChecked": false},
// //     {"label": "Comedy", "isChecked": false},
// //     {"label": "Drama", "isChecked": false},
// //     {"label": "Sci-Fi", "isChecked": false},
// //     {"label": "Horror", "isChecked": false},
// //     {"label": "Adventure", "isChecked": false},
// //     {"label": "Thriller", "isChecked": false},
// //     {"label": "Family", "isChecked": false},
// //     {"label": "Fantasy", "isChecked": false},
// //     {"label": "Bio-pic", "isChecked": false},
// //   ];

// //   void filter_window(Size size) {
// //     showModalBottomSheet(
// //       backgroundColor: Colors.white,
// //       context: context,
// //       isScrollControlled: true,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       builder: (context) {
// //         return StatefulBuilder(
// //           builder: (context, setSheetState) {
// //             return Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 // Header
// //                 Padding(
// //                   padding: const EdgeInsets.all(20),
// //                   child: Row(
// //                     children: [
// //                       Text(
// //                         "Filter by",
// //                         style: TextStyle(fontFamily:'Regular',
// //                           fontWeight: FontWeight.w600,
// //                           fontSize: size.safeWidth * 0.05,
// //                         ),
// //                       ),
// //                       const Spacer(),
// //                       IconButton(
// //                         onPressed: () => Navigator.pop(context),
// //                         icon: const Icon(Icons.close),
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 // Tabs + content
// //                 Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Left menu
// //                     Column(
// //                       children: [
// //                         GestureDetector(
// //                           onTap: () {
// //                             setSheetState(() {
// //                               sort_by_fil_vis = true;
// //                               genre_fil_vis = false;
// //                             });
// //                           },
// //                           child: Container(
// //                             padding: const EdgeInsets.symmetric(vertical: 10),
// //                             color:
// //                                 sort_by_fil_vis ? Colors.black12 : Colors.white,
// //                             width: size.safeWidth * 0.3,
// //                             alignment: Alignment.center,
// //                             child: Text(
// //                               "Sort by",
// //                               style: TextStyle(fontFamily:'Regular',
// //                                 fontWeight: FontWeight.w600,
// //                                 fontSize: size.safeWidth * 0.04,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         GestureDetector(
// //                           onTap: () {
// //                             setSheetState(() {
// //                               genre_fil_vis = true;
// //                               sort_by_fil_vis = false;
// //                             });
// //                           },
// //                           child: Container(
// //                             padding: const EdgeInsets.symmetric(vertical: 10),
// //                             color:
// //                                 genre_fil_vis ? Colors.black12 : Colors.white,
// //                             width: size.safeWidth * 0.3,
// //                             alignment: Alignment.center,
// //                             child: Text(
// //                               "Genre",
// //                               style: TextStyle(fontFamily:'Regular',
// //                                 fontWeight: FontWeight.w600,
// //                                 fontSize: size.safeWidth * 0.04,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     // Right content
// //                     Container(
// //                       width: size.safeWidth * 0.7,
// //                       color: Colors.black12,
// //                       height: size.safeHeight * 0.5,
// //                       child: SingleChildScrollView(
// //                         child: Column(
// //                           children: [
// //                             // Sort by (Radio)
// //                             if (sort_by_fil_vis)
// //                               ...sortOptions.map((opt) {
// //                                 return RadioListTile<String>(
// //                                   title: Text(
// //                                     opt["label"],
// //                                     style: TextStyle(fontFamily:'Regular',
// //                                       fontSize: size.safeWidth * 0.04,
// //                                     ),
// //                                   ),
// //                                   value: opt["label"],
// //                                   groupValue: selectedSort,
// //                                   onChanged: (val) {
// //                                     setSheetState(() {
// //                                       selectedSort = val!;
// //                                     });
// //                                   },
// //                                 );
// //                               }),

// //                             // Genre (Checkbox)
// //                             if (genre_fil_vis)
// //                               ...genreOptions.asMap().entries.map((entry) {
// //                                 int index = entry.key;
// //                                 var option = entry.value;

// //                                 return CheckboxListTile(
// //                                   title: Text(
// //                                     option["label"],
// //                                     style: TextStyle(fontFamily:'Regular',
// //                                       fontSize: size.safeWidth * 0.04,
// //                                     ),
// //                                   ),
// //                                   value: option["isChecked"],
// //                                   onChanged: (val) {
// //                                     setSheetState(() {
// //                                       genreOptions[index]["isChecked"] =
// //                                           val ?? false;
// //                                     });
// //                                   },
// //                                   controlAffinity:
// //                                       ListTileControlAffinity.leading,
// //                                 );
// //                               }),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),

// //                 //   Buttons
// //                 SizedBox(height: 10),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     TextButton(onPressed: () {}, child: Text("Clear All")),
// //                     InkWell(
// //                       onTap: () {},
// //                       child: Container(
// //                         padding: EdgeInsets.symmetric(
// //                           horizontal: 30,
// //                           vertical: 10,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: Colors.black,
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                         child: Text(
// //                           "Apply",
// //                           style: TextStyle(fontFamily:'Regular',color: Colors.white),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     //
// //     //
// //     final siz = MediaQuery.of(context).size;
// //     final textscl = MediaQuery.of(context).textScaleFactor;
// //     final fs = siz.safeWidth * 0.04 * textscl;

// //     //
// //     //
// //     return Scaffold(
// //       backgroundColor: whiteColor,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           child: Column(
// //             spacing: 15,
// //             children: [
// //               // Eventspage Category
// //               Center(
// //                 child: Text(
// //                   "EVENTS CATEGORY",
// //                   style: mainTitleTextStyle,
// //                   textAlign: TextAlign.center,
// //                 ),
// //               ),

// //               SingleChildScrollView(
// //                 scrollDirection: Axis.horizontal,
// //                 child: Row(
// //                   spacing: 15,
// //                   children: [
// //                     SizedBox(),
// //                     eve_cate(
// //                       "Music",
// //                       "assets/images/music.png",
// //                       siz,
// //                       MusicPage(name),
// //                     ),
// //                     eve_cate(
// //                       "Comedy",
// //                       "assets/images/movies.png",
// //                       siz,
// //                       MusicPage(),
// //                     ),
// //                     eve_cate(
// //                       "Performance",
// //                       "assets/images/event.png",
// //                       siz,
// //                       MusicPage(),
// //                     ),
// //                     eve_cate(
// //                       "Sports",
// //                       "assets/images/sports.png",
// //                       siz,
// //                       MusicPage(),
// //                     ),
// //                     SizedBox(),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 10),
// //               //   Artists
// //               Center(
// //                 child: Text(
// //                   "ARTISTS",
// //                   style: mainTitleTextStyle,
// //                   textAlign: TextAlign.center,
// //                 ),
// //               ),
// //               SingleChildScrollView(
// //                 scrollDirection: Axis.horizontal,
// //                 child: Row(
// //                   children: [
// //                     SizedBox(width: siz.safeWidth * 0.01),
// //                     Row(
// //                       children: List.generate(colors.length, (ind) {
// //                         return Column(
// //                           spacing: 5.0,
// //                           children: [
// //                             Container(
// //                               decoration: BoxDecoration(
// //                                 color: colors[ind],
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                               margin: EdgeInsets.symmetric(horizontal: 10),
// //                               height: siz.safeWidth * 0.3,
// //                               width: siz.safeWidth * 0.3,
// //                             ),
// //                             Text(
// //                               "Name ${ind + 1}",
// //                               style: TextStyle(fontFamily:'Regular',
// //                                 fontSize: Sizes().width * 0.03,
// //                                 fontWeight: FontWeight.w500,
// //                                 fontFamily: 'Regular',
// //                               ),
// //                             ),
// //                           ],
// //                         );
// //                       }),
// //                     ),
// //                     SizedBox(width: siz.safeWidth * 0.01),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 7),
// //               //   All Eventspage
// //               Center(
// //                 child: Text(
// //                   "ALL EVENTS",
// //                   style: mainTitleTextStyle,
// //                   textAlign: TextAlign.center,
// //                 ),
// //               ),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: siz.safeWidth * 0.01),
// //                 child: SingleChildScrollView(
// //                   scrollDirection: Axis.horizontal,
// //                   child: Row(
// //                     spacing: 10,
// //                     children: [
// //                       SizedBox(),
// //                       InkWell(
// //                         onTap: () {
// //                           filter_window(siz);
// //                         },
// //                         child: Container(
// //                           padding: EdgeInsets.all(10),
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(10),
// //                             border: Border.all(color: Colors.black),
// //                           ),
// //                           child: Row(
// //                             spacing: 5,
// //                             children: [
// //                               Icon(Icons.filter_alt),
// //                               Text("Filters"),
// //                               Icon(Icons.keyboard_arrow_down),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       ...List.generate(
// //                         filt_but_st.length,
// //                         (ind) => filter_butt(ind),
// //                       ),
// //                       SizedBox(),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(),
// //               Column(
// //                 children: [
// //                   Container(
// //                     height: siz.safeHeight * 0.5,
// //                     width: siz.safeWidth * 0.85,
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.only(
// //                         topLeft: Radius.circular(15),
// //                         topRight: Radius.circular(15),
// //                       ),
// //                       border: Border(
// //                         top: BorderSide(),
// //                         left: BorderSide(),
// //                         right: BorderSide(),
// //                       ),
// //                     ),
// //                     alignment: Alignment.center,
// //                     child: Text("Poster or Video"),
// //                   ),
// //                   Container(
// //                     width: siz.safeWidth * 0.85,
// //                     height: siz.safeHeight * 0.1,
// //                     decoration: BoxDecoration(
// //                       border: Border.all(),
// //                       borderRadius: BorderRadius.only(
// //                         bottomRight: Radius.circular(15),
// //                         bottomLeft: Radius.circular(15),
// //                       ),
// //                     ),
// //                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text("Date"),
// //                         Text(
// //                           "Concert Name",
// //                           style: TextStyle(fontFamily:'Regular',fontWeight: FontWeight.w700),
// //                         ),
// //                         Text("Location"),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/event/eventsummary.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/artists/artistspage.dart';
import 'package:ticpin/pages/view/concerts/concertpage.dart';
import 'package:ticpin/pages/view/music/musicpage.dart';
import 'package:ticpin/services/controllers/event_controller.dart';

// class Eventspage extends StatefulWidget {
//   const Eventspage({super.key});

//   @override
//   State<Eventspage> createState() => _EventspageState();
// }

// class _EventspageState extends State<Eventspage> {
//   final ctrl = Get.find<EventController>();
//   List<Color> art_img = [Colors.red, Colors.green, Colors.blue, Colors.orange];
//   List<Map<String, String>> eve_cate_data = [
//     {"name": "Music", "img": "assets/images/music.png"},
//     {"name": "Comedy", "img": "assets/images/comedy_new.png"},
//     {"name": "Performance", "img": "assets/images/performance_new.png"},
//     {"name": "Sports", "img": "assets/images/sports_new.png"},
//   ];

//   Widget eve_cate(String name, String loc, final size, Widget desti) {
//     return GestureDetector(
//       onTap: () => Get.to(desti),
//       child: Container(
//         // padding: EdgeInsets.all(size.safeWidth * 0.027),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [gradient1, gradient2],
//             stops: [0.45, 0.8],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ).withOpacity(0.75),
//           borderRadius: BorderRadius.circular(15),
//           // border: Border.all(color: Colors.black26, width: 1),
//         ),
//         width: size.safeWidth * 0.33,
//         height: size.safeHeight * 0.16,
//         child: Stack(
//           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 8.0, left: 10.0),
//                 child: Text(
//                   name,
//                   style: TextStyle(
//                     fontFamily: 'Regular',
//                     fontWeight: FontWeight.w600,
//                     fontSize: size.safeWidth * 0.035,
//                     color: whiteColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Container(
//                 height: size.safeHeight * 0.12,
//                 width: size.safeWidth * 0.22,
//                 child: Image.asset(loc, fit: BoxFit.fill),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //
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

//   //
//   bool sort_by_fil_vis = true;
//   bool genre_fil_vis = false;

//   Sizes size = Sizes();

//   // Sort options (Radio)
//   final List<Map<String, dynamic>> sortOptions = [
//     {"label": "Popularity"},
//     {"label": "Date"},
//     {"label": "Price: High to Low"},
//     {"label": "Price: Low to High"},
//   ];
//   String selectedSort = "Popularity"; // default selected

//   // Genre options (Checkbox)
//   final List<Map<String, dynamic>> genreOptions = [
//     {"label": "Action", "isChecked": false},
//     {"label": "Comedy", "isChecked": false},
//     {"label": "Drama", "isChecked": false},
//     {"label": "Sci-Fi", "isChecked": false},
//     {"label": "Horror", "isChecked": false},
//     {"label": "Adventure", "isChecked": false},
//     {"label": "Thriller", "isChecked": false},
//     {"label": "Family", "isChecked": false},
//     {"label": "Fantasy", "isChecked": false},
//     {"label": "Bio-pic", "isChecked": false},
//   ];

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
//                         "Filter by",
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
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Left menu
//                     Column(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setSheetState(() {
//                               sort_by_fil_vis = true;
//                               genre_fil_vis = false;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             color:
//                                 sort_by_fil_vis ? Colors.black12 : Colors.white,
//                             width: size.safeWidth * 0.3,
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Sort by",
//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: size.safeWidth * 0.04,
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setSheetState(() {
//                               genre_fil_vis = true;
//                               sort_by_fil_vis = false;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             color:
//                                 genre_fil_vis ? Colors.black12 : Colors.white,
//                             width: size.safeWidth * 0.3,
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Genre",
//                               style: TextStyle(
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
//                       height: size.safeHeight * 0.5,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             // Sort by (Radio)
//                             if (sort_by_fil_vis)
//                               ...sortOptions.map((opt) {
//                                 return RadioListTile<String>(
//                                   title: Text(
//                                     opt["label"],
//                                     style: TextStyle(
//                                       fontFamily: 'Regular',
//                                       fontSize: size.safeWidth * 0.04,
//                                     ),
//                                   ),
//                                   value: opt["label"],
//                                   groupValue: selectedSort,
//                                   onChanged: (val) {
//                                     setSheetState(() {
//                                       selectedSort = val!;
//                                     });
//                                   },
//                                 );
//                               }),

//                             // Genre (Checkbox)
//                             if (genre_fil_vis)
//                               ...genreOptions.asMap().entries.map((entry) {
//                                 int index = entry.key;
//                                 var option = entry.value;

//                                 return CheckboxListTile(
//                                   title: Text(
//                                     option["label"],
//                                     style: TextStyle(
//                                       fontFamily: 'Regular',
//                                       fontSize: size.safeWidth * 0.04,
//                                     ),
//                                   ),
//                                   value: option["isChecked"],
//                                   onChanged: (val) {
//                                     setSheetState(() {
//                                       genreOptions[index]["isChecked"] =
//                                           val ?? false;
//                                     });
//                                   },
//                                   controlAffinity:
//                                       ListTileControlAffinity.leading,
//                                 );
//                               }),
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
//                     TextButton(onPressed: () {}, child: Text("Clear All")),
//                     InkWell(
//                       onTap: () {},
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
//                           style: TextStyle(
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

//   bool loading = true;

//   void initState() {
//     super.initState();
//   }

//   Sizes siz = Sizes();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           spacing: 15,
//           children: [
//             SizedBox(width: siz.safeWidth * 0.06),
//             // Eventspage Category
//             Center(
//               child: Text(
//                 "EVENTS CATEGORY",
//                 style: mainTitleTextStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 spacing: 15,
//                 children: [
//                   SizedBox(),
//                   ...List.generate(eve_cate_data.length, (ind) {
//                     return eve_cate(
//                       eve_cate_data[ind]["name"]!,
//                       eve_cate_data[ind]["img"]!,
//                       siz,
//                       Musicpage(eve_cat_ind: ind),
//                     );
//                   }),
//                   SizedBox(),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             //   Artists
//             Center(
//               child: Text(
//                 "ARTISTS",
//                 style: mainTitleTextStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   SizedBox(width: siz.safeWidth * 0.012),
//                   Row(
//                     children: List.generate(art_img.length, (ind) {
//                       return GestureDetector(
//                         onTap: () => Get.to(Artistpage()),
//                         child: Column(
//                           spacing: 5.0,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               margin: EdgeInsets.symmetric(horizontal: 10),
//                               height: siz.safeWidth * 0.3,
//                               width: siz.safeWidth * 0.3,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Container(color: art_img[ind]),
//                               ),
//                             ),
//                             Text(
//                               "Name ${ind + 1}",
//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontSize: Sizes().width * 0.03,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                   SizedBox(width: siz.safeWidth * 0.012),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5),
//             //   All Eventspage
//             Center(
//               child: Text(
//                 "ALL EVENTS",
//                 style: mainTitleTextStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 spacing: 10,
//                 children: [
//                   SizedBox(width: siz.safeWidth * 0.012),
//                   InkWell(
//                     onTap: () {
//                       filter_window(siz);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       child: Row(
//                         spacing: 5,
//                         children: [
//                           Icon(Icons.filter_alt),
//                           Text("Filters"),
//                           Icon(Icons.keyboard_arrow_down),
//                         ],
//                       ),
//                     ),
//                   ),
//                   ...List.generate(
//                     filt_but_st.length,
//                     (ind) => filter_butt(ind),
//                   ),
//                   SizedBox(width: siz.safeWidth * 0.012),
//                 ],
//               ),
//             ),
//             SizedBox(),

//             // Column(
//             //   children: [
//             //     Container(
//             //       height: siz.safeHeight * 0.5,
//             //       width: siz.safeWidth * 0.85,
//             //       decoration: BoxDecoration(
//             //         borderRadius: BorderRadius.only(
//             //           topLeft: Radius.circular(15),
//             //           topRight: Radius.circular(15),
//             //         ),
//             //         border: Border(
//             //           top: BorderSide(),
//             //           left: BorderSide(),
//             //           right: BorderSide(),
//             //         ),
//             //       ),
//             //       alignment: Alignment.center,
//             //       child: Text("Poster or Video"),
//             //     ),
//             //     Container(
//             //       width: siz.safeWidth * 0.85,
//             //       height: siz.safeHeight * 0.1,
//             //       decoration: BoxDecoration(
//             //         border: Border.all(),
//             //         borderRadius: BorderRadius.only(
//             //           bottomRight: Radius.circular(15),
//             //           bottomLeft: Radius.circular(15),
//             //         ),
//             //       ),
//             //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             //       child: Column(
//             //         crossAxisAlignment: CrossAxisAlignment.start,
//             //         children: [
//             //           Text("Date"),
//             //           Text(
//             //             "Concert Name",
//             //             style: TextStyle(
//             //               fontFamily: 'Regular',
//             //               fontWeight: FontWeight.w700,
//             //             ),
//             //           ),
//             //           Text("Location"),
//             //         ],
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             // loading
//             //     ? const CircularProgressIndicator()
//             //     : events.isEmpty
//             //     ? const Text("No nearby events within 150km")
//             //     : Column(
//             //       children:
//             //           events.map((e) {
//             //             return Column(
//             //               children: [
//             //                 // Poster or Video
//             //                 Container(
//             //                   height: siz.safeHeight * 0.5,
//             //                   width: siz.safeWidth * 0.85,
//             //                   decoration: BoxDecoration(
//             //                     borderRadius: BorderRadius.only(
//             //                       topLeft: Radius.circular(15),
//             //                       topRight: Radius.circular(15),
//             //                     ),
//             //                     border: Border(
//             //                       top: BorderSide(),
//             //                       left: BorderSide(),
//             //                       right: BorderSide(),
//             //                     ),
//             //                   ),
//             //                   child:
//             //                       e.posterUrl.isNotEmpty
//             //                           ? ClipRRect(
//             //                             borderRadius: BorderRadius.only(
//             //                               topLeft: Radius.circular(15),
//             //                               topRight: Radius.circular(15),
//             //                             ),
//             //                             child: Image.network(
//             //                               getDriveImageUrl(e.posterUrl)!,
//             //                               fit: BoxFit.cover,
//             //                             ),
//             //                           )
//             //                           : Center(
//             //                             child: Text("No Poster Uploaded"),
//             //                           ),
//             //                 ),

//             //                 // Event Info
//             //                 Container(
//             //                   width: siz.safeWidth * 0.85,
//             //                   padding: EdgeInsets.symmetric(
//             //                     horizontal: 12,
//             //                     vertical: 10,
//             //                   ),
//             //                   decoration: BoxDecoration(
//             //                     border: Border.all(),
//             //                     borderRadius: BorderRadius.only(
//             //                       bottomRight: Radius.circular(15),
//             //                       bottomLeft: Radius.circular(15),
//             //                     ),
//             //                   ),
//             //                   child: Column(
//             //                     crossAxisAlignment: CrossAxisAlignment.start,
//             //                     children: [
//             //                       Text(
//             //                         "${e.date.toLocal()}".split(' ')[0],
//             //                         style: TextStyle(fontFamily: 'Regular'),
//             //                       ),
//             //                       Text(
//             //                         e.name,
//             //                         style: TextStyle(
//             //                           fontFamily: 'Regular',
//             //                           fontWeight: FontWeight.bold,
//             //                           fontSize: siz.safeWidth * 0.045,
//             //                         ),
//             //                       ),
//             //                       Text(
//             //                         e.venueName,
//             //                         style: TextStyle(fontFamily: 'Regular'),
//             //                       ),
//             //                       Text(
//             //                         "${e.distance.toStringAsFixed(1)} km away",
//             //                         style: TextStyle(
//             //                           fontFamily: 'Regular',
//             //                           color: Colors.grey[700],
//             //                         ),
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 ),
//             //                 SizedBox(height: 20),
//             //               ],
//             //             );
//             //           }).toList(),
//             //     ),
//             Obx(() {
//               final events = ctrl.allSummaries;

//               if (events.isEmpty) {
//                 return const Center(child: Text("No events found"));
//               }

//               if (events.isEmpty) {
//                 return SizedBox(
//                   height: size.safeHeight * 0.3,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//               return Column(
//                 children:
//                     events.map((e) {
//                       return Column(
//                         children: [
//                           // Poster or Video
//                           Container(
//                             height: (size.safeWidth * 0.85) * (3 / 2),
//                             width: siz.safeWidth * 0.85,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(15),
//                                 topRight: Radius.circular(15),
//                               ),
//                               border: Border(
//                                 top: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                                 left: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                                 right: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                               ),
//                             ),
//                             child:
//                                 e.posterUrl.isNotEmpty
//                                     ? ClipRRect(
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(15),
//                                         topRight: Radius.circular(15),
//                                       ),
//                                       child: Image.network(
//                                         e.posterUrl,
//                                         fit: BoxFit.fill,
//                                         errorBuilder:
//                                             (context, error, stackTrace) =>
//                                                 const Center(
//                                                   child: Text("Invalid Image"),
//                                                 ),
//                                         loadingBuilder:
//                                             (context, child, loadingProgress) =>
//                                                 loadingProgress == null
//                                                     ? child
//                                                     : LoadingShimmer(
//                                                       height: size.height,
//                                                       width: size.width,
//                                                       isCircle: false,
//                                                       radius: 0,
//                                                     ),
//                                       ),
//                                     )
//                                     : Center(
//                                       child: Icon(
//                                         Icons.broken_image_rounded,
//                                         color: Colors.grey,
//                                         size: size.safeWidth * 0.2,
//                                       ),
//                                     ),
//                           ),

//                           // Event Info
//                           Container(
//                             width: siz.safeWidth * 0.85,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 10,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                                 left: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                                 right: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                               ),
//                               borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(15),
//                                 bottomLeft: Radius.circular(15),
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   e.dateTime.toLocal().toString().split(' ')[0],
//                                   style: TextStyle(fontFamily: 'Regular'),
//                                 ),
//                                 Text(
//                                   e.name,
//                                   style: TextStyle(
//                                     fontFamily: 'Regular',
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: siz.safeWidth * 0.045,
//                                   ),
//                                 ),
//                                 Text(
//                                   e.venueName,
//                                   style: TextStyle(fontFamily: 'Regular'),
//                                 ),
//                                 Text(
//                                   "${e.distanceKm.toStringAsFixed(2)} km away",
//                                   style: TextStyle(
//                                     fontFamily: 'Regular',
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       );
//                     }).toList(),
//               );
//             }),

//             Obx(() {
//               final events = ctrl.allSummaries;

//               if (events.isEmpty) {
//                 return const Center(child: Text("No events found"));
//               }

//               if (events.isEmpty) {
//                 return SizedBox(
//                   height: (size.safeWidth * 0.9) * (3 / 2),
//                   child: LoadingShimmer(
//                     width: size.width * 0.8,
//                     height: (size.width * 0.8) * (2.6 / 2),
//                     isCircle: false,
//                   ),
//                 );
//               }
//               return Column(
//                 children: List.generate(events.length - 1, (index) {
//                   final e = ctrl.forYouEvents[index];
//                   return PosterCarousel(
//                     event: e,
//                     dist: e.distanceKm,
//                     size: size,
//                     name: e.name,
//                     date: DateFormat(
//                       'EEEE, d MMM',
//                     ).format(e.dateTime.toLocal()),
//                     loc: e.venueName,
//                     posterUrl: e.posterUrl,
//                     videoUrl: e.videoUrl,
//                     isVideo: e.videoUrl.isNotEmpty,
//                     index: index,
//                     currentIndex: index,
//                   );
//                 }),
//               );
//             }),
//             SizedBox(width: siz.safeWidth * 0.1),
//           ],
//         ),
//       ),
//     );
//   }
// }



// class Eventspage extends StatefulWidget {
//   const Eventspage({super.key});

//   @override
//   State<Eventspage> createState() => _EventspageState();
// }

// class _EventspageState extends State<Eventspage> {
//   late final EventController ctrl;
//   final ScrollController _scrollController = ScrollController();

//   List<Color> art_img = [Colors.red, Colors.green, Colors.blue, Colors.orange];
//   List<Map<String, String>> eve_cate_data = [
//     {"name": "Music", "img": "assets/images/music.png"},
//     {"name": "Comedy", "img": "assets/images/comedy_new.png"},
//     {"name": "Performance", "img": "assets/images/performance_new.png"},
//     {"name": "Sports", "img": "assets/images/sports_new.png"},
//   ];

//   Widget eve_cate(String name, String loc, final size, Widget desti) {
//     return GestureDetector(
//       onTap: () => Get.to(desti),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [gradient1, gradient2],
//             stops: [0.45, 0.8],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ).withOpacity(0.75),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         width: size.safeWidth * 0.33,
//         height: size.safeHeight * 0.16,
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 8.0, left: 10.0),
//                 child: Text(
//                   name,
//                   style: TextStyle(
//                     fontFamily: 'Regular',
//                     fontWeight: FontWeight.w600,
//                     fontSize: size.safeWidth * 0.035,
//                     color: whiteColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Container(
//                 height: size.safeHeight * 0.12,
//                 width: size.safeWidth * 0.22,
//                 child: Image.asset(loc, fit: BoxFit.fill),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
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

//   bool sort_by_fil_vis = true;
//   bool genre_fil_vis = false;

//   Sizes size = Sizes();

//   final List<Map<String, dynamic>> sortOptions = [
//     {"label": "Popularity"},
//     {"label": "Date"},
//     {"label": "Price: High to Low"},
//     {"label": "Price: Low to High"},
//   ];
//   String selectedSort = "Popularity";

//   final List<Map<String, dynamic>> genreOptions = [
//     {"label": "Action", "isChecked": false},
//     {"label": "Comedy", "isChecked": false},
//     {"label": "Drama", "isChecked": false},
//     {"label": "Sci-Fi", "isChecked": false},
//     {"label": "Horror", "isChecked": false},
//     {"label": "Adventure", "isChecked": false},
//     {"label": "Thriller", "isChecked": false},
//     {"label": "Family", "isChecked": false},
//     {"label": "Fantasy", "isChecked": false},
//     {"label": "Bio-pic", "isChecked": false},
//   ];

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
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     children: [
//                       Text(
//                         "Filter by",
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
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setSheetState(() {
//                               sort_by_fil_vis = true;
//                               genre_fil_vis = false;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             color:
//                                 sort_by_fil_vis ? Colors.black12 : Colors.white,
//                             width: size.safeWidth * 0.3,
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Sort by",
//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: size.safeWidth * 0.04,
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setSheetState(() {
//                               genre_fil_vis = true;
//                               sort_by_fil_vis = false;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             color:
//                                 genre_fil_vis ? Colors.black12 : Colors.white,
//                             width: size.safeWidth * 0.3,
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Genre",
//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: size.safeWidth * 0.04,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: size.safeWidth * 0.7,
//                       color: Colors.black12,
//                       height: size.safeHeight * 0.5,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             if (sort_by_fil_vis)
//                               ...sortOptions.map((opt) {
//                                 return RadioListTile<String>(
//                                   title: Text(
//                                     opt["label"],
//                                     style: TextStyle(
//                                       fontFamily: 'Regular',
//                                       fontSize: size.safeWidth * 0.04,
//                                     ),
//                                   ),
//                                   value: opt["label"],
//                                   groupValue: selectedSort,
//                                   onChanged: (val) {
//                                     setSheetState(() {
//                                       selectedSort = val!;
//                                     });
//                                   },
//                                 );
//                               }),
//                             if (genre_fil_vis)
//                               ...genreOptions.asMap().entries.map((entry) {
//                                 int index = entry.key;
//                                 var option = entry.value;

//                                 return CheckboxListTile(
//                                   title: Text(
//                                     option["label"],
//                                     style: TextStyle(
//                                       fontFamily: 'Regular',
//                                       fontSize: size.safeWidth * 0.04,
//                                     ),
//                                   ),
//                                   value: option["isChecked"],
//                                   onChanged: (val) {
//                                     setSheetState(() {
//                                       genreOptions[index]["isChecked"] =
//                                           val ?? false;
//                                     });
//                                   },
//                                   controlAffinity:
//                                       ListTileControlAffinity.leading,
//                                 );
//                               }),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     TextButton(onPressed: () {}, child: Text("Clear All")),
//                     InkWell(
//                       onTap: () {},
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
//                           style: TextStyle(
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
//   void initState() {
//     super.initState();

//     // Initialize controller
//     try {
//       ctrl = Get.find<EventController>();
//     } catch (e) {
//       ctrl = Get.put(EventController());
//     }

//     // Setup lazy loading listener
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     // Load more when user scrolls to 80% of the list
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.8) {
//       ctrl.loadMoreEvents();
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Sizes siz = Sizes();

//   double aspectratio = 24.0 / 36.0;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: Column(
//           spacing: 15,
//           children: [
//             SizedBox(width: siz.safeWidth * 0.06),

//             // Events Category
//             Center(
//               child: Text(
//                 "EVENTS CATEGORY",
//                 style: mainTitleTextStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 spacing: 15,
//                 children: [
//                   SizedBox(),
//                   ...List.generate(eve_cate_data.length, (ind) {
//                     return eve_cate(
//                       eve_cate_data[ind]["name"]!,
//                       eve_cate_data[ind]["img"]!,
//                       siz,
//                       Musicpage(eve_cat_ind: ind),
//                     );
//                   }),
//                   SizedBox(),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),

//             // Artists
//             Center(
//               child: Text(
//                 "ARTISTS",
//                 style: mainTitleTextStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   SizedBox(width: siz.safeWidth * 0.012),
//                   Row(
//                     children: List.generate(art_img.length, (ind) {
//                       return GestureDetector(
//                         onTap: () => Get.to(Artistpage()),
//                         child: Column(
//                           spacing: 5.0,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               margin: EdgeInsets.symmetric(horizontal: 10),
//                               height: siz.safeWidth * 0.3,
//                               width: siz.safeWidth * 0.3,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Container(color: art_img[ind]),
//                               ),
//                             ),
//                             Text(
//                               "Name ${ind + 1}",
//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontSize: Sizes().width * 0.03,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                   SizedBox(width: siz.safeWidth * 0.012),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5),

//             // All Events
//             Center(
//               child: Text(
//                 "ALL EVENTS",
//                 style: mainTitleTextStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 spacing: 10,
//                 children: [
//                   SizedBox(width: siz.safeWidth * 0.012),
//                   InkWell(
//                     onTap: () {
//                       filter_window(siz);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       child: Row(
//                         spacing: 5,
//                         children: [
//                           Icon(Icons.filter_alt),
//                           Text("Filters"),
//                           Icon(Icons.keyboard_arrow_down),
//                         ],
//                       ),
//                     ),
//                   ),
//                   ...List.generate(
//                     filt_but_st.length,
//                     (ind) => filter_butt(ind),
//                   ),
//                   SizedBox(width: siz.safeWidth * 0.012),
//                 ],
//               ),
//             ),
//             SizedBox(),

//             // Events List
//             Obx(() {
//               final events = ctrl.allSummaries;

//               if (ctrl.loading.value && events.isEmpty) {
//                 return SizedBox(
//                   height: size.safeHeight * 0.3,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }

//               if (events.isEmpty) {
//                 return const Center(child: Text("No events found"));
//               }

//               return Column(
//                 children: [
//                   // Display all events
//                   ...events.map((e) {
//                     return GestureDetector(
//                       onTap: () {
//                         Get.to(
//                           () => Concertpage(
//                             eventId: e.id,
//                             distance: e.distanceKm,
//                             videoUrl: e.videoUrl,
//                           ),
//                         );
//                       },
//                       child: Column(
//                         children: [
//                           // Poster
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: size.safeWidth * 0.05,
//                             ),
//                             child: AspectRatio(
//                               aspectRatio: 24.0 / 36.0,
//                               child: Container(
//                                 // height: (size.safeWidth * 0.85) * (3 / 2),
//                                 // width: siz.safeWidth * 0.85,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(15),
//                                     topRight: Radius.circular(15),
//                                   ),
//                                   border: Border(
//                                     top: BorderSide(
//                                       color: Colors.black12,
//                                       width: 1,
//                                     ),
//                                     left: BorderSide(
//                                       color: Colors.black12,
//                                       width: 1,
//                                     ),
//                                     right: BorderSide(
//                                       color: Colors.black12,
//                                       width: 1,
//                                     ),
//                                   ),
//                                 ),
//                                 child:
//                                     e.posterUrl.isNotEmpty
//                                         ? ClipRRect(
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(15),
//                                             topRight: Radius.circular(15),
//                                           ),
//                                           child: Image.network(
//                                             e.posterUrl,
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (
//                                                   context,
//                                                   error,
//                                                   stackTrace,
//                                                 ) => Center(
//                                                   child: Icon(
//                                                     Icons.broken_image_rounded,
//                                                     color: Colors.grey,
//                                                     size: size.safeWidth * 0.2,
//                                                   ),
//                                                 ),
//                                             loadingBuilder:
//                                                 (
//                                                   context,
//                                                   child,
//                                                   loadingProgress,
//                                                 ) =>
//                                                     loadingProgress == null
//                                                         ? child
//                                                         : Center(
//                                                           child: CircularProgressIndicator(
//                                                             value:
//                                                                 loadingProgress
//                                                                             .expectedTotalBytes !=
//                                                                         null
//                                                                     ? loadingProgress
//                                                                             .cumulativeBytesLoaded /
//                                                                         loadingProgress
//                                                                             .expectedTotalBytes!
//                                                                     : null,
//                                                           ),
//                                                         ),
//                                           ),
//                                         )
//                                         : Center(
//                                           child: Icon(
//                                             Icons.broken_image_rounded,
//                                             color: Colors.grey,
//                                             size: size.safeWidth * 0.2,
//                                           ),
//                                         ),
//                               ),
//                             ),
//                           ),

//                           // Event Info
//                           Container(
//                             width: siz.safeWidth * 0.9,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 10,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border(
//                                 bottom: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                                 left: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                                 right: BorderSide(
//                                   color: Colors.black12,
//                                   width: 1,
//                                 ),
//                               ),
//                               borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(15),
//                                 bottomLeft: Radius.circular(15),
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   DateFormat(
//                                     'EEEE, d MMM',
//                                   ).format(e.dateTime.toLocal()),
//                                   style: TextStyle(fontFamily: 'Regular'),
//                                 ),
//                                 Text(
//                                   e.name,
//                                   style: TextStyle(
//                                     fontFamily: 'Regular',
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: siz.safeWidth * 0.045,
//                                   ),
//                                 ),
//                                 Text(
//                                   e.venueName,
//                                   style: TextStyle(fontFamily: 'Regular'),
//                                 ),
//                                 Text(
//                                   "${e.distanceKm.toStringAsFixed(2)} km away",
//                                   style: TextStyle(
//                                     fontFamily: 'Regular',
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                     );
//                   }),

//                   // Loading indicator at bottom
//                   if (ctrl.loading.value && events.isNotEmpty)
//                     Padding(
//                       padding: EdgeInsets.symmetric(vertical: 20),
//                       child: CircularProgressIndicator(),
//                     ),

//                   // No more events indicator
//                   if (!ctrl.hasMore && events.isNotEmpty)
//                     Padding(
//                       padding: EdgeInsets.only(top: 20, bottom: 15),
//                       child: Text(
//                         "No more events",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontFamily: 'Regular',
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }),

//             SizedBox(height: siz.safeWidth * 0.1),
//           ],
//         ),
//       ),
//     );
//   }
// }


class Eventspage extends StatefulWidget {
  const Eventspage({super.key});

  @override
  State<Eventspage> createState() => _EventspageState();
}

class _EventspageState extends State<Eventspage> with AutomaticKeepAliveClientMixin {
  late final EventController ctrl;
  final ScrollController _scrollController = ScrollController();
  double _savedScrollPosition = 0.0;

  @override
  bool get wantKeepAlive => true;

  List<Color> art_img = [Colors.red, Colors.green, Colors.blue, Colors.orange];
  List<Map<String, String>> eve_cate_data = [
    {"name": "Music", "img": "assets/images/music.png"},
    {"name": "Comedy", "img": "assets/images/comedy_new.png"},
    {"name": "Performance", "img": "assets/images/performance_new.png"},
    {"name": "Sports", "img": "assets/images/sports_new.png"},
  ];

  Widget eve_cate(String name, String loc, final size, Widget desti) {
    return GestureDetector(
      onTap: () => Get.to(desti),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradient1, gradient2],
            stops: [0.45, 0.8],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).withOpacity(0.75),
          borderRadius: BorderRadius.circular(15),
        ),
        width: size.safeWidth * 0.33,
        height: size.safeHeight * 0.16,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.w600,
                    fontSize: size.safeWidth * 0.035,
                    color: whiteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: size.safeHeight * 0.12,
                width: size.safeWidth * 0.22,
                child: Image.asset(loc, fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
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

  bool sort_by_fil_vis = true;
  bool genre_fil_vis = false;

  Sizes size = Sizes();

  final List<Map<String, dynamic>> sortOptions = [
    {"label": "Popularity"},
    {"label": "Date"},
    {"label": "Price: High to Low"},
    {"label": "Price: Low to High"},
  ];
  String selectedSort = "Popularity";

  final List<Map<String, dynamic>> genreOptions = [
    {"label": "Action", "isChecked": false},
    {"label": "Comedy", "isChecked": false},
    {"label": "Drama", "isChecked": false},
    {"label": "Sci-Fi", "isChecked": false},
    {"label": "Horror", "isChecked": false},
    {"label": "Adventure", "isChecked": false},
    {"label": "Thriller", "isChecked": false},
    {"label": "Family", "isChecked": false},
    {"label": "Fantasy", "isChecked": false},
    {"label": "Bio-pic", "isChecked": false},
  ];

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              sort_by_fil_vis = true;
                              genre_fil_vis = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color:
                                sort_by_fil_vis ? Colors.black12 : Colors.white,
                            width: size.safeWidth * 0.3,
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
                        GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              genre_fil_vis = true;
                              sort_by_fil_vis = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color:
                                genre_fil_vis ? Colors.black12 : Colors.white,
                            width: size.safeWidth * 0.3,
                            alignment: Alignment.center,
                            child: Text(
                              "Genre",
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
                    Container(
                      width: size.safeWidth * 0.7,
                      color: Colors.black12,
                      height: size.safeHeight * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (sort_by_fil_vis)
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
                            if (genre_fil_vis)
                              ...genreOptions.asMap().entries.map((entry) {
                                int index = entry.key;
                                var option = entry.value;

                                return CheckboxListTile(
                                  title: Text(
                                    option["label"],
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: size.safeWidth * 0.04,
                                    ),
                                  ),
                                  value: option["isChecked"],
                                  onChanged: (val) {
                                    setSheetState(() {
                                      genreOptions[index]["isChecked"] =
                                          val ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () {}, child: Text("Clear All")),
                    InkWell(
                      onTap: () {},
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

  @override
  void initState() {
    super.initState();

    // Initialize controller
    try {
      ctrl = Get.find<EventController>();
    } catch (e) {
      ctrl = Get.put(EventController());
    }

    // Setup lazy loading listener
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Save current position
    _savedScrollPosition = _scrollController.position.pixels;
    
    // Load more when user scrolls to 80% of the content
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (ctrl.hasMore && !ctrl.loading.value) {
        ctrl.loadMoreEvents().then((_) {
          // Restore scroll position after loading
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients && _savedScrollPosition > 0) {
              _scrollController.jumpTo(_savedScrollPosition);
            }
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Sizes siz = Sizes();

  double aspectratio = 24.0 / 36.0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          spacing: 15,
          children: [
            SizedBox(width: siz.safeWidth * 0.06),

            // Events Category
            Center(
              child: Text(
                "EVENTS CATEGORY",
                style: mainTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 15,
                children: [
                  SizedBox(),
                  ...List.generate(eve_cate_data.length, (ind) {
                    return eve_cate(
                      eve_cate_data[ind]["name"]!,
                      eve_cate_data[ind]["img"]!,
                      siz,
                      Musicpage(eve_cat_ind: ind),
                    );
                  }),
                  SizedBox(),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Artists
            Center(
              child: Text(
                "ARTISTS",
                style: mainTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: siz.safeWidth * 0.012),
                  Row(
                    children: List.generate(art_img.length, (ind) {
                      return GestureDetector(
                        onTap: () => Get.to(Artistpage()),
                        child: Column(
                          spacing: 5.0,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: siz.safeWidth * 0.3,
                              width: siz.safeWidth * 0.3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(color: art_img[ind]),
                              ),
                            ),
                            Text(
                              "Name ${ind + 1}",
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: Sizes().width * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(width: siz.safeWidth * 0.012),
                ],
              ),
            ),
            SizedBox(height: 5),

            // All Events
            Center(
              child: Text(
                "ALL EVENTS",
                style: mainTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  SizedBox(width: siz.safeWidth * 0.012),
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
                  SizedBox(width: siz.safeWidth * 0.012),
                ],
              ),
            ),
            SizedBox(),

            // Events List - Only this part updates
            Obx(() {
              final events = ctrl.allSummaries;

              if (ctrl.loading.value && events.isEmpty) {
                return SizedBox(
                  height: size.safeHeight * 0.3,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (events.isEmpty) {
                return const Center(child: Text("No events found"));
              }

              return Column(
                key: ValueKey(events.length), // Key to prevent full rebuild
                children: [
                  // Display all events
                  ...List.generate(events.length, (index) {
                    final e = events[index];
                    return GestureDetector(
                      key: ValueKey(e.id), // Unique key for each event
                      onTap: () {
                        Get.to(
                          () => Concertpage(
                            eventId: e.id,
                            // distance: e.distanceKm,
                            // videoUrl: e.videoUrl,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          // Poster
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.safeWidth * 0.05,
                            ),
                            child: AspectRatio(
                              aspectRatio: 24.0 / 36.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.black12,
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: Colors.black12,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: Colors.black12,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child:
                                    e.posterUrl.isNotEmpty
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: Image.network(
                                            e.posterUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Center(
                                                  child: Icon(
                                                    Icons.broken_image_rounded,
                                                    color: Colors.grey,
                                                    size: size.safeWidth * 0.2,
                                                  ),
                                                ),
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) =>
                                                    loadingProgress == null
                                                        ? child
                                                        : Center(
                                                          child: CircularProgressIndicator(
                                                            value:
                                                                loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        loadingProgress
                                                                            .expectedTotalBytes!
                                                                    : null,
                                                          ),
                                                        ),
                                          ),
                                        )
                                        : Center(
                                          child: Icon(
                                            Icons.broken_image_rounded,
                                            color: Colors.grey,
                                            size: size.safeWidth * 0.2,
                                          ),
                                        ),
                              ),
                            ),
                          ),

                          // Event Info
                          Container(
                            width: siz.safeWidth * 0.9,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat(
                                    'EEEE, d MMM',
                                  ).format(e.dateTime.toLocal()),
                                  style: TextStyle(fontFamily: 'Regular'),
                                ),
                                Text(
                                  e.name,
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: siz.safeWidth * 0.045,
                                  ),
                                ),
                                Text(
                                  e.venueName,
                                  style: TextStyle(fontFamily: 'Regular'),
                                ),
                                Text(
                                  "${e.distanceKm.toStringAsFixed(2)} km away",
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  }),

                  // Loading indicator at bottom when fetching more
                  if (ctrl.loading.value && events.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(),
                    ),

                  // No more events indicator
                  if (!ctrl.hasMore && events.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 15),
                      child: Text(
                        "No more events",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Regular',
                          fontSize: siz.safeWidth * 0.035,
                        ),
                      ),
                    ),
                ],
              );
            }),

            SizedBox(height: siz.safeWidth * 0.1),
          ],
        ),
      ),
    );
  }
}