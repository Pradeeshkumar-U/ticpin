import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/shapes/tabbar.dart';
import 'package:ticpin/pages/home/place/locationpage.dart';
import 'package:ticpin/pages/home/sub%20pages/diningpage.dart';
import 'package:ticpin/pages/home/sub%20pages/sportspage.dart';
import 'package:ticpin/pages/profile/profilepage.dart';
import 'package:ticpin/pages/home/sub%20pages/eventspage.dart';
import 'package:ticpin/pages/home/sub%20pages/youpage.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/services/controllers/location_controller.dart';
import 'package:ticpin/services/qrcode.dart';

// ignore: must_be_immutable
class Homepage extends StatefulWidget {
  Homepage({super.key, this.fromLoc, this.address});
  String? fromLoc;
  String? address;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  final eventController = Get.find<EventController>();
  final locationController = Get.find<LocationController>();

  double? lat;
  double? lng;

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, cannot request.',
      );
    }
    locationController.fetchDeviceLocation();
  }

  Sizes size = Sizes();
  late TabController _tabController;
  int tabIndex = 0;
  double _titleOpacity = 1.0;

  final tabs = [
    ['FOR YOU', 'assets/images/icons/magic stick.svg'],
    ['DINING', 'assets/images/icons/dining.svg'],
    ['EVENTS', 'assets/images/icons/event.svg'],
    // ['MOVIES', 'assets/images/icons/movies.svg'],
    ['SPORTS', 'assets/images/icons/sports.svg'],
  ];

  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    double fadeStart = 0; // Adjust this value to control when fading starts
    double fadeEnd = 10; // how many pixels of scroll before it's fully faded
    double offset = _scrollController.offset;

    double opacity = 1.0 - ((offset - fadeStart) / (fadeEnd - fadeStart));
    if (mounted) {
      setState(() {
        _titleOpacity = opacity.clamp(0.0, 1.0);
      });
    }
    setState(() {
      _scrollOffset = offset;
    });
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

  static Tab defaultTab(String name, String icon, bool isSelected) {
    return Tab(
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: Sizes().width * 0.015),
            child: SvgPicture.asset(
              // ignore: deprecated_member_use
              color: isSelected ? whiteColor : Colors.black45,
              icon,
              width: Sizes().width * 0.06,
              height: Sizes().width * 0.06,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: Sizes().width * 0.03,
              color: isSelected ? whiteColor : Colors.black45,
              fontFamily: 'Semibold',
            ),
          ),
        ],
      ),
    );
  }

  double _scrollOffset = 1;
  @override
  void initState() {
    super.initState();
    _determinePosition();
    _tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        } // Update state when tab changes
      });
    _scrollController.addListener(_onScroll);
  }

  double _fadeValue() {
    const maxScroll = 200.0;
    return (_scrollOffset / maxScroll).clamp(0.01, 1.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Container(
        color: whiteColor,
        child: Stack(
          children: [
            // Opacity(
            //   opacity: _fadeValue() < 0.4 ? 1 - _fadeValue() : 0,
            //   child: Container(
            //     height:
            //         _fadeValue() < 0.4
            //             ? size.safeHeight * 0.13 * (1 - _fadeValue())
            //             : size.safeHeight * 0.00,
            //     decoration: BoxDecoration(
            //       color: gradient1,
            //       gradient: LinearGradient(
            //         begin: Alignment.centerLeft,
            //         end: Alignment.centerRight,
            //         colors: [gradient1, gradient2],
            //       ),
            //       borderRadius: BorderRadius.circular(20),
            //       border: Border.all(
            //         // color: Colors.white.withOpacity(0.3),
            //         width: 1.5,
            //       ),
            //     ),
            //     // color: whiteColor,
            //     // decoration: BoxDecoration(
            //     //
            //     // ),
            //   ),
            // ),
            Container(
              width: double.infinity,
              height: kToolbarHeight + size.safeWidth * 0.12,

              // height:
              //     _fadeValue() < 0.4
              //         ? size.safeHeight * 0.13 * (1 - _fadeValue())
              //         : size.safeHeight * 0.07,
              decoration: BoxDecoration(
                // color: Colors.white.withAlpha(
                //   50,
                // ),
                // color: gradient1,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [gradient1, gradient2],
                ), // semi-transparent glass color
                // borderRadius: BorderRadius.circular(20),
                // border: Border.all(
                //   // color: Colors.white.withOpacity(0.3),
                //   width: 1.5,
                // ),
              ),
              // color: whiteColor,
              // decoration: BoxDecoration(
              //
              // ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.safeWidth * 0.08),
              child: Scaffold(
                // extendBodyBehindAppBar: false,
                backgroundColor: Colors.transparent,
                body: Obx(() {
                  bool isLoading =
                      locationController.city.value.isEmpty ||
                      eventController.loading.value;

                  if (isLoading) {
                    return Container(
                      color: whiteColor,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: size.safeHeight * 0.19,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [gradient1, gradient2],
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: size.safeWidth * 0.08,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.safeWidth * 0.06,
                                          ),
                                          child: LoadingShimmer(
                                            width: size.safeWidth * 0.065,
                                            height: size.safeWidth * 0.07,
                                            isCircle: true,
                                            baseColor: whiteColor.withAlpha(50),
                                            highColor: whiteColor.withAlpha(30),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            LoadingShimmer(
                                              width: size.safeWidth * 0.4,
                                              height: size.safeWidth * 0.04,
                                              isCircle: false,
                                              baseColor: whiteColor.withAlpha(
                                                50,
                                              ),
                                              highColor: whiteColor.withAlpha(
                                                30,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            LoadingShimmer(
                                              width: size.safeWidth * 0.3,
                                              height: size.safeWidth * 0.04,
                                              isCircle: false,
                                              baseColor: whiteColor.withAlpha(
                                                50,
                                              ),
                                              highColor: whiteColor.withAlpha(
                                                30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: size.safeWidth * 0.04,
                                      ),
                                      child: LoadingShimmer(
                                        width: size.safeWidth * 0.88,
                                        height: size.safeWidth * 0.1,
                                        isCircle: false,
                                        radius: 10,
                                        baseColor: whiteColor.withAlpha(50),
                                        highColor: whiteColor.withAlpha(30),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.safeHeight * 0.19,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      LoadingShimmer(
                                        width: size.safeWidth * 0.25,
                                        height: size.safeWidth * 0.15,
                                        isCircle: false,
                                      ),
                                      LoadingShimmer(
                                        width: size.safeWidth * 0.25,
                                        height: size.safeWidth * 0.15,
                                        isCircle: false,
                                      ),
                                      LoadingShimmer(
                                        width: size.safeWidth * 0.25,
                                        height: size.safeWidth * 0.15,
                                        isCircle: false,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  LoadingShimmer(
                                    width: size.safeWidth * 0.6,
                                    height: size.safeWidth * 0.1,
                                    isCircle: false,
                                  ),
                                  SizedBox(height: 20),
                                  LoadingShimmer(
                                    width: size.safeWidth * 0.8,
                                    height: size.safeHeight * 0.55,
                                    isCircle: false,
                                  ),
                                  SizedBox(height: 20),
                                  LoadingShimmer(
                                    width: size.safeWidth * 0.6,
                                    height: size.safeWidth * 0.1,
                                    isCircle: false,
                                  ),
                                  SizedBox(height: 20),
                                  LoadingShimmer(
                                    width: size.safeWidth * 0.8,
                                    height: size.safeHeight * 0.3,
                                    isCircle: false,
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).padding.bottom +
                                        20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      return false;
                    },
                    child: NestedScrollView(
                      //   padding: EdgeInsets.only(top: size.safeWidth * 0.08),
                      controller: _scrollController,
                      headerSliverBuilder: (
                        BuildContext context,
                        bool innerBoxIsScrolled,
                      ) {
                        return <Widget>[
                          SliverAppBar(
                            elevation: 0,
                            forceElevated: innerBoxIsScrolled,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,

                            // expandedHeight: size.safeHeight * 0.04,
                            toolbarHeight: size.safeHeight * 0.027,
                            excludeHeaderSemantics: true,
                            leadingWidth: 0,
                            floating: true,
                            pinned: false,
                            snap: false,

                            flexibleSpace: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Opacity(
                                opacity: _titleOpacity, // Your fade logic
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: size.safeWidth * 0.04,
                                            right: size.safeWidth * 0.032,
                                          ),
                                          child: GestureDetector(
                                            onTap: () => Get.to(Profile()),
                                            child: CircleAvatar(
                                              radius: size.safeWidth * 0.055,
                                              backgroundColor: Colors.white30,
                                              child: CircleAvatar(
                                                radius: size.safeWidth * 0.04,
                                                backgroundColor: Colors.white70,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(),
                                            Text(
                                              'Yuvan',
                                              style: TextStyle(
                                                fontSize:
                                                    size.safeWidth * 0.039,
                                                fontFamily: 'Medium',
                                                color: Colors.white.withAlpha(
                                                  230,
                                                ),
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () async {
                                                final result = await Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration:
                                                        Duration(
                                                          milliseconds: 400,
                                                        ),
                                                    pageBuilder:
                                                        (
                                                          context,
                                                          animation,
                                                          secondaryAnimation,
                                                        ) => Locationpage(
                                                          position: Position(
                                                            longitude:
                                                                locationController
                                                                    .userLng!,
                                                            latitude:
                                                                locationController
                                                                    .userLat!,
                                                            timestamp:
                                                                DateTime.now(),
                                                            accuracy: 0,
                                                            altitude: 0,
                                                            altitudeAccuracy: 0,
                                                            heading: 0,
                                                            headingAccuracy: 0,
                                                            speed: 0,
                                                            speedAccuracy: 0,
                                                          ),
                                                        ),
                                                    transitionsBuilder: (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child,
                                                    ) {
                                                      const begin = Offset(
                                                        0.0,
                                                        1.0,
                                                      ); // Start from bottom
                                                      const end =
                                                          Offset
                                                              .zero; // End at normal position
                                                      const curve = Curves.ease;

                                                      var tween = Tween(
                                                        begin: begin,
                                                        end: end,
                                                      ).chain(
                                                        CurveTween(
                                                          curve: curve,
                                                        ),
                                                      );
                                                      return SlideTransition(
                                                        position: animation
                                                            .drive(tween),
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );

                                                if (result == true) {
                                                  setState(() {
                                                    widget.fromLoc = null;
                                                    _determinePosition();
                                                  });
                                                }
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right:
                                                          size.safeWidth * 0.01,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'assets/images/icons/location.svg',
                                                      width:
                                                          size.safeWidth *
                                                          0.035,
                                                      height:
                                                          size.safeWidth *
                                                          0.035,
                                                      // ignore: deprecated_member_use
                                                      color: Colors.white
                                                          .withAlpha(230),
                                                    ),
                                                  ),
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.safeWidth * 0.4,
                                                      minWidth: 0,
                                                    ),
                                                    child:
                                                        widget.fromLoc == null
                                                            ? Obx(
                                                              () => Text(
                                                                '${locationController.city}, ${locationController.state}',

                                                                style: TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize:
                                                                      size.safeWidth *
                                                                      0.03,
                                                                  fontFamily:
                                                                      'Regular',
                                                                  color:
                                                                      Colors
                                                                          .white70,
                                                                ),
                                                              ),
                                                            )
                                                            : Text(
                                                              widget.fromLoc!,
                                                              style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize:
                                                                    size.safeWidth *
                                                                    0.03,
                                                                fontFamily:
                                                                    'Regular',
                                                                color:
                                                                    Colors
                                                                        .white70,
                                                              ),
                                                            ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              size.safeWidth *
                                                              0.01,
                                                        ),
                                                    child: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      size:
                                                          size.safeWidth * 0.05,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(),
                                            SizedBox(),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: size.safeWidth * 0.04,
                                          ),
                                          child: GestureDetector(
                                            onTap: () => Get.to(QRpage()),
                                            child: SvgPicture.asset(
                                              'assets/images/icons/qr code.svg',
                                              width: size.safeWidth * 0.07,
                                              height: size.safeWidth * 0.07,
                                              // ignore: deprecated_member_use
                                              color: Colors.white.withAlpha(
                                                230,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //     right: size.safeWidth * 0.04,
                                        //   ),
                                        //   child: GestureDetector(
                                        //     onTap: () => Get.to(Profile()),
                                        //     child: CircleAvatar(
                                        //       radius: size.safeWidth * 0.05,
                                        //       backgroundColor: Colors.black26,
                                        //       child: CircleAvatar(
                                        //         radius: size.safeWidth * 0.035,
                                        //         backgroundColor: blackColor,
                                        //         child: Icon(
                                        //           Icons.person,
                                        //           color: Colors.white54,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: TabBarDelegate(
                              ButtonsTabBar(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                unselectedBackgroundColor: whiteColor,
                                unselectedBorderColor: Colors.transparent,
                                backgroundColor: gradient1,
                                borderWidth: 1.5,
                                contentPadding: EdgeInsets.symmetric(
                                  // horizontal: size.safeWidth * 0.01,
                                ),
                                contentCenter: true,
                                borderColor: gradient1,
                                onTap: (index) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    tabIndex = _tabController.index;
                                  });
                                },

                                width: size.safeWidth * 0.28,
                                radius: 15,
                                height: size.safeWidth * 0.115,
                                // physics: NeverScrollableScrollPhysics(),
                                buttonMargin: EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                splashColor: Colors.transparent,

                                tabs: List.generate(tabs.length, (index) {
                                  return Tab(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: defaultTab(
                                        tabs[index][0],
                                        tabs[index][1],
                                        _tabController.index == index,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          ForYoupage(),
                          Diningpage(),
                          Eventspage(),
                          // Moviespage(),
                          Sportspage(),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Container(
              width: double.infinity,
              height: size.safeWidth * 0.08,

              // height:
              //     _fadeValue() < 0.4
              //         ? size.safeHeight * 0.13 * (1 - _fadeValue())
              //         : size.safeHeight * 0.07,
              decoration: BoxDecoration(
                // color: Colors.white.withAlpha(
                //   50,
                // ),
                // color: gradient1,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [gradient1, gradient2],
                ), // semi-transparent glass color
                // borderRadius: BorderRadius.circular(20),
                // border: Border.all(
                //   // color: Colors.white.withOpacity(0.3),
                //   width: 1.5,
                // ),
              ),
              // color: whiteColor,
              // decoration: BoxDecoration(
              //
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
// lib/ui/home_page.dart
// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/shapes/tabbar.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/pages/home/place/locationpage.dart';
// import 'package:ticpin/pages/home/sub%20pages/diningpage.dart';
// import 'package:ticpin/pages/home/sub%20pages/eventspage.dart';
// import 'package:ticpin/pages/home/sub%20pages/sportspage.dart';
// import 'package:ticpin/pages/home/sub%20pages/youpage.dart';
// import 'package:ticpin/pages/profile/profilepage.dart';
// import 'package:ticpin/services/controllers/event_controller.dart';
// import 'package:ticpin/services/qrcode.dart';

// class Homepage extends StatefulWidget {
//   Homepage({super.key, this.fromLoc, this.address});
//   String? fromLoc;
//   String? address;

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage>
//     with SingleTickerProviderStateMixin {
//   final eventController = Get.find<EventController>();
//   Sizes size = Sizes();
//   late TabController _tabController;
//   int tabIndex = 0;
//   double _titleOpacity = 1.0;
//   double _scrollOffset = 0.0;

//   final tabs = [
//     ['FOR YOU', 'assets/images/icons/magic stick.svg'],
//     ['DINING', 'assets/images/icons/dining.svg'],
//     // ['EVENTS', 'assets/images/icons/event.svg'],
//     ['SPORTS', 'assets/images/icons/sports.svg'],
//   ];

//   ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: tabs.length, vsync: this)
//       ..addListener(() {
//         if (mounted) setState(() {});
//       });
//     _scrollController.addListener(_onScroll);
//     eventController.fetchDeviceLocation();
//   }

//   void _onScroll() {
//     double fadeStart = 0;
//     double fadeEnd = 10;
//     double offset = _scrollController.offset;
//     double opacity = 1.0 - ((offset - fadeStart) / (fadeEnd - fadeStart));
//     if (mounted)
//       setState(() {
//         _titleOpacity = opacity.clamp(0.0, 1.0);
//         _scrollOffset = offset;
//       });
//   }

//   double _fadeValue() {
//     const maxScroll = 200.0;
//     return (_scrollOffset / maxScroll).clamp(0.01, 1.0);
//   }

//   Widget buildTabItem(int index) {
//     final isSelected = _tabController.index == index;
//     return InkWell(
//       onTap: () {
//         HapticFeedback.lightImpact();
//         _tabController.animateTo(index);
//       },
//       child: AnimatedContainer(
//         width: size.safeWidth * 0.19,
//         curve: Curves.bounceIn,
//         duration: Duration(milliseconds: 400),
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

//   static Tab defaultTab(String name, String icon, bool isSelected) {
//     return Tab(
//       child: Row(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(right: Sizes().width * 0.015),
//             child: SvgPicture.asset(
//               icon,
//               width: Sizes().width * 0.06,
//               height: Sizes().width * 0.06,
//               color: isSelected ? whiteColor : Colors.black45,
//             ),
//           ),
//           Text(
//             name,
//             style: TextStyle(
//               fontSize: Sizes().width * 0.025,
//               fontFamily: 'Semibold',
//               color: isSelected ? whiteColor : Colors.black45,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: tabs.length,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Stack(
//             children: [
//               Container(
//                 height:
//                     _fadeValue() < 0.4
//                         ? size.safeHeight * 0.13 * (1 - _fadeValue())
//                         : size.safeHeight * 0.05,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                     colors: [gradient1, gradient2],
//                   ),
//                 ),
//               ),
//               NestedScrollView(
//                 controller: _scrollController,
//                 headerSliverBuilder: (context, innerBoxScrolled) {
//                   return [
//                     SliverAppBar(
//                       elevation: 0,
//                       backgroundColor: Colors.transparent,
//                       pinned: false,
//                       floating: true,
//                       snap: false,
//                       toolbarHeight: size.safeHeight * 0.06,
//                       flexibleSpace: Padding(
//                         padding: EdgeInsets.only(top: 4),
//                         child: Opacity(
//                           opacity: _titleOpacity,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                       left: size.safeWidth * 0.04,
//                                       right: size.safeWidth * 0.032,
//                                     ),
//                                     child: GestureDetector(
//                                       onTap: () => Get.to(Profile()),
//                                       child: CircleAvatar(
//                                         radius: size.safeWidth * 0.055,
//                                         backgroundColor: Colors.white30,
//                                         child: CircleAvatar(
//                                           radius: size.safeWidth * 0.04,
//                                           backgroundColor: Colors.white70,
//                                           child: Icon(
//                                             Icons.person,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () async {
//                                       if (eventController.userLat != null) {
//                                         final result = await Get.to(
//                                           () => Locationpage(
//                                             position: Position(
//                                               longitude:
//                                                   eventController.userLng!,
//                                               latitude:
//                                                   eventController.userLat!,
//                                               timestamp: DateTime.now(),
//                                               accuracy: 0,
//                                               altitude: 0,
//                                               altitudeAccuracy: 0,
//                                               heading: 0,
//                                               headingAccuracy: 0,
//                                               speed: 0,
//                                               speedAccuracy: 0,
//                                             ),
//                                           ),
//                                         );

//                                         if (result != null &&
//                                             result is String) {
//                                           // Optionally update homepage with selected city
//                                           setState(() {
//                                             widget.fromLoc = result;
//                                           });
//                                         }
//                                       } else {
//                                         // fallback if location not yet fetched
//                                         Get.snackbar(
//                                           "Location not ready",
//                                           "Please wait while we fetch your location.",
//                                         );
//                                       }
//                                     },

//                                     child: Row(
//                                       children: [
//                                         SvgPicture.asset(
//                                           'assets/images/icons/location.svg',
//                                           width: size.safeWidth * 0.035,
//                                           height: size.safeWidth * 0.035,
//                                           color: Colors.white.withAlpha(230),
//                                         ),
//                                         SizedBox(width: size.safeWidth * 0.01),
//                                         ConstrainedBox(
//                                           constraints: BoxConstraints(
//                                             maxWidth: size.safeWidth * 0.4,
//                                           ),
//                                           child: Text(
//                                             widget.fromLoc ?? "Select Location",
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: size.safeWidth * 0.027,
//                                               fontFamily: 'Regular',
//                                               color: Colors.white70,
//                                             ),
//                                           ),
//                                         ),
//                                         Icon(
//                                           Icons.keyboard_arrow_down_sharp,
//                                           size: size.safeWidth * 0.05,
//                                           color: Colors.white70,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               GestureDetector(
//                                 onTap: () => Get.to(QRpage()),
//                                 child: Padding(
//                                   padding: EdgeInsets.only(
//                                     right: size.safeWidth * 0.04,
//                                   ),
//                                   child: SvgPicture.asset(
//                                     'assets/images/icons/qr code.svg',
//                                     width: size.safeWidth * 0.07,
//                                     height: size.safeWidth * 0.07,
//                                     color: Colors.white.withAlpha(230),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SliverPersistentHeader(
//                       pinned: true,
//                       floating: true,
//                       delegate: TabBarDelegate(
//                         ButtonsTabBar(
//                           controller: _tabController,
//                           unselectedBackgroundColor: whiteColor,
//                           unselectedBorderColor: Colors.black45,
//                           backgroundColor: gradient1,
//                           borderWidth: 1.5,
//                           contentCenter: true,
//                           width: size.safeWidth * 0.25,
//                           radius: 15,
//                           height: size.safeWidth * 0.115,
//                           tabs: List.generate(
//                             tabs.length,
//                             (index) => buildTabItem(index),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ];
//                 },
//                 body: TabBarView(
//                   controller: _tabController,
//                   physics: NeverScrollableScrollPhysics(),
//                   children: [
//                     AllEventsPage(),
//                     Diningpage(),
//                     // EventDetailsPage(),
//                     Sportspage(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// Future<void> getCityFromCoords(double lat, double lng) async { // final uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', { // 'latlng': '$lat,$lng', // 'key': placesApiKey, // }); // try { // final response = await http.get(uri); // if (response.statusCode == 200) { // final decoded = json.decode(response.body) as Map<String, dynamic>; // if (decoded['status'] == 'OK') { // final results = decoded['results'] as List<dynamic>; // if (results.isNotEmpty) { // final components = // results[0]['address_components'] as List<dynamic>; // // Try locality first // final locality = components.firstWhere( // (c) => (c['types'] as List).contains('locality'), // orElse: () => {}, // ); // if (locality.isNotEmpty) { // setState(() { // place = locality['long_name']; // }); // } // // Try administrative_area_level_3 next // final adminArea3 = components.firstWhere( // (c) => // (c['types'] as List).contains('administrative_area_level_3'), // orElse: () => {}, // ); // if (adminArea3.isNotEmpty) { // if (place != '') { // setState(() { // secondaryPlace = adminArea3['long_name']; // }); // } else { // setState(() { // place = adminArea3['long_name']; // }); // } // } // // Try administrative_area_level_2 as last resort // final adminArea2 = components.firstWhere( // (c) => // (c['types'] as List).contains('administrative_area_level_2'), // orElse: () => {}, // ); // if (adminArea2.isNotEmpty) { // setState(() { // secondaryPlace = adminArea2['long_name']; // }); // } // final adminArea4 = components.firstWhere( // (c) => // (c['types'] as List).contains('administrative_area_level_1'), // orElse: () => {}, // ); // if (adminArea4.isNotEmpty) { // setState(() { // secondaryPlace = adminArea4['long_name']; // }); // } // } // } // } // } catch (e) { // place = e.toString(); // } // return null; // fallback if city not found // } // double? lat; // double? lng; // Future<void> _determinePosition() async { // bool serviceEnabled; // LocationPermission permission; // // Check if location services are enabled // serviceEnabled = await Geolocator.isLocationServiceEnabled(); // if (!serviceEnabled) { // return Future.error('Location services are disabled.'); // } // // Check permission // permission = await Geolocator.checkPermission(); // if (permission == LocationPermission.denied) { // permission = await Geolocator.requestPermission(); // if (permission == LocationPermission.denied) { // return Future.error('Location permissions are denied.'); // } // } // if (permission == LocationPermission.deniedForever) { // return Future.error( // 'Location permissions are permanently denied, cannot request.', // ); // } // // Get current position // _position = await Geolocator.getCurrentPosition(); // print('The position is ${_position!.latitude},${_position!.longitude}'); // SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); // sharedPreferences.setDouble('lat', _position!.latitude); // sharedPreferences.setDouble('lng', _position!.longitude); // lat = _position!.latitude; // lng = _position!.longitude; // Get.find<LocationController>().updateLocation( // _position!.latitude, // _position!.longitude, // ); // await getCityFromCoords(_position!.latitude, _position!.longitude); // }