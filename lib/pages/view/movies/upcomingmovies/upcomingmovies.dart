// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:sliver_tools/sliver_tools.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/size.dart';
// import 'dart:io' show Platform;

// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// class UpcomingMovie extends StatefulWidget {
//   const UpcomingMovie({super.key});

//   @override
//   State<UpcomingMovie> createState() => _UpcomingMovieState();
// }

// class _UpcomingMovieState extends State<UpcomingMovie> {
//   late YoutubePlayerController _controller;
//   bool _isPlaying = false;
//   final ScrollController _scrollController = ScrollController();
//   double _appBarOpacity = 0.0;
//   int _currentIndex = 0;

//   final String youtubeUrl = "https://youtu.be/OCg6BWlAXSw?si=28c1qhytYq7WE7uh";
//   String movie_name = "Name",
//       movie_details = "Details",
//       about_content = "Content\nContent\nContent\nContent";
//   String _selectedTab = "About";

//   final GlobalKey _aboutKey = GlobalKey();
//   final GlobalKey _castKey = GlobalKey();
//   final GlobalKey _videosKey = GlobalKey();
//   final GlobalKey _postersKey = GlobalKey();
//   double _opacity = 0.0;

//   String getYoutubeVideoId(String url) {
//   final uri = Uri.tryParse(url);
//   if (uri == null) return "";

//   // Case 1: Normal YouTube link (https://www.youtube.com/watch?v=VIDEOID)
//   if (uri.queryParameters.containsKey('v')) {
//     return uri.queryParameters['v'] ?? "";
//   }

//   // Case 2: Shortened link (https://youtu.be/VIDEOID)
//   if (uri.host.contains("youtu.be")) {
//     return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : "";
//   }

//   // Case 3: Embed link (https://www.youtube.com/embed/VIDEOID)
//   if (uri.pathSegments.contains("embed")) {
//     int index = uri.pathSegments.indexOf("embed");
//     if (index != -1 && uri.pathSegments.length > index + 1) {
//       return uri.pathSegments[index + 1];
//     }
//   }

//   return "";
// }

//   @override
//   void initState() {
//     super.initState();
//     final videoId = getYoutubeVideoId(youtubeUrl);

//     _controller = YoutubePlayerController.fromVideoId(
//       videoId: videoId,
//       autoPlay: false,
//       params: const YoutubePlayerParams(
//         showControls: false,
//         showFullscreenButton: false,
//       ),
//     );
//     _scrollController.addListener(() {
//       final offset = _scrollController.offset;
//       setState(() {
//         final t = _appBarOpacity = (offset / 200).clamp(0, 1);
//         _appBarOpacity = Curves.easeInOut.transform(t);
//       });
//     });
//     _scrollController.addListener(() {
//       double offset = _scrollController.offset;

//       // Adjust this value depending on when you want the title to fade in
//       double fadeStart = size.safeHeight * 0.01;
//       double fadeEnd = size.safeHeight * 0.1;

//       double newOpacity = (offset - fadeStart) / (fadeEnd - fadeStart);
//       newOpacity = newOpacity.clamp(0.0, 1.0);

//       if (newOpacity != _opacity) {
//         if (mounted) {
//           setState(() {
//             _opacity = newOpacity;
//           });
//         }
//       }
//     });
//   }

//   Widget bar_butt(String name, VoidCallback onTap) {
//     final bool isSelected = _selectedTab == name;

//     return IconButton(
//       onPressed: () {
//         setState(() {
//           _selectedTab = name;
//         });
//         onTap();
//       },
//       splashColor: Colors.transparent,
//       highlightColor: Colors.transparent,

