import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/shimmer.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/concerts/concertpage.dart';
import 'package:ticpin/pages/view/dining/restaurentpage.dart';
import 'package:ticpin/pages/view/sports/turfpage.dart';

class UniversalSearchPage extends StatefulWidget {
  const UniversalSearchPage({Key? key}) : super(key: key);

  @override
  State<UniversalSearchPage> createState() => _UniversalSearchPageState();
}

class _UniversalSearchPageState extends State<UniversalSearchPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;
  Sizes size = Sizes();

  String searchQuery = '';
  bool isSearching = false;

  List<SearchResult> allResults = [];
  List<SearchResult> eventsResults = [];
  List<SearchResult> turfsResults = [];
  List<SearchResult> artistsResults = [];
  List<SearchResult> diningResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchQuery = '';
        allResults = [];
        eventsResults = [];
        turfsResults = [];
        artistsResults = [];
        diningResults = [];
      });
      return;
    }

    setState(() {
      searchQuery = query;
      isSearching = true;
    });

    try {
      final lowerQuery = query.toLowerCase();

      // Search in all collections simultaneously
      final results = await Future.wait([
        _searchEvents(lowerQuery),
        _searchTurfs(lowerQuery),
        _searchArtists(lowerQuery),
        _searchDining(lowerQuery),
      ]);

      setState(() {
        eventsResults = results[0];
        turfsResults = results[1];
        artistsResults = results[2];
        diningResults = results[3];

        allResults = [
          ...eventsResults,
          ...turfsResults,
          ...artistsResults,
          ...diningResults,
        ];

        isSearching = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() => isSearching = false);
    }
  }

  Future<List<SearchResult>> _searchEvents(String query) async {
    try {
      final snapshot = await _firestore.collection('events').get();

      final results = <SearchResult>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final name = (data['name'] ?? '').toString().toLowerCase();
        final venue = (data['venue']?['name'] ?? '').toString().toLowerCase();
        final description =
            (data['description'] ?? '').toString().toLowerCase();

        final media = data['media'] as Map<String, dynamic>? ?? {};
        final imageUrl =
            (media['posterLink']) ??
            (media['galleryImages'] as List?)?.firstOrNull ??
            '';

        if (name.contains(query) ||
            venue.contains(query) ||
            description.contains(query)) {
          results.add(
            SearchResult(
              id: doc.id,
              type: SearchResultType.event,
              title: data['name'] ?? 'Unnamed Event',
              subtitle: data['venue']?['name'] ?? 'No venue',
              imageUrl: imageUrl,
              date: _formatEventDate(data),
              location: data['venue']?['name'] ?? '',
              data: data,
            ),
          );
        }
      }
      return results;
    } catch (e) {
      print('Error searching events: $e');
      return [];
    }
  }

  Future<List<SearchResult>> _searchTurfs(String query) async {
    try {
      final snapshot = await _firestore.collection('turfs').get();

      final results = <SearchResult>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final name = (data['name'] ?? '').toString().toLowerCase();
        final location = (data['location'] ?? '').toString().toLowerCase();
        final address = (data['address'] ?? '').toString().toLowerCase();

        if (name.contains(query) ||
            location.contains(query) ||
            address.contains(query)) {
          results.add(
            SearchResult(
              id: doc.id,
              type: SearchResultType.turf,
              title: data['name'] ?? 'Unnamed Turf',
              subtitle: data['location'] ?? 'No location',
              imageUrl: (data['poster_urls'] as List?)?.firstOrNull ?? '',
              location: data['location'] ?? '',
              data: data,
            ),
          );
        }
      }
      return results;
    } catch (e) {
      print('Error searching turfs: $e');
      return [];
    }
  }

  Future<List<SearchResult>> _searchArtists(String query) async {
    try {
      final snapshot = await _firestore.collection('artists').get();

      final results = <SearchResult>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final name = (data['name'] ?? '').toString().toLowerCase();
        final genre = (data['genre'] ?? '').toString().toLowerCase();
        final bio = (data['bio'] ?? '').toString().toLowerCase();

        if (name.contains(query) ||
            genre.contains(query) ||
            bio.contains(query)) {
          results.add(
            SearchResult(
              id: doc.id,
              type: SearchResultType.artist,
              title: data['name'] ?? 'Unknown Artist',
              subtitle: data['genre'] ?? 'Artist',
              imageUrl: data['imageUrl'],
              data: data,
            ),
          );
        }
      }
      return results;
    } catch (e) {
      print('Error searching artists: $e');
      return [];
    }
  }

  Future<List<SearchResult>> _searchDining(String query) async {
    try {
      final snapshot = await _firestore.collection('dining').get();
      final q = query.toLowerCase().trim();

      final results = <SearchResult>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // -------------------------
        // BASIC FIELDS
        // -------------------------
        final name = (data['name'] ?? '').toString().toLowerCase();
        // final brief = (data['briefDescription'] ?? '').toString().toLowerCase();

        // -------------------------
        // LOCATION
        // -------------------------
        final locationMap = data['location'] as Map<String, dynamic>? ?? {};
        final locationName =
            (locationMap['name'] ?? '').toString().toLowerCase();

        // -------------------------
        // FILTERS
        // -------------------------
        final filters = data['filters'] as Map<String, dynamic>? ?? {};

        List<String> cuisines =
            (filters['cuisines'] as List?)
                ?.map((e) => e.toString().toLowerCase())
                .toList() ??
            [];

        List<String> categories =
            (filters['categories'] as List?)
                ?.map((e) => e.toString().toLowerCase())
                .toList() ??
            [];

        List<String> dishes =
            (filters['dishes'] as List?)
                ?.map((e) => e.toString().toLowerCase())
                .toList() ??
            [];

        // -------------------------
        // SEARCH MATCH
        // -------------------------
        final matches =
            name.contains(q) ||
            // brief.contains(q) ||
            locationName.contains(q) ||
            cuisines.any((c) => c.contains(q)) ||
            categories.any((c) => c.contains(q)) ||
            dishes.any((d) => d.contains(q));

        if (!matches) continue;

        // -------------------------
        // IMAGE PICK (best available)
        // -------------------------
        final images = data['images'] as Map<String, dynamic>? ?? {};
        final imageUrl =
            (images['carousel'] as List?)?.firstOrNull ??
            (images['about'] as List?)?.firstOrNull ??
            (images['menu'] as List?)?.firstOrNull ??
            '';

        results.add(
          SearchResult(
            id: doc.id,
            type: SearchResultType.dining,
            title: data['name'] ?? 'Unnamed Restaurant',
            subtitle: cuisines.isNotEmpty ? cuisines.join(', ') : 'Restaurant',
            imageUrl: imageUrl,
            location: locationName,
            data: data,
          ),
        );
      }

      return results;
    } catch (e) {
      print('❌ Error searching dining: $e');
      return [];
    }
  }

  String _formatEventDate(Map<String, dynamic> data) {
    try {
      if (data['startDate'] != null) {
        final timestamp = data['startDate'] as Timestamp;
        final date = timestamp.toDate();
        final day = date.day;
        final month = _getMonthName(date.month);
        return '$day $month';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          height: 45,
          margin: EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search anything',
              hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'Regular',
                color: Colors.grey.shade500,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
              suffixIcon:
                  searchQuery.isNotEmpty
                      ? IconButton(
                        icon: Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                      : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: _performSearch,
          ),
        ),
        bottom:
            searchQuery.isNotEmpty
                ? TabBar(
                  controller: _tabController,
                  labelColor: blackColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: blackColor,
                  splashFactory: NoSplash.splashFactory,
                  labelStyle: TextStyle(
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 14,
                  ),
                  tabs: [
                    // Tab(text: 'All (${allResults.length})'),
                    // Tab(text: 'Events (${eventsResults.length})'),
                    // Tab(text: 'Turfs (${turfsResults.length})'),
                    // Tab(text: 'Dining (${diningResults.length})'),
                    Tab(text: 'All'),
                    Tab(text: 'Events'),
                    Tab(text: 'Turfs'),
                    Tab(text: 'Dining'),
                  ],
                )
                : null,
      ),
      body:
          searchQuery.isEmpty
              ? _buildEmptyState()
              : isSearching
              ? SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: List.generate(7, (_) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: size.safeWidth * 0.05,
                        ),
                        child: LoadingShimmer(
                          width: size.safeWidth,
                          height: size.safeHeight * 0.12,
                          isCircle: false,
                        ),
                      );
                    }),
                  ),
                ),
              )
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildResultsList(allResults),
                  _buildResultsList(eventsResults),
                  _buildResultsList(turfsResults),
                  _buildResultsList(diningResults),
                ],
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text(
            'Search for anything',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Events, Turfs, Artists, Restaurants and more',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Regular',
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(List<SearchResult> results) {
    if (results.isEmpty) {
      return Center(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
              SizedBox(height: 16),
              Text(
                'No results found',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Regular',
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Try searching with different keywords',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Regular',
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return _buildSearchResultTile(result);
        },
      ),
    );
  }

  Widget _buildSearchResultTile(SearchResult result) {
    return InkWell(
      onTap: () => _navigateToDetail(result),
      child: Container(
        padding: EdgeInsets.only(left: 12),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Image
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: ClipRRect(
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
                    result.imageUrl != null
                        ? Image.network(
                          result.imageUrl!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage(result.type);
                          },
                        )
                        : _buildPlaceholderImage(result.type),
              ),
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
                          result.title,
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
                            color: _getTypeColor(result.type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getTypeLabel(result.type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                              color: _getTypeColor(result.type),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),

                    // Subtitle
                    Text(
                      result.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Regular',
                        color: Colors.grey.shade600,
                      ),
                    ),

                    // Additional info for events
                    if (result.type == SearchResultType.event) ...[
                      // SizedBox(height: 6),
                      Row(
                        children: [
                          if (result.date != null &&
                              result.date!.isNotEmpty) ...[
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              result.date!,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                          if (result.location != null &&
                              result.location!.isNotEmpty) ...[
                            if (result.date != null && result.date!.isNotEmpty)
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
                                result.location!,
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
                    if ((result.type == SearchResultType.turf ||
                            result.type == SearchResultType.dining) &&
                        result.location != null &&
                        result.location!.isNotEmpty) ...[
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              result.location!,
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

  Widget _buildPlaceholderImage(SearchResultType type) {
    IconData icon;
    Color color;

    switch (type) {
      case SearchResultType.event:
        icon = Icons.celebration;
        color = Colors.blue;
        break;
      case SearchResultType.turf:
        icon = Icons.sports_soccer;
        color = Colors.green;
        break;
      case SearchResultType.artist:
        icon = Icons.person;
        color = Colors.purple;
        break;
      case SearchResultType.dining:
        icon = Icons.restaurant_menu;
        color = Colors.orange;
        break;
    }

    return Container(
      width: 70,
      height: 70,
      color: color.withOpacity(0.1),
      child: Icon(icon, size: 40, color: color),
    );
  }

  Color _getTypeColor(SearchResultType type) {
    switch (type) {
      case SearchResultType.event:
        return Colors.blue;
      case SearchResultType.turf:
        return Colors.green;
      case SearchResultType.artist:
        return Colors.purple;
      case SearchResultType.dining:
        return Colors.orange;
    }
  }

  String _getTypeLabel(SearchResultType type) {
    switch (type) {
      case SearchResultType.event:
        return 'EVENT';
      case SearchResultType.turf:
        return 'TURF';
      case SearchResultType.artist:
        return 'ARTIST';
      case SearchResultType.dining:
        return 'DINING';
    }
  }

  void _navigateToDetail(SearchResult result) {
    // Navigate to detail page based on type
    switch (result.type) {
      case SearchResultType.event:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Concertpage(eventId: result.id),
          ),
        );
        print('Navigate to event: ${result.id}');
        break;
      case SearchResultType.turf:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Turfpage(turfId: result.id)),
        );
        print('Navigate to turf: ${result.id}');
        break;
      case SearchResultType.artist:
        print('Navigate to artist: ${result.id}');
        break;
      case SearchResultType.dining:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Restaurentpage(diningId: result.id),
          ),
        );
        print('Navigate to dining: ${result.id}');
        break;
    }
  }
}

// ==================== SEARCH RESULT MODELS ====================

enum SearchResultType { event, turf, artist, dining }

class SearchResult {
  final String id;
  final SearchResultType type;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String? date;
  final String? location;
  final Map<String, dynamic> data;

  SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.date,
    this.location,
    required this.data,
  });
}
