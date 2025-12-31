import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/turf/turffull.dart';
import 'package:ticpin/constants/models/user/user.dart';
import 'package:ticpin/constants/shapes/ticbutton.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/dining/billpaypage.dart';
import 'package:ticpin/pages/view/sports/bookingpage.dart';
import 'package:ticpin/pages/view/sports/snacksbar.dart';
import 'package:ticpin/services/controllers/turf_controller.dart';
import 'package:ticpin/services/places.dart';

// ignore: must_be_immutable
class Turfpage extends StatefulWidget {
  Turfpage({super.key, required this.turfId});

  String turfId;

  @override
  State<Turfpage> createState() => _TurfpageState();
}

class IntervalSlot {
  final String start;
  final String end;

  IntervalSlot(this.start, this.end);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntervalSlot &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

class _TurfpageState extends State<Turfpage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  CarouselSliderController _turfController = CarouselSliderController();
  int _turfCurrent = 0;
  final TurfController controller = Get.find<TurfController>();
  List<SnackItem> snacks = [
    SnackItem(name: "Lays", det: "Red lays with more quantity", price: 20),
    SnackItem(name: "Coke", det: "Chilled soft drink", price: 100),
    SnackItem(name: "Cookies", det: "Chocolate chip cookies", price: 50),
  ];

  // Update your PageView builder to use the new buildIntervalUI

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

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _loadTurfData();

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

  Future<void> _loadTurfData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Load from cache or Firestore
      final turf = await controller.loadTurfFull(widget.turfId);

