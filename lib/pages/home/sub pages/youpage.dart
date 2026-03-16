import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/artists/artistspage.dart';
import 'package:ticpin/pages/view/dining/restaurentpage.dart';
import 'package:ticpin/constants/shapes/containers.dart';
import 'package:ticpin/services/controllers/dining_controller.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/services/controllers/turf_controller.dart';
import 'package:ticpin/services/controllers/offer_controller.dart';

class ForYoupage extends StatefulWidget {
  const ForYoupage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ForYoupageState();
  }
}

class _ForYoupageState extends State<ForYoupage> {
  late final EventController ctrl;
  late final TurfController turfCtrl;
  late final DiningController diningController;
  late final OfferController offerCtrl;

  int _eventCurrent = 0;
  int _turfCurrent = 0;
  final CarouselSliderController _eventController = CarouselSliderController();
  final CarouselSliderController _turfController = CarouselSliderController();

  Sizes size = Sizes();

  @override
  void initState() {
    super.initState();
    try {
      ctrl = Get.find<EventController>();
      turfCtrl = Get.find<TurfController>();
      diningController = Get.find<DiningController>();
      offerCtrl = Get.find<OfferController>();
    } catch (e) {
      ctrl = Get.put(EventController());
      turfCtrl = Get.put(TurfController());
      diningController = Get.put(DiningController());
      offerCtrl = Get.put(OfferController());
    }
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.03,
                bottom: size.safeWidth * 0.07,
              ),
              child: Text('HOT RIGHT NOW', style: mainTitleTextStyle),
            ),

            Obx(() {
              if (ctrl.loading.value && ctrl.forYouEvents.isEmpty) {
                return AspectRatio(
                  aspectRatio: 9 / 16,
                  child: LoadingShimmer(
                    width: size.width,
                    height: size.height,
                    isCircle: false,
                  ),
                );
              }

              if (ctrl.forYouEvents.isEmpty) {
                return SizedBox(
                  height: (size.safeWidth * 0.9) * (3 / 2),
                  child: const Center(child: Text("No upcoming events")),
                );
              }

              return CarouselSlider.builder(
                carouselController: _eventController,
                itemCount: ctrl.forYouEvents.length,
                itemBuilder: (context, index, realIndex) {
                  final e = ctrl.forYouEvents[index];
                  return PosterCarousel(
                    event: e,
                    dist: e.distanceKm,
                    size: size,
                    name: e.name,
                    date: DateFormat(
                      'EEEE, d MMM',
                    ).format(e.dateTime.toLocal()),
                    loc: e.venueName,
                    posterUrl: e.posterUrl,
                    videoUrl: e.videoUrl,
                    isVideo: e.videoUrl.isNotEmpty,
                    index: index,
                    currentIndex: _eventCurrent,
                  );
                },
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() => _eventCurrent = index);
                  },
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  aspectRatio: 24.0 / 36.0,
                  viewportFraction: 0.85,
                  height: size.width * (36 / 24),
                  enableInfiniteScroll: true,
                ),
              );
            }),

            Obx(() {
              return Padding(
                padding: EdgeInsets.only(
                  top: size.safeWidth * 0.03,
                  bottom: size.safeWidth * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(ctrl.forYouEvents.length, (index) {
                    return Container(
                      width:
                          _eventCurrent == index
                              ? size.safeWidth * 0.03
                              : size.safeWidth * 0.02,
                      height: size.safeWidth * 0.02,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withAlpha(_eventCurrent == index ? 255 : 100),
                      ),
                    );
                  }),
                ),
              );
            }),

            Obx(() {
              if (offerCtrl.loading.value) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (offerCtrl.allOffers.isEmpty) {
                return const SizedBox();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.safeWidth * 0.03,
                      bottom: size.safeWidth * 0.07,
                    ),
                    child: Text('OFFERS FOR YOU', style: mainTitleTextStyle),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: size.safeWidth * 0.05),
                        ...offerCtrl.allOffers.map((offer) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: size.safeWidth * 0.05,
                            ),
                            child: offersContainer(
                              date: offer.validUntil,
                              name: offer.title,
                              color: gradient1,
                              offer: '${offer.discount}% OFF',
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: size.safeHeight * 0.03),
                ],
              );
            }),

            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.03,
                bottom: size.safeWidth * 0.07,
              ),
              child: Text('ARTISTS', style: mainTitleTextStyle),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: size.safeWidth * 0.026),
                  Row(
                    children: List.generate(colors.length, (ind) {
                      return GestureDetector(
                        onTap: () => Get.to(Artistpage()),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colors[ind],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              height: size.safeWidth * 0.3,
                              width: size.safeWidth * 0.3,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Name ${ind + 1}",
                              style: TextStyle(
                                fontSize: Sizes().width * 0.03,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Regular',
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
            SizedBox(height: size.safeHeight * 0.03),
            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.04,
                bottom: size.safeWidth * 0.05,
              ),
              child: Text('IN LIMELIGHT', style: mainTitleTextStyle),
            ),

            SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      diningController.nearestSummaries.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final dining = entry.value;

                        return Padding(
                          padding: EdgeInsets.only(
                            left: size.safeWidth * 0.05,
                            right:
                                index ==
                                        diningController
                                                .nearestSummaries
                                                .length -
                                            1
                                    ? size.safeWidth * 0.05
                                    : 0,
                          ),
                          child: GestureDetector(
                            onTap:
                                () => Get.to(
                                  () => Restaurentpage(diningId: dining.id),
                                ),
                            child: Container(
                              width:
                                  diningController.nearestSummaries.length == 1
                                      ? size.safeWidth * 0.9
                                      : size.safeWidth * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: dining.carouselImage,
                                      width:
                                          diningController
                                                      .nearestSummaries
                                                      .length ==
                                                  1
                                              ? size.safeWidth * 0.9
                                              : size.safeWidth * 0.8,
                                      height:
                                          (diningController
                                                      .nearestSummaries
                                                      .length ==
                                                  1
                                              ? size.safeWidth * 0.9
                                              : size.safeWidth * 0.8) *
                                          (2.0 / 3.0),
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => Container(
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            color: gradient1.withAlpha(80),
                                            child: const Icon(
                                              Icons.restaurant,
                                              size: 50,
                                            ),
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Sizes().width * 0.03,
                                      vertical: Sizes().width * 0.015,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        if (dining.cuisines != null &&
                                            dining.cuisines!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: Text(
                                              dining.cuisines!
                                                  .take(3)
                                                  .join(' • '),
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
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: size.safeWidth * 0.07,
                bottom: size.safeWidth * 0.05,
              ),
              child: Text('TURFS NEAR YOU', style: mainTitleTextStyle),
            ),

            Obx(() {
              if (turfCtrl.loading.value && turfCtrl.forYouTurfs.isEmpty) {
                return AspectRatio(
                  aspectRatio: 3.0 / 2.0,
                  child: LoadingShimmer(
                    width: size.width,
                    height: size.height,
                    isCircle: false,
                  ),
                );
              }

              if (turfCtrl.forYouTurfs.isEmpty) {
                return const AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Center(child: Text("No turfs available")),
                );
              }

              return CarouselSlider.builder(
                carouselController: _turfController,
                itemCount: turfCtrl.forYouTurfs.length,
                itemBuilder: (context, index, realIndex) {
                  final turf = turfCtrl.forYouTurfs[index];
                  return TurfPosterCarousel(
                    turf: turf,
                    dist: turf.distanceKm,
                    size: size,
                    name: turf.name,
                    city: turf.city,
                    loc: turf.address,
                    price: '₹ ${turf.halfHourPrice} / 30 min',
                    posterUrl:
                        turf.posterUrls.isNotEmpty ? turf.posterUrls.first : '',
                    index: index,
                    currentIndex: _turfCurrent,
                  );
                },
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() => _turfCurrent = index);
                  },
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  aspectRatio: 3.0 / 2.0,
                  viewportFraction: 0.9,
                  height: (size.safeWidth * 1.3) * (2 / 3),
                  enableInfiniteScroll: true,
                ),
              );
            }),

            Obx(() {
              return Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.03,
                  bottom: size.width * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(turfCtrl.forYouTurfs.length, (index) {
                    return Container(
                      width:
                          _turfCurrent == index
                              ? size.width * 0.03
                              : size.width * 0.02,
                      height: size.width * 0.02,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withAlpha(_turfCurrent == index ? 255 : 100),
                      ),
                    );
                  }),
                ),
              );
            }),
            SizedBox(height: size.safeHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
