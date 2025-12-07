import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/dining/billpaypage.dart';

class Restaurentpage extends StatefulWidget {
  const Restaurentpage({super.key});

  @override
  State<Restaurentpage> createState() => _RestaurentpageState();
}

class _RestaurentpageState extends State<Restaurentpage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  String name = "Dining name",
      details = "Dining details",
      time = 'opens on time',
      about_content = "Content\nContent\nContent\nContent";

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _scrollController.addListener(() {
      Sizes size = Sizes();
      _onScroll().then((sectionkey) {
        setState(() {});
      });
      double offset = _scrollController.offset;

      // Adjust this value depending on when you want the title to fade in
      double fadeStart = size.safeHeight * 0.3;
      double fadeEnd = size.safeHeight * 0.4;

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
        fixedSize: Size.fromWidth(size.safeWidth * 0.23),
        elevation: 0,

        padding: EdgeInsets.all(size.safeWidth * 0.015),
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

  // //
  // Widget buildStarRating(double rating) {
  //   return Row(
  //     children: List.generate(5, (i) {
  //       String emoji;
  //       if (i < rating.floor()) {
  //         emoji = "⭐";
  //       } else if (i < rating && rating - i >= 0.5) {
  //         emoji = "🌟"; // optional: half-star look
  //       } else {
  //         emoji = "☆";
  //       }

  //       final iconWidget =
  //           Platform.isIOS
  //               ? Text(
  //                 emoji,
  //                 style: const TextStyle(fontFamily: 'Regular', fontSize: 24),
  //               )
  //               : Icon(
  //                 i < rating.floor()
  //                     ? Icons.star
  //                     : (i < rating && rating - i >= 0.5)
  //                     ? Icons.star_half
  //                     : Icons.star_border,
  //                 size: 28,
  //                 color: Colors.white,
  //               );

  //       return ShaderMask(
  //         shaderCallback:
  //             (bounds) => const LinearGradient(
  //               colors: [Colors.orange, Colors.red],
  //             ).createShader(bounds),
  //         child: iconWidget,
  //       );
  //     }),
  //   );
  // }

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

  int _seatNumber = 0;

  bool isGlowing = false;
  bool isSelected = false;

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
                        "Select number of seats",
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
                //
                // Right content
                Container(
                  width: size.safeWidth,
                  height: size.safeHeight * 0.3,
                  child: GridView.builder(
                    itemCount: 18,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.safeWidth * 0.15,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: size.safeWidth * 0.07,
                      mainAxisSpacing: size.safeWidth * 0.07,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            _seatNumber = index + 1;
                          });
                        },
                        child: Container(
                          height: size.safeWidth * 0.27,
                          width: size.safeWidth * 0.27,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color:
                                  index + 1 == _seatNumber
                                      ? primaryColor.withAlpha(200)
                                      : blackColor,
                            ),
                            color:
                                index + 1 == _seatNumber
                                    ? primaryColor.withAlpha(60)
                                    : whiteColor,
                          ),
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: size.safeWidth * 0.035,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                //   Buttons
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text(
                    //     "Clear All",
                    //     style: TextStyle(fontFamily: 'Regular'),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        Get.to(DiningBillpage());
                      },
                      child: Container(
                        width: size.safeWidth * 0.9,
                        height: size.safeWidth * 0.13,
                        // padding: EdgeInsets.symmetric(
                        //   horizontal: 30,
                        //   vertical: 10,
                        // ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Proceed to Pay",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              color: Colors.black,
                              fontSize: size.safeWidth * 0.04,
                            ),
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

  //
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
Sizes size = Sizes();
  //
  @override
  Widget build(BuildContext context) {
    final List<List> tabs = [
      ['Menu', section1Key],
      ['Gallery', section2Key],
      ['Reviews', section3Key],
      ['About', section4Key],
    ];

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
                      size.safeWidth - MediaQuery.of(context).padding.top,
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
                      height: size.safeWidth,
                      width: size.safeWidth,
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
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                  SizedBox(height: 8),
                                  Text(
                                    time,
                                    style: TextStyle(
                                      fontFamily: 'Regular',

                                      fontSize: size.safeWidth * 0.035,
                                      color: Colors.black.withAlpha(210),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(40),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Text(
                                    "Call Now",
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
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
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "Menu",
                                    key: section1Key,
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: size.safeWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.safeWidth * 0.05),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(width: size.safeWidth * 0.026),
                                  Row(
                                    children: List.generate(colors.length, (
                                      ind,
                                    ) {
                                      final menu = [
                                        'Food',
                                        'Beverages',
                                        'Bar',
                                        'Snacks',
                                        'Sauce',
                                      ];
                                      return Column(
                                        spacing: 5.0,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: colors[ind],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            height: size.safeWidth * 0.3,
                                            width: size.safeWidth * 0.3,
                                          ),
                                          Text(
                                            menu[ind],
                                            style: TextStyle(
                                              fontSize: Sizes().width * 0.03,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Regular',
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  SizedBox(width: size.safeWidth * 0.026),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.safeWidth * 0.07),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Gallery",
                            key: section2Key,
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
                              SizedBox(width: size.safeWidth * 0.026),
                              Row(
                                children: List.generate(colors.length, (ind) {
                                  return Column(
                                    spacing: 5.0,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colors[ind],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        height: size.safeWidth * 0.3,
                                        width: size.safeWidth * 0.3,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              SizedBox(width: size.safeWidth * 0.026),
                            ],
                          ),
                        ),
                        SizedBox(height: size.safeWidth * 0.07),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Reviews",
                            key: section3Key,
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
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children:
                                      colors
                                          .map(
                                            (i) => Padding(
                                              padding: EdgeInsets.only(
                                                right: 20,
                                              ),
                                              child: Container(
                                                width: size.safeWidth * 0.7,
                                                height: size.safeWidth * 0.55,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(17),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top:
                                                            size.safeWidth *
                                                            0.015,
                                                        left:
                                                            size.safeWidth *
                                                            0.01,
                                                      ),
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                          radius:
                                                              size.safeWidth *
                                                              0.06,
                                                          backgroundColor:
                                                              Colors.black38,
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                              left:
                                                                  size.safeWidth *
                                                                  0.03,
                                                              right:
                                                                  size.safeWidth *
                                                                  0.03,
                                                            ),
                                                        title: Text(
                                                          'Username',

                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Regular',
                                                            fontSize:
                                                                size.safeWidth *
                                                                0.035,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Time',

                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Regular',
                                                            fontSize:
                                                                size.safeWidth *
                                                                0.03,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        trailing: Container(
                                                          width:
                                                              size.safeWidth *
                                                              0.13,
                                                          height:
                                                              size.safeWidth *
                                                              0.06,

                                                          decoration: BoxDecoration(
                                                            color:
                                                                Colors
                                                                    .lightGreenAccent
                                                                    .shade700,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                '2.5',

                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Semibold',
                                                                  fontSize:
                                                                      size.safeWidth *
                                                                      0.028,
                                                                  color:
                                                                      blackColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox.shrink(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal:
                                                                size.safeWidth *
                                                                0.04,
                                                            vertical:
                                                                size.safeWidth *
                                                                0.02,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                size.safeWidth *
                                                                0.62,
                                                            height:
                                                                size.safeWidth *
                                                                0.3,
                                                            child: Text(
                                                              'Hi how are you iam fine lets build something funny start from abcdefghijklmnopqrstuvwxyz 0123456789 what the hill is this comment section currently typing content for ticpin review builder now lets see if it works ahh shit it is not working lets see again now it is working',
                                                              maxLines: 8,

                                                              softWrap: true,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,

                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Semibold',
                                                                fontSize:
                                                                    size.safeWidth *
                                                                    0.03,
                                                                color:
                                                                    blackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.safeWidth * 0.07),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "About",
                            key: section4Key,
                            style: TextStyle(
                              fontFamily: 'Regular',

                              fontSize: size.safeWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: size.safeWidth * 0.05),
                        Column(
                          children: List.generate(15, (i) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'About the Restaurent in bulletins',
                                style: TextStyle(
                                  fontSize: size.safeWidth * 0.035,
                                  fontFamily: 'Regular',
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: size.safeWidth * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Available Facilities",
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
                              SizedBox(width: size.safeWidth * 0.035),
                              Row(
                                children: List.generate(colors.length, (ind) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: size.safeWidth * 0.035,
                                    ),
                                    child: Column(
                                      // spacing: 5.0,
                                      children: [
                                        Text(
                                          "Dinner",
                                          style: TextStyle(
                                            fontFamily: 'Regular',

                                            fontSize: size.safeWidth * 0.033,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Lunch",
                                          style: TextStyle(
                                            fontFamily: 'Regular',

                                            fontSize: size.safeWidth * 0.033,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Delivery",
                                          style: TextStyle(
                                            fontFamily: 'Regular',

                                            fontSize: size.safeWidth * 0.033,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Full bar",
                                          style: TextStyle(
                                            fontFamily: 'Regular',

                                            fontSize: size.safeWidth * 0.033,
                                            // fontWeight: FontWeight.bold,
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
                        SizedBox(height: size.safeWidth * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Similar Restaurents",
                            style: TextStyle(
                              fontFamily: 'Regular',

                              fontSize: size.safeWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: size.safeWidth * 0.05),
                        SizedBox(
                          height: size.safeHeight * 0.3,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: size.safeWidth * 0.045,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: diningColorSlider,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.safeHeight * 0.1),
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
              width: size.safeWidth,
              padding: EdgeInsets.only(top: 10, bottom: 18),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      filter_window(size);
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
                          "Book a Table",
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
                          "Pay Bill",
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
