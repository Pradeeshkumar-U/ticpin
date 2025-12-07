import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/shapes/containers.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/movies/theatrepage.dart';

class TheatresNearMe extends StatefulWidget {
  const TheatresNearMe({super.key});

  @override
  State<TheatresNearMe> createState() => _TheatresNearMeState();
}

class _TheatresNearMeState extends State<TheatresNearMe> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _stickyKey = GlobalKey();
  late int eve_cate_ind;

  double _scrollOffset = 0.0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  double _fadeValue() {
    const maxScroll = 200.0;
    return (_scrollOffset / maxScroll).clamp(0.0, 1.0);
  }

  List<Map<String, dynamic>> filt_but_st = [
    {"value": "Cancellation Available", "tapped": false},
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

  // Sort options (Radio)
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
                // Header
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

                // Tabs + content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left menu
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
                    // Right content
                    Container(
                      width: size.safeWidth * 0.7,
                      color: Colors.black12,
                      // height: size.safeHeight * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Sort by (Radio)
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

                //   Buttons
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

  bool isSelected = false;
  bool isGlowing = false;
  final siz = Sizes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient1.withAlpha(70),
              gradient2.withAlpha(35),
              Colors.white10,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.15, 0.3, 0.45],
          ).withOpacity((1.0 - _fadeValue()) * 0.2),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // AppBar with fade
            SliverAppBar(
              pinned: true,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white.withOpacity(_fadeValue()),
              elevation: _fadeValue() > 0.5 ? 2 : 0,
              iconTheme: IconThemeData(
                color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
                ),
              ),
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _fadeValue(),
                child: Text(
                  'Theatres Near Me',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search_rounded,
                    color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
                  ),
                ),
              ],
            ),

            // Top content
            SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Flexible(
                    //   child: Image.asset(
                    //     ,
                    //     fit: BoxFit.fitHeight,
                    //     width: siz.safeWidth * 0.5,
                    //   ),
                    // ),
                    Opacity(
                      opacity: 1 - _fadeValue(),
                      child: FittedBox(
                        child: Text(
                          'Theatres\nnear me',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.w600,
                            fontSize: siz.safeWidth * 0.08,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 100),
              ]),
            ),

            // Sticky Row
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyRowDelegate(
                minHeight: 79,
                maxHeight: 79,
                child: Container(
                  key: _stickyKey,
                  color: Colors.white.withOpacity(_fadeValue()),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      // Text(
                      //   '${eve_cate_data[eve_cate_ind]["name"]} Events',
                      //   style: TextStyle(
                      //     fontFamily: 'Regular',
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: siz.safeWidth * 0.05,
                      //   ),
                      // ),
                      // const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // spacing: 15,
                        children: [
                          SizedBox(width: siz.safeWidth * 0.04),
                          // SizedBox(width: siz.safeWidth * 0.01),
                          // InkWell(
                          //   onTap: () {
                          //     filter_window(siz);
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //       color: whiteColor,
                          //       borderRadius: BorderRadius.circular(10),
                          //       border: Border.all(color: Colors.black),
                          //     ),
                          //     child: Row(
                          //       spacing: 5,
                          //       children: [
                          //         Icon(Icons.filter_alt),
                          //         Text("Filters"),
                          //         Icon(Icons.keyboard_arrow_down),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          ...List.generate(
                            filt_but_st.length,
                            (ind) => filter_butt(ind),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable List
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TheatresNearMeList(siz, 'Broadway Cinemas', 'IMAX'),
                  TheatresNearMeList(siz, 'Ganga Theatre', 'A/C, non A/C'),
                  SizedBox(height: siz.safeHeight * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column TheatresNearMeList(Sizes siz, String theatre, String detail) {
    return Column(
      // padding: EdgeInsets.only(bottom: 15.0),
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: siz.safeWidth * 0.06,
            // bottom: siz.safeWidth * 0.05,
          ),
          child: ListTile(
            onTap: () => Get.to(Theatrepage()),
            trailing: MaterialButton(
              highlightElevation: 0,
              minWidth: siz.safeWidth * 0.08,
              height: siz.safeWidth * 0.08,
              padding: EdgeInsets.all(0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: greyColor.withAlpha(40),
              elevation: 0,
              onPressed: () {
                setState(() {
                  isSelected = !isSelected;
                });
              },
              child: StatefulBuilder(
                builder: (context, set) {
                  glowOff() =>
                      Future.delayed(const Duration(milliseconds: 700), () {
                        if (context.mounted) set(() => isGlowing = false);
                      });

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
                      padding: EdgeInsets.all(siz.safeWidth * 0.01),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: isGlowing ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.local_fire_department_sharp,
                              size: siz.safeWidth * 0.07 + 3,
                              color: Colors.orangeAccent.withOpacity(0.5),
                              shadows: [
                                Shadow(
                                  color: Colors.orangeAccent.withOpacity(0.8),
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
                                  Icons.local_fire_department_sharp,
                                  color: Colors.white,
                                  size: siz.safeWidth * 0.07,
                                ),
                              )
                              : Icon(
                                Icons.local_fire_department_outlined,
                                color: blackColor.withAlpha(200),
                                size: siz.safeWidth * 0.07,
                              ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            horizontalTitleGap: siz.safeWidth * 0.01,
            leading: CircleAvatar(
              radius: siz.safeWidth * 0.1,
              backgroundColor: greyColor.withAlpha(40),
            ),
            title: Text(theatre, style: TextStyle(fontFamily: 'Medium')),
            subtitle: Text(detail, style: TextStyle(fontFamily: 'Regular')),
          ),
        ),
        SlidingGridViewer(),
      ],
    );
  }
}

class _StickyRowDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyRowDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyRowDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
