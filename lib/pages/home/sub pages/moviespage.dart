// import 'dart:io' show Platform;
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/shapes/containers.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/constants/styles.dart';
// import 'package:ticpin/constants/temporary.dart';
// import 'package:ticpin/pages/view/movies/theatersnearme.dart';
// import 'package:ticpin/pages/view/movies/upcomingmovies/upcomingmovieslist.dart';
// import 'package:ticpin/constants/glass_container.dart';

// class Moviespage extends StatefulWidget {
//   const Moviespage({super.key});

//   @override
//   State<Moviespage> createState() => _MoviespageState();
// }

// class _MoviespageState extends State<Moviespage> {
//   Sizes size = Sizes();
//   final CarouselSliderController _upcomingController =
//       CarouselSliderController();

//   int _upcomingCurrent = 0;

//   @override
//   Widget build(BuildContext context) {
//     bool isIOS = false;
//     try {
//       isIOS = Platform.isIOS;
//     } catch (e) {
//       isIOS = false;
//     }

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             whiteColor,
//             isIOS ? gradient1.withOpacity(0.2) : whiteColor,
//           ],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: size.safeWidth * 0.06,
//                   bottom: size.safeWidth * 0.05,
//                 ),
//                 child: Text('UPCOMING MOVIES', style: mainTitleTextStyle),
//               ),
//               CarouselSlider(
//                 items: upcomingColorSlider,
//                 carouselController: _upcomingController,
//                 options: CarouselOptions(
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(days: 99),
//                   enlargeCenterPage: true,
//                   height: size.safeHeight * 0.42,
//                   viewportFraction: 0.9,
//                   onPageChanged: (index, reason) {
//                     if (mounted) {
//                       setState(() {
//                         _upcomingCurrent = index;
//                       });
//                     }
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: size.safeWidth * 0.03,
//                   bottom: size.safeWidth * 0.03,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children:
//                       upcomingColorSlider.asMap().entries.map((entry) {
//                         return Container(
//                           width:
//                               _upcomingCurrent == entry.key
//                                   ? size.safeWidth * 0.03
//                                   : size.safeWidth * 0.02,
//                           height: size.safeWidth * 0.02,
//                           margin: const EdgeInsets.symmetric(
//                             vertical: 8.0,
//                             horizontal: 4.0,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15.0),
//                             color: (Theme.of(context).brightness ==
//                                         Brightness.dark
//                                     ? Colors.white
//                                     : Colors.black)
//                                 .withAlpha(
//                                   _upcomingCurrent == entry.key ? 255 : 100,
//                                 ),
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.safeWidth * 0.065,
//                   vertical: size.safeWidth * 0.03,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () => Get.to(const TheatresNearMe()),
//                       child: TicpinGlassContainer(
//                         width: size.safeWidth * 0.42,
//                         height: size.safeHeight * 0.08,
//                         borderRadius: 17,
//                         blur: 10,
//                         linearGradientOpacity: 0.1,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               stops: const [0.45, 1],
//                               colors: [
//                                 gradient1.withAlpha(80),
//                                 gradient2.withAlpha(80),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(17),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   right: size.safeWidth * 0.03,
//                                 ),
//                                 child: Text(
//                                   'Theatres\nnear me',
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(
//                                     fontSize: size.safeWidth * 0.027,
//                                     fontFamily: 'Regular',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => Get.to(const UpcomingMoviesList()),
//                       child: TicpinGlassContainer(
//                         width: size.safeWidth * 0.42,
//                         height: size.safeHeight * 0.08,
//                         borderRadius: 17,
//                         blur: 10,
//                         linearGradientOpacity: 0.1,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               stops: const [0.45, 1],
//                               colors: [
//                                 gradient1.withAlpha(80),
//                                 gradient2.withAlpha(80),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(17),
//                           ),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   left: size.safeWidth * 0.03,
//                                 ),
//                                 child: Text(
//                                   'Upcoming\nMovies',
//                                   style: TextStyle(
//                                     fontSize: size.safeWidth * 0.027,
//                                     fontFamily: 'Regular',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: size.safeWidth * 0.075,
//                   bottom: size.safeWidth * 0.05,
//                 ),
//                 child: Text('YOUR OFFERS', style: mainTitleTextStyle),
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     SizedBox(width: size.safeWidth * 0.05),
//                     Row(
//                       children: List.generate(3, (index) {
//                         return Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: size.safeWidth * 0.015,
//                           ),
//                           child: TicpinGlassContainer(
//                             height: size.safeHeight * 0.08,
//                             width: size.safeWidth * 0.4,
//                             borderRadius: 13,
//                             blur: 10,
//                             linearGradientOpacity: 0.05, child: null,
//                           ),
//                         );
//                       }),
//                     ),
//                     SizedBox(width: size.safeWidth * 0.05),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: size.safeWidth * 0.1,
//                 ),
//                 child: Text('LIVE NOW', style: mainTitleTextStyle),
//               ),
//               const gridViewer(),
//               SizedBox(height: size.safeHeight * 0.02),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
