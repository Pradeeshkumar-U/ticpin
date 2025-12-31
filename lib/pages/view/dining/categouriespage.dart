import 'package:flutter/material.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/services.dart';
import 'package:ticpin/constants/shapes/ticbutton.dart';
import 'package:ticpin/constants/size.dart';

class CategoryPage extends StatefulWidget {
  final int cate_ind;
  const CategoryPage({super.key, required this.cate_ind});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
    eve_cate_ind = widget.cate_ind;
  }

  double _fadeValue() {
    const maxScroll = 200.0;
    return (_scrollOffset / maxScroll).clamp(0.0, 1.0);
  }

  List<Map<String, dynamic>> filt_but_st = [
    {"value": "30% & above offer", "tapped": false},
    {"value": "Top Rated", "tapped": false},
    {"value": "Rated 4.5+", "tapped": false},
    {"value": "50% off", "tapped": false},
    {"value": "Pure Veg", "tapped": false},
    {"value": "Pet Friendly", "tapped": false},
    {"value": "Open Now", "tapped": false},
    {"value": "Outdoor Seating", "tapped": false},
    {"value": "Serves Alcohol", "tapped": false},
    {"value": "Cafe", "tapped": false},
    {"value": "Fine Dining", "tapped": false},
    {"value": "Open Late", "tapped": false},
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
          style: TextStyle(fontFamily: 'Regular'),
          "${filt_but_st[ind]["value"]}",
        ),
      ),
    );
  }

  Map<String, bool> filt_butt = {
    "sortby": true,
    "dish_cus": false,
    "mor_fil": false,
  };

  // Sort options (Radio)
  final List<Map<String, dynamic>> sortOptions = [
    {"label": "Popularity"},
    {"label": "Date"},
    {"label": "Price: High to Low"},
    {"label": "Price: Low to High"},
  ];
  String selectedSort = "Popularity"; // default selected

  // Dish and Cusine options (Checkbox)
  final List<Map<String, dynamic>> dish_cus_options = [
    {"label": "South India", "isChecked": false},
    {"label": "Biryani", "isChecked": false},
    {"label": "Cafe", "isChecked": false},
    {"label": "Mandi", "isChecked": false},
    {"label": "Keralan", "isChecked": false},
    {"label": "Chinese", "isChecked": false},
    {"label": "Asian", "isChecked": false},
    {"label": "Fast Food", "isChecked": false},
    {"label": "Indian", "isChecked": false},
    {"label": "North Indian", "isChecked": false},
    {"label": "Mithai", "isChecked": false},
    {"label": "Bakery", "isChecked": false},
    {"label": "Continental", "isChecked": false},
    {"label": "Italian", "isChecked": false},
    {"label": "BBQ", "isChecked": false},
  ];

  // More Filters options (Checkbox)
  final List<Map<String, dynamic>> mor_fil_options = [
    {"label": "WheelChair Accessible", "isChecked": false},
    {"label": "Buffet", "isChecked": false},
    {"label": "Cafes", "isChecked": false},
    {"label": "Pubs & Bars", "isChecked": false},
    {"label": "Fine Dining", "isChecked": false},
    {"label": "Bakeries", "isChecked": false},
    {"label": "Breakfast", "isChecked": false},
    {"label": "Live Music", "isChecked": false},
    {"label": "Brunch", "isChecked": false},
    {"label": "Quick Bites", "isChecked": false},
    {"label": "Romantic Dining", "isChecked": false},
    {"label": "Open Now", "isChecked": false},
    {"label": "Pure Veg", "isChecked": false},
  ];

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
                            setSheetState(() {
                              filt_butt["sortby"] = true;
                              filt_butt["dish_cus"] = false;
                              filt_butt["mor_fil"] = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color:
                                filt_butt["sortby"] as bool
                                    ? Colors.black12
                                    : Colors.white,
                            width: size.safeWidth * 0.3,
                            height: size.safeHeight * 0.08,
                            alignment: Alignment.center,
                            child: Text(
                              "Sort by      ",
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: size.safeWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              filt_butt["sortby"] = false;
                              filt_butt["dish_cus"] = true;
                              filt_butt["mor_fil"] = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color:
                                filt_butt["dish_cus"] as bool
                                    ? Colors.black12
                                    : Colors.white,
                            width: size.safeWidth * 0.3,
                            height: size.safeHeight * 0.08,
                            alignment: Alignment.center,
                            child: Text(
                              "Dishes and\nCusine",
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: size.safeWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              filt_butt["sortby"] = false;
                              filt_butt["dish_cus"] = false;
                              filt_butt["mor_fil"] = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color:
                                filt_butt["mor_fil"] as bool
                                    ? Colors.black12
                                    : Colors.white,
                            width: size.safeWidth * 0.3,
                            height: size.safeHeight * 0.08,
                            alignment: Alignment.center,
                            child: Text(
                              "More Filters",
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
                      height: size.safeHeight * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Sort by (Radio)
                            if (filt_butt["sortby"] as bool)
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

                            // Dish and Cusine (Checkbox)
                            if (filt_butt["dish_cus"] as bool)
                              ...dish_cus_options.asMap().entries.map((entry) {
                                int index = entry.key;
                                var option = entry.value;

                                return CheckboxListTile(
                                  title: Text(
                                    option["label"],
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: size.safeWidth * 0.04,
                                    ),
                                  ),
                                  value: option["isChecked"],
                                  onChanged: (val) {
                                    setSheetState(() {
                                      dish_cus_options[index]["isChecked"] =
                                          val ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              }),
                            // More Filters (Checkbox)
                            if (filt_butt["mor_fil"] as bool)
                              ...mor_fil_options.asMap().entries.map((entry) {
                                int index = entry.key;
                                var option = entry.value;

                                return CheckboxListTile(
                                  title: Text(
                                    option["label"],
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: size.safeWidth * 0.04,
                                    ),
                                  ),
                                  value: option["isChecked"],
                                  onChanged: (val) {
                                    setSheetState(() {
                                      mor_fil_options[index]["isChecked"] =
                                          val ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
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
                      onPressed: () {},
                      child: Text(
                        style: TextStyle(fontFamily: 'Regular'),
                        "Clear All",
                      ),
                    ),
                    InkWell(
                      onTap: () {},
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

  // Ticlist Button
  // bool isSelected = false;
  // Widget ticlist_mini(bool tap, double wid) {
  //   bool isSelected = tap, isGlowing = false;

  //   return StatefulBuilder(
  //     builder: (context, set) {
  //       glowOff() => Future.delayed(const Duration(milliseconds: 700), () {
  //         if (context.mounted) set(() => isGlowing = false);
  //       });

  //       return InkWell(
  //         splashFactory: NoSplash.splashFactory,
  //         onTap: () {
  //           set(() {
  //             isSelected = !isSelected;
  //           });
  //           if (isSelected) {
  //             isGlowing = true;
  //             glowOff();
  //           }
  //         },
  //         child: Container(
  //           padding: EdgeInsets.all(wid * 0.01),
  //           decoration: BoxDecoration(
  //             color: isSelected ? Colors.black : Colors.black12,
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               AnimatedOpacity(
  //                 opacity: isGlowing ? 1 : 0,
  //                 duration: const Duration(milliseconds: 300),
  //                 child: Icon(
  //                   Icons.local_fire_department_sharp,
  //                   size: wid * 0.075 + 5,
  //                   color: Colors.orangeAccent.withOpacity(0.5),
  //                   shadows: [
  //                     Shadow(
  //                       color: Colors.orangeAccent.withOpacity(0.8),
  //                       blurRadius: 25,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               isSelected
  //                   ? ShaderMask(
  //                     shaderCallback:
  //                         (r) => const LinearGradient(
  //                           colors: [Color(0xFFFFBF00), Color(0xFFFF0000)],
  //                           begin: Alignment.topCenter,
  //                           end: Alignment.bottomCenter,
  //                         ).createShader(r),
  //                     child: Icon(
  //                       Icons.local_fire_department_sharp,
  //                       color: Colors.white,
  //                       size: wid * 0.075,
  //                     ),
  //                   )
  //                   : Icon(
  //                     Icons.local_fire_department_outlined,
  //                     color: Colors.black45,
  //                     size: wid * 0.075,
  //                   ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
              // backgroundColor: Colors.transparent,
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
              flexibleSpace: AnimatedContainer(
                duration: const Duration(milliseconds: 200), // smooth animation
                color: Colors.white.withOpacity(_fadeValue()), // fade smoothly
              ),
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: (_fadeValue() > 0.75) ? _fadeValue() : 0,
                child: Text(
                  dini_cate[eve_cate_ind]["1linetitle"]!,
                  style: TextStyle(
                    fontFamily: 'Regular',
                    color: Color.lerp(Colors.white, Colors.black, _fadeValue()),
                  ),
                ),
              ),
            ),

            // Top content
            SliverList(
              delegate: SliverChildListDelegate([
                Opacity(
                  opacity: 1 - _fadeValue() * 0.5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox.shrink(),
                          FittedBox(
                            child: Text(
                              dini_cate[eve_cate_ind]["title"] as String,
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: siz.safeWidth * 0.08,
                              ),
                            ),
                          ),
                          // SizedBox.shrink(),
                          // const SizedBox(height: 100),
                          Flexible(
                            child: Image.asset(
                              dini_cate[eve_cate_ind]["uncrop"] as String,
                              fit: BoxFit.fitHeight,
                              width: siz.safeWidth * 0.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: siz.safeHeight * 0.1),
                    ],
                  ),
                ),
              ]),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyRowDelegate(
                minHeight: siz.safeHeight * 0.1,
                maxHeight: siz.safeHeight * 0.1,
                child: Container(
                  key: _stickyKey,
                  color: Colors.white.withAlpha(
                    _fadeValue() > 0.95 ? (_fadeValue() * 255).toInt() : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 15,
                      children: [
                        const SizedBox(),
                        InkWell(
                          onTap: () {
                            filter_window(siz);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              spacing: 5,
                              children: [
                                Icon(Icons.filter_alt),
                                Text(
                                  style: TextStyle(fontFamily: 'Regular'),
                                  "Filters",
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
                        const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Scrollable List
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Column(
                      children: [
                        Container(
                          height: siz.safeHeight * 0.25,
                          width: siz.safeWidth * 0.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            border: Border(
                              top: BorderSide(),
                              left: BorderSide(),
                              right: BorderSide(),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            style: TextStyle(fontFamily: 'Regular'),
                            "Dining photo",
                          ),
                        ),
                        Container(
                          width: siz.safeWidth * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.symmetric(vertical: BorderSide()),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            "Offers",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: siz.safeWidth * 0.04,
                            ),
                          ),
                        ),
                        Container(
                          width: siz.safeWidth * 0.85,
                          height: siz.safeHeight * 0.1,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(),
                              right: BorderSide(),
                              bottom: BorderSide(),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Dining Name",
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    style: TextStyle(fontFamily: 'Regular'),
                                    "Location",
                                  ),
                                ],
                              ),
                              Spacer(),
                              // TicListButton(itemId: itemId, itemType: itemType, isInTicList: isInTicList, isBackground: isBackground, wid: wid)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: 5),
            ),
          ],
        ),
      ),
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
