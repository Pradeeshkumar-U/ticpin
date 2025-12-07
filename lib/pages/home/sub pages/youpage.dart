import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/artists/artistspage.dart';
import 'package:ticpin/services/controllers/event_controller.dart';

// class ForYoupage extends StatefulWidget {
//   const ForYoupage({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _ForYoupageState();
//   }
// }

// class _ForYoupageState extends State<ForYoupage> {

//    final ctrl = Get.find<EventController>();

//   bool loading = true;
//   int _eventCurrent = 0;
//   int _upcomingCurrent = 0;
//   final CarouselSliderController _eventController = CarouselSliderController();
//   final CarouselSliderController _upcomingController =
//       CarouselSliderController();

//   Sizes size = Sizes();

//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: whiteColor,
//       child: SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.03,
//                 bottom: size.safeWidth * 0.07,
//               ),
//               child: Text('HOT RIGHT NOW', style: mainTitleTextStyle),
//             ),
//             // CarouselSlider.builder(
//             //   carouselController: _eventController,
//             //   itemBuilder: (context, index, realIndex) {
//             //     return PosterCarousel(
//             //       name: items[index]['name']!,
//             //       date: items[index]['date']!,
//             //       loc: items[index]['loc']!,
//             //       currentIndex: _eventCurrentIndex,
//             //       index: index,
//             //       isVideo: true,
//             //     );
//             //   },
//             //   itemCount: items.length,
//             //   options: CarouselOptions(
//             //     onPageChanged: (index, reason) {
//             //       _onPageChanged(index);
//             //       if (mounted) {
//             //         setState(() {
//             //           _eventCurrent = index;
//             //         });
//             //       }
//             //     },
//             //     height:
//             //         (size.safeWidth * 0.9) * (3 / 2), // extra space for text below
//             //     enlargeCenterPage: true,
//             //     viewportFraction: 0.8,
//             //     enableInfiniteScroll: true,
//             //   ),
//             // ),
//             CarouselSlider.builder(
//               carouselController: _eventController,
//               itemCount: events.length,
//               itemBuilder: (context, index, realIndex) {
//                 final e = events[index];
//                 return PosterCarousel(
//                   name: e.name,
//                   date: "${e.date.toLocal()}".split(' ')[0],
//                   loc: e.venueName,
//                   posterUrl: getDriveImageUrl(e.posterUrl),
//                   videoUrl: getDriveImageUrl(e.videoUrl),
//                   isVideo: e.videoUrl.isNotEmpty,
//                   index: index,
//                   currentIndex: _eventCurrent,
//                 );
//               },
//               options: CarouselOptions(
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _eventCurrent = index;
//                   });
//                 },
//                 height: (size.safeWidth * 0.9) * (3 / 2),
//                 enlargeCenterPage: true,
//                 viewportFraction: 0.8,
//                 enableInfiniteScroll: true,
//               ),
//             ),

//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.03,
//                 bottom: size.safeWidth * 0.03,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     eventColorSlider.asMap().entries.map((entry) {
//                       return Container(
//                         width:
//                             _eventCurrent == entry.key
//                                 ? size.safeWidth * 0.03
//                                 : size.safeWidth * 0.02,
//                         height: size.safeWidth * 0.02,
//                         margin: EdgeInsets.symmetric(
//                           vertical: 8.0,
//                           horizontal: 4.0,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15.0),
//                           color: (Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? Colors.white
//                                   : Colors.black)
//                               .withAlpha(
//                                 _eventCurrent == entry.key ? 255 : 100,
//                               ),
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ),
//             // Padding(
//             //   padding: EdgeInsets.only(
//             //     top: size.safeWidth * 0.03,
//             //     bottom: size.safeWidth * 0.05,
//             //   ),
//             //   child: Text('BLOCKBUSTER', style: mainTitleTextStyle),
//             // ),
//             // CarouselSlider(
//             //   items: blockbusterColorSlider,
//             //   carouselController: _blockbusterController,
//             //   options: CarouselOptions(
//             //     autoPlay: true,
//             //     autoPlayInterval: Duration(days: 99),
//             //     enlargeCenterPage: true,
//             //     height: size.safeHeight * 0.42,
//             //     viewportFraction: 0.93,
//             //     animateToClosest: true,
//             //     enlargeFactor: 0.5,
//             //     onPageChanged: (index, reason) {
//             //       if (mounted) {
//             //         setState(() {
//             //           _blockbusterCurrent = index;
//             //         });
//             //       }
//             //     },
//             //   ),
//             // ),

