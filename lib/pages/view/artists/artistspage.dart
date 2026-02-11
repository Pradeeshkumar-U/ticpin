import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticpin/constants/temporary.dart';

// ignore: must_be_immutable
class Artistpage extends StatefulWidget {
  Artistpage({super.key});
  String type = 'artist';

  @override
  State<Artistpage> createState() => _ArtistpageState();
}

class _ArtistpageState extends State<Artistpage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  double _opacity = 0.0;
  int _carouselCurrent = 0;

  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(() {
      double offset = _scrollController.offset;

      // Adjust this value depending on when you want the title to fade in
      double fadeStart = size.safeHeight * 0.35;
      double fadeEnd = size.safeHeight * 0.5;

      double newOpacity = (offset - fadeStart) / (fadeEnd - fadeStart);
      newOpacity = newOpacity.clamp(0.0, 1.0);

      if (newOpacity != _opacity) {
        if (mounted) {
          setState(() {
            _opacity = newOpacity;
          });
        }
      }
    });
  }

  bool isTap = false;

  @override
  void dispose() {
    _tabController.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  Future<List<String>> getTopTracks(String artist) async {
    final apiKey = '32fc48456591478c3a309c204c65e477';
    final url = Uri.parse(
      'http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=${Uri.encodeComponent(artist)}&api_key=$apiKey&format=json&limit=5',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['toptracks']['track'] as List;
      return tracks.map((track) => track['name'] as String).toList();
    } else {
      throw Exception('Failed to load top tracks');
    }
  }

  bool isGlowing = false;
  bool isSelected = false;
  bool isGlowing2 = false;
  bool isSelected2 = false;

  Sizes size = Sizes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leadingWidth: size.safeWidth * 0.14,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: EdgeInsets.only(left: size.safeWidth * 0.04),
            child: Container(
              padding: EdgeInsets.all(0),
              width: size.safeWidth * 0.03,
              height: size.safeWidth * 0.03,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white54,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Color.lerp(
                  blackColor.withAlpha(200),
                  blackColor,
                  _opacity,
                ),
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isTap = !isTap;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white54,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
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
                        // padding: EdgeInsets.all(size.safeWidth * 0.006),
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
                                size: size.safeWidth * 0.075 + 3,
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
                                    size: size.safeWidth * 0.07,
                                  ),
                                )
                                : Icon(
                                  Icons.local_fire_department_outlined,
                                  color: Color.lerp(
                                    blackColor.withAlpha(200),
                                    blackColor,
                                    _opacity,
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
          ),
          SizedBox(width: size.safeWidth * 0.02),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white54,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/images/icons/share.svg',
                width: size.safeWidth * 0.06,
                height: size.safeWidth * 0.06,
                // ignore: deprecated_member_use
                color: Color.lerp(
                  blackColor.withAlpha(200),
                  blackColor,
                  _opacity,
                ),
              ),
            ),
          ),
          SizedBox(width: size.safeWidth * 0.05),
        ],
        // title: AnimatedOpacity(
        //   opacity: _opacity,
        //   duration: Duration(milliseconds: 300),
        //   child: Text("Movie Title"),
        // ),
        flexibleSpace: Opacity(
          opacity: _opacity,
          child: FlexibleSpaceBar(
            background: Container(color: whiteColor),
            title: Text(
              ' Artist Name',
              style: TextStyle(
                fontSize: size.safeWidth * 0.05,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              width: size.safeWidth,
              height: size.safeHeight * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/temp/poster.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: size.safeHeight * 0.03),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.safeWidth * 0.06,
                    vertical: size.safeWidth * 0.02,
                  ),
                  child: Text(
                    'Artist Name',
                    style: TextStyle(
                      fontSize: size.safeWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.safeHeight * 0.04),
            SizedBox(
              width: size.safeWidth,
              // key: section2Key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.safeWidth * 0.06,
                      bottom: size.safeWidth * 0.06,
                      top: size.safeWidth * 0.03,
                    ),
                    child: Text(
                      'All Events',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: size.safeWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ),
                  artistTile(
                    ' Date (Ticket opened)',
                    ' Event name',
                    ' Venue',
                    ' Price',
                    true,
                  ),
                  artistTile(
                    ' Date (Upcoming)',
                    ' Event name',
                    ' Venue',
                    ' Price',
                    false,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.safeWidth * 0.06,
                      bottom: size.safeWidth * 0.04,
                      top: size.safeWidth * 0.06,
                    ),
                    child: Text(
                      'Playlist',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: size.safeWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.safeWidth * 0.035,
                    ),
                    child: Center(
                      child: Container(
                        width: size.safeWidth * 0.8,
                        height: size.safeHeight * 0.28,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12.withAlpha(20),
                            width: 1,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.45, 1],
                            colors: [
                              gradient1.withAlpha(80),
                              gradient2.withAlpha(80),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.safeWidth * 0.03,
                                      vertical: size.safeWidth * 0.03,
                                    ),
                                    child: Container(
                                      height: size.safeWidth * 0.22,
                                      width: size.safeWidth * 0.22,
                                      decoration: BoxDecoration(
                                        color: greyColor.withAlpha(50),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      // child: Icon(icon, color: Colors.black54, size: size.safeWidth * 0.06),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: size.safeWidth * 0.03,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ' Artist name',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.safeWidth * 0.035,
                                            fontFamily: 'Medium',
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                            size.safeWidth * 0.003,
                                          ),
                                          child: Text(
                                            ' Details',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: size.safeWidth * 0.03,
                                              fontFamily: 'Regular',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                            size.safeWidth * 0.005,
                                          ),
                                          child: Container(
                                            width: size.safeWidth * 0.16,
                                            height: size.safeWidth * 0.05,
                                            decoration: BoxDecoration(
                                              color: blackColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'View more >',
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize:
                                                      size.safeWidth * 0.016,
                                                  fontFamily: 'Regular',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CarouselSlider(
                              items: songSlider,
                              carouselController: _carouselSliderController,
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: Duration(days: 99),
                                enlargeCenterPage: true,
                                height: size.safeHeight * 0.05,
                                viewportFraction: 0.9,
                                enlargeFactor: 0.6,
                                onPageChanged: (index, reason) {
                                  if (mounted) {
                                    setState(() {
                                      _carouselCurrent = index;
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: size.safeWidth * 0.01,
                                bottom: size.safeWidth * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    eventColorSlider.asMap().entries.map((
                                      entry,
                                    ) {
                                      return GestureDetector(
                                        onTap:
                                            () => _carouselSliderController
                                                .animateToPage(entry.key),
                                        child: Container(
                                          width:
                                              _carouselCurrent == entry.key
                                                  ? size.safeWidth * 0.03
                                                  : size.safeWidth * 0.02,
                                          height: size.safeWidth * 0.02,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15.0,
                                            ),
                                            color: (Theme.of(
                                                          context,
                                                        ).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black)
                                                .withAlpha(
                                                  _carouselCurrent == entry.key
                                                      ? 255
                                                      : 100,
                                                ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
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
            SizedBox(height: size.safeHeight * 0.05),
          ],
        ),
      ),
    );
  }

  Padding artistTile(
    String date,
    String name,
    String venue,
    String price,
    bool isLive,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.safeWidth * 0.018),
      child: Center(
        child: Container(
          width: size.safeWidth * 0.8,
          height: size.safeHeight * 0.171,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12.withAlpha(20), width: 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.45, 1],
              colors: [gradient1.withAlpha(80), gradient2.withAlpha(80)],
            ),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.safeWidth * 0.02,
                        vertical: size.safeWidth * 0.02,
                      ),
                      child: Container(
                        height: size.safeWidth * 0.22,
                        width: size.safeWidth * 0.22,
                        decoration: BoxDecoration(
                          color: greyColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // child: Icon(icon, color: Colors.black54, size: size.safeWidth * 0.06),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.safeWidth * 0.01),
                      child: SizedBox(
                        width: size.safeWidth * 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: size.safeWidth * 0.03,
                                fontFamily: 'Medium',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.safeWidth * 0.003),
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.safeWidth * 0.03,
                                  fontFamily: 'Regular',
                                ),
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(
                                        size.safeWidth * 0.003,
                                      ),
                                      child: Text(
                                        venue,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: size.safeWidth * 0.025,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(
                                        size.safeWidth * 0.003,
                                      ),
                                      child: Text(
                                        price,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.safeWidth * 0.025,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                isLive
                                    ? Padding(
                                      padding: EdgeInsets.all(
                                        size.safeWidth * 0.005,
                                      ),
                                      child: Container(
                                        width: size.safeWidth * 0.16,
                                        height: size.safeWidth * 0.05,
                                        decoration: BoxDecoration(
                                          color: blackColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Book Tickets',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: size.safeWidth * 0.018,
                                              fontFamily: 'Regular',
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    : Row(
                                      children: [
                                        StatefulBuilder(
                                          builder: (context, set) {
                                            glowOff() => Future.delayed(
                                              const Duration(milliseconds: 700),
                                              () {
                                                if (context.mounted)
                                                  set(() => isGlowing2 = false);
                                              },
                                            );

                                            return InkWell(
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                              onTap: () {
                                                set(() {
                                                  isSelected2 = !isSelected2;
                                                });
                                                if (isSelected2) {
                                                  isGlowing2 = true;
                                                  glowOff();
                                                }
                                              },
                                              child: Container(
                                                // padding: EdgeInsets.all(size.safeWidth * 0.006),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    AnimatedOpacity(
                                                      opacity:
                                                          isGlowing2 ? 1 : 0,
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .local_fire_department_sharp,
                                                        size:
                                                            size.safeWidth *
                                                                0.06 +
                                                            5,
                                                        color: Colors
                                                            .orangeAccent
                                                            .withOpacity(0.5),
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
                                                    isSelected2
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
                                                              ).createShader(r),
                                                          child: Icon(
                                                            Icons
                                                                .local_fire_department_sharp,
                                                            color: Colors.white,
                                                            size:
                                                                size.safeWidth *
                                                                0.06,
                                                          ),
                                                        )
                                                        : Icon(
                                                          Icons
                                                              .local_fire_department_outlined,
                                                          color: blackColor
                                                              .withAlpha(200),
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
                                        SizedBox(width: size.safeWidth * 0.01),
                                      ],
                                    ),
                              ],
                            ),
                          ],
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
    );
  }

  Padding contentTiles(IconData icon, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.safeWidth * 0.035,
        horizontal: size.safeWidth * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.safeWidth * 0.06),
            child: Container(
              height: size.safeWidth * 0.12,
              width: size.safeWidth * 0.12,
              decoration: BoxDecoration(
                color: greyColor.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.black54,
                size: size.safeWidth * 0.06,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: size.safeWidth * 0.033,
                  fontFamily: 'Regular',
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: size.safeWidth * 0.031,
                  fontFamily: 'Regular',
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
