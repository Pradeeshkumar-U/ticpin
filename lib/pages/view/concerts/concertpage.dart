import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/event/eventfull.dart';
import 'package:ticpin/constants/services.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticpin/constants/temporary.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/services/controllers/videoController.dart';
import 'package:ticpin/services/places.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class Concertpage extends StatefulWidget {
  const Concertpage({
    super.key,
    required this.eventId,
    required this.distance,
    required this.videoUrl,
  });
  final String eventId;
  final double distance;
  final String videoUrl;

  @override
  State<Concertpage> createState() => _ConcertpageState();
}

class _ConcertpageState extends State<Concertpage>
    with TickerProviderStateMixin {
  final EventController controller = Get.find<EventController>();

  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  final GlobalKey section1Key = GlobalKey();
  final GlobalKey section2Key = GlobalKey();
  final GlobalKey section3Key = GlobalKey();
  final GlobalKey section4Key = GlobalKey();

  double _opacity = 0.0;
  int _carouselCurrent = 0;
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

  String? videoError;
  final soundCtrl = Get.find<VideoSoundController>();
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  Widget _videoPlayerContainer(double width, double height) {
    // If error exists
    if (videoError != null) {
      return SizedBox(
        height: size.height,
        width: size.width,
        child: Center(
          child: Text(
            'Failed to load video',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Not initialized yet → show loader
    if (!_isVideoInitialized || _videoController == null) {
      return SizedBox(
        child: LoadingShimmer(
          width: size.width,
          height: size.height,
          isCircle: false,
        ),
      );
    }

    // Video Aspect Ratio
    // final videoSize = _videoController!.value.size;
    // final aspectRatio = videoSize.width / videoSize.height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: size.height,
        width: size.width,
        // width: size.safeWidth * 0.8,
        // height: (size.safeWidth * 0.9) * (2.6 / 2),
        child: Stack(
          children: [
            /// *** MAIN VIDEO ***
            // AspectRatio(
            //   aspectRatio: aspectRatio,
            //   child: VideoPlayer(_videoController!),
            // ),
            VideoPlayer(_videoController!),

            /// *** CENTER PLAY/PAUSE BUTTON ***
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
                child: AnimatedOpacity(
                  opacity: _videoController!.value.isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.play_arrow,
                      size: 50,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),

            /// *** MUTE BUTTON (top right) ***
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    soundCtrl.isMuted.value
                        ? Icons.volume_off
                        : Icons.volume_up,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    soundCtrl.toggleMute();
                    _videoController!.setVolume(
                      soundCtrl.isMuted.value ? 0 : 1,
                    );
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();

  EventFull? _event;
  bool _isLoading = true;
  bool _hasError = false;

  String formatAddress(String input) {
    // Split by newline
    List<String> lines =
        input.split('\n').where((e) => e.trim().isNotEmpty).toList();

    if (lines.length <= 3) {
      return lines.join('\n'); // nothing to merge
    }

    // Merge first 2 lines with comma
    String mergedFirstLine = "${lines[0]}, ${lines[1]}";

    // Keep next lines normally
    List<String> finalLines = [mergedFirstLine, lines[2], lines[3]];

    return finalLines.join('\n');
  }

  Future<void> initVideo() async {
    try {
      await _videoController!.initialize();
      _videoController!.setLooping(false);
      // Set volume **only once** after initialization
      if (!_isVideoInitialized) {
        _videoController!.setVolume(soundCtrl.isMuted.value ? 0 : 1);
      }

      setState(() {
        _isVideoInitialized = true;
        videoError = null;
      });
    } catch (e) {
      setState(() => videoError = e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEventData();

    if (widget.videoUrl != "") {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      initVideo();
    }

    _tabController = TabController(length: 4, vsync: this);

    _scrollController.addListener(() {
      _onScroll().then((sectionkey) {
        setState(() {});
      });
      double offset = _scrollController.offset;

      // Adjust this value depending on when you want the title to fade in
      double fadeStart = size.height * 0.01;
      double fadeEnd = size.height * 0.03;

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

  int _currentCarouselIndex = 0;

  Future<void> _loadEventData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Load from cache or Firestore
      final event = await controller.loadEventFull(widget.eventId);

      if (mounted) {
        setState(() {
          _event = event;
          _isLoading = false;
          _hasError = event == null;
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

  bool isSelected = false;
  bool isGlowing = false;
  @override
  void dispose() {
    _tabController.dispose();
    _videoController?.dispose();
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

  Sizes size = Sizes();
  @override
  Widget build(BuildContext context) {
    final wid = size.safeWidth * 0.9;

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError || _event == null) {
      return _buildErrorState();
    }

    final event = _event!;

    final List<List> tabs = [
      ['About', section1Key],
      ['Artist', section2Key],
      ['Gallery', section3Key],
      ['Venue', section4Key],
    ];
    bool galleryEnabled = _event!.galleryImages.isNotEmpty;

    final formattedDate = DateFormat(
      'EEEE, d MMM',
    ).format(event.firstDate!.toLocal());

    final formattedTime = DateFormat(
      'h:mm a',
    ).format(event.firstDate!.toLocal());

    return Scaffold(
      backgroundColor: whiteColor,

      body: Stack(
        children: [
          Opacity(
            opacity: 1 - _opacity,
            child: Container(
              // height: size.height * 0.11,
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              width: size.safeWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(colors: [gradient1, gradient2]),
              ),
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_sharp,
                    color: Color.lerp(whiteColor, blackColor, _opacity),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                backgroundColor: Color.lerp(
                  Colors.transparent,
                  whiteColor,
                  _opacity,
                ),
                surfaceTintColor: Colors.transparent,
                pinned: true,
                floating: false,
                // toolbarHeight: size.height * 0.07,
                // expandedHeight: size.height * 0.07,
                automaticallyImplyLeading: true,

                actions: [
                  // SvgPicture.asset(
                  //   'assets/images/icons/fire.svg',
                  //   width: size.safeWidth * 0.06,
                  //   height: size.safeWidth * 0.07,
                  //   color: Color.lerp(whiteColor, blackColor, _opacity),
                  // ),
                  StatefulBuilder(
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
                          padding: EdgeInsets.all(wid * 0.01),
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
                                  size: wid * 0.075 + 3,
                                  color: Colors.orangeAccent.withOpacity(0.5),
                                  shadows: [
                                    Shadow(
                                      color: Colors.orangeAccent.withOpacity(
                                        0.8,
                                      ),
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
                                      size: wid * 0.075,
                                    ),
                                  )
                                  : Icon(
                                    Icons.local_fire_department_outlined,
                                    color: Color.lerp(
                                      whiteColor.withAlpha(230),
                                      blackColor.withAlpha(200),
                                      _opacity,
                                    ),
                                    size: wid * 0.075,
                                  ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(width: size.safeWidth * 0.02),
                  SvgPicture.asset(
                    'assets/images/icons/share.svg',
                    width: size.safeWidth * 0.06,
                    height: size.safeWidth * 0.06,
                    color: Color.lerp(whiteColor, blackColor, _opacity),
                  ),
                  SizedBox(width: size.safeWidth * 0.05),
                ],
                // title: AnimatedOpacity(
                //   opacity: _opacity,
                //   duration: Duration(milliseconds: 300),
                //   child: Text("Movie Title"),
                // ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    event.name,
                    style: TextStyle(
                      fontSize: size.safeWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                      color: Color.lerp(
                        Colors.transparent,
                        blackColor,
                        _opacity,
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    // Poster and other widgets
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(17),
                    //   child: Container(
                    //     width: size.safeWidth * 0.8,
                    //     height: (size.safeWidth * 0.8) * (2.6 / 2),
                    //     decoration: BoxDecoration(
                    //       // image: DecorationImage(
                    //       //   image: AssetImage(
                    //       //     'assets/images/temp/poster.jpg',
                    //       //   ),
                    //       //   fit: BoxFit.fill,
                    //       // ),
                    //     ),
                    //     child: Image.network(
                    //       event.posterUrl,
                    //       fit: BoxFit.fill,
                    //       errorBuilder:
                    //           (context, error, stackTrace) =>
                    //               const Center(child: Text("Invalid Image")),
                    //       loadingBuilder:
                    //           (context, child, loadingProgress) =>
                    //               loadingProgress == null
                    //                   ? child
                    //                   : LoadingShimmer(
                    //                     height: size.height,
                    //                     width: size.width,
                    //                     isCircle: false,
                    //                     radius: 0,
                    //                   ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: size.height * 0.03),
                    // _videoPlayerContainer(
                    //   size.safeWidth * 0.8,
                    //   (size.safeWidth * 0.8) * (2.6 / 2),
                    // ),
                    (widget.videoUrl != "")
                        ? Column(
                          children: [
                            CarouselSlider(
                              items: [
                                // -------- Poster Image --------
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.safeWidth * 0.05,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(17),
                                    child: SizedBox(
                                      height: size.height,
                                      width: size.width,
                                      child: Image.network(
                                        event.posterUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                                  child: Text("Invalid Image"),
                                                ),
                                        loadingBuilder:
                                            (context, child, loadingProgress) =>
                                                loadingProgress == null
                                                    ? child
                                                    : LoadingShimmer(
                                                      height: size.height,
                                                      width: size.width,
                                                      isCircle: false,
                                                      radius: 0,
                                                    ),
                                      ),
                                    ),
                                  ),
                                ),

                                // -------- Video Container --------
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.safeWidth * 0.05,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(17),
                                    child: _videoPlayerContainer(
                                      size.safeWidth,
                                      size.safeHeight,
                                    ),
                                  ),
                                ),
                              ],
                              options: CarouselOptions(
                                // height:

                                //     _currentCarouselIndex == 0
                                //         ? (size.safeWidth * 0.8) * (2.6 / 2)
                                //         : (size.safeWidth) * (2.6 / 2),
                                viewportFraction: 1,
                                // aspectRatio: 24.0 / 36.0,
                                // enlargeFactor: 0.2,
                                height: (size.width * 0.9) * (36 / 24),
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentCarouselIndex = index;
                                  });
                                },
                              ),
                            ),

                            SizedBox(height: 10),

                            // =================== INDICATOR ===================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                2,
                                (index) => AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width:
                                      _currentCarouselIndex == index ? 10 : 7,
                                  height:
                                      _currentCarouselIndex == index ? 10 : 7,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        _currentCarouselIndex == index
                                            ? Colors.black87
                                            : Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.safeWidth * 0.05,
                          ),
                          child: AspectRatio(
                            aspectRatio: 24.0 / 36.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Container(
                                // width: size.safeWidth * 0.8,
                                // height: (size.safeWidth * 0.8) * (2.6 / 2),
                                decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //   image: AssetImage(
                                  //     'assets/images/temp/poster.jpg',
                                  //   ),
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                                child: Image.network(
                                  event.posterUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Center(
                                            child: Text("Invalid Image"),
                                          ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          loadingProgress == null
                                              ? child
                                              : LoadingShimmer(
                                                height: size.height,
                                                width: size.width,
                                                isCircle: false,
                                                radius: 0,
                                              ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      event.name,
                      style: TextStyle(
                        fontSize: size.safeWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Regular',
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Container(
                      width: size.safeWidth * 0.8,
                      // height: size.height * 0.16,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.safeWidth * 0.01),
                              child: Text(
                                "$formattedDate • $formattedTime",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.safeWidth * 0.032,
                                  fontFamily: 'Regular',
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(size.safeWidth * 0.01),
                              child: Text(
                                'Gate opens at 6 PM',
                                style: TextStyle(
                                  color: Colors.black12.withAlpha(80),
                                  fontSize: size.safeWidth * 0.025,
                                  fontFamily: 'Regular',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.safeWidth * 0.5,
                              child: Divider(
                                thickness: 1.2,
                                color: Colors.black12.withAlpha(30),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                      size.safeWidth * 0.005,
                                    ),
                                    child: Text(
                                      event.venueName,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.safeWidth * 0.032,
                                        fontFamily: 'Semibold',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                      size.safeWidth * 0.005,
                                    ),
                                    child: Text(
                                      formatAddress(event.venueAddress),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: size.safeWidth * 0.03,
                                        fontFamily: 'Regular',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                      size.safeWidth * 0.01,
                                    ),
                                    child: Text(
                                      '${widget.distance.toStringAsFixed(2)} kms away',
                                      style: TextStyle(
                                        color: Colors.black12.withAlpha(60),
                                        fontSize: size.safeWidth * 0.025,
                                        fontFamily: 'Regular',
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
                    SizedBox(height: size.height * 0.04),
                  ],
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  child: Container(
                    color: whiteColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.01 * size.safeWidth,
                      vertical: 8,
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(),
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
                      tabs: List.generate(
                        tabs.length,
                        (index) => Center(
                          child: concertElevatedButton(
                            tabs[index][0],
                            tabs[index][1],
                            index,
                            index != 2 || galleryEnabled,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      width: size.safeWidth,
                      key: section1Key,

                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.safeWidth * 0.06,
                              vertical: size.safeWidth * 0.04,
                            ),
                            child: Text(
                              'About',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: size.safeWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ),
                          contentTiles(
                            Icons.translate_rounded,
                            'Language',
                            event.languages.join(', '),
                          ),
                          contentTiles(
                            Icons.timer_rounded,
                            'Duration',
                            '${(event.days.single.endTime).hour - (event.days.single.startTime).hour} Hours',
                          ),
                          contentTiles(
                            CupertinoIcons.tickets_fill,
                            'Tickets needed for',
                            event.ticketRequiredAge,
                          ),
                          contentTiles(
                            Icons.info_rounded,
                            'Entry allowed for',
                            event.ageRestriction == "None"
                                ? "All ages"
                                : event.ageRestriction,
                          ),
                          contentTiles(
                            Icons.info_rounded,
                            'Layout',
                            event.layout,
                          ),
                          contentTiles(
                            Icons.chair,
                            'Seating arrangement',
                            "",
                            // event.tickets.single.seatingType,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.safeWidth,
                      key: section2Key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.safeWidth * 0.06,
                              vertical: size.safeWidth * 0.04,
                            ),
                            child: Text(
                              'Artist',
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
                                height: size.height * 0.28,
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
                                      // Color(0xFF2cd5d9).withAlpha(30),
                                      // Color(0xff2323ff).withAlpha(30),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                  ' ${event.artistLineup.first}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        size.safeWidth * 0.035,
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
                                                      fontSize:
                                                          size.safeWidth * 0.03,
                                                      fontFamily: 'Regular',
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                    size.safeWidth * 0.005,
                                                  ),
                                                  child: Container(
                                                    width:
                                                        size.safeWidth * 0.16,
                                                    height:
                                                        size.safeWidth * 0.05,
                                                    decoration: BoxDecoration(
                                                      color: blackColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'View more >',
                                                        style: TextStyle(
                                                          color: whiteColor,
                                                          fontSize:
                                                              size.safeWidth *
                                                              0.016,
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
                                      carouselController:
                                          _carouselSliderController,
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        autoPlayInterval: Duration(days: 99),
                                        enlargeCenterPage: true,
                                        height: size.height * 0.05,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            eventColorSlider.asMap().entries.map((
                                              entry,
                                            ) {
                                              return GestureDetector(
                                                onTap:
                                                    () =>
                                                        _carouselSliderController
                                                            .animateToPage(
                                                              entry.key,
                                                            ),
                                                child: Container(
                                                  width:
                                                      _carouselCurrent ==
                                                              entry.key
                                                          ? size.safeWidth *
                                                              0.03
                                                          : size.safeWidth *
                                                              0.02,
                                                  height: size.safeWidth * 0.02,
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 4.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15.0,
                                                        ),
                                                    color: (Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black)
                                                        .withAlpha(
                                                          _carouselCurrent ==
                                                                  entry.key
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
                    (event.galleryImages.isEmpty)
                        ? SizedBox.shrink()
                        : SizedBox(
                          key: section3Key,
                          width: size.safeWidth,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.safeWidth * 0.06,
                                  right: size.safeWidth * 0.06,
                                  top: size.safeWidth * 0.04,
                                  bottom: size.safeWidth * 0.01,
                                ),
                                child: Text(
                                  'Gallery',
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
                                  horizontal: size.safeWidth * 0.06,
                                ),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: event.galleryImages.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                    left: size.safeWidth * 0.03,
                                    right: size.safeWidth * 0.03,
                                    top: size.safeWidth * 0.05,
                                    bottom: size.safeWidth * 0.05,
                                  ),

                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: size.safeWidth * 0.06,
                                        mainAxisSpacing: size.safeWidth * 0.06,
                                      ),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: greyColor.withAlpha(50),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(17),
                                        child: Image.network(
                                          event.galleryImages[index],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Center(
                                                    child: Text(
                                                      "Invalid Image",
                                                    ),
                                                  ),
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) =>
                                                  loadingProgress == null
                                                      ? child
                                                      : LoadingShimmer(
                                                        height: size.height,
                                                        width: size.width,
                                                        isCircle: false,
                                                        radius: 0,
                                                      ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    SizedBox(
                      key: section4Key,
                      width: size.safeWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: size.safeWidth * 0.06,
                              right: size.safeWidth * 0.06,
                              // top: size.safeWidth * 0.04,
                              bottom: size.safeWidth * 0.01,
                            ),
                            child: Text(
                              'Venue',
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
                                padding: EdgeInsets.symmetric(
                                  vertical: size.safeWidth * 0.035,
                                ),
                                width: size.safeWidth * 0.8,
                                // height: size.height * 0.08,
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
                                      // Color(0xFF2cd5d9).withAlpha(30),
                                      // Color(0xff2323ff).withAlpha(30),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    // left: size.safeWidth * 0.035,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: size.safeWidth * 0.02,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.safeWidth * 0.02,
                                          ),
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.safeWidth * 0.6,
                                          child: Text(
                                            event.venueName,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: size.safeWidth * 0.035,
                                              fontFamily: 'Medium',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.safeWidth * 0.6,
                                          child: Text(
                                            formatAddress(event.venueAddress),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: size.safeWidth * 0.03,
                                              fontFamily: 'Regular',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: size.safeWidth * 0.02,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              openMapLink(event.mapsLink);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    size.safeWidth * 0.03,
                                                vertical:
                                                    size.safeWidth * 0.015,
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
                                                  fontSize:
                                                      size.safeWidth * 0.025,
                                                  fontFamily: 'Regular',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //     right: size.safeWidth * 0.035,
                                        //   ),
                                        //   child: Container(
                                        //     // width: size.safeWidth * 0.18,
                                        //     // height: size.safeWidth * 0.05,
                                        //     decoration: BoxDecoration(
                                        //       color: blackColor,
                                        //       borderRadius: BorderRadius.all(
                                        //         Radius.circular(8),
                                        //       ),
                                        //     ),
                                        //     child: Center(
                                        //       child: Padding(
                                        //         padding: const EdgeInsets.all(
                                        //           8.0,
                                        //         ),
                                        //         child: Text(
                                        //           'get directions >',
                                        //           style: TextStyle(
                                        //             color: whiteColor,
                                        //             fontSize:
                                        //                 size.safeWidth * 0.016,
                                        //             fontFamily: 'Regular',
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.safeWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: size.safeWidth * 0.06,
                              right: size.safeWidth * 0.06,
                              top: size.safeWidth * 0.03,
                              bottom: size.safeWidth * 0.05,
                            ),
                            child: Text(
                              'More',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: size.safeWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ),

                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  horizon_cont(
                                    "Frequently Asked Questions",
                                    Icon(
                                      CupertinoIcons.question_circle_fill,
                                      color: Colors.black54,
                                    ),
                                    Navigator(),
                                    wid,
                                  ),
                                  Container(
                                    height: 1.5,
                                    color: Colors.black26,
                                    width: wid * 0.8,
                                  ),
                                  horizon_cont(
                                    "Terms and Conditions",
                                    Icon(
                                      Icons.event_note_rounded,
                                      color: Colors.black54,
                                    ),
                                    Navigator(),
                                    wid,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      padding: EdgeInsets.only(top: 12),
                      width: size.safeWidth * 0.82,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(width: size.safeWidth * 0.05),
                              CircleAvatar(
                                radius: size.safeWidth * 0.1,
                                // backgroundImage: AssetImage(
                                //   "assets/image/ar_rahman.jpeg",
                                // ),
                                backgroundColor: Colors.black54,
                              ),
                              // SizedBox(width: size.safeWidth * 0.05),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "OrganisationName",
                                  style: TextStyle(
                                    // fontSize: fs,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 10,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              height: 0.5,
                              color: Colors.black,
                              margin: EdgeInsets.only(top: 15),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Events Organised",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Medium',
                                    ),
                                  ),
                                  Text(
                                    "20",
                                    style: TextStyle(fontFamily: 'Regular'),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  width: 0.5,
                                  height: size.height * 0.09,
                                  color: Colors.black,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Experience",
                                    style: TextStyle(
                                      fontFamily: 'Medium',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "2 years",
                                    style: TextStyle(fontFamily: 'Regular'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.15),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.1,
              width: size.safeWidth,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border(top: BorderSide(color: blackColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.08),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Starts from',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.safeWidth * 0.03,
                            fontFamily: 'Regular',
                          ),
                        ),
                        Text(
                          ' Rupees',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.safeWidth * 0.035,
                            fontFamily: 'Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.safeWidth * 0.08),
                    child: Container(
                      width: size.safeWidth * 0.26,
                      height: size.safeWidth * 0.08,
                      decoration: BoxDecoration(
                        color: blackColor,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Center(
                        child: Text(
                          'Book Tickets',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: size.safeWidth * 0.03,
                            fontFamily: 'Regular',
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

  // OPTIMIZATION: Separate loading state widget
  Widget _buildLoadingState() {
    return Scaffold(
      body: Container(
        color: whiteColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [gradient1, gradient2],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.1,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingShimmer(
                        width: size.safeWidth * 0.45,
                        height: size.safeWidth * 0.08,
                        isCircle: false,
                        baseColor: whiteColor.withAlpha(50),
                        highColor: whiteColor.withAlpha(30),
                      ),
                      LoadingShimmer(
                        width: size.safeWidth * 0.2,
                        height: size.safeWidth * 0.08,
                        isCircle: false,
                        baseColor: whiteColor.withAlpha(50),
                        highColor: whiteColor.withAlpha(30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      LoadingShimmer(
                        width: size.safeWidth * 0.8,
                        height: size.safeHeight * 0.55,
                        isCircle: false,
                      ),
                      SizedBox(height: 20),
                      LoadingShimmer(
                        width: size.safeWidth * 0.6,
                        height: size.safeWidth * 0.1,
                        isCircle: false,
                      ),
                      SizedBox(height: 20),
                      LoadingShimmer(
                        width: size.safeWidth * 0.8,
                        height: size.safeHeight * 0.3,
                        isCircle: false,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 20,
                      ),
                    ],
                  ),
                ),
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
          'Event Not Found',
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
              'Unable to load event details',
              style: TextStyle(fontSize: 18, fontFamily: 'Regular'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _loadEventData(); // Retry loading
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

  Future<void> _onScroll() async {
    List<Map<String, dynamic>> sections = [
      {'key': section1Key, 'index': 0},
      {'key': section2Key, 'index': 1},
      {'key': section3Key, 'index': 2},
      {'key': section4Key, 'index': 3},
    ];

    for (var section in sections) {
      final keyContext = section['key'].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero, ancestor: null).dy;

        if (position <= size.height * 0.5 && position >= -box.size.height / 5) {
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

  int _selectedIndex = 0;
  ElevatedButton concertElevatedButton(
    String label,
    GlobalKey sectionKey,
    int index,
    bool enabled,
  ) {
    bool isSelected = _selectedIndex == index;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        fixedSize: Size.fromWidth(size.safeWidth * 0.2),
        elevation: 0,

        padding: EdgeInsets.all(size.safeWidth * 0.02),
        backgroundColor: (isSelected ? gradient1.withAlpha(80) : whiteColor),
        // side: BorderSide(color: Colors.black12.withAlpha(30), width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
      onPressed: () {
        // update tab highlight
        enabled
            ? scrollToSection(sectionKey).then((_) {
              _tabController.animateTo(index);
            })
            : null;
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: size.safeWidth * 0.03,
          fontFamily: 'Regular',
          color: enabled ? Colors.black : greyColor.withAlpha(50),
        ),
      ),
    );
  }
}

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
  double get maxExtent =>
      child is PreferredSizeWidget
          ? (child as PreferredSizeWidget).preferredSize.height
          : kToolbarHeight;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
