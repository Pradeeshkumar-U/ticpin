// import 'package:flutter/material.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/services.dart';
// import 'package:ticpin/constants/shapes/containers.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/constants/styles.dart';
// import 'package:ticpin/constants/temporary.dart';
// import 'package:ticpin/pages/view/dining/categouriespage.dart';

// class Diningpage extends StatefulWidget {
//   const Diningpage({super.key});

//   @override
//   State<Diningpage> createState() => _DiningpageState();
// }

// class _DiningpageState extends State<Diningpage> {
//   Sizes size = Sizes();

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
//         child: Text(
//           "${filt_but_st[ind]["value"]}",
//           style: TextStyle(fontFamily: 'Regular'),
//         ),
//       ),
//     );
//   }

//   Widget cate_card(String title, String path, final siz, final fs) {
//     return Container(
//       width: siz.safeWidth * 0.35,
//       height: siz.safeHeight * 0.17,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         gradient: LinearGradient(
//           colors: [gradient1, gradient2],
//           stops: [0.45, 0.8],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ).withOpacity(0.75),
//       ),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomRight,
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
//               child: Container(
//                 width: siz.safeWidth * 0.2,
//                 height: siz.safeHeight * 0.1,
//                 alignment: Alignment.bottomRight,
//                 child: FittedBox(
//                   fit: BoxFit.fill,
//                   child: Image.asset(path, fit: BoxFit.fill),
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Padding(
//               padding: EdgeInsets.only(left: fs * 0.5, top: fs * 0.5),
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'Regular',
//                   fontSize: size.safeWidth * 0.035,
//                 ),
//               ),
//             ),
//           ),
//         ],
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
//                       // height: size.safeHeight * 0.5,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             // Sort by (Radio)
//                             ...sortOptions.map((opt) {
//                               return RadioListTile<String>(
//                                 title: Text(
//                                   opt["label"],
//                                   style: TextStyle(
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
//                       child: Text(
//                         "Clear All",
//                         style: TextStyle(fontFamily: 'Regular'),
//                       ),
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: size.safeWidth * 0.05),
//                 child: Padding(
//                   padding: EdgeInsets.only(left: size.safeWidth * 0.055),
//                   child: Row(children: [diningContainer(), diningContainer()]),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.04,
//                 bottom: size.safeWidth * 0.05,
//               ),
//               child: Text('IN LIMELIGHT', style: mainTitleTextStyle),
//             ),
//             SizedBox(
//               height: size.safeHeight * 0.3,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: size.safeWidth * 0.055),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: diningColorSlider,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.07,
//                 bottom: size.safeWidth * 0.05,
//               ),
//               child: Text('CATEGORIES', style: mainTitleTextStyle),
//             ),
//             GridView.count(
//               padding: EdgeInsets.all(size.safeWidth * 0.04),
//               crossAxisCount: 3,
//               physics: NeverScrollableScrollPhysics(),
//               crossAxisSpacing: size.safeWidth * 0.04,
//               mainAxisSpacing: size.safeWidth * 0.04,
//               shrinkWrap: true,
//               childAspectRatio: size.safeWidth * 0.2 / (size.safeHeight * 0.1),
//               children: List.generate(dini_cate.length, (ind) {
//                 return GestureDetector(
//                   onTap: () {
//                     print("Dining Details");
//                     print(dini_cate.length);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CategoryPage(cate_ind: ind),
//                       ),
//                     );
//                   },
//                   child: cate_card(
//                     dini_cate[ind]["title"] as String,
//                     dini_cate[ind]["image"] as String,
//                     size,
//                     size.safeWidth * 0.04,
//                   ),
//                 );
//               }),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.07,
//                 bottom: size.safeWidth * 0.05,
//               ),
//               child: Text('FEATURED IN TICPIN', style: mainTitleTextStyle),
//             ),
//             Container(
//               width: size.safeWidth * 0.89,
//               height: size.safeWidth * 0.2,
//               decoration: BoxDecoration(
//                 color: Colors.black12,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.07,
//                 bottom: size.safeWidth * 0.05,
//               ),
//               child: Text('ALL RESTAURANTS', style: mainTitleTextStyle),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 spacing: 15,
//                 children: [
//                   SizedBox(width: size.safeWidth * 0.015),
//                   InkWell(
//                     onTap: () {
//                       filter_window(size);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: whiteColor,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       child: Row(
//                         spacing: 5,
//                         children: [
//                           Icon(Icons.filter_alt),
//                           Text(
//                             "Filters",
//                             style: TextStyle(fontFamily: 'Regular'),
//                           ),
//                           Icon(Icons.keyboard_arrow_down),
//                         ],
//                       ),
//                     ),
//                   ),
//                   ...List.generate(
//                     filt_but_st.length,
//                     (ind) => filter_butt(ind),
//                   ),
//                   SizedBox(width: size.safeWidth * 0.015),
//                 ],
//               ),
//             ),
//             SizedBox(height: size.safeHeight * 0.03),
//             restaurantsList(),
//             restaurantsList(),

