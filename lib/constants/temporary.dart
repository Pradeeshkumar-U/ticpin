import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/event/eventsummary.dart';
import 'package:ticpin/constants/models/turf/turfsummary.dart';
import 'package:ticpin/constants/shapes/containers.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/concerts/concertpage.dart';
import 'package:ticpin/pages/view/sports/turfpage.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/services/controllers/videoController.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Temp {
  static final eventNotIsVideo = false;
  static final eventIsVideo = true;
  static final eventDate = 'Sat, 08 Nov, 7 PM';
  static final eventName = 'Event Name';
  static final eventLoc = 'Event Location';
}

class TurfPosterCarousel extends StatefulWidget {
  final TurfSummary turf;
  final double dist;
  final Sizes size;
  final String name;
  final String city;
  final String loc;
  final String price;
  final String posterUrl;
  final int index;
  final int currentIndex;

  const TurfPosterCarousel({
    super.key,
    required this.turf,
    required this.dist,
    required this.size,
    required this.name,
    required this.city,
    required this.loc,
    required this.price,
    required this.posterUrl,
    required this.index,
    required this.currentIndex,
  });

  @override
  State<TurfPosterCarousel> createState() => _TurfPosterCarouselState();
}

class _TurfPosterCarouselState extends State<TurfPosterCarousel> {
  @override
  Widget build(BuildContext context) {
    double aspectratio = 3.0 / 2.0;
    double height = widget.size.width / aspectratio;
    double width = height * aspectratio;
    return GestureDetector(
      onTap: () {
        Get.to(
          () => Turfpage(
            turfId: widget.turf.id,
            // distance: widget.event.distanceKm,

            // videoUrl: widget.videoUrl!,
            // videoUrl: "",
          ),
        );

        // Navigate to turf detail page
        // Get.to(() => TurfDetailPage(turfId: turf.id));
      },
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.black12, width: 1),
                      left: BorderSide(color: Colors.black12, width: 1),
                      right: BorderSide(color: Colors.black12, width: 1),
                    ),
                  ),
                  child:
                      widget.posterUrl.isNotEmpty
                          ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),

                            child: Image.network(
                              widget.posterUrl,
                              // width: width,
                              // height: height,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stack) => const Center(
                                    child: Icon(
                                      Icons.sports_soccer,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),

                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : LoadingShimmer(
                                            height: height,
                                            width: width,
                                            isCircle: false,
                                            radius: 0,
                                          ),
                            ),
                          )
                          : SizedBox(
                            height: height,
                            child: Stack(
                              children: [
                                LoadingShimmer(
                                  height: height,
                                  width: width,
                                  isCircle: false,
                                  radius: 0,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.sports_soccer,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                  left: BorderSide(color: Colors.black12, width: 1),
                  right: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextStyle(
                          widget.name,
                          widget.size.safeWidth * 0.045,
                          fondWeight: FontWeight.bold,
                        ),
                        customTextStyle(
                          widget.city,
                          widget.size.safeWidth * 0.033,
                        ),

                        customTextStyle(
                          '${widget.price}',
                          widget.size.safeWidth * 0.033,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Sizes().width * 0.02,
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blackColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            color: whiteColor,
                            fontFamily: 'Regular',
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
      ),
    );
  }
}

// ignore: must_be_immutable
class PosterCarousel extends StatefulWidget {
  PosterCarousel({
    super.key,
    required this.event,
    required this.name,
    required this.date,
    required this.loc,
    required this.dist,
    required this.posterUrl,
    required this.videoUrl,
    required this.isVideo,
    required this.index,
    required this.currentIndex,
    required this.size,
  });

  String name;
  String date;
  String loc;
  String? posterUrl;
  String? videoUrl;
  bool isVideo;
  double dist;
  int index;
  int currentIndex;
  EventSummary event;
  Sizes size;

  @override
  State<PosterCarousel> createState() => _PosterCarouselState();
}

class _PosterCarouselState extends State<PosterCarousel> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    if (widget.isVideo) {
      _controller = VideoPlayerController.asset('assets/images/temp/video.mp4')
        ..initialize().then((_) {
          setState(() {
            _controller!.setVolume(0.0);
            _controller!.setLooping(true);
            _maybePlayOrPause();
            if (mounted) {
              setState(() {});
            }
          });
        });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PosterCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _maybePlayOrPause();
    }
  }

  void _maybePlayOrPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (widget.index == widget.currentIndex) {
      _controller!.play();
    } else {
      _controller!.pause();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
    }
  }

  final soundCtrl = Get.find<VideoSoundController>();
  final ctrl = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    double aspectratio = 24.0 / 36.0;

    double height = widget.size.safeHeight / aspectratio;
    double width = height * aspectratio;
    // 2:3 aspect ratio

    return eventContainer(height, width);
  }

  GestureDetector eventContainer(double height, double width) {
    return GestureDetector(
      onTap: () {
        _controller?.pause();
        Get.to(
          () => Concertpage(
            eventId: widget.event.id,
            // distance: widget.event.distanceKm,

            // videoUrl: widget.videoUrl!,
            // videoUrl: "",
          ),
        )?.then((_) {
          // // Called when coming back
          // if (_controller != null &&
          //     _controller!.value.isInitialized &&
          //     widget.index == widget.currentIndex) {
          //   _controller!.play();
          //   if (_controller != null && _controller!.value.isInitialized) {
          //     // Toggle global mute
          //     soundCtrl.toggleMute();

          //     // Apply to current video
          //     _controller!.setVolume(soundCtrl.isMuted.value ? 0.0 : 1.0);
          //   }
          // }
          // Called when coming back
          if (_controller != null &&
              _controller!.value.isInitialized &&
              widget.index == widget.currentIndex) {
            _controller!.play();

            // Apply the global mute state WITHOUT toggling it
            _controller!.setVolume(soundCtrl.isMuted.value ? 0.0 : 1.0);
          }
        });
      },
      child: VisibilityDetector(
        key: Key("event-video-${widget.currentIndex}"),
        onVisibilityChanged: (visibility) {
          if (ctrl.videoControllers.length <= widget.index)
            return; // SAFETY CHECK

          double visible = visibility.visibleFraction;
          if (visible > 0.6) {
            ctrl.playVideo(widget.index);
          } else {
            ctrl.pauseVideo(widget.index);
          }
        },
        child: SizedBox(
          width: width,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Poster Image
              Expanded(
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.black12, width: 1),
                      left: BorderSide(color: Colors.black12, width: 1),
                      right: BorderSide(color: Colors.black12, width: 1),
                    ),
                    // image: DecorationImage(
                    //   image: AssetImage('assets/images/temp/poster.jpg'),
                    //   fit: BoxFit.fill,
                    // ),
                  ),

                  child:
                      widget.isVideo &&
                              widget.videoUrl != null &&
                              widget.videoUrl!.isNotEmpty &&
                              _controller != null &&
                              widget.currentIndex == widget.index
                          ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(17),
                              topRight: Radius.circular(17),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final containerAspectRatio =
                                    constraints.maxWidth /
                                    constraints.maxHeight;
                                final videoAspectRatio =
                                    _controller!.value.isInitialized
                                        ? _controller!.value.aspectRatio
                                        : 16 / 9;

                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // VIDEO
                                    if (_controller!.value.isInitialized)
                                      OverflowBox(
                                        alignment: Alignment.center,
                                        minWidth:
                                            containerAspectRatio >
                                                    videoAspectRatio
                                                ? constraints.maxWidth
                                                : constraints.maxHeight *
                                                    videoAspectRatio,
                                        minHeight:
                                            containerAspectRatio >
                                                    videoAspectRatio
                                                ? constraints.maxWidth /
                                                    videoAspectRatio
                                                : constraints.maxHeight,
                                        maxWidth:
                                            containerAspectRatio >
                                                    videoAspectRatio
                                                ? constraints.maxWidth
                                                : constraints.maxHeight *
                                                    videoAspectRatio,
                                        maxHeight:
                                            containerAspectRatio >
                                                    videoAspectRatio
                                                ? constraints.maxWidth /
                                                    videoAspectRatio
                                                : constraints.maxHeight,
                                        child: VideoPlayer(_controller!),
                                      )
                                    else
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),

                                    // MUTE BUTTON
                                    Padding(
                                      padding: EdgeInsets.all(
                                        Sizes().width * 0.02,
                                      ),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            if (mounted) {
                                              if (_controller != null &&
                                                  _controller!
                                                      .value
                                                      .isInitialized) {
                                                // Toggle global mute
                                                soundCtrl.toggleMute();

                                                // Apply to current video
                                                _controller!.setVolume(
                                                  soundCtrl.isMuted.value
                                                      ? 0.0
                                                      : 1.0,
                                                );
                                              }
                                            }
                                          },
                                          child: Obx(
                                            () => Container(
                                              padding: EdgeInsets.all(
                                                Sizes().width * 0.015,
                                              ),
                                              // width: Sizes().width * 0.08,
                                              // height: Sizes().width * 0.08,
                                              // decoration: const BoxDecoration(
                                              //   shape: BoxShape.circle,
                                              //   color: Color(0xFFCFCFFA),
                                              // ),
                                              // child: SvgPicture.asset(
                                              //   soundCtrl.isMuted.value
                                              //       ? 'assets/images/icons/mute.svg'
                                              //       : 'assets/images/icons/speaker.svg',
                                              //   width: Sizes().width * 0.1,
                                              //   height: Sizes().width * 0.1,
                                              // ),
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                soundCtrl.isMuted.value
                                                    ? Icons.volume_off
                                                    : Icons.volume_up,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                          :
                          // IMAGE MODE
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(17),
                              topRight: Radius.circular(17),
                            ),
                            child:
                                widget.posterUrl != null &&
                                        widget.posterUrl!.isNotEmpty
                                    ? Image.network(
                                      widget.posterUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Center(
                                                child: Text("Invalid Image"),
                                              ),
                                      loadingBuilder:
                                          (context, child, loadingProgress) =>
                                              loadingProgress == null
                                                  ? child
                                                  : LoadingShimmer(
                                                    height: height,
                                                    width: width,
                                                    isCircle: false,
                                                    radius: 0,
                                                  ),
                                    )
                                    : Center(
                                      child: Icon(
                                        Icons.broken_image_rounded,
                                        color: Colors.grey,
                                        size: widget.size.safeWidth * 0.2,
                                      ),
                                    ),
                          ),
                ),
              ),

              // Text Below
              Container(
                width: width,
                // margin: EdgeInsets.all(Sizes().width * 0.1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(17),
                    bottomRight: Radius.circular(17),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                    left: BorderSide(color: Colors.black12, width: 1),
                    right: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(widget.size.safeWidth * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyle(
                        widget.date,
                        widget.size.safeWidth * 0.035,
                      ),
                      customTextStyle(
                        widget.name,
                        widget.size.safeWidth * 0.05,
                        fondWeight: FontWeight.bold,
                      ),
                      customTextStyle(
                        widget.loc,
                        widget.size.safeWidth * 0.035,
                      ),
                      // Obx(
                      //   () => Padding(
                      //     padding: EdgeInsets.all(widget.size.safeWidth * 0.001),
                      //     child: Text(
                      //       "${widget.event.distanceKm.toStringAsFixed(2)} km away",
                      //       style: TextStyle(
                      //         fontSize: widget.size.safeWidth * 0.035,
                      //         fontFamily: 'Regular',
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.all(widget.size.safeWidth * 0.001),
                        child: Text(
                          "${widget.event.distanceKm.toStringAsFixed(2)} km away",
                          style: TextStyle(
                            fontSize: widget.size.safeWidth * 0.03,
                            fontFamily: 'Regular',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
];

final List<Widget> eventColorSlider =
    colors
        .map(
          (item) => eventContainer(
            isVideo: false,
            date: Temp.eventDate,
            name: Temp.eventName,
            loc: Temp.eventLoc,
            color: item,
          ),
        )
        .toList();

final List songs = ['Song 1', 'Song 2', 'Song 3', 'Song 4', 'Song 5'];

final List<Widget> songSlider =
    songs.map((item) => songContainer(song: item)).toList();

final List<Widget> blockbusterColorSlider =
    colors
        .map(
          (item) => blockbusterContainer(
            date: Temp.eventDate,
            name: Temp.eventName,
            color: item,
          ),
        )
        .toList();

final List<Widget> offersColorSlider =
    colors
        .map(
          (item) => offersContainer(
            date: Temp.eventDate,
            name: Temp.eventName,

            color: item,
            offer: '50% OFF',
          ),
        )
        .toList();

final List<Widget> diningColorSlider =
    colors
        .map(
          (item) => diningContainer(
            loc: 'Location',
            name: 'Dining Name',

            color: item,
            offer: '50% OFF',
          ),
        )
        .toList();

final List<Widget> sportsColorSlider =
    colors
        .map(
          (item) =>
              sportsContainer(loc: 'Location', name: 'Turf Name', color: item),
        )
        .toList();

final List<Widget> upcomingColorSlider =
    colors
        .map(
          (item) => upcomingContainer(
            date: Temp.eventDate,
            name: Temp.eventName,
            color: item,
          ),
        )
        .toList();



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:ticpin/constants/shapes/containers.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/pages/view/concerts/concertpage.dart';
// import 'package:video_player/video_player.dart';

// class Temp {
//   static final eventNotIsVideo = false;
//   static final eventIsVideo = true;
//   static final eventDate = 'Sat, 08 Nov, 7 PM';
//   static final eventName = 'Event Name';
//   static final eventLoc = 'Event Location';
// }

// // ignore: must_be_immutable
// class PosterCarousel extends StatefulWidget {
//   PosterCarousel({
//     super.key,
//     required this.name,
//     required this.date,
//     required this.loc,
//     required this.isVideo,
//     required this.index,
//     required this.currentIndex,
//   });
//   String date;
//   int index;
//   int currentIndex;
//   String loc;
//   String name;
//   bool isVideo;
//   @override
//   State<PosterCarousel> createState() => _PosterCarouselState();
// }

// class _PosterCarouselState extends State<PosterCarousel> {
//   VideoPlayerController? _controller;

//   @override
//   void initState() {
//     if (widget.isVideo) {
//       _controller = VideoPlayerController.asset('assets/images/temp/video.mp4')
//         ..initialize().then((_) {
//           setState(() {
//             _controller!.setVolume(0.0);
//             _controller!.setLooping(true);
//             _maybePlayOrPause();
//             if (mounted) {
//               setState(() {});
//             }
//           });
//         });
//     }
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant PosterCarousel oldWidget) {
//     super.didUpdateWidget(oldWidget);
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
//     super.dispose();
//     if (_controller != null) {
//       _controller!.dispose();
//     }
//   }

//   bool isMute = true;
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.safeWidth * 0.9;
//     double height = width * (5 / 2); // 2:3 aspect ratio

//     return eventContainer(height, width);
//   }

//   GestureDetector eventContainer(double height, double width) {
//     return GestureDetector(
//       onTap: () {
//         _controller?.pause();
//         Get.to(() => Concertpage())?.then((_) {
//           // Called when coming back
//           if (_controller != null &&
//               _controller!.value.isInitialized &&
//               widget.index == widget.currentIndex) {
//             _controller!.play();
//             isMute = !isMute;
//           }
//         });
//       },
//       child: SizedBox(
//         width: width,
//         child: Column(
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Poster Image
//             Expanded(
//               child: Container(
//                 width: width,
//                 height: height,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(17),
//                     topRight: Radius.circular(17),
//                   ),
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/temp/poster.jpg'),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//                 child:
//                     widget.isVideo &&
//                             _controller != null &&
//                             widget.currentIndex == widget.index
//                         ? ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(17),
//                             topRight: Radius.circular(17),
//                           ),
//                           child: LayoutBuilder(
//                             builder: (context, constraints) {
//                               final containerAspectRatio =
//                                   constraints.maxWidth / constraints.maxHeight;
//                               final videoAspectRatio =
//                                   _controller!.value.aspectRatio;

//                               return Stack(
//                                 fit: StackFit.expand,
//                                 children: [
//                                   if (_controller!.value.isInitialized)
//                                     OverflowBox(
//                                       alignment: Alignment.center,
//                                       minWidth:
//                                           containerAspectRatio >
//                                                   videoAspectRatio
//                                               ? constraints.maxWidth
//                                               : constraints.maxHeight *
//                                                   videoAspectRatio,
//                                       minHeight:
//                                           containerAspectRatio >
//                                                   videoAspectRatio
//                                               ? constraints.maxWidth /
//                                                   videoAspectRatio
//                                               : constraints.maxHeight,
//                                       maxWidth:
//                                           containerAspectRatio >
//                                                   videoAspectRatio
//                                               ? constraints.maxWidth
//                                               : constraints.maxHeight *
//                                                   videoAspectRatio,
//                                       maxHeight:
//                                           containerAspectRatio >
//                                                   videoAspectRatio
//                                               ? constraints.maxWidth /
//                                                   videoAspectRatio
//                                               : constraints.maxHeight,
//                                       child: VideoPlayer(_controller!),
//                                     )
//                                   else
//                                     const Center(
//                                       child: CircularProgressIndicator(),
//                                     ),
//                                   Padding(
//                                     padding: EdgeInsets.all(
//                                       Sizes().width * 0.02,
//                                     ),
//                                     child: Align(
//                                       alignment: Alignment.topRight,
//                                       child: InkWell(
//                                         onTap: () {
//                                           if (mounted) {
//                                             if (isMute) {
//                                               _controller!.setVolume(1.0);
//                                             } else {
//                                               _controller!.setVolume(0.0);
//                                             }
//                                             setState(() {
//                                               isMute = !isMute;
//                                             });
//                                           }
//                                         },
//                                         child: Container(
//                                           padding: EdgeInsets.all(
//                                             Sizes().width * 0.015,
//                                           ),
//                                           width: Sizes().width * 0.08,
//                                           height: Sizes().width * 0.08,
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: Color(0xFFCFCFFA),
//                                           ),

//                                           child: SvgPicture.asset(
//                                             isMute
//                                                 ? 'assets/images/icons/mute.svg'
//                                                 : 'assets/images/icons/speaker.svg',
//                                             width: Sizes().width * 0.1,
//                                             height: Sizes().width * 0.1,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         )
//                         : Padding(
//                           padding: EdgeInsets.all(Sizes().width * 0.02),
//                           child: Align(
//                             alignment: Alignment.topRight,
//                             child: Container(
//                               padding: EdgeInsets.all(Sizes().width * 0.02),
//                               width: Sizes().width * 0.07,
//                               height: Sizes().width * 0.07,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFFCFCFFA),
//                               ),

//                               child: InkWell(
//                                 onTap: () {
//                                   if (mounted) {
//                                     setState(() {
//                                       isMute = !isMute;
//                                     });
//                                   }
//                                 },
//                                 child: SvgPicture.asset(
//                                   isMute
//                                       ? 'assets/images/icons/mute.svg'
//                                       : 'assets/images/icons/speaker.svg',
//                                   width: Sizes().width * 0.07,
//                                   height: Sizes().width * 0.07,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//               ),
//             ),

//             // Text Below
//             Container(
//               width: width,
//               // margin: EdgeInsets.all(Sizes().width * 0.1),
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
//                     customTextStyle(widget.date, Sizes().width * 0.03),
//                     customTextStyle(widget.name, Sizes().width * 0.045),
//                     customTextStyle(widget.loc, Sizes().width * 0.03),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// final List<Color> colors = [
//   Colors.red,
//   Colors.green,
//   Colors.blue,
//   Colors.yellow,
//   Colors.purple,
// ];

// final List<Widget> eventColorSlider =
//     colors
//         .map(
//           (item) => eventContainer(
//             isVideo: false,
//             date: Temp.eventDate,
//             name: Temp.eventName,
//             loc: Temp.eventLoc,
//             color: item,
//           ),
//         )
//         .toList();

// final List songs = ['Song 1', 'Song 2', 'Song 3', 'Song 4', 'Song 5'];

// final List<Widget> songSlider =
//     songs.map((item) => songContainer(song: item)).toList();

// final List<Widget> blockbusterColorSlider =
//     colors
//         .map(
//           (item) => blockbusterContainer(
//             date: Temp.eventDate,
//             name: Temp.eventName,
//             color: item,
//           ),
//         )
//         .toList();

// final List<Widget> offersColorSlider =
//     colors
//         .map(
//           (item) => offersContainer(
//             date: Temp.eventDate,
//             name: Temp.eventName,

//             color: item,
//             offer: '50% OFF',
//           ),
//         )
//         .toList();



// final List<Widget> diningColorSlider =
//     colors
//         .map(
//           (item) => diningContainer(
//             loc: 'Location',
//             name: 'Dining Name',

//             color: item,
//             offer: '50% OFF',
//           ),
//         )
//         .toList();

// final List<Widget> sportsColorSlider =
//     colors
//         .map(
//           (item) => sportsContainer(
//             loc: 'Location',
//             name: 'Turf Name',

//             color: item,
//           ),
//         )
//         .toList();

// final List<Widget> upcomingColorSlider =
//     colors
//         .map(
//           (item) => upcomingContainer(
//             date: Temp.eventDate,
//             name: Temp.eventName,
//             color: item,
//           ),
//         )
//         .toList();
