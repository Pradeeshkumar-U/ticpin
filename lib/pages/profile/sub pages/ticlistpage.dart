import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/models/user/user.dart';
import 'package:ticpin/constants/models/user/userservice.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/home/homepage.dart';
import 'package:ticpin/pages/view/artists/artistspage.dart';
import 'package:ticpin/pages/view/concerts/concertpage.dart';
import 'package:ticpin/pages/view/dining/restaurentpage.dart';
import 'package:ticpin/pages/view/sports/turfpage.dart';

class _TabItem {
  final String label;
  final Widget view;

  _TabItem({required this.label, required this.view});
}

class TicListPage extends StatefulWidget {
  const TicListPage({Key? key}) : super(key: key);

  @override
  State<TicListPage> createState() => _TicListPageState();
}

class _TicListPageState extends State<TicListPage>
    with TickerProviderStateMixin {
  final UserService _userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TabController? _tabController;
  Sizes size = Sizes();
  List<_TabItem> _tabs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(Icons.bookmark, color: Colors.red),
            // SizedBox(width: 8),
            Text('My TicList', style: TextStyle(fontFamily: 'Regular')),
          ],
        ),
        // bottom: TabBar(
        //   controller: _tabController,
        //   labelColor: blackColor,
        //   unselectedLabelColor: Colors.grey,
        //   indicatorColor: blackColor,
        //   isScrollable: true,
        //   labelStyle: TextStyle(
        //     fontFamily: 'Regular',
        //     fontWeight: FontWeight.bold,
        //     fontSize: 14,
        //   ),
        //   tabs: [
        //     Tab(text: 'All'),
        //     Tab(text: 'Events'),
        //     Tab(text: 'Turfs'),
        //     Tab(text: 'Dining'),
        //   ],
        // ),
      ),
      body: StreamBuilder<UserModel?>(
        stream: _userService.getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please login to view your TicList',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Regular',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          final ticList = snapshot.data!.ticList;

          // 🔹 BUILD TABS DYNAMICALLY
          _tabs = [_TabItem(label: 'All', view: _buildAllList(ticList))];

          if (ticList.events.isNotEmpty) {
            _tabs.add(
              _TabItem(label: 'Events', view: _buildEventsList(ticList.events)),
            );
          }

          if (ticList.turfs.isNotEmpty) {
            _tabs.add(
              _TabItem(label: 'Turfs', view: _buildTurfsList(ticList.turfs)),
            );
          }

          if (ticList.dining.isNotEmpty) {
            _tabs.add(
              _TabItem(label: 'Dining', view: _buildDiningList(ticList.dining)),
            );
          }

          if (ticList.artists.isNotEmpty) {
            _tabs.add(
              _TabItem(
                label: 'Artists',
                view: _buildArtistsList(ticList.artists),
              ),
            );
          }

          if (_tabController == null ||
              _tabController!.length != _tabs.length) {
            _tabController?.dispose();
            _tabController = TabController(length: _tabs.length, vsync: this);
          }

          return Column(
            children: [
              Material(
                color: whiteColor,
                child: TabBar(
                  splashFactory: NoSplash.splashFactory,
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: blackColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: blackColor,
                  labelStyle: const TextStyle(
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs.map((t) => t.view).toList(),
                ),
              ),
            ],
          );
        },
      ),

      // body: StreamBuilder<UserModel?>(
      //   stream: _userService.getUserDataStream(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }

      //     if (!snapshot.hasData || snapshot.data == null) {
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(
      //               Icons.bookmark_border,
      //               size: 80,
      //               color: Colors.grey.shade300,
      //             ),
      //             SizedBox(height: 16),
      //             Text(
      //               'Please login to view your TicList',
      //               style: TextStyle(
      //                 fontSize: 16,
      //                 fontFamily: 'Regular',
      //                 color: Colors.grey.shade600,
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     }

      //     final ticList = snapshot.data!.ticList;
      //     // 🔹 BUILD TABS DYNAMICALLY
      //     _tabs = [_TabItem(label: 'All', view: _buildAllList(ticList))];

      //     if (ticList.events.isNotEmpty) {
      //       _tabs.add(
      //         _TabItem(label: 'Events', view: _buildEventsList(ticList.events)),
      //       );
      //     }

      //     if (ticList.turfs.isNotEmpty) {
      //       _tabs.add(
      //         _TabItem(label: 'Turfs', view: _buildTurfsList(ticList.turfs)),
      //       );
      //     }

      //     if (ticList.dining.isNotEmpty) {
      //       _tabs.add(
      //         _TabItem(label: 'Dining', view: _buildDiningList(ticList.dining)),
      //       );
      //     }

      //     if (ticList.artists.isNotEmpty) {
      //       _tabs.add(
      //         _TabItem(
      //           label: 'Artists',
      //           view: _buildArtistsList(ticList.artists),
      //         ),
      //       );
      //     }

      //     _tabController = TabController(length: _tabs.length, vsync: this);

      //     return TabBarView(
      //       controller: _tabController,
      //       children: [
      //         _buildAllList(ticList),
      //         _buildEventsList(ticList.events),
      //         _buildTurfsList(ticList.turfs),
      //         _buildDiningList(ticList.dining),
      //       ],
      //     );
      //   },
      // ),
    );
  }

  Widget _buildAllList(TicList ticList) {
    final totalCount = ticList.totalCount;

    if (totalCount == 0) {
      return _buildEmptyState('Your TicList is empty', Icons.bookmark_border);
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        if (ticList.events.isNotEmpty) ...[
          _buildSectionHeader('Events', ticList.events.length),
          SizedBox(height: 12),
          ...ticList.events.take(3).map((id) => _buildEventItem(id)),
          if (ticList.events.length > 3)
            TextButton(
              onPressed: () => _tabController?.animateTo(1),
              child: Text(
                'View all events',
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ),
          SizedBox(height: 16),
        ],
        if (ticList.turfs.isNotEmpty) ...[
          _buildSectionHeader('Turfs', ticList.turfs.length),
          SizedBox(height: 12),
          ...ticList.turfs.take(3).map((id) => _buildTurfItem(id)),
          if (ticList.turfs.length > 3)
            TextButton(
              onPressed: () => _tabController?.animateTo(2),
              child: Text(
                'View all turfs',
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ),
          SizedBox(height: 16),
        ],
        if (ticList.dining.isNotEmpty) ...[
          _buildSectionHeader('Dining', ticList.dining.length),
          SizedBox(height: 12),
          ...ticList.dining.take(3).map((id) => _buildDiningItem(id)),
          if (ticList.dining.length > 3)
            TextButton(
              onPressed: () => _tabController?.animateTo(3),
              child: Text(
                'View all restaurants',
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Regular',
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsList(List<String> eventIds) {
    if (eventIds.isEmpty) {
      return _buildEmptyState('No events saved yet', Icons.event);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: eventIds.length,
      itemBuilder: (context, index) => _buildEventItem(eventIds[index]),
    );
  }

  Widget _buildTurfsList(List<String> turfIds) {
    if (turfIds.isEmpty) {
      return _buildEmptyState('No turfs saved yet', Icons.sports_soccer);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: turfIds.length,
      itemBuilder: (context, index) => _buildTurfItem(turfIds[index]),
    );
  }

  Widget _buildDiningList(List<String> diningIds) {
    if (diningIds.isEmpty) {
      return _buildEmptyState('No restaurants saved yet', Icons.restaurant);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: diningIds.length,
      itemBuilder: (context, index) => _buildDiningItem(diningIds[index]),
    );
  }

  Widget _buildArtistsList(List<String> artistsIds) {
    if (artistsIds.isEmpty) {
      return _buildEmptyState('No artists saved yet', Icons.person);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: artistsIds.length,
      itemBuilder: (context, index) => _buildDiningItem(artistsIds[index]),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start exploring and save your favorites!',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Regular',
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String eventId) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('events').doc(eventId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final media = data['media'] as Map<String, dynamic>? ?? {};
        final imageUrl =
            media['posterLink'] ??
            (media['galleryImages'] as List?)?.firstOrNull ??
            '';

        return _buildItemCard(
          type: TicListItemType.event,
          imageUrl: imageUrl,
          title: data['name'] ?? 'Unnamed Event',
          subtitle: data['venue']?['name'] ?? 'No venue',
          date: _formatEventDate(data),
          location: data['venue']?['name'] ?? '',
          color: Colors.blue,
          icon: Icons.event,
          onTap: () {
            Get.to(() => Concertpage(eventId: eventId));
          },
          onRemove: () async {
            await _userService.removeFromTicList(
              eventId,
              TicListItemType.event,
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from TicList'),
                backgroundColor: Colors.orange,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTurfItem(String turfId) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('turfs').doc(turfId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final imageUrl = (data['poster_urls'] as List?)?.firstOrNull ?? '';

        return _buildItemCard(
          type: TicListItemType.turf,
          imageUrl: imageUrl,
          title: data['name'] ?? 'Unnamed Turf',
          subtitle: data['location'] ?? 'No location',
          location: data['location'] ?? '',
          color: Colors.green,
          icon: Icons.sports_soccer,
          onTap: () {
            Get.to(() => Turfpage(turfId: turfId));
          },
          onRemove: () async {
            await _userService.removeFromTicList(turfId, TicListItemType.turf);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from TicList'),
                backgroundColor: Colors.orange,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDiningItem(String diningId) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('dining').doc(diningId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final images = data['images'] as Map<String, dynamic>? ?? {};
        final imageUrl =
            (images['carousel'] as List?)?.firstOrNull ??
            (images['about'] as List?)?.firstOrNull ??
            (images['menu'] as List?)?.firstOrNull ??
            '';

        final locationMap = data['location'] as Map<String, dynamic>? ?? {};
        final locationName = locationMap['name'] ?? '';

        final filters = data['filters'] as Map<String, dynamic>? ?? {};
        final cuisines =
            (filters['cuisines'] as List?)?.join(', ') ?? 'Restaurant';

        return _buildItemCard(
          type: TicListItemType.dining,
          imageUrl: imageUrl,
          title: data['name'] ?? 'Unnamed Restaurant',
          subtitle: cuisines,
          location: locationName,
          color: Colors.orange,
          icon: Icons.restaurant,
          onTap: () {
            Get.to(() => Restaurentpage(diningId: diningId));
          },
          onRemove: () async {
            await _userService.removeFromTicList(
              diningId,
              TicListItemType.dining,
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from TicList'),
                backgroundColor: Colors.orange,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildArtistItem(String artistId) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('artists').doc(artistId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        return _buildItemCard(
          type: TicListItemType.artist,
          imageUrl: data['imageUrl'] ?? '',
          title: data['name'] ?? 'Unknown Artist',
          subtitle: data['genre'] ?? 'Artist',
          color: Colors.purple,
          icon: Icons.mic,
          onTap: () {
            Get.to(
              () => Artistpage(
                // artistId: artistId
              ),
            );
          },
          onRemove: () async {
            await _userService.removeFromTicList(
              artistId,
              TicListItemType.artist,
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from TicList'),
                backgroundColor: Colors.orange,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItemCard({
    String? imageUrl,
    TicListItemType? type,
    required String title,
    required String subtitle,
    String? date,
    String? location,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 12),
        // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              // child: Image.network(
              //   result.imageUrl!,
              //   width: 100,
              //   height: 100,
              //   fit: BoxFit.cover,
              //   errorBuilder: (context, error, stackTrace) {
              //     return _buildPlaceholderImage(result.type);
              //   },
              // ),
              child:
                  imageUrl != null
                      ? Image.network(
                        imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(type!);
                        },
                      )
                      : _buildPlaceholder(type!),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular',
                            color: blackColor,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getTypeLabel(type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                              color: _getTypeColor(type),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),

                    // Subtitle
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Regular',
                        color: Colors.grey.shade600,
                      ),
                    ),

                    // Additional info for events
                    if (type == TicListItemType.event) ...[
                      SizedBox(height: 6),
                      Row(
                        children: [
                          if (date != null && date.isNotEmpty) ...[
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                          if (location != null && location.isNotEmpty) ...[
                            if (date != null && date.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '•',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],

                    // Location for turfs and dining
                    if ((type == TicListItemType.turf ||
                            type == TicListItemType.dining) &&
                        location != null &&
                        location.isNotEmpty) ...[
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(TicListItemType type) {
    switch (type) {
      case TicListItemType.event:
        return Colors.blue;
      case TicListItemType.turf:
        return Colors.green;
      case TicListItemType.artist:
        return Colors.purple;
      case TicListItemType.dining:
        return Colors.orange;
    }
  }

  String _getTypeLabel(TicListItemType type) {
    switch (type) {
      case TicListItemType.event:
        return 'EVENT';
      case TicListItemType.turf:
        return 'TURF';
      case TicListItemType.artist:
        return 'ARTIST';
      case TicListItemType.dining:
        return 'DINING';
    }
  }

  IconData _getTypeIcon(TicListItemType type) {
    switch (type) {
      case TicListItemType.event:
        return Icons.celebration;
      case TicListItemType.turf:
        return Icons.sports_soccer;
      case TicListItemType.artist:
        return Icons.person;
      case TicListItemType.dining:
        return Icons.restaurant_menu;
    }
  }

  Widget _buildPlaceholder(TicListItemType type) {
    Color color = _getTypeColor(type);
    IconData icon = _getTypeIcon(type);
    return Container(
      width: 70,
      height: 70,
      color: color.withOpacity(0.1),
      child: Icon(icon, size: 40, color: color),
    );
  }

  String _formatEventDate(Map<String, dynamic> data) {
    try {
      if (data['startDate'] != null) {
        final timestamp = data['startDate'] as Timestamp;
        final date = timestamp.toDate();
        return '${date.day} ${_getMonthName(date.month)}';
      }
    } catch (e) {
      print('Error formatting date: $e');
    }
    return '';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