//       icon: Container(
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFFCFCFFA) : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         child: Text(
//           name,
//           style: TextStyle(
//             fontFamily: 'Regular',
//             fontWeight: FontWeight.bold,
//             color: isSelected ? Colors.black : Colors.black54,
//           ),
//         ),
//       ),
//     );
//   }

//   //
//   void _scrollTo(GlobalKey key) {
//     final ctx = key.currentContext;
//     if (ctx != null) {
//       final box = ctx.findRenderObject() as RenderBox;
//       final offset = box.localToGlobal(
//         Offset.zero,
//         ancestor: context.findRenderObject(),
//       );
//       final adjustment = kToolbarHeight + 110;

//       _scrollController.animateTo(
//         _scrollController.offset + offset.dy - adjustment,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   //
//   Widget buildStarRating(double rating) {
//     return Row(
//       children: List.generate(5, (i) {
//         String emoji;
//         if (i < rating.floor()) {
//           emoji = "⭐";
//         } else if (i < rating && rating - i >= 0.5) {
//           emoji = "🌟"; // optional: half-star look
//         } else {
//           emoji = "☆";
//         }

//         final iconWidget =
//             Platform.isIOS
//                 ? Text(emoji, style: const TextStyle(fontSize: 24))
//                 : Icon(
//                   i < rating.floor()
//                       ? Icons.star
//                       : (i < rating && rating - i >= 0.5)
//                       ? Icons.star_half
//                       : Icons.star_border,
//                   size: 28,
//                   color: Colors.white,
//                 );

//         return ShaderMask(
//           shaderCallback:
//               (bounds) => const LinearGradient(
//                 colors: [Colors.orange, Colors.red],
//               ).createShader(bounds),
//           child: iconWidget,
//         );
//       }),
//     );
//   }

//   Sizes size = Sizes();

//   bool isTap = false;
//   bool isSelected = false;
//   bool isGlowing = false;
//   //
//   @override
//   void dispose() {
//     _controller.close();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   //
//   @override
//   Widget build(BuildContext context) {
//     final wid = MediaQuery.of(context).size.safeWidth;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//         automaticallyImplyLeading: true,
//         leadingWidth: size.safeWidth * 0.14,
//         leading: GestureDetector(
//           onTap: () => Get.back(),
//           child: Padding(
//             padding: EdgeInsets.only(left: size.safeWidth * 0.04),
//             child: Container(
//               padding: EdgeInsets.all(0),
//               width: size.safeWidth * 0.03,
//               height: size.safeWidth * 0.03,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: greyColor.withAlpha(60),
//               ),
//               child: Icon(
//                 Icons.arrow_back,
//                 color: Color.lerp(whiteColor, blackColor, _opacity),
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 isTap = !isTap;
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: greyColor.withAlpha(60),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(3.0),
//                 child: StatefulBuilder(
//                   builder: (context, set) {
//                     glowOff() =>
//                         Future.delayed(const Duration(milliseconds: 700), () {
//                           if (context.mounted) set(() => isGlowing = false);
//                         });

//                     return InkWell(
//                       splashFactory: NoSplash.splashFactory,
//                       onTap: () {
//                         set(() {
//                           isSelected = !isSelected;
//                         });
//                         if (isSelected) {
//                           isGlowing = true;
//                           glowOff();
//                         }
//                       },
//                       child: Container(
//                         // padding: EdgeInsets.all(size.safeWidth * 0.006),
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             AnimatedOpacity(
//                               opacity: isGlowing ? 1 : 0,
//                               duration: const Duration(milliseconds: 300),
//                               child: Icon(
//                                 Icons.local_fire_department_sharp,
//                                 size: size.safeWidth * 0.075 + 5,
//                                 color: Colors.orangeAccent.withOpacity(0.5),
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.orangeAccent.withOpacity(0.8),
//                                     blurRadius: 25,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             isSelected
//                                 ? ShaderMask(
//                                   shaderCallback:
//                                       (r) => const LinearGradient(
//                                         colors: [
//                                           Color(0xFFFFBF00),
//                                           Color(0xFFFF0000),
//                                         ],
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter,
//                                       ).createShader(r),
//                                   child: Icon(
//                                     Icons.local_fire_department_sharp,
//                                     color: Colors.white,
//                                     size: size.safeWidth * 0.07,
//                                   ),
//                                 )
//                                 : Icon(
//                                   Icons.local_fire_department_outlined,
//                                   color: Color.lerp(
//                                     whiteColor.withAlpha(230),
//                                     blackColor.withAlpha(200),
//                                     _opacity,
//                                   ),
//                                   size: size.safeWidth * 0.07,
//                                 ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: size.safeWidth * 0.02),
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: greyColor.withAlpha(60),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SvgPicture.asset(
//                 'assets/images/icons/share.svg',
//                 width: size.safeWidth * 0.06,
//                 height: size.safeWidth * 0.06,
//                 // ignore: deprecated_member_use
//                 color: Color.lerp(whiteColor, blackColor, _opacity),
//               ),
//             ),
//           ),
//           SizedBox(width: size.safeWidth * 0.05),
//         ],
//         // title: AnimatedOpacity(
//         //   opacity: _opacity,
//         //   duration: Duration(milliseconds: 300),
//         //   child: Text("Movie Title"),
//         // ),
//         flexibleSpace: Opacity(
//           opacity: _opacity,
//           child: FlexibleSpaceBar(
//             background: Container(color: whiteColor),
//             title: Text(
//               ' Movie Name',
//               style: TextStyle(
//                 fontSize: size.safeWidth * 0.05,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Regular',
//               ),
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           CustomScrollView(
//             controller: _scrollController,
//             slivers: [
//               SliverToBoxAdapter(child: YoutubePlayer(controller: _controller,)),

//               SliverToBoxAdapter(
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         movie_name,
//                         style: TextStyle(
//                           fontFamily: 'Regular',

//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         movie_details,
//                         style: TextStyle(
//                           fontFamily: 'Regular',

//                           fontSize: 15,
//                           color: Colors.black.withAlpha(190),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverPersistentHeader(
//                 pinned: true,
//                 delegate: _StickyTabBarDelegate(
//                   child: Container(
//                     color: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 10),
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 25),
//                       decoration: BoxDecoration(
//                         // color: Colors.black.withAlpha(20),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           bar_butt("About", () => _scrollTo(_aboutKey)),
//                           bar_butt("Cast", () => _scrollTo(_castKey)),
//                           bar_butt("Videos", () => _scrollTo(_videosKey)),
//                           bar_butt("Posters", () => _scrollTo(_postersKey)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 15),
//                       Text(
//                         "About",
//                         key: _aboutKey,
//                         style: TextStyle(
//                           fontFamily: 'Regular',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 7),
//                       Text(about_content, textAlign: TextAlign.justify),
//                       SizedBox(height: 15),
//                       Text(
//                         "Ratings",
//                         style: TextStyle(
//                           fontFamily: 'Regular',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 7),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           buildStarRating(3.7),
//                           SizedBox(width: 20),
//                           Text("3.7"),
//                         ],
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         "Cast",
//                         key: _castKey,
//                         style: TextStyle(
//                           fontFamily: 'Regular',

//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 7),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: List.generate(10, (ind) {
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: wid * 0.1,
//                                     backgroundColor: Colors.black,
//                                     child: CircleAvatar(
//                                       radius: (wid * 0.1) - 0.5,
//                                       backgroundColor: Colors.white,
//                                       child: Text("${ind + 1}"),
//                                     ),
//                                   ),
//                                   Text("Name ${ind + 1}"),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         "Videos",
//                         key: _videosKey,
//                         style: TextStyle(
//                           fontFamily: 'Regular',

//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 7),
//                       Column(
//                         children: [
//                           CarouselSlider(
//                             options: CarouselOptions(
//                               height: wid * (9 / 16) + 70,
//                               enlargeCenterPage: true,
//                               viewportFraction: 1,
//                               onPageChanged: (index, reason) {
//                                 setState(() {
//                                   _currentIndex = index;
//                                 });
//                               },
//                             ),
//                             items: List.generate(4, (index) {
//                               return Column(
//                                 children: [
//                                   Container(
//                                     height: wid * (9 / 16),
//                                     color: Colors.grey.shade300,
//                                     alignment: Alignment.center,
//                                     child: Text("Item ${index + 1}"),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   Text("#Video Tags"),
//                                 ],
//                               );
//                             }),
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: List.generate(4, (index) {
//                               return Container(
//                                 margin: const EdgeInsets.symmetric(
//                                   horizontal: 3,
//                                 ),
//                                 width: _currentIndex == index ? 20 : 6,
//                                 height: _currentIndex == index ? 8 : 6,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color:
//                                       _currentIndex == index
//                                           ? Colors.black
//                                           : Colors.grey.shade400,
//                                 ),
//                               );
//                             }),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         "Posters",
//                         key: _postersKey,
//                         style: TextStyle(
//                           fontFamily: 'Regular',

//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 7),
//                       GridView.count(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                         childAspectRatio: 1,
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         padding: EdgeInsets.all(10),
//                         children: List.generate(4, (ind) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               color: Colors.black12,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               "${ind + 1}",

//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontSize: 18,
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                       SizedBox(height: 80),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               color: Colors.white,
//               child: Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Expected Release Date"),
//                       Text(
//                         "Date",
//                         style: TextStyle(
//                           fontFamily: 'Regular',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         //   TicPin Button
//                         //   TicPin Button
//                       ),
//                     ],
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
//     return Padding(padding: EdgeInsets.only(top: kToolbarHeight), child: child);
//   }

//   @override
//   double get maxExtent => 70 + kToolbarHeight;

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
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/artists/artistspage.dart';
import 'dart:io' show Platform;

import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class UpcomingMovie extends StatefulWidget {
  const UpcomingMovie({super.key});

  @override
  State<UpcomingMovie> createState() => _UpcomingMovieState();
}

class _UpcomingMovieState extends State<UpcomingMovie>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;
  int _currentIndex = 0;
  String getYoutubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return "";

    // Case 1: Normal YouTube link (https://www.youtube.com/watch?v=VIDEOID)
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'] ?? "";
    }

    // Case 2: Shortened link (https://youtu.be/VIDEOID)
    if (uri.host.contains("youtu.be")) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : "";
    }

    // Case 3: Embed link (https://www.youtube.com/embed/VIDEOID)
    if (uri.pathSegments.contains("embed")) {
      int index = uri.pathSegments.indexOf("embed");
      if (index != -1 && uri.pathSegments.length > index + 1) {
        return uri.pathSegments[index + 1];
      }
    }

    return "";
  }

  final String you_tu_url = "https://youtu.be/OCg6BWlAXSw?si=28c1qhytYq7WE7uh";
  String movie_name = "Name",
      movie_details = "Details",
      about_content = "Content\nContent\nContent\nContent";

  late TabController _tabController;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _scrollController.addListener(() {
      Sizes size = Sizes();
      _onScroll().then((sectionkey) {
        setState(() {});
      });
      double offset = _scrollController.offset;

      // Adjust this value depending on when you want the title to fade in
      double fadeStart = size.safeHeight * 0.01;
      double fadeEnd = size.safeHeight * 0.03;

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
        fixedSize: Size.fromWidth(size.safeWidth * 0.2),
        elevation: 0,

        padding: EdgeInsets.all(size.safeWidth * 0.02),
        backgroundColor: isSelected ? gradient1.withAlpha(80) : whiteColor,
        // side: BorderSide(color: Colors.black12.withAlpha(30), width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
      onPressed: () {
        // update tab highlight
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

  //
  Widget buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (i) {
        String emoji;
        if (i < rating.floor()) {
          emoji = "⭐";
        } else if (i < rating && rating - i >= 0.5) {
          emoji = "🌟"; // optional: half-star look
        } else {
          emoji = "☆";
        }

        final iconWidget =
            Platform.isIOS
                ? Text(
                  emoji,
                  style: const TextStyle(fontFamily: 'Regular', fontSize: 24),
                )
                : Icon(
                  i < rating.floor()
                      ? Icons.star
                      : (i < rating && rating - i >= 0.5)
                      ? Icons.star_half
                      : Icons.star_border,
                  size: 28,
                  color: Colors.white,
                );

        return ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [Colors.orange, Colors.red],
              ).createShader(bounds),
          child: iconWidget,
        );
      }),
    );
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

        // if (mounted) {
        //   setState(() {});
        // }
      }
    }
  }

  bool isGlowing = false;
  bool isSelected = false;
  //
  @override
  void dispose() {
    _controller.close();
    _scrollController.dispose();
    super.dispose();
  }

  Sizes size = Sizes();

  //
  @override
  Widget build(BuildContext context) {
    final List<List> tabs = [
      ['About', section1Key],
      ['Cast', section2Key],
      ['Videos', section3Key],
      ['Posters', section4Key],
    ];
    final videoId = getYoutubeVideoId(you_tu_url);
   
    List<Color> col_lis = [
      Colors.green,
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];
    return WillPopScope(
      onWillPop: () async {
        _controller.close();
        setState(() {});
        return true;
      },

      child: Scaffold(
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
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: CircleAvatar(
                          //     backgroundColor: Colors.white54,
                          //     child: Icon(
                          //       Icons.search,
                          //       color: Color.lerp(
                          //         blackColor.withAlpha(200),
                          //         blackColor,
                          //         _appBarOpacity,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          IconButton(
                            onPressed: () {},
                            icon: CircleAvatar(
                              backgroundColor: Colors.white54,
                              child: StatefulBuilder(
                                builder: (context, set) {
                                  glowOff() => Future.delayed(
                                    const Duration(milliseconds: 700),
                                    () {
                                      if (context.mounted)
                                        set(() => isGlowing = false);
                                    },
                                  );

                                  return InkWell(
                                    splashFactory: NoSplash.splashFactory,
                                    onTap: () {
                                      set(() {
                                        isSelected = !isSelected;
                                      });
                                      if (isSelected) {
                                        isGlowing = true;
                                        glowOff();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        size.safeWidth * 0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedOpacity(
                                            opacity: isGlowing ? 1 : 0,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            child: Icon(
                                              Icons.local_fire_department_sharp,
                                              size: size.safeWidth * 0.07 + 3,
                                              color: Colors.orangeAccent
                                                  .withOpacity(0.5),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.orangeAccent
                                                      .withOpacity(0.8),
                                                  blurRadius: 25,
                                                ),
                                              ],
                                            ),
                                          ),
                                          isSelected
                                              ? ShaderMask(
                                                shaderCallback:
                                                    (r) => const LinearGradient(
                                                      colors: [
                                                        Color(0xFFFFBF00),
                                                        Color(0xFFFF0000),
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end:
                                                          Alignment
                                                              .bottomCenter,
                                                    ).createShader(r),
                                                child: Icon(
                                                  Icons
                                                      .local_fire_department_sharp,
                                                  color: Colors.white,
                                                  size: size.safeWidth * 0.07,
                                                ),
                                              )
                                              : Icon(
                                                Icons
                                                    .local_fire_department_outlined,
                                                color: Color.lerp(
                                                  blackColor.withAlpha(200),
                                                  blackColor.withAlpha(200),
                                                  _appBarOpacity,
                                                ),
                                                size: size.safeWidth * 0.07,
                                              ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                        size.safeWidth * (9 / 16) -
                        MediaQuery.of(context).padding.top,
                    backgroundColor: Color.lerp(
                      Colors.transparent,
                      whiteColor,
                      _appBarOpacity,
                    ),

                    elevation: _appBarOpacity > 0.1 ? 4 : 0,
                    stretchTriggerOffset: 0.1,
                    title: Opacity(
                      opacity: _appBarOpacity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie_name,
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            movie_details,
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
                      background: Container(
                        height: size.safeWidth * (9 / 16),
                        width: size.safeWidth,
                        color: Colors.black,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (_isPlaying)
                              YoutubePlayer(controller: _controller)
                            else
                              Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Thumbnail image
                                  Image.network(
                                    "https://img.youtube.com/vi/${getYoutubeVideoId(you_tu_url)}/hqdefault.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                  // Custom play button
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => _isPlaying = true);
                                      _controller.loadVideoById(
                                        videoId: videoId,
                                        startSeconds: 0,
                                      );
                                    },
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      size: 60,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AnimatedOpacity(
                      opacity: 1 - _appBarOpacity,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie_name,
                              style: TextStyle(
                                fontFamily: 'Regular',

                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              movie_details,
                              style: TextStyle(
                                fontFamily: 'Regular',

                                fontSize: 15,
                                color: Colors.black.withAlpha(190),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// 🔻 Sticky Tab Row
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
                            // padding: EdgeInsets.all(size.safeWidth * 0.02),
                            // tabs: [
                            //   concertElevatedButton('About', section1Key),
                            //   concertElevatedButton('Artist', section2Key),
                            //   concertElevatedButton('Gallery', section3Key),
                            //   concertElevatedButton('Venue', section4Key),
                            // ]
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
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),

                            child: Column(
                              children: [
                                Text(
                                  "About",
                                  key: section1Key,
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  about_content,
                                  style: TextStyle(fontFamily: 'Regular'),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ratings",
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildStarRating(3.7),
                                    SizedBox(width: 20),
                                    Text(
                                      "3.7",
                                      style: TextStyle(fontFamily: 'Regular'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Cast",
                              key: section2Key,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(
                          //     children: List.generate(col_lis.length, (ind) {
                          //       return Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Column(
                          //           children: [
                          //             CircleAvatar(
                          //               radius: (size.safeWidth * 0.15) - 0.3,
                          //               backgroundColor: col_lis[ind],
                          //             ),
                          //             Text(
                          //               "Name ${ind + 1}",
                          //               style: TextStyle(fontFamily: 'Regular'),
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     }),
                          //   ),
                          // ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: size.safeWidth * 0.02),
                                Row(
                                  children: List.generate(colors.length, (ind) {
                                    return GestureDetector(
                                      onTap: () => Get.to(Artistpage()),
                                      child: Column(
                                        spacing: 5.0,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            height: size.safeWidth * 0.3,
                                            width: size.safeWidth * 0.3,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                color: colors[ind],
                                              ),
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
                                SizedBox(width: size.safeWidth * 0.02),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Videos",
                              key: section3Key,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Column(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: size.safeWidth * (9 / 16) + 70,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                ),
                                items: List.generate(col_lis.length, (index) {
                                  return Column(
                                    children: [
                                      Container(
                                        height: size.safeWidth * (9 / 16),
                                        width: size.safeWidth * 0.9,
                                        color: col_lis[index],
                                        alignment: Alignment.center,
                                        // child: youtubePlayer(wid),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "#${index + 1} Video Tags",
                                        style: TextStyle(fontFamily: 'Regular'),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(col_lis.length, (
                                  index,
                                ) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    width: _currentIndex == index ? 20 : 6,
                                    height: _currentIndex == index ? 8 : 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          _currentIndex == index
                                              ? Colors.black
                                              : Colors.grey.shade400,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Posters",
                              key: section4Key,
                              style: TextStyle(
                                fontFamily: 'Regular',

                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(10),
                            children: List.generate(col_lis.length, (ind) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: col_lis[ind],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                              );
                            }),
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
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
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.white,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Expected Release Date"),
                        Text(
                          "Date",
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          //   TicPin Button
                          //   TicPin Button
                        ),
                      ],
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
