import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/shapes/containers.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';
import 'package:ticpin/pages/view/sports/turfpage.dart';
import 'package:ticpin/services/controllers/turf_controller.dart';
import 'package:ticpin/constants/glass_container.dart';

class Sportspage extends StatefulWidget {
  const Sportspage({super.key});

  @override
  State<Sportspage> createState() => _SportspageState();
}

class _SportspageState extends State<Sportspage> {
  late final TurfController ctrl;
  Sizes size = Sizes();

  List<Map<String, dynamic>> filt_but_st = [
    {"value": "Cricket", "tapped": false},
    {"value": "Football", "tapped": false},
    {"value": "Others", "tapped": false},
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
          style: const TextStyle(fontFamily: 'Regular'),
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> sortOptions = [
    {"label": "Popularity"},
    {"label": "Name"},
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
                    Container(
                      width: size.safeWidth * 0.7,
                      color: Colors.black12,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedSort = "Popularity";
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Clear All",
                        style: TextStyle(fontFamily: 'Regular'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // Apply sorting logic if needed
                        });
                        Navigator.pop(context);
                      },
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
      ctrl = Get.find<TurfController>();
    } catch (e) {
      ctrl = Get.put(TurfController());
    }
  }

  List<dynamic> _getSortedTurfs(List<dynamic> turfs) {
    final sorted = [...turfs];
    switch (selectedSort) {
      case "Name":
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Price: High to Low":
        sorted.sort((a, b) => b.halfHourPrice.compareTo(a.halfHourPrice));
        break;
      case "Price: Low to High":
        sorted.sort((a, b) => a.halfHourPrice.compareTo(b.halfHourPrice));
        break;
      case "Popularity":
      default:
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
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
          colors: [whiteColor, isIOS ? gradient1.withOpacity(0.2) : whiteColor],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.02,
                  bottom: size.safeWidth * 0.05,
                ),
                child: Text('CRICKET TURFS', style: mainTitleTextStyle),
              ),
              Obx(() {
                final turfs = ctrl.allSummaries;
                final cricketTurfs =
                    turfs
                        .where(
                          (turf) => turf.playground.any(
                            (p) =>
                                p.toString().toLowerCase().contains('cricket'),
                          ),
                        )
                        .toList();
                final sortedCricket = _getSortedTurfs(cricketTurfs);

                if (sortedCricket.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: size.safeWidth * 0.05),
                    child: Text(
                      "No cricket turfs available",
                      style: TextStyle(
                        fontFamily: 'Regular',
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: size.safeWidth * 0.7,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          sortedCricket.asMap().entries.map((entry) {
                            final index = entry.key;
                            final turf = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                left: size.safeWidth * 0.05,
                                right:
                                    index == sortedCricket.length - 1
                                        ? size.safeWidth * 0.05
                                        : 0,
                              ),
                              child: horizontalTurfCard(turf),
                            );
                          }).toList(),
                    ),
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.04,
                  bottom: size.safeWidth * 0.05,
                ),
                child: Text('FOOTBALL TURFS', style: mainTitleTextStyle),
              ),
              Obx(() {
                final turfs = ctrl.allSummaries;
                final footballTurfs =
                    turfs
                        .where(
                          (turf) => turf.playground.any(
                            (p) =>
                                p.toString().toLowerCase().contains('football'),
                          ),
                        )
                        .toList();
                final sortedFootball = _getSortedTurfs(footballTurfs);

                if (sortedFootball.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: size.safeWidth * 0.05),
                    child: Text(
                      "No football turfs available",
                      style: TextStyle(
                        fontFamily: 'Regular',
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: size.safeWidth * 0.7,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          sortedFootball.asMap().entries.map((entry) {
                            final index = entry.key;
                            final turf = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                left: size.safeWidth * 0.05,
                                right:
                                    index == sortedFootball.length - 1
                                        ? size.safeWidth * 0.05
                                        : 0,
                              ),
                              child: horizontalTurfCard(turf),
                            );
                          }).toList(),
                    ),
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.07,
                  bottom: size.safeWidth * 0.05,
                ),
                child: Text('ALL GROUNDS', style: mainTitleTextStyle),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 15,
                  children: [
                    SizedBox(width: size.safeWidth * 0.015),
                    InkWell(
                      onTap: () => filter_window(size),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Row(
                          spacing: 5,
                          children: [
                            Icon(Icons.filter_alt),
                            Text(
                              "Filters",
                              style: TextStyle(fontFamily: 'Regular'),
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
                    SizedBox(width: size.safeWidth * 0.015),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final turfs = ctrl.allSummaries;
                if (ctrl.loading.value && turfs.isEmpty) {
                  return SizedBox(
                    height: size.safeHeight * 0.3,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (turfs.isEmpty) {
                  return const Center(child: Text("No turfs found"));
                }
                final sortedTurfs = _getSortedTurfs(turfs);
                return Column(
                  children:
                      sortedTurfs.map((turf) => restaurantsList(turf)).toList(),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget horizontalTurfCard(turf) {
    return TicpinGlassContainer(
      width: size.safeWidth * 0.8,
      height: size.safeHeight * 0.35,
      borderRadius: 17,
      blur: 10,
      linearGradientOpacity: 0.1,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 3.0 / 2.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child:
                  turf.posterUrls.isNotEmpty
                      ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          topRight: Radius.circular(17),
                        ),
                        child: Image.network(
                          turf.posterUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.grey,
                                  size: size.safeWidth * 0.15,
                                ),
                              ),
                        ),
                      )
                      : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(17),
                            topRight: Radius.circular(17),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.sports_soccer,
                            color: Colors.grey[600],
                            size: size.safeWidth * 0.15,
                          ),
                        ),
                      ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes().width * 0.03,
                    vertical: Sizes().width * 0.015,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyle(turf.name, Sizes().width * 0.04),
                      Text(
                        turf.address,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: Sizes().width * 0.03,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes().width * 0.02),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => Turfpage(turfId: turf.id)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blackColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(color: whiteColor, fontFamily: 'Regular'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget restaurantsList(turf) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.safeHeight * 0.03),
      child: TicpinGlassContainer(
        width: Sizes().width * 0.9,
        height: size.safeHeight * 0.35,
        borderRadius: 17,
        blur: 10,
        linearGradientOpacity: 0.1,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3.0 / 2.0,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child:
                    turf.posterUrls.isNotEmpty
                        ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(17),
                            topRight: Radius.circular(17),
                          ),
                          child: Image.network(
                            turf.posterUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Center(
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.grey,
                                    size: size.safeWidth * 0.2,
                                  ),
                                ),
                          ),
                        )
                        : Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(17),
                              topRight: Radius.circular(17),
                            ),
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.sports_soccer,
                              color: Colors.grey[600],
                              size: size.safeWidth * 0.2,
                            ),
                          ),
                        ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes().width * 0.03,
                      vertical: Sizes().width * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextStyle(turf.name, Sizes().width * 0.04),
                        customTextStyle(turf.address, Sizes().width * 0.03),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes().width * 0.02,
                  ),
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => Turfpage(turfId: turf.id)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blackColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    child: const Text(
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
          ],
        ),
      ),
    );
  }
}
