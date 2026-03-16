import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/services.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/dining/categouriespage.dart';
import 'package:ticpin/pages/view/dining/restaurentpage.dart';
import 'package:ticpin/services/controllers/dining_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ticpin/constants/glass_container.dart';

class Diningpage extends StatefulWidget {
  const Diningpage({super.key});

  @override
  State<Diningpage> createState() => _DiningpageState();
}

class _DiningpageState extends State<Diningpage> {
  Sizes size = Sizes();
  final DiningController diningController = Get.find<DiningController>();

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
        child: Text(
          "${filt_but_st[ind]["value"]}",
          style: const TextStyle(fontFamily: 'Regular'),
        ),
      ),
    );
  }

  Widget cate_card(String title, String path, final siz, final fs) {
    return TicpinGlassContainer(
      width: siz.safeWidth * 0.35,
      height: siz.safeHeight * 0.17,
      borderRadius: 15,
      blur: 10,
      linearGradientOpacity: 0.1,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15)),
              child: SizedBox(
                width: siz.safeWidth * 0.2,
                height: siz.safeHeight * 0.1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(path),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: fs * 0.5, top: fs * 0.5),
              child: Text(
                title,
                style: TextStyle(
                  color: blackColor,
                  fontFamily: 'Regular',
                  fontSize: size.safeWidth * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Clear All",
                        style: TextStyle(fontFamily: 'Regular'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
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
          colors: [
            whiteColor,
            isIOS ? gradient1.withOpacity(0.2) : whiteColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          if (diningController.loading.value && diningController.allSummaries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.safeWidth * 0.05),
                    child: Padding(
                      padding: EdgeInsets.only(left: size.safeWidth * 0.055),
                      child: Row(
                        children: diningController.forYouDinings.take(2).map((dining) {
                          return diningContainer(dining);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.safeWidth * 0.04,
                    bottom: size.safeWidth * 0.05,
                  ),
                  child: Text('IN LIMELIGHT', style: mainTitleTextStyle),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: diningController.nearestSummaries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final dining = entry.value;

                      return Padding(
                        padding: EdgeInsets.only(
                          left: size.safeWidth * 0.05,
                          right: index == diningController.nearestSummaries.length - 1 ? size.safeWidth * 0.05 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => Get.to(() => Restaurentpage(diningId: dining.id)),
                          child: Container(
                            width: diningController.nearestSummaries.length == 1 ? size.safeWidth * 0.9 : size.safeWidth * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  child: CachedNetworkImage(
                                    imageUrl: dining.carouselImage,
                                    width: diningController.nearestSummaries.length == 1 ? size.safeWidth * 0.9 : size.safeWidth * 0.8,
                                    height: (diningController.nearestSummaries.length == 1 ? size.safeWidth * 0.9 : size.safeWidth * 0.8) * (2.0 / 3.0),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(child: CircularProgressIndicator()),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: gradient1.withAlpha(80),
                                      child: const Icon(Icons.restaurant, size: 50),
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
                                            Text(
                                              dining.name,
                                              style: TextStyle(
                                                fontSize: Sizes().width * 0.04,
                                                fontFamily: 'Medium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: Sizes().width * 0.035,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${dining.rating.toStringAsFixed(1)} (${dining.totalReviews})',
                                                  style: TextStyle(
                                                    fontSize: Sizes().width * 0.03,
                                                    fontFamily: 'Regular',
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  dining.formattedDistance,
                                                  style: TextStyle(
                                                    fontSize: Sizes().width * 0.03,
                                                    fontFamily: 'Regular',
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (dining.cuisines != null && dining.cuisines!.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Text(
                                                  dining.cuisines!.take(3).join(' • '),
                                                  style: TextStyle(
                                                    fontSize: Sizes().width * 0.028,
                                                    fontFamily: 'Regular',
                                                    color: Colors.black54,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.safeWidth * 0.07,
                    bottom: size.safeWidth * 0.05,
                  ),
                  child: Text('CATEGORIES', style: mainTitleTextStyle),
                ),
                GridView.count(
                  padding: EdgeInsets.all(size.safeWidth * 0.04),
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: size.safeWidth * 0.04,
                  mainAxisSpacing: size.safeWidth * 0.04,
                  shrinkWrap: true,
                  childAspectRatio: size.safeWidth * 0.2 / (size.safeHeight * 0.1),
                  children: List.generate(dini_cate.length, (ind) {
                    return GestureDetector(
                      onTap: () => Get.to(() => CategoryPage(cate_ind: ind)),
                      child: cate_card(
                        dini_cate[ind]["title"] as String,
                        dini_cate[ind]["image"] as String,
                        size,
                        size.safeWidth * 0.04,
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.safeWidth * 0.07,
                    bottom: size.safeWidth * 0.05,
                  ),
                  child: Text('FEATURED IN TICPIN', style: mainTitleTextStyle),
                ),
                Container(
                  width: size.safeWidth * 0.89,
                  height: size.safeWidth * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.safeWidth * 0.07,
                    bottom: size.safeWidth * 0.05,
                  ),
                  child: Text('ALL RESTAURANTS', style: mainTitleTextStyle),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 15,
                    children: [
                      const SizedBox(width: 15),
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
                              Text("Filters", style: TextStyle(fontFamily: 'Regular')),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                      ...List.generate(filt_but_st.length, (ind) => filter_butt(ind)),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...diningController.allSummaries.map((dining) => restaurantsList(dining)),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget restaurantsList(dining) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.safeHeight * 0.03),
      child: GestureDetector(
        onTap: () => Get.to(() => Restaurentpage(diningId: dining.id)),
        child: Container(
          width: Sizes().width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                child: CachedNetworkImage(
                  imageUrl: dining.carouselImage,
                  height: (Sizes().width * 0.9) * (2.0 / 3.0),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: (Sizes().width * 0.9) * (2.0 / 3.0),
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: (Sizes().width * 0.9) * (2.0 / 3.0),
                    color: gradient1.withAlpha(80),
                    child: const Center(child: Icon(Icons.restaurant, size: 80)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes().width * 0.03,
                  vertical: Sizes().width * 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dining.name,
                      style: TextStyle(
                        fontSize: Sizes().width * 0.04,
                        fontFamily: 'Medium',
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: Sizes().width * 0.035),
                        const SizedBox(width: 4),
                        Text(
                          '${dining.rating.toStringAsFixed(1)} (${dining.totalReviews})',
                          style: TextStyle(fontSize: Sizes().width * 0.03, fontFamily: 'Regular'),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          dining.formattedDistance,
                          style: TextStyle(fontSize: Sizes().width * 0.03, fontFamily: 'Regular', color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget diningContainer(dining) {
    return Padding(
      padding: EdgeInsets.only(right: size.safeWidth * 0.055),
      child: Container(
        width: size.safeWidth * 0.87,
        decoration: BoxDecoration(
          color: gradient1.withAlpha(80),
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.safeWidth * 0.02, left: size.safeWidth * 0.04),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Offers you love',
                  style: TextStyle(fontFamily: 'Medium', fontSize: size.safeWidth * 0.05),
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: size.safeWidth * 0.02),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: diningController.forYouDinings.take(5).length,
              itemBuilder: (context, index) {
                final diningItem = diningController.forYouDinings[index];
                return GestureDetector(
                  onTap: () => Get.to(() => Restaurentpage(diningId: diningItem.id)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: diningItem.carouselImage,
                        width: size.safeWidth * 0.27,
                        height: size.safeWidth * 0.3,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) => Container(color: whiteColor, child: const Icon(Icons.restaurant)),
                      ),
                    ),
                    title: Text(
                      diningItem.name,
                      style: TextStyle(fontFamily: 'Medium', fontSize: size.safeWidth * 0.035),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          diningItem.briefDescription,
                          style: TextStyle(fontFamily: 'Regular', fontSize: size.safeWidth * 0.03),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          diningItem.formattedDistance,
                          style: TextStyle(fontFamily: 'Regular', fontSize: size.safeWidth * 0.03),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: size.safeWidth * 0.03, bottom: size.safeWidth * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('See More', style: TextStyle(fontFamily: 'Medium', fontSize: size.safeWidth * 0.04)),
                  Icon(Icons.keyboard_arrow_right, size: size.safeWidth * 0.07),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