      if (mounted) {
        setState(() {
          _turf = turf;
          _isLoading = false;
          _hasError = turf == null;
        });
      }
    } catch (e) {
      print('Error loading event: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  TurfFull? _turf;

  Sizes size = Sizes();

  bool isGlowing = false;
  bool isSelected = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // OPTIMIZATION: Separate loading state widget
  Widget _buildLoadingState() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: whiteColor,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 20),
                  LoadingShimmer(
                    width: size.safeWidth,
                    height: size.safeHeight * 0.35,
                    isCircle: false,
                  ),
                  SizedBox(height: 60),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.6,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.7,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.3,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.9,
                      height: size.safeHeight * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.3,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.9,
                      height: size.safeHeight * 0.1,
                      isCircle: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                    child: LoadingShimmer(
                      width: size.safeWidth * 0.3,
                      height: size.safeWidth * 0.1,
                      isCircle: false,
                    ),
                  ),
                  // SizedBox(height: 20),
                  // Padding(
                  //   padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                  //   child: LoadingShimmer(
                  //     width: size.safeWidth * 0.9,
                  //     height: size.safeHeight * 0.1,
                  //     isCircle: false,
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // OPTIMIZATION: Separate error state widget
  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: gradient1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Turf Not Found',
          style: TextStyle(color: whiteColor, fontFamily: 'Regular'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Unable to load turf details',
              style: TextStyle(fontSize: 18, fontFamily: 'Regular'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _loadTurfData(); // Retry loading
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blackColor,
                padding: EdgeInsets.symmetric(
                  horizontal: size.safeWidth * 0.1,
                  vertical: size.safeWidth * 0.03,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(fontFamily: 'Regular', color: whiteColor),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    final turf = _turf!;

    if (_hasError || _turf == null) {
      return _buildErrorState();
    }

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
                        IconButton(
                          onPressed: () {},
                          icon: CircleAvatar(
                            backgroundColor: Colors.white54,
                            child: TicListButton(
                              itemId: turf.turfId,
                              itemType: TicListItemType.turf,
                              // isInTicList: isInTicList,
                              isBackground: false,
                              // wid: size.width,
                              color: Color.lerp(
                                blackColor.withAlpha(170),
                                blackColor.withAlpha(200),
                                _appBarOpacity,
                              ),
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
                      size.safeWidth * 0.7 + MediaQuery.of(context).padding.top,
                  backgroundColor: whiteColor,

                  elevation: _appBarOpacity > 0.1 ? 4 : 0,
                  stretchTriggerOffset: 0.1,
                  title: Opacity(
                    opacity: _appBarOpacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          turf.name,
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          turf.city,
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
                    background: Column(
                      children: [
                        CarouselSlider.builder(
                          carouselController: _turfController,
                          itemCount: turf.posterUrls.length,
                          itemBuilder: (context, index, realIndex) {
                            return SizedBox(
                              // height:
                              //     size.safeWidth * 0.6 +
                              //     MediaQuery.of(context).padding.top,
                              // -MediaQuery.of(context).padding.top,
                              width: size.safeWidth,
                              child: Image.network(
                                turf.posterUrls[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            scrollPhysics:
                                turf.posterUrls.length == 1
                                    ? NeverScrollableScrollPhysics()
                                    : AlwaysScrollableScrollPhysics(),
                            viewportFraction: 1,
                            height:
                                size.safeWidth * 0.7 +
                                MediaQuery.of(context).padding.top,
                          ),
                        ),
                        turf.posterUrls.length == 1
                            ? SizedBox.shrink()
                            : Padding(
                              padding: EdgeInsets.only(
                                top: size.width * 0.01,
                                bottom: size.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  turf.posterUrls.length,
                                  (index) {
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
                                        color: (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                            .withAlpha(
                                              _turfCurrent == index ? 255 : 100,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AnimatedOpacity(
                    opacity: 1 - _appBarOpacity,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: size.safeWidth * 0.05),
                          Text(
                            turf.name,
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
                                    turf.city,
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

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Address",

                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: size.safeWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                turf.address,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: size.safeWidth * 0.035,

                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () {
                                openMapLink(turf.mapLink);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.safeWidth * 0.03,
                                  vertical: size.safeWidth * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: blackColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),

                                child: Text(
                                  'get directions >',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: size.safeWidth * 0.025,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Venue Information",

                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: size.safeWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: SizedBox(
                          width: size.width,
                          child: Wrap(
                            // alignment: WrapAlignment.start,
                            // crossAxisAlignment: WrapCrossAlignment.start,
                            // runAlignment: WrapAlignment.start,
                            spacing: 10,
                            runSpacing: 8,
                            children:
                                turf.venueInfo.map((amenity) {
                                  return Chip(
                                    label: Text(
                                      amenity,
                                      style: const TextStyle(
                                        fontFamily: 'Medium',
                                      ),
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      193,
                                      173,
                                      255,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Playground Types",

                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: size.safeWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: SizedBox(
                          width: size.width,
                          child: Wrap(
                            // alignment: WrapAlignment.start,
                            // crossAxisAlignment: WrapCrossAlignment.start,
                            // runAlignment: WrapAlignment.start,
                            spacing: 10,
                            runSpacing: 8,
                            children:
                                turf.playground.map((amenity) {
                                  return Chip(
                                    label: Text(
                                      amenity,
                                      style: const TextStyle(
                                        fontFamily: 'Medium',
                                      ),
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      193,
                                      173,
                                      255,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Amenities",

                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: size.safeWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: SizedBox(
                          width: size.width,
                          child: Wrap(
                            // alignment: WrapAlignment.start,
                            // crossAxisAlignment: WrapCrossAlignment.start,
                            // runAlignment: WrapAlignment.start,
                            spacing: 10,
                            runSpacing: 8,
                            children:
                                turf.amenities.map((amenity) {
                                  return Chip(
                                    label: Text(
                                      amenity,
                                      style: const TextStyle(
                                        fontFamily: 'Medium',
                                      ),
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      193,
                                      173,
                                      255,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Venue Rules",

                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: size.safeWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: SizedBox(
                          width: size.width,
                          child: Wrap(
                            // alignment: WrapAlignment.start,
                            // crossAxisAlignment: WrapCrossAlignment.start,
                            // runAlignment: WrapAlignment.start,
                            spacing: 10,
                            runSpacing: 8,
                            children:
                                turf.venueRules.map((amenity) {
                                  return Chip(
                                    label: Text(
                                      amenity,
                                      style: const TextStyle(
                                        fontFamily: 'Medium',
                                      ),
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      193,
                                      173,
                                      255,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(height: size.safeHeight * 0.3),

                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 8.0),
                      //   child: GridView.builder(
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemCount: 7,
                      //     shrinkWrap: true,
                      //     gridDelegate:
                      //         SliverGridDelegateWithFixedCrossAxisCount(
                      //           crossAxisCount: 3,
                      //           // mainAxisSpacing: 10,
                      //           // crossAxisSpacing: 10,
                      //           childAspectRatio: (1 / 0.6),
                      //         ),
                      //     itemBuilder: (context, index) {
                      //       return Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Container(
                      //           height: size.safeHeight * 0.1,

                      //           decoration: BoxDecoration(
                      //             border: Border.all(
                      //               width: 1,
                      //               color: Colors.black45,
                      //             ),
                      //             borderRadius: BorderRadius.circular(12),
                      //             color: Colors.black12,
                      //           ),
                      //           child: FittedBox(
                      //             fit: BoxFit.scaleDown,
                      //             child: Column(
                      //               children: [
                      //                 Padding(
                      //                   padding: EdgeInsets.only(top: 8.0),
                      //                   child: Text(
                      //                     '11:22 AM',
                      //                     style: TextStyle(
                      //                       fontFamily: 'Medium',
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: EdgeInsets.only(bottom: 8.0),
                      //                   child: Text(
                      //                     '02:00 PM',
                      //                     style: TextStyle(
                      //                       fontFamily: 'Medium',
                      //                       // fontSize: size.safeWidth * 0.025,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      // SizedBox(height: size.safeHeight * 0.15),

                      // // PAGE VIEW FOR SLOTS
                      // SizedBox(
                      //   height: 400, // FIXED HEIGHT → NO ERRORS
                      //   child: PageView.builder(
                      //     controller: _pageController,
                      //     itemCount: sessions.length,
                      //     onPageChanged:
                      //         (i) => setState(() => _selectedIndex = i),
                      //     itemBuilder: (context, index) {
                      //       final session = sessions[index];
                      //       final slots = allTimes[index];

                      //       int half = (slots.length / 2).ceil();
                      //       final firstHalf = slots.sublist(0, half);
                      //       final secondHalf = slots.sublist(half - 1);

                      //       return Column(
                      //         children: [
                      //           buildIntervalUI(session, firstHalf),
                      //           SizedBox(height: 10),
                      //           buildIntervalUI(session, secondHalf),
                      //         ],
                      //       );
                      //     },
                      //   ),
                      // ),

                      // SizedBox(height: 10),

                      // PAGE INDICATOR
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
              padding: EdgeInsets.only(
                top: 10,
                bottom: 18,
                left: 20,
                right: 20,
              ),
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Get.to(
                    SportsBookingPage(
                      turfId: widget.turfId,
                      turfData: turf.raw,
                    ),
                  );
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
                      "Book Now",
                      style: TextStyle(
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