//             // Padding(
//             //   padding: EdgeInsets.only(
//             //     top: size.safeWidth * 0.03,
//             //     bottom: size.safeWidth * 0.03,
//             //   ),
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children:
//             //         blockbusterColorSlider.asMap().entries.map((entry) {
//             //           return Container(
//             //             width:
//             //                 _blockbusterCurrent == entry.key
//             //                     ? size.safeWidth * 0.03
//             //                     : size.safeWidth * 0.02,
//             //             height: size.safeWidth * 0.02,
//             //             margin: EdgeInsets.symmetric(
//             //               vertical: 8.0,
//             //               horizontal: 4.0,
//             //             ),
//             //             decoration: BoxDecoration(
//             //               borderRadius: BorderRadius.circular(15.0),
//             //               color: (Theme.of(context).brightness ==
//             //                           Brightness.dark
//             //                       ? Colors.white
//             //                       : Colors.black)
//             //                   .withAlpha(
//             //                     _blockbusterCurrent == entry.key ? 255 : 100,
//             //                   ),
//             //             ),
//             //           );
//             //         }).toList(),
//             //   ),
//             // ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.03,
//                 bottom: size.safeWidth * 0.07,
//               ),
//               child: Text('ARTISTS', style: mainTitleTextStyle),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   SizedBox(width: size.safeWidth * 0.026),
//                   Row(
//                     children: List.generate(colors.length, (ind) {
//                       return GestureDetector(
//                         onTap: () => Get.to(Artistpage()),
//                         child: Column(
//                           spacing: 5.0,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: colors[ind],
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               margin: EdgeInsets.symmetric(horizontal: 10),
//                               height: size.safeWidth * 0.3,
//                               width: size.safeWidth * 0.3,
//                             ),
//                             Text(
//                               "Name ${ind + 1}",
//                               style: TextStyle(
//                                 fontSize: Sizes().width * 0.03,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'Regular',
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                   SizedBox(width: size.safeWidth * 0.026),
//                 ],
//               ),
//             ),
//             SizedBox(height: size.safeHeight * 0.03),
//             // SizedBox(
//             //   height: size.safeHeight * 0.235,
//             //   child: SingleChildScrollView(
//             //     scrollDirection: Axis.horizontal,
//             //     child: Row(
//             //       children: [
//             //         Padding(
//             //           padding: EdgeInsets.only(left: size.safeWidth * 0.065),
//             //           child: Row(
//             //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //             children: List.generate(
//             //               colors.length,
//             //               (index) => artistContainer(index: index),
//             //             ),
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             Padding(
//               padding: EdgeInsets.only(
//                 // top: size.safeWidth * 0.005,
//                 bottom: size.safeWidth * 0.06,
//               ),
//               child: Text('OFFERS FOR YOU', style: mainTitleTextStyle),
//             ),
//             SizedBox(
//               height: size.safeHeight * 0.3,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: size.safeWidth * 0.05),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: offersColorSlider,
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
//               child: Text('UPCOMING EVENTS', style: mainTitleTextStyle),
//             ),
//             CarouselSlider(
//               items: upcomingColorSlider,
//               carouselController: _upcomingController,
//               options: CarouselOptions(
//                 autoPlay: true,
//                 autoPlayInterval: Duration(days: 99),
//                 enlargeCenterPage: true,
//                 height: size.safeHeight * 0.42,
//                 viewportFraction: 0.93,
//                 onPageChanged: (index, reason) {
//                   if (mounted) {
//                     setState(() {
//                       _upcomingCurrent = index;
//                     });
//                   }
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 top: size.safeWidth * 0.03,
//                 bottom: size.safeWidth * 0.03,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     upcomingColorSlider.asMap().entries.map((entry) {
//                       return Container(
//                         width:
//                             _upcomingCurrent == entry.key
//                                 ? size.safeWidth * 0.03
//                                 : size.safeWidth * 0.02,
//                         height: size.safeWidth * 0.02,
//                         margin: EdgeInsets.symmetric(
//                           vertical: 8.0,
//                           horizontal: 4.0,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15.0),
//                           color: (Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? Colors.white
//                                   : Colors.black)
//                               .withAlpha(
//                                 _upcomingCurrent == entry.key ? 255 : 100,
//                               ),
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ),
//             // Padding(
//             //   padding: EdgeInsets.only(
//             //     top: size.safeWidth * 0.05,
//             //     // bottom: size.safeWidth * 0.01,
//             //   ),
//             //   child: Text('RECENT HITS', style: mainTitleTextStyle),
//             // ),
//             // gridViewer(),
//             SizedBox(height: size.safeHeight * 0.02),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ForYoupage extends StatefulWidget {
  const ForYoupage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ForYoupageState();
  }
}

