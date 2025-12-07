import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/pages/view/artists/artistspage.dart';
import 'package:ticpin/pages/view/concerts/concertpage.dart';
import 'package:ticpin/pages/view/dining/restaurentpage.dart';
import 'package:ticpin/pages/view/movies/blockbustermovies.dart';
import 'package:ticpin/pages/view/movies/upcomingmovies/upcomingmovies.dart';
import 'package:ticpin/pages/view/sports/turfpage.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable, camel_case_types
class eventContainer extends StatefulWidget {
  eventContainer({
    super.key,
    required this.isVideo,
    required this.date,
    required this.name,
    required this.loc,
    required this.color,
  });
  bool isVideo;

  String date;
  String name;
  String loc;
  Color color;

  @override
  State<eventContainer> createState() => _eventContainerState();
}

// ignore: camel_case_types
class _eventContainerState extends State<eventContainer> {
  bool isMute = true;
  Sizes size = Sizes();
  late VideoPlayerController _controller;

  @override
  void initState() {
    if (widget.isVideo) {
      _controller = VideoPlayerController.asset('assets/images/temp/video.mp4')
        ..initialize().then((_) {
          setState(() {
            _controller.setVolume(0.0);
            _controller.play();
          });
        });
    }
    super.initState();
  }

  void _handleTap() async {
    if (!mounted) return;
    await Get.to(
      () => Concertpage(
        eventId: widget.name,
        distance: 0.0,
        videoUrl: "",
        // concertId: widget.name,
        // concertName: widget.name,
        // concertDate: widget.date,
        // concertLocation: widget.loc,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = size.safeHeight * 0.7;
    double width = size.safeWidth * 0.8;
    return GestureDetector(
      onTap: _handleTap,
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Container(
                  height: height - size.safeHeight * 0.1,
                  width: width,
                  decoration:
                      widget.isVideo
                          ? BoxDecoration(color: Colors.transparent)
                          : BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                'assets/images/temp/poster.jpg',
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(17),
                              topRight: Radius.circular(17),
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black12,
                                width: 1,
                              ),
                            ),
                            // color: widget.color,
                          ),
                  child:
                      widget.isVideo
                          ? SizedBox(
                            height: height - size.safeHeight * 0.1,
                            width: width,
                            child: VideoPlayer(_controller),
                          )
                          : Padding(
                            padding: EdgeInsets.all(Sizes().width * 0.02),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.all(Sizes().width * 0.02),
                                width: Sizes().width * 0.1,
                                height: Sizes().width * 0.1,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFCFCFFA),
                                ),

                                child: InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        isMute = !isMute;
                                      });
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    isMute
                                        ? 'assets/images/icons/mute.svg'
                                        : 'assets/images/icons/speaker.svg',
                                    width: Sizes().width * 0.04,
                                    height: Sizes().width * 0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                ),
              ),
              Container(
                height: size.safeHeight * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(17),
                    bottomRight: Radius.circular(17),
                  ),
                  border: Border(
                    left: BorderSide(color: Colors.black12, width: 1),
                    right: BorderSide(color: Colors.black12, width: 1),
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                width: width,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width * 0.06,
                          vertical: Sizes().width * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class blockbusterContainer extends StatelessWidget {
  blockbusterContainer({
    super.key,
    required this.date,
    required this.name,
    required this.color,
  });
  String date;
  String name;
  Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(BlockbusterMovie()),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: Sizes().height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                  color: color,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes().width * 0.03,
                    vertical: Sizes().width * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyle(name, Sizes().width * 0.045),
                      customTextStyle(date, Sizes().width * 0.03),
                    ],
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

// ignore: camel_case_types
class artistContainer extends StatelessWidget {
  const artistContainer({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Sizes().width * 0.065),
      child: GestureDetector(
        onTap: () => Get.to(Artistpage()),
        child: Column(
          children: [
            CircleAvatar(
              radius: Sizes().width * 0.15,
              backgroundColor: colors[index],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes().width * 0.03),
              child: customTextStyle('Name', Sizes().width * 0.035),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class offersContainer extends StatelessWidget {
  offersContainer({
    super.key,
    required this.date,
    required this.name,
    required this.color,
    required this.offer,
  });

  final String name;
  Color color;
  final String date;
  final String offer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Sizes().width * 0.055),
      child: Container(
        width: Sizes().width * 0.7,
        // height: Sizes().height * 0.2,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                // height: Sizes().height * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                  color: color,
                ),
              ),
            ),
            Container(
              height: Sizes().width * 0.05,

              decoration: BoxDecoration(
                color: greyColor.withAlpha(50),
                border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child: Center(
                child: Text(
                  offer,
                  style: TextStyle(
                    fontSize: Sizes().width * 0.03,
                    fontFamily: 'Regular',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes().width * 0.03,
                    vertical: Sizes().width * 0.015,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      customTextStyle(name, Sizes().width * 0.035),
                      customTextStyle(date, Sizes().width * 0.02),
                    ],
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

// ignore: must_be_immutable, camel_case_types
class diningContainer extends StatelessWidget {
  diningContainer({
    super.key,
    required this.loc,
    required this.name,
    required this.color,
    required this.offer,
  });

  final String name;
  Color color;
  final String loc;
  final String offer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Sizes().width * 0.045),
      child: GestureDetector(
        onTap: () => Get.to(Restaurentpage()),
        child: Container(
          width: Sizes().width * 0.7,
          // height: Sizes().height * 0.2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  // height: Sizes().height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1),
                    ),
                    color: color,
                  ),
                ),
              ),
              Container(
                height: Sizes().width * 0.05,

                decoration: BoxDecoration(
                  color: greyColor.withAlpha(50),
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child: Center(
                  child: Text(
                    offer,
                    style: TextStyle(
                      fontSize: Sizes().width * 0.03,
                      fontFamily: 'Regular',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes().width * 0.03,
                      vertical: Sizes().width * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        customTextStyle(name, Sizes().width * 0.035),
                        customTextStyle(loc, Sizes().width * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class sportsContainer extends StatelessWidget {
  sportsContainer({
    super.key,
    required this.loc,
    required this.name,
    required this.color,
  });

  final String name;
  Color color;
  final String loc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Sizes().width * 0.045),
      child: GestureDetector(
        onTap: () => Get.to(Turfpage()),
        child: Container(
          width: Sizes().width * 0.9,
          // height: Sizes().height * 0.2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  // height: Sizes().height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 1),
                    ),
                    color: color,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes().width * 0.03,
                      vertical: Sizes().width * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        customTextStyle(name, Sizes().width * 0.04),
                        customTextStyle(loc, Sizes().width * 0.03),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Sizes().width * 0.02,
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blackColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          child: Text(
                            'Book Now',
                            style: TextStyle(
                              color: whiteColor,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Sizes().width * 0.03),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class upcomingContainer extends StatelessWidget {
  upcomingContainer({
    super.key,
    required this.date,
    required this.name,
    required this.color,
  });
  String date;
  String name;
  Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(UpcomingMovie()),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: Sizes().height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                  color: color,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes().width * 0.03,
                    vertical: Sizes().width * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextStyle(name, Sizes().width * 0.045),
                      customTextStyle('coming on $date', Sizes().width * 0.03),
                    ],
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

// ignore: must_be_immutable, camel_case_types
class songContainer extends StatelessWidget {
  songContainer({super.key, required this.song});
  String song;
  Sizes size = Sizes();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.safeWidth * 0.02,
      width: size.safeWidth * 0.7,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: size.safeWidth * 0.04),
            child: Text(
              song,
              style: TextStyle(
                fontSize: Sizes().width * 0.027,
                fontFamily: 'Regular',
                color: blackColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: size.safeWidth * 0.02),
            child: Icon(Icons.play_arrow_rounded, size: size.safeWidth * 0.06),
          ),
        ],
      ),
    );
  }
}

Padding customTextStyle(
  String loc,
  double fontSize, {
  FontWeight? fondWeight = FontWeight.normal,
}) {
  return Padding(
    padding: EdgeInsets.all(Sizes().width * 0.001),
    child: Text(
      loc,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Regular',
        fontWeight: fondWeight,
      ),
    ),
  );
}

// ignore: camel_case_types
class gridViewer extends StatelessWidget {
  const gridViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes().width * 0.028),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 6,

        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: Sizes().height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(17),
                        topRight: Radius.circular(17),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1),
                      ),
                      color: colors[index % colors.length],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes().width * 0.03,
                        vertical: Sizes().width * 0.01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customTextStyle('name', Sizes().width * 0.03),
                          customTextStyle(
                            Temp.eventDate,
                            Sizes().width * 0.022,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ignore: camel_case_types
class SlidingGridViewer extends StatelessWidget {
  const SlidingGridViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes().height * 0.6,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: Sizes().width * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes().width * 0.028),
              child: GridView.builder(
                itemCount: 8,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 8,
                  // crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            height: Sizes().height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(17),
                                topRight: Radius.circular(17),
                              ),
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                              ),
                              color: colors[index % colors.length],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes().width * 0.03,
                                vertical: Sizes().width * 0.01,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextStyle('name', Sizes().width * 0.03),
                                  customTextStyle(
                                    Temp.eventDate,
                                    Sizes().width * 0.022,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: Sizes().width * 0.025),
          ],
        ),
      ),
    );
  }
}
