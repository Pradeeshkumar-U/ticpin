import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/dining/billpaypage.dart';
import 'package:ticpin/pages/view/sports/snacksbar.dart';

class Turfpage extends StatefulWidget {
  const Turfpage({super.key});

  @override
  State<Turfpage> createState() => _TurfpageState();
}

class _TurfpageState extends State<Turfpage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;
  late TabController _tabController;
  List<SnackItem> snacks = [
    SnackItem(name: "Lays", det: "Red lays with more quantity", price: 20),
    SnackItem(name: "Coke", det: "Chilled soft drink", price: 100),
    SnackItem(name: "Cookies", det: "Chocolate chip cookies", price: 50),
  ];

  // NOTE: we accept the sheetSetState callback here so we can rebuild the modal.
  Widget snacksPart(
    SnackItem snack,
    int ind,
    double fs,
    Sizes siz,
    void Function(void Function()) sheetSetState,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: siz.safeHeight * 0.008),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
          borderRadius: BorderRadius.circular(fs),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: siz.safeWidth * 0.03,
                vertical: siz.safeHeight * 0.015,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: siz.safeWidth * 0.2,
                    width: siz.safeWidth * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(fs * 0.8),
                    ),
                  ),
                  SizedBox(width: siz.safeWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snack.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: fs * 0.9,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          snack.det,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: fs * 0.8,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: gradient2.withAlpha(40),
                      borderRadius: BorderRadius.circular(fs),
                      border: Border.all(color: gradient2),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: siz.safeWidth * 0.02,
                      vertical: siz.safeHeight * 0.005,
                    ),
                    child: Text(
                      "₹${snack.totalPrice}",
                      style: TextStyle(
                        color: gradient2,
                        fontSize: fs * 0.85,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: siz.safeWidth * 0.04,
                vertical: siz.safeHeight * 0.01,
              ),
              child: Row(
                children: [
                  Text(
                    "Quantity : ${snack.quan}",
                    style: TextStyle(
                      fontSize: fs * 0.85,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      sheetSetState(() {
                        snack.quan += 1;
                      });
                      setState(() {});
                    },
                    icon: CircleAvatar(
                      radius: fs * 0.9,
                      backgroundColor: gradient1,
                      child: Text(
                        "+",
                        style: TextStyle(fontSize: fs, color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sheetSetState(() {
                        if (snack.quan > 0) snack.quan -= 1;
                      });
                      setState(() {});
                    },
                    icon: CircleAvatar(
                      radius: fs * 0.9,
                      backgroundColor: gradient1,
                      child: Text(
                        "-",
                        style: TextStyle(fontSize: fs, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void snackspage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final siz = Sizes();
            final fs = siz.safeWidth * 0.05;

            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B85FF), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.62],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              height: siz.safeHeight * 0.8,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: fs),
                      Text(
                        "Snacks",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fs * 1.1,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: fs,
                          backgroundColor: Colors.white54,
                          child: Icon(Icons.close, size: fs),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: siz.safeWidth,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(fs * 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snacks.length,
                      itemBuilder: (context, ind) {
                        return snacksPart(
                          snacks[ind],
                          ind,
                          fs,
                          siz,
                          setSheetState,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String name = "Name",
      details = "Details",
          // time = 'opens on time',
          about_content =
          "Content\nContent\nContent\nContent";
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
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        } // Update state when tab changes
      });
    _scrollController.addListener(() {
      Sizes size = Sizes();

      double offset = _scrollController.offset;

      // Adjust this value depending on when you want the title to fade in
      double fadeStart = size.safeHeight * 0.1;
      double fadeEnd = size.safeHeight * 0.2;

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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: Sizes().width * 0.031,
                color: blackColor,
                fontFamily: 'Medium',
              ),
            ),
            Text(
              details,
              style: TextStyle(
                fontSize: Sizes().width * 0.03,
                color: blackColor,
                fontFamily: 'Medium',
              ),
            ),
          ],
        ),
      ),
    );
  }

  int tabIndex = 0;

  Sizes size = Sizes();

  bool isGlowing = false;
  bool isSelected = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
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
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
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
                      size.safeWidth * 0.6 - MediaQuery.of(context).padding.top,
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
                          name,
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          details,
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
                      // height: size.safeWidth * 0.5,
                      // width: size.safeWidth * 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [gradient1, gradient2],
                        ),
                      ), // child: Stack(
                      //   fit: StackFit.expand,
                      //   children: [
                      //     if (_isPlaying)
                      //       YoutubePlayer(controller: _controller)
                      //     else
                      //       Stack(
                      //         fit: StackFit.expand,
                      //         children: [
                      //           // Thumbnail image
                      //           Image.network(
                      //             "https://img.youtube.com/vi/${getYoutubeVideoId(you_tu_url)}/hqdefault.jpg",
                      //             fit: BoxFit.cover,
                      //           ),
                      //           // Custom play button
                      //           GestureDetector(
                      //             onTap: () {
                      //               setState(() => _isPlaying = true);
                      //               _controller.loadVideoById(
                      //                 videoId: videoId,
                      //                 startSeconds: 0,
                      //               );
                      //             },
                      //             child: Icon(
                      //               Icons.play_circle_fill,
                      //               size: 60,
                      //               color: Colors.white70,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //   ],
                      // ),
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
                          SizedBox(height: size.safeWidth * 0.05),
                          Text(
                            name,
                            style: TextStyle(
                              fontFamily: 'Regular',

                              fontSize: size.safeWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    details,
                                    style: TextStyle(
                                      fontFamily: 'Regular',

                                      fontSize: size.safeWidth * 0.035,
                                      color: Colors.black.withAlpha(190),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: Container(
                              //     margin: EdgeInsets.symmetric(
                              //       horizontal: 15,
                              //       vertical: 8,
                              //     ),
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: 15,
                              //       vertical: 8,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       color: Colors.black.withAlpha(40),
                              //       borderRadius: BorderRadius.circular(13),
                              //     ),
                              //     child: Text(
                              //       "Call Now",
                              //       style: TextStyle(
                              //         fontFamily: 'Regular',
                              //         fontWeight: FontWeight.w600,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: size.safeWidth * 0.01),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [

                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 🔻 Sticky Tab Row
                // SliverPersistentHeader(
                //   pinned: true,
                //   delegate: _StickyTabBarDelegate(
                //     child: Container(
                //       color: Colors.white,
                //       padding: EdgeInsets.symmetric(vertical: 10),
                //       child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(15),
                //         ),
                //         child: TabBar(
                //           controller: _tabController,
                //           dividerHeight: 0,
                //           // padding: EdgeInsets.all(size.safeWidth * 0.02),
                //           // tabs: [
                //           //   concertElevatedButton('About', section1Key),
                //           //   concertElevatedButton('Artist', section2Key),
                //           //   concertElevatedButton('Gallery', section3Key),
                //           //   concertElevatedButton('Venue', section4Key),
                //           // ]
                //           onTap: (value) {},
                //           indicator: BoxDecoration(),
                //           tabs: List.generate(
                //             tabs.length,
                //             (index) => Center(
                //               child: concertElevatedButton(
                //                 tabs[index][0],
                //                 tabs[index][1],
                //                 index,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Amenities",

                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: size.safeWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: size.safeWidth * 0.05),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 7,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                // mainAxisSpacing: 10,
                                // crossAxisSpacing: 10,
                                childAspectRatio: (1 / 0.4),
                              ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.safeHeight * 0.05,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromARGB(255, 193, 173, 255),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'First-aid',
                                    style: TextStyle(
                                      fontFamily: 'Medium',
                                      // fontSize: size.safeWidth * 0.025,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // SizedBox(height: size.safeWidth * 0.07),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Select Day and Time",

                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.safeWidth * 0.05),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: size.safeWidth * 0.01),
                            SizedBox(
                              // height: size.safeWidth * 0.2,
                              child: ButtonsTabBar(
                                controller: _tabController,
                                unselectedBackgroundColor: Colors.black12,
                                unselectedBorderColor: Colors.transparent,

                                backgroundColor: Color.fromARGB(
                                  255,
                                  193,
                                  173,
                                  255,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: size.safeWidth * 0.01,
                                ),
                                contentCenter: true,
                                borderColor: Colors.black,
                                borderWidth: 1,

                                onTap: (index) {
                                  setState(() {
                                    tabIndex = _tabController.index;
                                  });
                                },

                                width: size.safeWidth * 0.2,
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
                            SizedBox(width: size.safeWidth * 0.01),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 7,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                // mainAxisSpacing: 10,
                                // crossAxisSpacing: 10,
                                childAspectRatio: (1 / 0.6),
                              ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.safeHeight * 0.1,

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black45,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black12,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '11:22 AM',
                                          style: TextStyle(
                                            fontFamily: 'Medium',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          '02:00 PM',
                                          style: TextStyle(
                                            fontFamily: 'Medium',
                                            // fontSize: size.safeWidth * 0.025,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: size.safeHeight * 0.15),
                    ],
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
              width: size.safeWidth,
              padding: EdgeInsets.only(top: 10, bottom: 18),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      snackspage();
                    },
                    child: Container(
                      width: size.safeWidth * 0.45,
                      height: size.safeWidth * 0.12,
                      // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      padding: EdgeInsets.symmetric(
                        // horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(60),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: Text(
                          "Proceed to Pay",
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(DiningBillpage());
                    },
                    child: Container(
                      width: size.safeWidth * 0.45,
                      height: size.safeWidth * 0.12,
                      // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      padding: EdgeInsets.symmetric(
                        // horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: Text(
                          "Rs. 10000",
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
    );
  }
}