class _ForYoupageState extends State<ForYoupage> {
  late final EventController ctrl;

  int _eventCurrent = 0;
  int _upcomingCurrent = 0;
  final CarouselSliderController _eventController = CarouselSliderController();
  final CarouselSliderController _upcomingController =
      CarouselSliderController();

  Sizes size = Sizes();

  @override
  void initState() {
    super.initState();
    // Initialize or get existing controller
    try {
      ctrl = Get.find<EventController>();
    } catch (e) {
      ctrl = Get.put(EventController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.03,
                bottom: size.safeWidth * 0.07,
              ),
              child: Text('HOT RIGHT NOW', style: mainTitleTextStyle),
            ),

            // Main carousel with 8 closest events
            // Obx(
            //   () =>
            //       ctrl.loading.value && ctrl.forYouEvents.isEmpty
            //           ? SizedBox(
            //             height: (size.safeWidth * 0.9) * (3 / 2),
            //             child: Center(child: CircularProgressIndicator()),
            //           )
            //           : ctrl.forYouEvents.isEmpty
            //           ? SizedBox(
            //             height: (size.safeWidth * 0.9) * (3 / 2),
            //             child: Center(child: Text('No upcoming events')),
            //           )
            //           : CarouselSlider.builder(
            //             carouselController: _eventController,
            //             itemCount: ctrl.forYouEvents.length,
            //             itemBuilder: (context, index, realIndex) {
            //               final e = ctrl.forYouEvents[index];
            //               return PosterCarousel(
            //                 event: e,
            //                 dist: e.distanceKm,
            //                 size: size,
            //                 name: e.name,
            //                 date: "${e.dateTime.toLocal()}".split(' ')[0],
            //                 loc: e.venueName,
            //                 posterUrl: e.posterUrl,
            //                 videoUrl: e.videoUrl,
            //                 isVideo: e.videoUrl.isNotEmpty,
            //                 index: index,
            //                 currentIndex: _eventCurrent,
            //               );
            //             },
            //             options: CarouselOptions(
            //               onPageChanged: (index, reason) {
            //                 setState(() {
            //                   _eventCurrent = index;
            //                 });
            //               },
            //               height: (size.safeWidth * 0.9) * (3 / 2),
            //               enlargeCenterPage: true,
            //               viewportFraction: 0.8,
            //               enableInfiniteScroll: true,
            //             ),
            //           ),
            // ),

            // Carousel indicators
            // Obx(
            //   () => Padding(
            //     padding: EdgeInsets.only(
            //       top: size.safeWidth * 0.03,
            //       bottom: size.safeWidth * 0.03,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: List.generate(ctrl.forYouEvents.length, (index) {
            //         return Container(
            //           width:
            //               _eventCurrent == index
            //                   ? size.safeWidth * 0.03
            //                   : size.safeWidth * 0.02,
            //           height: size.safeWidth * 0.02,
            //           margin: EdgeInsets.symmetric(
            //             vertical: 8.0,
            //             horizontal: 4.0,
            //           ),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(15.0),
            //             color: (Theme.of(context).brightness == Brightness.dark
            //                     ? Colors.white
            //                     : Colors.black)
            //                 .withAlpha(_eventCurrent == index ? 255 : 100),
            //           ),
            //         );
            //       }),
            //     ),
            //   ),
            // ),
            Obx(() {
              if (ctrl.loading.value && ctrl.forYouEvents.isEmpty) {
                return AspectRatio(
                  aspectRatio: 9 / 16,
                  child: LoadingShimmer(
                    width: size.width,
                    height: size.height,
                    isCircle: false,
                  ),
                );
              }

              if (ctrl.forYouEvents.isEmpty) {
                return SizedBox(
                  height: (size.safeWidth * 0.9) * (3 / 2),
                  child: Center(child: Text("No upcoming events")),
                );
              }

              return CarouselSlider.builder(
                carouselController: _eventController,
                itemCount: ctrl.forYouEvents.length,
                itemBuilder: (context, index, realIndex) {
                  final e = ctrl.forYouEvents[index];
                  return PosterCarousel(
                    event: e,
                    dist: e.distanceKm,
                    size: size,
                    name: e.name,
                    date: DateFormat(
                      'EEEE, d MMM',
                    ).format(e.dateTime.toLocal()),
                    loc: e.venueName,
                    posterUrl: e.posterUrl,
                    videoUrl: e.videoUrl,
                    isVideo: e.videoUrl.isNotEmpty,
                    index: index,
                    currentIndex: _eventCurrent,
                  );
                },
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() => _eventCurrent = index);
                  },

                  // height: (size.safeWidth * 0.9) * (3 / 2),
                  // height: (size.width * 0.9) * (3.5 / 2),
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  aspectRatio: 24.0 / 36.0,
                  viewportFraction: 0.85,
                  height: size.width * (36 / 24),
                  enableInfiniteScroll: true,
                ),
              );
            }),

            // CAROUSEL INDICATORS (REACTIVE ONLY COUNT)
            Obx(() {
              return Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.03,
                  bottom: size.safeWidth * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(ctrl.forYouEvents.length, (index) {
                    return Container(
                      width:
                          _eventCurrent == index
                              ? size.safeWidth * 0.03
                              : size.safeWidth * 0.02,
                      height: size.safeWidth * 0.02,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withAlpha(_eventCurrent == index ? 255 : 100),
                      ),
                    );
                  }),
                ),
              );
            }),

            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.03,
                bottom: size.safeWidth * 0.07,
              ),
              child: Text('ARTISTS', style: mainTitleTextStyle),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: size.safeWidth * 0.026),
                  Row(
                    children: List.generate(colors.length, (ind) {
                      return GestureDetector(
                        onTap: () => Get.to(Artistpage()),
                        child: Column(
                          spacing: 5.0,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colors[ind],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: size.safeWidth * 0.3,
                              width: size.safeWidth * 0.3,
                            ),
                            Text(
                              "Name ${ind + 1}",
                              style: TextStyle(
                                fontSize: Sizes().width * 0.03,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(width: size.safeWidth * 0.026),
                ],
              ),
            ),
            SizedBox(height: size.safeHeight * 0.03),

            Padding(
              padding: EdgeInsets.only(bottom: size.safeWidth * 0.06),
              child: Text('OFFERS FOR YOU', style: mainTitleTextStyle),
            ),
            SizedBox(
              height: size.safeHeight * 0.3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: offersColorSlider,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.07,
                bottom: size.safeWidth * 0.05,
              ),
              child: Text('UPCOMING EVENTS', style: mainTitleTextStyle),
            ),
            CarouselSlider(
              items: upcomingColorSlider,
              carouselController: _upcomingController,
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(days: 99),
                enlargeCenterPage: true,
                height: size.safeHeight * 0.42,
                viewportFraction: 0.93,
                onPageChanged: (index, reason) {
                  if (mounted) {
                    setState(() {
                      _upcomingCurrent = index;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.03,
                bottom: size.safeWidth * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    upcomingColorSlider.asMap().entries.map((entry) {
                      return Container(
                        width:
                            _upcomingCurrent == entry.key
                                ? size.safeWidth * 0.03
                                : size.safeWidth * 0.02,
                        height: size.safeWidth * 0.02,
                        margin: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withAlpha(
                                _upcomingCurrent == entry.key ? 255 : 100,
                              ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: size.safeHeight * 0.02),
          ],
        ),
      ),
    );
  }
}

// // lib/ui/all_events_page.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ticpin/pages/home/sub%20pages/eventspage.dart';
// import 'package:ticpin/services/controllers/event_controller.dart';

// class AllEventsPage extends StatelessWidget {
//   const AllEventsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = Get.find<EventController>();

//     return Scaffold(
//       appBar: AppBar(title: const Text("All Events")),
//       body: Obx(() {
//         if (ctrl.loading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final list = ctrl.allSummaries;

//         if (list.isEmpty) {
//           return const Center(child: Text("No events found"));
//         }

//         return ListView.separated(
//           itemCount: list.length,
//           separatorBuilder: (_, __) => const Divider(height: 1),
//           itemBuilder: (context, index) {
//             final e = list[index];

//             return ListTile(
//               leading: e.posterUrl.isNotEmpty
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(6),
//                       child: Image.network(
//                         e.posterUrl,
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   : const Icon(Icons.event),
//               title: Text(e.name),
//               subtitle: Text(
//           "${e.dateTime.toLocal()} • ${e.distanceKm.toStringAsFixed(2)} km away",
//         ),
//               onTap: () async {
//                 final full = await ctrl.loadEventFull(e.id);

//                 if (full == null) {
//                   Get.snackbar("Error", "Event details not found");
//                   return;
//                 }

//                 Get.to(() => EventDetailsPage(eventFull: full));
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }

// import 'package:carousel_slider/carousel_controller.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/models/event/eventsummary.dart';
// import 'package:ticpin/constants/shapes/containers.dart';
// import 'package:ticpin/constants/shimmer.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/constants/styles.dart';
// import 'package:ticpin/constants/temporary.dart';
// import 'package:ticpin/pages/view/artists/artistspage.dart';
// import 'package:ticpin/pages/view/concerts/concertpage.dart';
// import 'package:ticpin/services/controllers/event_controller.dart';
// import 'package:video_player/video_player.dart';

// class ForYoupage extends StatefulWidget {
//   const ForYoupage({super.key});

//   @override
//   State<StatefulWidget> createState() => _ForYoupageState();
// }

// class _ForYoupageState extends State<ForYoupage> {
//   final ctrl = Get.find<EventController>();

//   int _eventCurrent = 0;
//   int _upcomingCurrent = 0;

//   final CarouselSliderController _eventController = CarouselSliderController();
//   final CarouselSliderController _upcomingController =
//       CarouselSliderController();
//   final ScrollController _scrollController = ScrollController();

//   Sizes size = Sizes();

//   @override
//   void initState() {
//     super.initState();
//     // OPTIMIZATION: Lazy load more events when scrolling near bottom
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   // OPTIMIZATION: Infinite scroll pagination
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.8) {
//       // Load more when 80% scrolled
//       ctrl.loadMoreEvents();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       color: whiteColor,
//       child: Obx(() {
//         // Show loading indicator only on initial load
//         if (ctrl.loading.value && ctrl.allSummaries.isEmpty) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final events = ctrl.allSummaries;

//         if (events.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("NO EVENTS FOUND", style: mainTitleTextStyle),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () => ctrl.loadAllEvents(forceRefresh: true),
//                   child: Text("Refresh"),
//                 ),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           // OPTIMIZATION: Pull to refresh
//           onRefresh: () => ctrl.refreshEvents(),
//           child: SingleChildScrollView(
//             controller: _scrollController,
//             physics: AlwaysScrollableScrollPhysics(),
//             child: Column(
//               children: [
//                 // HOT RIGHT NOW SECTION
//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: size.safeWidth * 0.03,
//                     bottom: size.safeWidth * 0.07,
//                   ),
//                   child: Text('HOT RIGHT NOW', style: mainTitleTextStyle),
//                 ),

//                 CarouselSlider.builder(
//                   carouselController: _eventController,
//                   itemCount: events.length,
//                   itemBuilder: (context, index, realIndex) {
//                     final e = events[index];

//                     return PosterCarousel(
//                       event: e,
//                       name: e.name,
//                       date: DateFormat(
//                         'EEEE, d MMM • h:mm a',
//                       ).format(e.dateTime.toLocal()),
//                       loc: e.venue,
//                       dist: "${e.distanceKm.toStringAsFixed(2)} km away",
//                       posterUrl: e.posterUrl,
//                       videoUrl: e.videoUrl,
//                       isVideo: e.videoUrl.isNotEmpty,
//                       index: index,
//                       currentIndex: _eventCurrent,
//                       size: size,
//                     );
//                   },
//                   options: CarouselOptions(
//                     onPageChanged: (index, reason) {
//                       setState(() => _eventCurrent = index);
//                     },
//                     height: (size.safeWidth * 0.9) * (3 / 2),
//                     enlargeCenterPage: true,
//                     viewportFraction: 0.8,
//                     enableInfiniteScroll: true,
//                   ),
//                 ),

//                 // Carousel indicators
//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: size.safeWidth * 0.03,
//                     bottom: size.safeWidth * 0.03,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children:
//                         events.asMap().entries.map((entry) {
//                           return Container(
//                             width:
//                                 _eventCurrent == entry.key
//                                     ? size.safeWidth * 0.03
//                                     : size.safeWidth * 0.02,
//                             height: size.safeWidth * 0.02,
//                             margin: EdgeInsets.symmetric(
//                               vertical: 8.0,
//                               horizontal: 4.0,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15.0),
//                               color: (Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? Colors.white
//                                       : Colors.black)
//                                   .withAlpha(
//                                     _eventCurrent == entry.key ? 255 : 100,
//                                   ),
//                             ),
//                           );
//                         }).toList(),
//                   ),
//                 ),

//                 // ARTISTS SECTION
//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: size.safeWidth * 0.03,
//                     bottom: size.safeWidth * 0.07,
//                   ),
//                   child: Text('ARTISTS', style: mainTitleTextStyle),
//                 ),

//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       SizedBox(width: size.safeWidth * 0.04),
//                       Row(
//                         children: List.generate(colors.length, (ind) {
//                           return GestureDetector(
//                             onTap: () => Get.to(Artistpage()),
//                             child: Column(
//                               spacing: 5.0,
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   margin: EdgeInsets.symmetric(horizontal: 10),
//                                   height: size.safeWidth * 0.3,
//                                   width: size.safeWidth * 0.3,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(15),
//                                     child: Container(color: colors[ind]),
//                                   ),
//                                 ),
//                                 Text(
//                                   "Name ${ind + 1}",
//                                   style: TextStyle(
//                                     fontFamily: 'Regular',
//                                     fontSize: Sizes().width * 0.03,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       ),
//                       SizedBox(width: size.safeWidth * 0.04),
//                     ],
//                   ),
//                 ),

//                 // UPCOMING EVENTS SECTION
//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: size.safeWidth * 0.07,
//                     bottom: size.safeWidth * 0.05,
//                   ),
//                   child: Text('UPCOMING EVENTS', style: mainTitleTextStyle),
//                 ),

//                 CarouselSlider(
//                   items: upcomingColorSlider,
//                   carouselController: _upcomingController,
//                   options: CarouselOptions(
//                     enlargeStrategy: CenterPageEnlargeStrategy.scale,
//                     autoPlay: true,
//                     autoPlayInterval: Duration(days: 99),
//                     enlargeCenterPage: true,
//                     height: size.safeHeight * 0.34,
//                     viewportFraction: 0.80,
//                     aspectRatio: 2 / 3,
//                     onPageChanged: (index, reason) {
//                       if (mounted) {
//                         setState(() => _upcomingCurrent = index);
//                       }
//                     },
//                   ),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: size.safeWidth * 0.03,
//                     bottom: size.safeWidth * 0.03,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children:
//                         colors.asMap().entries.map((entry) {
//                           return Container(
//                             width:
//                                 _upcomingCurrent == entry.key
//                                     ? size.safeWidth * 0.03
//                                     : size.safeWidth * 0.02,
//                             height: size.safeWidth * 0.02,
//                             margin: EdgeInsets.symmetric(
//                               vertical: 8.0,
//                               horizontal: 4.0,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15.0),
//                               color: (Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? Colors.white
//                                       : Colors.black)
//                                   .withAlpha(
//                                     _upcomingCurrent == entry.key ? 255 : 100,
//                                   ),
//                             ),
//                           );
//                         }).toList(),
//                   ),
//                 ),

//                 // OPTIMIZATION: Show loading indicator at bottom when loading more
//                 if (ctrl.loading.value && ctrl.allSummaries.isNotEmpty)
//                   Padding(
//                     padding: EdgeInsets.all(20),
//                     child: CircularProgressIndicator(),
//                   ),

//                 SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// // ============================================
// // OPTIMIZED POSTER CAROUSEL
// // ============================================

// class PosterCarousel extends StatefulWidget {
//   PosterCarousel({
//     super.key,
//     required this.event,
//     required this.name,
//     required this.date,
//     required this.loc,
//     required this.dist,
//     required this.posterUrl,
//     required this.videoUrl,
//     required this.isVideo,
//     required this.index,
//     required this.currentIndex,
//     required this.size,
//   });

//   final String name;
//   final String date;
//   final String loc;
//   final String? posterUrl;
//   final String? videoUrl;
//   final bool isVideo;
//   final String dist;
//   final int index;
//   final int currentIndex;
//   final EventSummary event;
//   final Sizes size;

//   @override
//   State<PosterCarousel> createState() => _PosterCarouselState();
// }

// class _PosterCarouselState extends State<PosterCarousel> {
//   VideoPlayerController? _controller;
//   bool isMute = true;

//   @override
//   void initState() {
//     super.initState();
//     // OPTIMIZATION: Only initialize video for visible carousel item
//     if (widget.isVideo && widget.index == widget.currentIndex) {
//       _initializeVideo();
//     }
//   }

//   void _initializeVideo() {
//     if (widget.videoUrl == null || widget.videoUrl!.isEmpty) return;

//     // OPTIMIZATION: Load from network instead of asset
//     // Use videoUrl from Firebase Storage instead of local asset
//     _controller = VideoPlayerController.asset('assets/images/temp/video.mp4')
//       ..initialize()
//           .then((_) {
//             if (mounted) {
//               setState(() {
//                 _controller!.setVolume(0.0);
//                 _controller!.setLooping(true);
//                 _maybePlayOrPause();
//               });
//             }
//           })
//           .catchError((error) {
//             print('Video initialization error: $error');
//           });
//   }

//   @override
//   void didUpdateWidget(covariant PosterCarousel oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     // OPTIMIZATION: Initialize video only when item becomes visible
//     if (widget.index == widget.currentIndex &&
//         oldWidget.currentIndex != widget.currentIndex &&
//         widget.isVideo &&
//         _controller == null) {
//       _initializeVideo();
//     }

//     if (widget.currentIndex != oldWidget.currentIndex) {
//       _maybePlayOrPause();
//     }
//   }

//   void _maybePlayOrPause() {
//     if (_controller == null || !_controller!.value.isInitialized) return;

//     if (widget.index == widget.currentIndex) {
//       _controller!.play();
//     } else {
//       _controller!.pause();
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = widget.size.safeWidth * 0.9;
//     double height = width * (5 / 2);

//     return eventContainer(height, width);
//   }

//   GestureDetector eventContainer(double height, double width) {
//     return GestureDetector(
//       onTap: () {
//         _controller?.pause();
//         Get.to(
//           () => Concertpage(
//             eventId: widget.event.id,
//             distance: widget.event.distanceKm,
//           ),
//         )?.then((_) {
//           // Resume video when returning
//           if (_controller != null &&
//               _controller!.value.isInitialized &&
//               widget.index == widget.currentIndex) {
//             _controller!.play();
//           }
//         });
//       },
//       child: SizedBox(
//         width: width,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Poster/Video Container
//             Expanded(
//               child: Container(
//                 width: width,
//                 height: height,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(17),
//                     topRight: Radius.circular(17),
//                   ),
//                   border: Border(
//                     top: BorderSide(color: Colors.black12, width: 1),
//                     left: BorderSide(color: Colors.black12, width: 1),
//                     right: BorderSide(color: Colors.black12, width: 1),
//                   ),
//                 ),
//                 child: _buildMediaContent(height, width),
//               ),
//             ),

//             // Event Details Container
//             Container(
//               width: width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(17),
//                   bottomRight: Radius.circular(17),
//                 ),
//                 border: Border(
//                   bottom: BorderSide(color: Colors.black12, width: 1),
//                   left: BorderSide(color: Colors.black12, width: 1),
//                   right: BorderSide(color: Colors.black12, width: 1),
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(Sizes().width * 0.03),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     customTextStyle(widget.date, Sizes().width * 0.035),
//                     customTextStyle(
//                       widget.name,
//                       Sizes().width * 0.05,
//                       fondWeight: FontWeight.bold,
//                     ),
//                     customTextStyle(widget.loc, Sizes().width * 0.04),
//                     // OPTIMIZATION: Removed Obx wrapper since distanceKm is no longer reactive
//                     Padding(
//                       padding: EdgeInsets.all(Sizes().width * 0.001),
//                       child: Text(
//                         "${widget.event.distanceKm.toStringAsFixed(2)} km away",
//                         style: TextStyle(
//                           fontSize: widget.size.safeWidth * 0.035,
//                           fontFamily: 'Regular',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaContent(double height, double width) {
//     // Show video if available and this is the current carousel item
//     if (widget.isVideo &&
//         widget.videoUrl != null &&
//         widget.videoUrl!.isNotEmpty &&
//         _controller != null &&
//         widget.currentIndex == widget.index) {
//       return _buildVideoPlayer();
//     }

//     // Otherwise show image
//     return _buildImageView(height, width);
//   }

//   Widget _buildVideoPlayer() {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(17),
//         topRight: Radius.circular(17),
//       ),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           if (!_controller!.value.isInitialized) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final containerAspectRatio =
//               constraints.maxWidth / constraints.maxHeight;
//           final videoAspectRatio = _controller!.value.aspectRatio;

//           return Stack(
//             fit: StackFit.expand,
//             children: [
//               // Video Player
//               OverflowBox(
//                 alignment: Alignment.center,
//                 minWidth:
//                     containerAspectRatio > videoAspectRatio
//                         ? constraints.maxWidth
//                         : constraints.maxHeight * videoAspectRatio,
//                 minHeight:
//                     containerAspectRatio > videoAspectRatio
//                         ? constraints.maxWidth / videoAspectRatio
//                         : constraints.maxHeight,
//                 maxWidth:
//                     containerAspectRatio > videoAspectRatio
//                         ? constraints.maxWidth
//                         : constraints.maxHeight * videoAspectRatio,
//                 maxHeight:
//                     containerAspectRatio > videoAspectRatio
//                         ? constraints.maxWidth / videoAspectRatio
//                         : constraints.maxHeight,
//                 child: VideoPlayer(_controller!),
//               ),

//               // Mute Button
//               Padding(
//                 padding: EdgeInsets.all(Sizes().width * 0.02),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: InkWell(
//                     onTap: () {
//                       if (mounted) {
//                         setState(() {
//                           isMute = !isMute;
//                           _controller!.setVolume(isMute ? 0.0 : 1.0);
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(Sizes().width * 0.015),
//                       width: Sizes().width * 0.08,
//                       height: Sizes().width * 0.08,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFFCFCFFA),
//                       ),
//                       child: SvgPicture.asset(
//                         isMute
//                             ? 'assets/images/icons/mute.svg'
//                             : 'assets/images/icons/speaker.svg',
//                         width: Sizes().width * 0.1,
//                         height: Sizes().width * 0.1,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildImageView(double height, double width) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(17),
//         topRight: Radius.circular(17),
//       ),
//       child:
//           widget.posterUrl != null && widget.posterUrl!.isNotEmpty
//               ? Image.network(
//                 widget.posterUrl!,
//                 fit: BoxFit.fill,
//                 // OPTIMIZATION: Add caching headers
//                 cacheHeight:
//                     (height * MediaQuery.of(context).devicePixelRatio).toInt(),
//                 cacheWidth:
//                     (width * MediaQuery.of(context).devicePixelRatio).toInt(),
//                 errorBuilder:
//                     (context, error, stackTrace) =>
//                         const Center(child: Text("Invalid Image")),
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return LoadingShimmer(
//                     height: height,
//                     width: width,
//                     isCircle: false,
//                     radius: 0,
//                   );
//                 },
//               )
//               : Center(
//                 child: Icon(
//                   Icons.broken_image_rounded,
//                   color: Colors.grey,
//                   size: widget.size.safeWidth * 0.2,
//                 ),
//               ),
//     );
//   }
// }
