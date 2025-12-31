class DiningFull {
  final String id;
  final Map<String, dynamic> raw;

  DiningFull({
    required this.id,
    required this.raw,
  });

  // Basic Info
  String get name => raw['name'] ?? '';
  String get briefDescription => raw['briefDescription'] ?? '';
  String get description => raw['description'] ?? '';
  String get contactNumber => raw['contactNumber'] ?? '';
  
  // Location
  double get venueLat => _parseDouble(raw['location']?['lat']);
  double get venueLng => _parseDouble(raw['location']?['lng']);
  String get address => raw['owner']?['address'] ?? '';
  
  // Images
  List<String> get carouselImages {
    final images = raw['images']?['carousel'];
    if (images is List) return images.cast<String>();
    return [];
  }
  
  List<String> get aboutImages {
    final images = raw['images']?['about'];
    if (images is List) return images.cast<String>();
    return [];
  }
  
  List<String> get menuImages {
    final images = raw['images']?['menu'];
    if (images is List) return images.cast<String>();
    return [];
  }
  
  // Filters
  List<String> get cuisines {
    final cuisines = raw['filters']?['cuisines'];
    if (cuisines is List) return cuisines.cast<String>();
    return [];
  }
  
  List<String> get categories {
    final categories = raw['filters']?['categories'];
    if (categories is List) return categories.cast<String>();
    return [];
  }
  
  List<String> get dishes {
    final dishes = raw['filters']?['dishes'];
    if (dishes is List) return dishes.cast<String>();
    return [];
  }
  
  // Facilities
  List<String> get facilities {
    final facilities = raw['facilities'];
    if (facilities is List) return facilities.cast<String>();
    return [];
  }
  
  // Reviews
  double get rating => _parseDouble(raw['reviews']?['rating']);
  int get totalReviews => raw['reviews']?['total'] ?? 0;
  String get reviewSource => raw['reviews']?['source'] ?? '';
  String get reviewUrl => raw['reviews']?['url'] ?? '';
  
  // Timings
  String get openTime => raw['timings']?['open'] ?? '';
  String get closeTime => raw['timings']?['close'] ?? '';
  
  // Owner Info
  String get ownerName => raw['owner']?['name'] ?? '';
  String get ownerPaymentUid => raw['paymentUid'] ?? '';
  
  // Metadata
  String get diningId => raw['diningId'] ?? id;
  String get createdBy => raw['createdBy'] ?? '';
  DateTime? get createdAt {
    final timestamp = raw['created_at'];
    if (timestamp is DateTime) return timestamp;
    return null;
  }

  // Helper method
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Utility getters
  bool get hasMenuImages => menuImages.isNotEmpty;
  bool get hasAboutImages => aboutImages.isNotEmpty;
  bool get hasMultipleCuisines => cuisines.length > 1;
  
  String get formattedRating => rating.toStringAsFixed(1);
  
  String get formattedTimings {
    if (openTime.isEmpty || closeTime.isEmpty) return 'Hours not available';
    return '$openTime - $closeTime';
  }

  bool get isOpenNow {
    // Implement time-based logic here if needed
    // This is a placeholder
    final now = DateTime.now();
    // Parse openTime and closeTime and compare with current time
    return true;
  }

  // Get all images
  List<String> get allImages {
    return [...carouselImages, ...aboutImages, ...menuImages];
  }
}