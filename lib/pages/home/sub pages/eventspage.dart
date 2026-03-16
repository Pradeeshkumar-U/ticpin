import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';
import 'package:ticpin/pages/view/artists/artistspage.dart';
import 'package:ticpin/pages/view/concerts/concertpage.dart';
import 'package:ticpin/pages/view/music/musicpage.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/constants/glass_container.dart';

class Eventspage extends StatefulWidget {
  const Eventspage({super.key});

  @override
  State<Eventspage> createState() => _EventspageState();
}

class _EventspageState extends State<Eventspage> with AutomaticKeepAliveClientMixin {
  late final EventController ctrl;

  @override
  bool get wantKeepAlive => true;

  List<Color> art_img = [Colors.red, Colors.green, Colors.blue, Colors.orange];
  List<Map<String, String>> eve_cate_data = [
    {"name": "Music", "img": "assets/images/music.png"},
    {"name": "Comedy", "img": "assets/images/comedy_new.png"},
    {"name": "Performance", "img": "assets/images/performance_new.png"},
    {"name": "Sports", "img": "assets/images/sports_new.png"},
  ];

  Widget eve_cate(String name, String loc, final size, Widget desti) {
    return GestureDetector(
      onTap: () => Get.to(desti),
      child: TicpinGlassContainer(
        width: size.safeWidth * 0.33,
        height: size.safeHeight * 0.16,
        borderRadius: 15,
        blur: 10,
        linearGradientOpacity: 0.1,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.w600,
                    fontSize: size.safeWidth * 0.035,
                    color: blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: size.safeHeight * 0.12,
                width: size.safeWidth * 0.22,
                child: Image.asset(loc, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> filt_but_st = [
    {"value": "Today", "tapped": false},
    {"value": "Tomorrow", "tapped": false},
    {"value": "Music", "tapped": false},
    {"value": "Concert", "tapped": false},
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
          color: filt_but_st[ind]["tapped"] ? gradient1.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Text("${filt_but_st[ind]["value"]}", style: const TextStyle(fontFamily: 'Regular')),
      ),
    );
  }

  bool sort_by_fil_vis = true;
  bool genre_fil_vis = false;
  Sizes size = Sizes();

  final List<Map<String, dynamic>> sortOptions = [
    {"label": "Popularity"},
    {"label": "Date"},
    {"label": "Price: High to Low"},
    {"label": "Price: Low to High"},
  ];
  String selectedSort = "Popularity";

  final List<Map<String, dynamic>> genreOptions = [
    {"label": "Action", "isChecked": false},
    {"label": "Comedy", "isChecked": false},
    {"label": "Drama", "isChecked": false},
    {"label": "Sci-Fi", "isChecked": false},
    {"label": "Horror", "isChecked": false},
    {"label": "Adventure", "isChecked": false},
    {"label": "Thriller", "isChecked": false},
    {"label": "Family", "isChecked": false},
    {"label": "Fantasy", "isChecked": false},
    {"label": "Bio-pic", "isChecked": false},
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              sort_by_fil_vis = true;
                              genre_fil_vis = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color: sort_by_fil_vis ? Colors.black12 : Colors.white,
                            width: size.safeWidth * 0.3,
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
                        GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              genre_fil_vis = true;
                              sort_by_fil_vis = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color: genre_fil_vis ? Colors.black12 : Colors.white,
                            width: size.safeWidth * 0.3,
                            alignment: Alignment.center,
                            child: Text(
                              "Genre",
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
                    Container(
                      width: size.safeWidth * 0.7,
                      color: Colors.black12,
                      height: size.safeHeight * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (sort_by_fil_vis)
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
                            if (genre_fil_vis)
                              ...genreOptions.asMap().entries.map((entry) {
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
                                      genreOptions[index]["isChecked"] = val ?? false;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () {}, child: const Text("Clear All")),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
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
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    try {
      ctrl = Get.find<EventController>();
    } catch (e) {
      ctrl = Get.put(EventController());
    }
  }

  Sizes siz = Sizes();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isIOS = false;
    try {
      isIOS = Platform.isIOS;
    } catch (e) {
      isIOS = false;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            whiteColor,
            isIOS ? gradient1.withOpacity(0.2) : whiteColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          if (ctrl.loading.value && ctrl.allSummaries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.allSummaries.isEmpty) {
            return const Center(child: Text("No events found"));
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              spacing: 15,
              children: [
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    "EVENTS CATEGORY",
                    style: mainTitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 15,
                    children: [
                      const SizedBox(),
                      ...List.generate(eve_cate_data.length, (ind) {
                        return eve_cate(
                          eve_cate_data[ind]["name"]!,
                          eve_cate_data[ind]["img"]!,
                          siz,
                          Musicpage(eve_cat_ind: ind),
                        );
                      }),
                      const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "ARTISTS",
                    style: mainTitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      ...List.generate(art_img.length, (ind) {
                        return GestureDetector(
                          onTap: () => Get.to( Artistpage()),
                          child: Column(
                            spacing: 5.0,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                height: siz.safeWidth * 0.3,
                                width: siz.safeWidth * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(color: art_img[ind]),
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
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    "ALL EVENTS",
                    style: mainTitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    children: [
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () => filter_window(siz),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Row(
                            spacing: 5,
                            children: [
                              Icon(Icons.filter_alt),
                              Text("Filters"),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                      ...List.generate(
                        filt_but_st.length,
                        (ind) => filter_butt(ind),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
                const SizedBox(),
                ...ctrl.allSummaries.map((e) {
                  return GestureDetector(
                    key: ValueKey(e.id),
                    onTap: () => Get.to(() => Concertpage(eventId: e.id)),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.safeWidth * 0.05),
                          child: AspectRatio(
                            aspectRatio: 24.0 / 36.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                border: Border.fromBorderSide(
                                  BorderSide(color: Colors.black12, width: 1),
                                ),
                              ),
                              child: e.posterUrl.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      e.posterUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Center(child: Icon(Icons.broken_image_rounded)),
                                    ),
                                  )
                                  : const Center(child: Icon(Icons.broken_image_rounded)),
                            ),
                          ),
                        ),
                        Container(
                          width: siz.safeWidth * 0.9,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black12, width: 1),
                              left: BorderSide(color: Colors.black12, width: 1),
                              right: BorderSide(color: Colors.black12, width: 1),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE, d MMM').format(e.dateTime.toLocal()),
                                style: const TextStyle(fontFamily: 'Regular'),
                              ),
                              Text(
                                e.name,
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  fontSize: siz.safeWidth * 0.045,
                                ),
                              ),
                              Text(e.venueName, style: const TextStyle(fontFamily: 'Regular')),
                              Text(
                                "${e.distanceKm.toStringAsFixed(2)} km away",
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }),
                SizedBox(height: siz.safeWidth * 0.1),
              ],
            ),
          );
        }),
      ),
    );
  }
}