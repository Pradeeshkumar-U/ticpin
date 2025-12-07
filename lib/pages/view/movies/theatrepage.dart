import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/shapes/tabbar.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/movies/theatrebuilder.dart';

class Theatrepage extends StatefulWidget {
  const Theatrepage({super.key});

  @override
  State<Theatrepage> createState() => _TheatrepageState();
}

class _TheatrepageState extends State<Theatrepage>
    with SingleTickerProviderStateMixin {
  Sizes size = Sizes();
  bool isSelected = false;
  bool isGlowing = false;
  late TabController _tabController;
  int tabIndex = 0;
  double _titleOpacity = 1.0;

  final tabs = [
    ['11 Aug', 'Sun'],
    ['12 Aug', 'Mon'],
    ['13 Aug', 'Tue'],
    ['14 Aug', 'Wed'],
    ['15 Aug', 'Thu'],
    ['16 Aug', 'Fri'],
    ['17 Aug', 'Sat'],
    ['18 Aug', 'Sun'],
  ];

  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    double fadeStart = 0; // Adjust this value to control when fading starts
    double fadeEnd = 5; // how many pixels of scroll before it's fully faded
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

  static Tab defaultTab(String name, String details, bool isSelected) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: Sizes().width * 0.033,
              color: blackColor,
              fontFamily: 'Medium',
            ),
          ),
          Text(
            details,
            style: TextStyle(
              fontSize: Sizes().width * 0.031,
              color: blackColor,
              fontFamily: 'Medium',
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
    return (_scrollOffset / maxScroll).clamp(0.0, 1.0);
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
      child: Material(
        surfaceTintColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height:
                  _fadeValue() < 0.3
                      ? size.safeHeight * 0.22 * (1 - _fadeValue())
                      : size.safeHeight * 0.165,
              // color: whiteColor,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [gradient1, gradient2],
                ),
              ),
              child: AppBar(
                // actions: [
                //   Icon(Icons.search, color: whiteColor),
                //   SizedBox(width: size.safeWidth * 0.035),
                // ],
                // leading: GestureDetector(
                //   onTap: () => Get.back(),
                //   child: Icon(Icons.arrow_back, color: whiteColor),
                // ),
                leading: SizedBox.shrink(),
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.only(top: size.safeWidth * 0.18),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    return false;
                  },
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (
                      BuildContext context,
                      bool innerBoxIsScrolled,
                    ) {
                      return <Widget>[
                        // SliverPersistentHeader(delegate: AppBarDelegate),
                        SliverAppBar(
                          elevation: 0,
                          forceElevated: innerBoxIsScrolled,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,

                          // expandedHeight: size.safeHeight * 0.04,
                          toolbarHeight: size.safeHeight * 0.05,
                          excludeHeaderSemantics: true,
                          leadingWidth: 0,
                          floating: true,
                          pinned: false,
                          snap: false,

                          flexibleSpace: Padding(
                            padding: EdgeInsets.only(
                              top: size.safeWidth * 0.04,
                            ),
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
                                          right: size.safeWidth * 0.023,
                                        ),
                                        child: CircleAvatar(
                                          radius: size.safeWidth * 0.07,
                                          backgroundColor: Colors.white70,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Theatre name',
                                            style: TextStyle(
                                              fontSize: size.safeWidth * 0.035,
                                              fontFamily: 'Medium',
                                              color: Colors.white.withAlpha(
                                                230,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Details',
                                                style: TextStyle(
                                                  fontSize:
                                                      size.safeWidth * 0.027,
                                                  fontFamily: 'Regular',
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: size.safeWidth * 0.05,
                                        ),
                                        child: Container(
                                          height: size.safeWidth * 0.07,
                                          width: size.safeWidth * 0.07,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              11,
                                            ),
                                          ),
                                          child: Center(
                                            child: StatefulBuilder(
                                              builder: (context, set) {
                                                glowOff() => Future.delayed(
                                                  const Duration(
                                                    milliseconds: 700,
                                                  ),
                                                  () {
                                                    if (context.mounted)
                                                      set(
                                                        () => isGlowing = false,
                                                      );
                                                  },
                                                );

                                                return InkWell(
                                                  splashFactory:
                                                      NoSplash.splashFactory,
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
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                    ),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        AnimatedOpacity(
                                                          opacity:
                                                              isGlowing ? 1 : 0,
                                                          duration:
                                                              const Duration(
                                                                milliseconds:
                                                                    300,
                                                              ),
                                                          child: Icon(
                                                            Icons
                                                                .local_fire_department_sharp,
                                                            size:
                                                                size.safeWidth *
                                                                    0.06 +
                                                                3,
                                                            color: Colors
                                                                .orangeAccent
                                                                .withOpacity(
                                                                  0.5,
                                                                ),
                                                            shadows: [
                                                              Shadow(
                                                                color: Colors
                                                                    .orangeAccent
                                                                    .withOpacity(
                                                                      0.8,
                                                                    ),
                                                                blurRadius: 25,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        isSelected
                                                            ? ShaderMask(
                                                              shaderCallback:
                                                                  (
                                                                    r,
                                                                  ) => const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                        0xFFFFBF00,
                                                                      ),
                                                                      Color(
                                                                        0xFFFF0000,
                                                                      ),
                                                                    ],
                                                                    begin:
                                                                        Alignment
                                                                            .topCenter,
                                                                    end:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                  ).createShader(
                                                                    r,
                                                                  ),
                                                              child: Icon(
                                                                Icons
                                                                    .local_fire_department_sharp,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                size:
                                                                    size.safeWidth *
                                                                    0.06,
                                                              ),
                                                            )
                                                            : Icon(
                                                              Icons
                                                                  .local_fire_department_outlined,
                                                              color: blackColor
                                                                  .withAlpha(
                                                                    200,
                                                                  ),
                                                              size:
                                                                  size.safeWidth *
                                                                  0.06,
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
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
                          delegate: TheatreTabBarDelegate(
                            ButtonsTabBar(
                              controller: _tabController,
                              unselectedBackgroundColor: whiteColor,
                              unselectedBorderColor: Colors.black54,
                              backgroundColor: Color.fromARGB(
                                255,
                                193,
                                173,
                                255,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                // horizontal: size.safeWidth * 0.01,
                              ),
                              contentCenter: true,
                              borderColor: Color.fromARGB(255, 193, 173, 255),
                              onTap: (index) {
                                setState(() {
                                  tabIndex = _tabController.index;
                                });
                              },

                              width: size.safeWidth * 0.25,
                              radius: 15,
                              height: size.safeWidth * 0.17,

                              // physics: NeverScrollableScrollPhysics(),
                              buttonMargin: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                              splashColor: Colors.transparent,
                              duration: 0,

                              tabs: List.generate(tabs.length, (index) {
                                return Tab(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.0,
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
                      children: List.generate(tabs.length, (index) {
                        return TheatreBuilder(theatre: tabs[index]);
                      }),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: kToolbarHeight,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: size.safeWidth * 0.045),
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white70,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.arrow_back, color: blackColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: size.safeWidth * 0.045),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white70,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.search, color: blackColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