//             restaurantsList(),
//             SizedBox(height: size.safeHeight * 0.03),
//           ],
//         ),
//       ),
//     );
//   }

//   Padding restaurantsList() {
//     return Padding(
//       padding: EdgeInsets.only(bottom: size.safeHeight * 0.03),
//       child: Container(
//         width: Sizes().width * 0.9,
//         // height: Sizes().height * 0.2,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black12, width: 1),
//           borderRadius: BorderRadius.circular(17),
//         ),
//         child: Column(
//           children: [
//             Container(
//               height: Sizes().height * 0.3,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(17),
//                   topRight: Radius.circular(17),
//                 ),
//                 border: Border(
//                   bottom: BorderSide(color: Colors.black12, width: 1),
//                 ),
//                 color: Colors.red,
//               ),
//             ),
//             // Container(
//             //   height: Sizes().width * 0.05,

//             //   decoration: BoxDecoration(
//             //     color: greyColor.withAlpha(50),
//             //     border: Border(
//             //       bottom: BorderSide(color: Colors.black12, width: 1),
//             //     ),
//             //   ),
//             // child: Center(
//             //   child: Text(
//             //     ,
//             //     style: TextStyle(
//             //       fontSize: Sizes().width * 0.03,
//             //       fontFamily: 'Regular',
//             //       color: Colors.white,
//             //     ),
//             //   ),
//             // ),
//             // ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: Sizes().width * 0.03,
//                     vertical: Sizes().width * 0.015,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       customTextStyle('Restaurant Name', Sizes().width * 0.04),
//                       customTextStyle('Location', Sizes().width * 0.03),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Padding diningContainer() {
//     return Padding(
//       padding: EdgeInsets.only(right: size.safeWidth * 0.055),
//       child: Container(
//         height: size.safeHeight * 0.63,
//         width: size.safeWidth * 0.87,
//         decoration: BoxDecoration(
//           color: gradient1.withAlpha(80),
//           border: Border.all(color: Colors.black12, width: 1),
//           borderRadius: BorderRadius.circular(15),
//           // gradient: LinearGradient(
//           //   begin: Alignment.topLeft,
//           //   end: Alignment.bottomRight,
//           //   colors: [gradient1.withAlpha(80), gradient2.withAlpha(80)],
//           // ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.01,
//                 left: size.safeWidth * 0.04,
//               ),
//               child: Text(
//                 'Offers you love',
//                 style: TextStyle(
//                   fontFamily: 'Medium',
//                   fontSize: size.safeWidth * 0.05,
//                 ),
//               ),
//             ),
//             ListView.builder(
//               padding: EdgeInsets.only(left: size.safeWidth * 0.02),
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: Container(
//                     width: size.safeWidth * 0.27,
//                     height: size.safeWidth * 0.3,
//                     decoration: BoxDecoration(
//                       color: whiteColor,
//                       border: Border.all(width: 1, color: Colors.black12),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   title: Text(
//                     'Dining Name',
//                     style: TextStyle(
//                       fontFamily: 'Medium',
//                       fontSize: size.safeWidth * 0.035,
//                     ),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Offer',
//                         style: TextStyle(
//                           fontFamily: 'Medium',
//                           fontSize: size.safeWidth * 0.03,
//                         ),
//                       ),
//                       Text(
//                         'Location',
//                         style: TextStyle(
//                           fontFamily: 'Medium',
//                           fontSize: size.safeWidth * 0.03,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 // bottom: size.safeWidth * 0.01,
//                 right: size.safeWidth * 0.03,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         'See More',
//                         style: TextStyle(
//                           fontFamily: 'Medium',
//                           fontSize: size.safeWidth * 0.04,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: size.safeWidth * 0.01),
//                         child: Icon(
//                           Icons.keyboard_arrow_right,
//                           size: size.safeWidth * 0.07,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/services.dart';
import 'package:ticpin/constants/shapes/containers.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/dining/categouriespage.dart';
import 'package:ticpin/pages/view/dining/restaurentpage.dart';
import 'package:ticpin/services/controllers/dining_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Diningpage extends StatefulWidget {
  const Diningpage({super.key});

  @override
  State<Diningpage> createState() => _DiningpageState();
}

class _DiningpageState extends State<Diningpage> {
  Sizes size = Sizes();
  final DiningController diningController = Get.find<DiningController>();

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

  Widget cate_card(String title, String path, final siz, final fs) {
    return Container(
      width: siz.safeWidth * 0.35,
      height: siz.safeHeight * 0.17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [gradient1, gradient2],
          stops: [0.45, 0.8],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).withOpacity(0.75),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
              child: Container(
                width: siz.safeWidth * 0.2,
                height: siz.safeHeight * 0.1,
                alignment: Alignment.bottomRight,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(path, fit: BoxFit.fill),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: fs * 0.5, top: fs * 0.5),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Regular',
                  fontSize: size.safeWidth * 0.035,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                    Container(
                      width: size.safeWidth * 0.7,
                      color: Colors.black12,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(() {
        if (diningController.loading.value &&
            diningController.allSummaries.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Featured Offers Section
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.safeWidth * 0.05,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.055),
                    child: Row(
                      children:
                          diningController.forYouDinings.take(2).map((dining) {
                            return diningContainer(dining);
                          }).toList(),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.04,
                  bottom: size.safeWidth * 0.05,
                ),
                child: Text('IN LIMELIGHT', style: mainTitleTextStyle),
              ),

              // Nearest Dinings Carousel
              SizedBox(
                // height: (Sizes().width * 0.73),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        diningController.nearestSummaries.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final dining = entry.value;

                          return Padding(
                            padding: EdgeInsets.only(
                              left: size.safeWidth * 0.05,
                              right:
                                  index ==
                                          diningController
                                                  .nearestSummaries
                                                  .length -
                                              1
                                      ? size.safeWidth * 0.05
                                      : 0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => Restaurentpage(diningId: dining.id),
                                );
                              },
                              child: Container(
                                width:
                                    diningController.nearestSummaries.length ==
                                            1
                                        ? size.safeWidth * 0.9
                                        : size.safeWidth * 0.8,
                                // height: (size.safeWidth * 0.9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: dining.carouselImage,
                                        width:
                                            diningController
                                                        .nearestSummaries
                                                        .length ==
                                                    1
                                                ? size.safeWidth * 0.9
                                                : size.safeWidth * 0.8,
                                        height:
                                            (diningController
                                                        .nearestSummaries
                                                        .length ==
                                                    1
                                                ? size.safeWidth * 0.9
                                                : size.safeWidth * 0.8) *
                                            (2.0 / 3.0),
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => Container(
                                              color: gradient1.withAlpha(80),
                                              child: const Icon(
                                                Icons.restaurant,
                                                size: 50,
                                              ),
                                            ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: Sizes().width * 0.03,
                                              vertical: Sizes().width * 0.015,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  dining.name,
                                                  style: TextStyle(
                                                    fontSize:
                                                        Sizes().width * 0.04,
                                                    fontFamily: 'Medium',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size:
                                                          Sizes().width * 0.035,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '${dining.rating.toStringAsFixed(1)} (${dining.totalReviews})',
                                                      style: TextStyle(
                                                        fontSize:
                                                            Sizes().width *
                                                            0.03,
                                                        fontFamily: 'Regular',
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      dining.formattedDistance,
                                                      style: TextStyle(
                                                        fontSize:
                                                            Sizes().width *
                                                            0.03,
                                                        fontFamily: 'Regular',
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (dining.cuisines != null &&
                                                    dining.cuisines!.isNotEmpty)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 4,
                                                    ),
                                                    child: Text(
                                                      dining.cuisines!
                                                          .take(3)
                                                          .join(' • '),
                                                      style: TextStyle(
                                                        fontSize:
                                                            Sizes().width *
                                                            0.028,
                                                        fontFamily: 'Regular',
                                                        color: Colors.black54,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                              ],
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
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.07,
                  bottom: size.safeWidth * 0.05,
                ),
                child: Text('CATEGORIES', style: mainTitleTextStyle),
              ),

              GridView.count(
                padding: EdgeInsets.all(size.safeWidth * 0.04),
                crossAxisCount: 3,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: size.safeWidth * 0.04,
                mainAxisSpacing: size.safeWidth * 0.04,
                shrinkWrap: true,
                childAspectRatio:
                    size.safeWidth * 0.2 / (size.safeHeight * 0.1),
                children: List.generate(dini_cate.length, (ind) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPage(cate_ind: ind),
                        ),
                      );
                    },
                    child: cate_card(
                      dini_cate[ind]["title"] as String,
                      dini_cate[ind]["image"] as String,
                      size,
                      size.safeWidth * 0.04,
                    ),
                  );
                }),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.07,
                  bottom: size.safeWidth * 0.05,
                ),
                child: Text('FEATURED IN TICPIN', style: mainTitleTextStyle),
              ),

              Container(
                width: size.safeWidth * 0.89,
                height: size.safeWidth * 0.2,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.07,
                  bottom: size.safeWidth * 0.05,
                ),
                child: Text('ALL RESTAURANTS', style: mainTitleTextStyle),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 15,
                  children: [
                    SizedBox(width: size.safeWidth * 0.015),
                    InkWell(
                      onTap: () {
                        filter_window(size);
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
                    SizedBox(width: size.safeWidth * 0.015),
                  ],
                ),
              ),

              SizedBox(height: size.safeHeight * 0.03),

              // All Restaurants List
              ...diningController.allSummaries.map((dining) {
                return restaurantsList(dining);
              }).toList(),

              SizedBox(height: size.safeHeight * 0.03),
            ],
          ),
        );
      }),
    );
  }

  Widget restaurantsList(dining) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.safeHeight * 0.03),
      child: GestureDetector(
        onTap: () {
          Get.to(() => Restaurentpage(diningId: dining.id));
        },
        child: Container(
          width: Sizes().width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
                child: CachedNetworkImage(
                  imageUrl: dining.carouselImage,
                  height: (Sizes().width * 0.9) * (2.0 / 3.0),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        height: (Sizes().width * 0.9) * (2.0 / 3.0),
                        color: Colors.grey[300],
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        height: (Sizes().width * 0.9) * (2.0 / 3.0),
                        color: gradient1.withAlpha(80),
                        child: Center(child: Icon(Icons.restaurant, size: 80)),
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes().width * 0.03,
                        vertical: Sizes().width * 0.015,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dining.name,
                            style: TextStyle(
                              fontSize: Sizes().width * 0.04,
                              fontFamily: 'Medium',
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: Sizes().width * 0.035,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${dining.rating.toStringAsFixed(1)} (${dining.totalReviews})',
                                style: TextStyle(
                                  fontSize: Sizes().width * 0.03,
                                  fontFamily: 'Regular',
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                dining.formattedDistance,
                                style: TextStyle(
                                  fontSize: Sizes().width * 0.03,
                                  fontFamily: 'Regular',
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          if (dining.cuisines != null &&
                              dining.cuisines!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                dining.cuisines!.take(3).join(' • '),
                                style: TextStyle(
                                  fontSize: Sizes().width * 0.028,
                                  fontFamily: 'Regular',
                                  color: Colors.black54,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
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
  }

  Widget diningContainer(dining) {
    return Padding(
      padding: EdgeInsets.only(right: size.safeWidth * 0.055),
      child: Container(
        // height: size.safeHeight * 0.63,
        width: size.safeWidth * 0.87,
        decoration: BoxDecoration(
          color: gradient1.withAlpha(80),
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.02,
                left: size.safeWidth * 0.04,
              ),
              child: Text(
                'Offers you love',
                style: TextStyle(
                  fontFamily: 'Medium',
                  fontSize: size.safeWidth * 0.05,
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: size.safeWidth * 0.02),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: diningController.forYouDinings.take(5).length,
              itemBuilder: (context, index) {
                final diningItem = diningController.forYouDinings[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => Restaurentpage(diningId: diningItem.id));
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: diningItem.carouselImage,
                        width: size.safeWidth * 0.27,
                        height: size.safeWidth * 0.3,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              width: size.safeWidth * 0.27,
                              height: size.safeWidth * 0.3,
                              color: Colors.grey[300],
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              width: size.safeWidth * 0.27,
                              height: size.safeWidth * 0.3,
                              color: whiteColor,
                              child: Icon(Icons.restaurant),
                            ),
                      ),
                    ),
                    title: Text(
                      diningItem.name,
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: size.safeWidth * 0.035,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          diningItem.briefDescription,
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.03,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          diningItem.formattedDistance,
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                right: size.safeWidth * 0.03,
                bottom: size.safeWidth * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'See More',
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: size.safeWidth * 0.04,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: size.safeWidth * 0.01),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: size.safeWidth * 0.07,
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
    );
  }
}
