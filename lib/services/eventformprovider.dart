import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../constants/ticketcategory.dart';

class EventFormProvider extends ChangeNotifier {
  // ─── BASIC DETAILS ────────────────────────────────────────────────
  String name = '';
  String category = 'Music';
  String ageRestriction = 'None';
  String ticketRequiredAge = 'All Ages';
  String layout = 'Indoor';
  final List<String> languages = [];

  // ─── EVENT DAYS (SIMPLIFIED) ─────────────────────────────────────
  List<Map<String, dynamic>> days = [
    {
      'date': DateTime.now().add(const Duration(days: 1)),
      'startTime': const TimeOfDay(hour: 18, minute: 0),
      'endTime': const TimeOfDay(hour: 21, minute: 0),
    },
  ];

  // ─── TEXT CONTROLLERS ─────────────────────────────────────────────
  final nameController = TextEditingController();
  final venueNameController = TextEditingController();
  final venueAddressController = TextEditingController();
  final venueMapsLinkController = TextEditingController();
  final organiserCompanyController = TextEditingController();
  final organiserPersonController = TextEditingController();
  final organiserPhoneController = TextEditingController();
  final organiserEmailController = TextEditingController();
  final bankAccountController = TextEditingController();
  final ifscController = TextEditingController();
  final panGstController = TextEditingController();
  final gstNoController = TextEditingController();
  final liabilityController = TextEditingController();
  final posterController = TextEditingController();
  final videoController = TextEditingController();

  // ─── VENUE ───────────────────────────────────────────────────────
  String venueName = '';
  String venueFullAddress = '';
  String venueLat = '';
  String venueLng = '';
  String venueMapsLink = '';

  // ─── ORGANISER ───────────────────────────────────────────────────
  String organiserCompany = '';
  String organiserContactPerson = '';
  String organiserPhone = '';
  String organiserEmail = '';

  // ─── ARTISTS / MEDIA / PROMOTION ─────────────────────────────────
  final List<String> artistLineup = [];
  String posterDriveLink = '';
  String videoDriveLink = '';
  final List<String> hashtags = [];
  Map<String, String> socialLinks = {
    'instagram': '',
    'facebook': '',
    'twitter': '',
  };

  // ─── TICKETS ─────────────────────────────────────────────────────
  final List<TicketCategory> tickets = [];

  // ─── FINANCIAL / LEGAL ───────────────────────────────────────────
  String bankAccount = '';
  String ifsc = '';
  String panOrGst = '';
  String bankName = '';
  String accountHolder = '';
  final List<String> nocLinks = [];
  String gstNo = '';
  String liabilityText = '';

  // ─── IMAGE FILES & URLS ──────────────────────────────────────────
  File? posterImageFile;
  List<File> galleryImageFiles = [];
  List<String> galleryImageUrls = [];

  bool submitting = false;

  // ─── FIELD UPDATER ───────────────────────────────────────────────
  void updateField(String field, dynamic value) {
    switch (field) {
      case 'name':
        name = value;
        break;
      case 'category':
        category = value;
        break;
      case 'ageRestriction':
        ageRestriction = value;
        break;
      case 'ticketRequiredAge':
        ticketRequiredAge = value;
        break;
      case 'layout':
        layout = value;
        break;
      case 'venueName':
        venueName = value;
        break;
      case 'venueFullAddress':
        venueFullAddress = value;
        break;
      case 'venueLat':
        venueLat = value;
        break;
      case 'venueLng':
        venueLng = value;
        break;
      case 'venueMapsLink':
        venueMapsLink = value;
        break;
      case 'organiserCompany':
        organiserCompany = value;
        break;
      case 'organiserContactPerson':
        organiserContactPerson = value;
        break;
      case 'organiserPhone':
        organiserPhone = value;
        break;
      case 'organiserEmail':
        organiserEmail = value;
        break;
      case 'posterDriveLink':
        posterDriveLink = value;
        break;
      case 'videoDriveLink':
        videoDriveLink = value;
        break;
      case 'bankAccount':
        bankAccount = value;
        break;
      case 'ifsc':
        ifsc = value;
        break;
      case 'panOrGst':
        panOrGst = value;
        break;
      case 'bankName':
        bankName = value;
        break;
      case 'accountHolder':
        accountHolder = value;
        break;
      case 'gstNo':
        gstNo = value;
        break;
      case 'liabilityText':
        liabilityText = value;
        break;
    }
    notifyListeners();
  }

  // ─── LANGUAGE HELPERS ─────────────────────────────────────────────
  void addLanguage(String lang) {
    for (final l in lang
        .split(RegExp(r'[,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)) {
      if (!languages.contains(l)) languages.add(l);
    }
    notifyListeners();
  }

  void removeLanguage(String lang) {
    languages.remove(lang);
    notifyListeners();
  }

  // ─── DAY HELPERS ─────────────────────────────────────────────────
  void addDay() {
    days.add({
      'date': DateTime.now().add(const Duration(days: 1)),
      'startTime': const TimeOfDay(hour: 18, minute: 0),
      'endTime': const TimeOfDay(hour: 21, minute: 0),
    });
    notifyListeners();
  }

  void removeDay(int index) {
    if (days.length > 1) {
      days.removeAt(index);
      notifyListeners();
    }
  }

  void updateDay(int index, String field, dynamic value) {
    days[index][field] = value;
    notifyListeners();
  }

  // ─── ARTISTS / HASHTAGS / TICKETS / NOC ──────────────────────────
  void addArtist(String a) {
    for (final name in a
        .split(RegExp(r'[,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)) {
      if (!artistLineup.contains(name)) artistLineup.add(name);
    }
    notifyListeners();
  }

  void removeArtist(String a) {
    artistLineup.remove(a);
    notifyListeners();
  }

  void addHashtag(String h) {
    for (final tag in h
        .split(RegExp(r'[,\s\n#]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)) {
      final formatted = tag.startsWith('#') ? tag : '#$tag';
      if (!hashtags.contains(formatted)) hashtags.add(formatted);
    }
    notifyListeners();
  }

  void removeHashtag(String h) {
    hashtags.remove(h);
    notifyListeners();
  }

  void addTicket(TicketCategory t) {
    tickets.add(t);
    notifyListeners();
  }

  void removeTicket(TicketCategory t) {
    tickets.removeWhere((x) => x.id == t.id);
    notifyListeners();
  }

  void addNocLink(String u) {
    nocLinks.add(u);
    notifyListeners();
  }

  void removeNocLink(String u) {
    nocLinks.remove(u);
    notifyListeners();
  }

  // ─── IMAGE HANDLING ──────────────────────────────────────────────
  void setPosterImageFile(File file) {
    posterImageFile = file;
    posterDriveLink = '';
    notifyListeners();
  }

  void addGalleryImage(File file) {
    galleryImageFiles.add(file);
    notifyListeners();
  }

  void removeGalleryImage(int index) {
    galleryImageFiles.removeAt(index);
    notifyListeners();
  }

  void removeGalleryImageUrl(int index) {
    galleryImageUrls.removeAt(index);
    notifyListeners();
  }

  void clearPosterImage() {
    posterImageFile = null;
    posterDriveLink = '';
    notifyListeners();
  }

  // ─── STORAGE HELPERS ─────────────────────────────────────────────
  Future<String?> _uploadImage(File file, String path) async {
    try {
      debugPrint('📤 Starting upload: $path');
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('✅ Upload successful: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Error uploading image to $path: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> _uploadImages(String eventId) async {
    final result = <String, dynamic>{};
    debugPrint('📤 Starting image upload for event: $eventId');

    if (posterImageFile != null) {
      debugPrint('📤 Uploading NEW poster image...');
      final posterUrl = await _uploadImage(
        posterImageFile!,
        "event_posters/$eventId/poster.jpg",
      );
      if (posterUrl != null) {
        result["posterLink"] = posterUrl;
        debugPrint('✅ Poster uploaded: $posterUrl');
      }
    }

    if (galleryImageFiles.isNotEmpty) {
      debugPrint('📤 Uploading ${galleryImageFiles.length} gallery images...');
      final urls = <String>[];

      for (final file in galleryImageFiles) {
        final uniqueName = _generateUniqueFilename('gallery', file.path);
        final path = "event_posters/$eventId/$uniqueName";
        final url = await _uploadImage(file, path);
        if (url != null) {
          urls.add(url);
        }
      }

      if (urls.isNotEmpty) {
        result['galleryImages'] = urls;
      }
    }

    return result;
  }

  String _generateUniqueFilename(String prefix, String originalPath) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final rand = (1000 + (DateTime.now().microsecond % 9000));
    final ext =
        originalPath.contains('.') ? originalPath.split('.').last : 'jpg';
    return '${prefix}_${ts}_$rand.$ext';
  }

  Future<void> _deleteFolderContents(String path) async {
    try {
      debugPrint('🗑️ Deleting folder: $path');
      final folder = FirebaseStorage.instance.ref(path);
      final listResult = await folder.listAll();

      for (final item in listResult.items) {
        await item.delete();
        debugPrint('🗑️ Deleted file: ${item.fullPath}');
      }
    } catch (e) {
      debugPrint('❌ Error deleting folder $path: $e');
    }
  }

  Future<void> _deleteEventImages(String eventId) async {
    await _deleteFolderContents("event_posters/$eventId");
  }

  Future<bool> deleteImageFromStorage(String filePathOrUrl) async {
    try {
      final storage = FirebaseStorage.instance;
      Reference ref;
      if (filePathOrUrl.startsWith('http')) {
        ref = storage.refFromURL(filePathOrUrl);
      } else {
        ref = storage.ref().child(filePathOrUrl);
      }
      await ref.delete();
      print('✅ File deleted successfully: $filePathOrUrl');
      return true;
    } catch (e) {
      print('❌ Failed to delete file: $e');
      return false;
    }
  }

  // ─── TIME OF DAY HELPERS ─────────────────────────────────────────
  Map<String, int> _timeOfDayToMap(TimeOfDay time) => {
        'hour': time.hour,
        'minute': time.minute,
      };

  TimeOfDay _mapToTimeOfDay(Map<String, dynamic>? map) =>
      TimeOfDay(hour: map?['hour'] ?? 18, minute: map?['minute'] ?? 0);

  // ─── FIRESTORE CRUD ──────────────────────────────────────────────
  Map<String, dynamic> _buildBaseData() {
    final daysData = <Map<String, dynamic>>[];
    for (int i = 0; i < days.length; i++) {
      daysData.add({
        'day${i + 1}': {
          'date': Timestamp.fromDate(days[i]['date']),
          'startTime': _timeOfDayToMap(days[i]['startTime']),
          'endTime': _timeOfDayToMap(days[i]['endTime']),
        },
      });
    }

    return {
      'name': name,
      'category': category,
      'ageRestriction': ageRestriction,
      'ticketRequiredAge': ticketRequiredAge,
      'layout': layout,
      'languages': languages,
      'days': daysData,
      'venue': {
        'name': venueName,
        'fullAddress': venueFullAddress,
        'venueLat': venueLat,
        'venueLng': venueLng,
        'mapsLink': venueMapsLink,
      },
      'organiser': {
        'companyName': organiserCompany,
        'contactPerson': organiserContactPerson,
        'contactPhone': organiserPhone,
        'contactEmail': organiserEmail,
      },
      'artistLineup': artistLineup,
      'tickets': tickets.map((t) {
        final map = t.toMap();
        // Initialize 'available' field equal to 'quantity' for new tickets
        if (!map.containsKey('available')) {
          map['available'] = map['quantity'] ?? 0;
        }
        return map;
      }).toList(),
      'financial': {
        'accountNumber': bankAccount,
        'ifsc': ifsc,
        'panOrGst': panOrGst,
        'bankName': bankName,
        'accountHolder': accountHolder,
      },
      'promotion': {'hashtags': hashtags, 'socialLinks': socialLinks},
      'legal': {
        'noc': nocLinks,
        'gstNo': gstNo,
        'liabilityText': liabilityText,
      },
      'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
    };
  }

  /// CREATE: Create new event with images
  Future<String> createEvent() async {
    try {
      debugPrint('🚀 ===== STARTING EVENT CREATION =====');

      final doc = FirebaseFirestore.instance.collection("events").doc();
      final eventId = doc.id;
      debugPrint('✅ Generated event ID: $eventId');

      debugPrint('📤 ===== STARTING IMAGE UPLOAD =====');
      final uploadedImages = await _uploadImages(eventId);

      final eventData = _buildBaseData();

      eventData['media'] = {
        'posterLink': uploadedImages['posterLink'] ?? '',
        'videoLink': videoDriveLink,
        'galleryImages': uploadedImages['galleryImages'] ?? [],
      };

      await doc.set({
        ...eventData,
        'eventId': eventId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ ===== EVENT CREATED SUCCESSFULLY =====');
      return eventId;
    } catch (e, stackTrace) {
      debugPrint('❌ ===== ERROR CREATING EVENT =====');
      debugPrint('❌ Error: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// UPDATE: Update existing event with new images
  Future<String> updateEvent(String eventId) async {
    try {
      debugPrint('🔄 ===== STARTING EVENT UPDATE =====');

      final uploadedImages = await _uploadImages(eventId);
      final eventData = _buildBaseData();

      final finalPosterLink = uploadedImages['posterLink'] ?? posterDriveLink;
      final finalGalleryImages = <String>[
        ...galleryImageUrls,
        ...(uploadedImages['galleryImages'] as List<String>? ?? []),
      ];

      eventData['media'] = {
        'posterLink': finalPosterLink,
        'videoLink': videoDriveLink,
        'galleryImages': finalGalleryImages,
      };

      await FirebaseFirestore.instance.collection("events").doc(eventId).update(
        {...eventData, 'updatedAt': FieldValue.serverTimestamp()},
      );

      debugPrint('✅ ===== EVENT UPDATED SUCCESSFULLY =====');
      return eventId;
    } catch (e, stackTrace) {
      debugPrint('❌ ===== ERROR UPDATING EVENT =====');
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  /// DELETE: Delete event and all associated images
  Future<void> deleteEvent(String eventId) async {
    try {
      debugPrint('🗑️ ===== STARTING EVENT DELETION =====');

      await FirebaseFirestore.instance
          .collection("events")
          .doc(eventId)
          .delete();

      await _deleteEventImages(eventId);

      debugPrint('✅ ===== EVENT DELETED SUCCESSFULLY =====');
    } catch (e, stackTrace) {
      debugPrint('❌ ===== ERROR DELETING EVENT =====');
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  // ─── LOAD FROM FIRESTORE ─────────────────────────────────────────
  void loadFromFirestore(Map<String, dynamic> data, String? id) {
    debugPrint('📥 ===== LOADING EVENT DATA =====');

    name = data['name'] ?? '';
    category = data['category'] ?? 'Music';
    ageRestriction = data['ageRestriction'] ?? 'None';
    ticketRequiredAge = data['ticketRequiredAge'] ?? 'All Ages';
    layout = data['layout'] ?? 'Indoor';

    languages.clear();
    if (data['languages'] != null) {
      languages.addAll(List<String>.from(data['languages']));
    }

    days.clear();
    if (data['days'] != null && data['days'] is List) {
      for (final dayData in data['days']) {
        if (dayData is Map) {
          final dayKey = dayData.keys.firstWhere(
            (key) => key.toString().startsWith('day'),
            orElse: () => 'day1',
          );

          final dayInfo = dayData[dayKey];
          if (dayInfo is Map) {
            days.add({
              'date':
                  (dayInfo['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
              'startTime': _mapToTimeOfDay(dayInfo['startTime']),
              'endTime': _mapToTimeOfDay(dayInfo['endTime']),
            });
          }
        }
      }
    }

    if (days.isEmpty) {
      days.add({
        'date': DateTime.now().add(const Duration(days: 1)),
        'startTime': const TimeOfDay(hour: 18, minute: 0),
        'endTime': const TimeOfDay(hour: 21, minute: 0),
      });
    }

    venueName = data['venue']?['name'] ?? '';
    venueFullAddress = data['venue']?['fullAddress'] ?? '';
    venueLat = data['venue']?['venueLat'] ?? '';
    venueLng = data['venue']?['venueLng'] ?? '';
    venueMapsLink = data['venue']?['mapsLink'] ?? '';

    organiserCompany = data['organiser']?['companyName'] ?? '';
    organiserContactPerson = data['organiser']?['contactPerson'] ?? '';
    organiserPhone = data['organiser']?['contactPhone'] ?? '';
    organiserEmail = data['organiser']?['contactEmail'] ?? '';

    artistLineup.clear();
    if (data['artistLineup'] != null) {
      artistLineup.addAll(List<String>.from(data['artistLineup']));
    }

    posterDriveLink = data['media']?['posterLink'] ?? '';
    videoDriveLink = data['media']?['videoLink'] ?? '';

    galleryImageUrls.clear();
    if (data['media']?['galleryImages'] != null) {
      galleryImageUrls.addAll(
        List<String>.from(data['media']['galleryImages']),
      );
    }

    tickets.clear();
    if (data['tickets'] != null) {
      for (final t in data['tickets']) {
        tickets.add(TicketCategory.fromMap(Map<String, dynamic>.from(t)));
      }
    }

    bankAccount = data['financial']?['accountNumber'] ?? '';
    ifsc = data['financial']?['ifsc'] ?? '';
    panOrGst = data['financial']?['panOrGst'] ?? '';
    bankName = data['financial']?['bankName'] ?? '';
    accountHolder = data['financial']?['accountHolder'] ?? '';

    hashtags.clear();
    if (data['promotion']?['hashtags'] != null) {
      hashtags.addAll(List<String>.from(data['promotion']['hashtags']));
    }

    socialLinks = Map<String, String>.from(
      data['promotion']?['socialLinks'] ??
          {'instagram': '', 'facebook': '', 'twitter': ''},
    );

    nocLinks.clear();
    if (data['legal']?['noc'] != null) {
      nocLinks.addAll(List<String>.from(data['legal']['noc']));
    }

    gstNo = data['legal']?['gstNo'] ?? '';
    liabilityText = data['legal']?['liabilityText'] ?? '';

    // Update text controllers
    nameController.text = name;
    venueNameController.text = venueName;
    venueAddressController.text = venueFullAddress;
    venueMapsLinkController.text = venueMapsLink;
    organiserCompanyController.text = organiserCompany;
    organiserPersonController.text = organiserContactPerson;
    organiserPhoneController.text = organiserPhone;
    organiserEmailController.text = organiserEmail;
    bankAccountController.text = bankAccount;
    ifscController.text = ifsc;
    panGstController.text = panOrGst;
    gstNoController.text = gstNo;
    liabilityController.text = liabilityText;
    posterController.text = posterDriveLink;
    videoController.text = videoDriveLink;

    notifyListeners();
  }

  // ─── RESET PROVIDER ──────────────────────────────────────────────
  void reset() {
    name = '';
    category = 'Music';
    ageRestriction = 'None';
    ticketRequiredAge = 'All Ages';
    layout = 'Indoor';
    languages.clear();

    days = [
      {
        'date': DateTime.now().add(const Duration(days: 1)),
        'startTime': const TimeOfDay(hour: 18, minute: 0),
        'endTime': const TimeOfDay(hour: 21, minute: 0),
      },
    ];

    venueName = '';
    venueFullAddress = '';
    venueLat = '';
    venueLng = '';
    venueMapsLink = '';
    organiserCompany = '';
    organiserContactPerson = '';
    organiserPhone = '';
    organiserEmail = '';
    artistLineup.clear();
    posterDriveLink = '';
    videoDriveLink = '';
    hashtags.clear();
    socialLinks = {'instagram': '', 'facebook': '', 'twitter': ''};
    tickets.clear();
    bankAccount = '';
    ifsc = '';
    panOrGst = '';
    bankName = '';
    accountHolder = '';
    nocLinks.clear();
    gstNo = '';
    liabilityText = '';
    posterImageFile = null;
    galleryImageFiles.clear();
    galleryImageUrls.clear();

    nameController.clear();
    venueNameController.clear();
    venueAddressController.clear();
    venueMapsLinkController.clear();
    organiserCompanyController.clear();
    organiserPersonController.clear();
    organiserPhoneController.clear();
    organiserEmailController.clear();
    bankAccountController.clear();
    ifscController.clear();
    panGstController.clear();
    gstNoController.clear();
    liabilityController.clear();
    posterController.clear();
    videoController.clear();

    submitting = false;
    notifyListeners();
  }

  void setSubmitting(bool value) {
    submitting = value;
    notifyListeners();
  }
}
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import '../constants/ticketcategory.dart';

// class EventFormProvider extends ChangeNotifier {
//   // ─── BASIC DETAILS ────────────────────────────────────────────────
//   String name = '';
//   String category = 'Music';
//   String ageRestriction = 'None';
//   String ticketRequiredAge = 'All Ages';
//   String layout = 'Indoor';
//   final List<String> languages = [];

//   // ─── EVENT DAYS (SIMPLIFIED) ─────────────────────────────────────
//   List<Map<String, dynamic>> days = [
//     {
//       'date': DateTime.now().add(const Duration(days: 1)),
//       'startTime': const TimeOfDay(hour: 18, minute: 0),
//       'endTime': const TimeOfDay(hour: 21, minute: 0),
//     },
//   ];

//   // ─── TEXT CONTROLLERS ─────────────────────────────────────────────
//   final nameController = TextEditingController();
//   final venueNameController = TextEditingController();
//   final venueAddressController = TextEditingController();
//   final venueMapsLinkController = TextEditingController();
//   final organiserCompanyController = TextEditingController();
//   final organiserPersonController = TextEditingController();
//   final organiserPhoneController = TextEditingController();
//   final organiserEmailController = TextEditingController();
//   final bankAccountController = TextEditingController();
//   final ifscController = TextEditingController();
//   final panGstController = TextEditingController();
//   final gstNoController = TextEditingController();
//   final liabilityController = TextEditingController();
//   final posterController = TextEditingController();
//   final videoController = TextEditingController();

//   // ─── VENUE ───────────────────────────────────────────────────────
//   String venueName = '';
//   String venueFullAddress = '';
//   String venueLat = '';
//   String venueLng = '';
//   String venueMapsLink = '';

//   // ─── ORGANISER ───────────────────────────────────────────────────
//   String organiserCompany = '';
//   String organiserContactPerson = '';
//   String organiserPhone = '';
//   String organiserEmail = '';

//   // ─── ARTISTS / MEDIA / PROMOTION ─────────────────────────────────
//   final List<String> artistLineup = [];
//   String posterDriveLink = '';
//   String videoDriveLink = '';
//   final List<String> hashtags = [];
//   Map<String, String> socialLinks = {
//     'instagram': '',
//     'facebook': '',
//     'twitter': '',
//   };

//   // ─── TICKETS ─────────────────────────────────────────────────────
//   final List<TicketCategory> tickets = [];

//   // ─── FINANCIAL / LEGAL ───────────────────────────────────────────
//   String bankAccount = '';
//   String ifsc = '';
//   String panOrGst = '';
//   String bankName = '';
//   String accountHolder = '';
//   final List<String> nocLinks = [];
//   String gstNo = '';
//   String liabilityText = '';

//   // ─── IMAGE FILES & URLS ──────────────────────────────────────────
//   File? posterImageFile;
//   List<File> galleryImageFiles = [];
//   List<String> galleryImageUrls = [];

//   bool submitting = false;

//   // ─── FIELD UPDATER ───────────────────────────────────────────────
//   void updateField(String field, dynamic value) {
//     switch (field) {
//       case 'name':
//         name = value;
//         break;
//       case 'category':
//         category = value;
//         break;
//       case 'ageRestriction':
//         ageRestriction = value;
//         break;
//       case 'ticketRequiredAge':
//         ticketRequiredAge = value;
//         break;
//       case 'layout':
//         layout = value;
//         break;
//       case 'venueName':
//         venueName = value;
//         break;
//       case 'venueFullAddress':
//         venueFullAddress = value;
//         break;
//       case 'venueLat':
//         venueLat = value;
//         break;
//       case 'venueLng':
//         venueLng = value;
//         break;
//       case 'venueMapsLink':
//         venueMapsLink = value;
//         break;
//       case 'organiserCompany':
//         organiserCompany = value;
//         break;
//       case 'organiserContactPerson':
//         organiserContactPerson = value;
//         break;
//       case 'organiserPhone':
//         organiserPhone = value;
//         break;
//       case 'organiserEmail':
//         organiserEmail = value;
//         break;
//       case 'posterDriveLink':
//         posterDriveLink = value;
//         break;
//       case 'videoDriveLink':
//         videoDriveLink = value;
//         break;
//       case 'bankAccount':
//         bankAccount = value;
//         break;
//       case 'ifsc':
//         ifsc = value;
//         break;
//       case 'panOrGst':
//         panOrGst = value;
//         break;
//       case 'bankName':
//         bankName = value;
//         break;
//       case 'accountHolder':
//         accountHolder = value;
//         break;
//       case 'gstNo':
//         gstNo = value;
//         break;
//       case 'liabilityText':
//         liabilityText = value;
//         break;
//     }
//     notifyListeners();
//   }

//   // ─── LANGUAGE HELPERS ─────────────────────────────────────────────
//   void addLanguage(String lang) {
//     for (final l in lang
//         .split(RegExp(r'[,\n]'))
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)) {
//       if (!languages.contains(l)) languages.add(l);
//     }
//     notifyListeners();
//   }

//   void removeLanguage(String lang) {
//     languages.remove(lang);
//     notifyListeners();
//   }

//   // ─── DAY HELPERS ─────────────────────────────────────────────────
//   void addDay() {
//     days.add({
//       'date': DateTime.now().add(const Duration(days: 1)),
//       'startTime': const TimeOfDay(hour: 18, minute: 0),
//       'endTime': const TimeOfDay(hour: 21, minute: 0),
//     });
//     notifyListeners();
//   }

//   void removeDay(int index) {
//     if (days.length > 1) {
//       days.removeAt(index);
//       notifyListeners();
//     }
//   }

//   void updateDay(int index, String field, dynamic value) {
//     days[index][field] = value;
//     notifyListeners();
//   }

//   // ─── ARTISTS / HASHTAGS / TICKETS / NOC ──────────────────────────
//   void addArtist(String a) {
//     for (final name in a
//         .split(RegExp(r'[,\n]'))
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)) {
//       if (!artistLineup.contains(name)) artistLineup.add(name);
//     }
//     notifyListeners();
//   }

//   void removeArtist(String a) {
//     artistLineup.remove(a);
//     notifyListeners();
//   }

//   void addHashtag(String h) {
//     for (final tag in h
//         .split(RegExp(r'[,\s\n#]+'))
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)) {
//       final formatted = tag.startsWith('#') ? tag : '#$tag';
//       if (!hashtags.contains(formatted)) hashtags.add(formatted);
//     }
//     notifyListeners();
//   }

//   void removeHashtag(String h) {
//     hashtags.remove(h);
//     notifyListeners();
//   }

//   void addTicket(TicketCategory t) {
//     tickets.add(t);
//     notifyListeners();
//   }

//   void removeTicket(TicketCategory t) {
//     tickets.removeWhere((x) => x.id == t.id);
//     notifyListeners();
//   }

//   void addNocLink(String u) {
//     nocLinks.add(u);
//     notifyListeners();
//   }

//   void removeNocLink(String u) {
//     nocLinks.remove(u);
//     notifyListeners();
//   }

//   // ─── IMAGE HANDLING ──────────────────────────────────────────────
//   void setPosterImageFile(File file) {
//     posterImageFile = file;
//     // Clear the URL when user selects a new file
//     posterDriveLink = '';
//     notifyListeners();
//   }

//   void addGalleryImage(File file) {
//     galleryImageFiles.add(file);
//     notifyListeners();
//   }

//   void removeGalleryImage(int index) {
//     galleryImageFiles.removeAt(index);
//     notifyListeners();
//   }

//   void removeGalleryImageUrl(int index) {
//     galleryImageUrls.removeAt(index);
//     notifyListeners();
//   }

//   void clearPosterImage() {
//     posterImageFile = null;
//     posterDriveLink = '';
//     notifyListeners();
//   }

//   // ─── STORAGE HELPERS ─────────────────────────────────────────────

//   /// Upload a single image to Firebase Storage
//   Future<String?> _uploadImage(File file, String path) async {
//     try {
//       debugPrint('📤 Starting upload: $path');
//       final ref = FirebaseStorage.instance.ref().child(path);

//       // Upload file
//       final uploadTask = ref.putFile(file);

//       // Wait for upload to complete
//       final snapshot = await uploadTask;

//       // Get download URL
//       final downloadUrl = await snapshot.ref.getDownloadURL();

//       debugPrint('✅ Upload successful: $path');
//       debugPrint('✅ Download URL: $downloadUrl');

//       return downloadUrl;
//     } catch (e) {
//       debugPrint('❌ Error uploading image to $path: $e');
//       return null;
//     }
//   }

//   /// Upload all images (poster + gallery) to Firebase Storage
//   /// Returns only the URLs of newly uploaded images
//   // Future<Map<String, dynamic>> _uploadImages(String eventId) async {
//   //   final result = <String, dynamic>{};

//   //   debugPrint('📤 Starting image upload for event: $eventId');
//   //   debugPrint('📤 Poster file exists: ${posterImageFile != null}');
//   //   debugPrint('📤 Gallery files count: ${galleryImageFiles.length}');

//   //   // Upload poster image ONLY if user selected a new one
//   //   if (posterImageFile != null) {
//   //     debugPrint('📤 Uploading NEW poster image...');
//   //     final posterUrl = await _uploadImage(
//   //       posterImageFile!,
//   //       "event_posters/$eventId/poster.jpg",
//   //     );
//   //     if (posterUrl != null) {
//   //       result["posterLink"] = posterUrl;
//   //       debugPrint('✅ Poster uploaded: $posterUrl');
//   //     } else {
//   //       debugPrint('❌ Poster upload failed');
//   //     }
//   //   } else {
//   //     debugPrint('ℹ️ No new poster image to upload, keeping existing');
//   //   }

//   //   // Upload NEW gallery images if exist
//   //   if (galleryImageFiles.isNotEmpty) {
//   //     debugPrint(
//   //       '📤 Uploading ${galleryImageFiles.length} NEW gallery images...',
//   //     );
//   //     final urls = <String>[];

//   //     // Start numbering from existing gallery count
//   //     final startIndex = galleryImageUrls.length;

//   //     for (int i = 0; i < galleryImageFiles.length; i++) {
//   //       final galleryIndex = startIndex + i;
//   //       debugPrint('📤 Uploading gallery image $galleryIndex...');
//   //       final url = await _uploadImage(
//   //         galleryImageFiles[i],
//   //         "event_posters/$eventId/gallery_$galleryIndex.jpg",
//   //       );
//   //       if (url != null) {
//   //         urls.add(url);
//   //         debugPrint('✅ Gallery image $galleryIndex uploaded: $url');
//   //       } else {
//   //         debugPrint('❌ Gallery image $galleryIndex upload failed');
//   //       }
//   //     }
//   //     if (urls.isNotEmpty) {
//   //       result["galleryImages"] = urls;
//   //       debugPrint('✅ New gallery images uploaded: ${urls.length} images');
//   //     }
//   //   } else {
//   //     debugPrint('ℹ️ No new gallery images to upload');
//   //   }

//   //   debugPrint('📤 Upload complete. Result keys: ${result.keys.toList()}');
//   //   return result;
//   // }
//   Future<Map<String, dynamic>> _uploadImages(String eventId) async {
//     final result = <String, dynamic>{};
//     debugPrint('📤 Starting image upload for event: $eventId');

//     // Poster upload (unchanged: keep same path)
//     if (posterImageFile != null) {
//       debugPrint('📤 Uploading NEW poster image...');
//       final posterUrl = await _uploadImage(
//         posterImageFile!,
//         "event_posters/$eventId/poster.jpg",
//       );
//       if (posterUrl != null) {
//         result["posterLink"] = posterUrl;
//         debugPrint('✅ Poster uploaded: $posterUrl');
//       } else {
//         debugPrint('❌ Poster upload failed');
//       }
//     } else {
//       debugPrint('ℹ️ No new poster image to upload, keeping existing');
//     }

//     // Gallery uploads: use unique filenames (timestamp + random)
//     if (galleryImageFiles.isNotEmpty) {
//       debugPrint(
//         '📤 Uploading ${galleryImageFiles.length} NEW gallery images...',
//       );
//       final urls = <String>[];

//       for (final file in galleryImageFiles) {
//         final uniqueName = _generateUniqueFilename('gallery', file.path);
//         final path = "event_posters/$eventId/$uniqueName";
//         debugPrint('📤 Uploading gallery as $path');
//         final url = await _uploadImage(file, path);
//         if (url != null) {
//           urls.add(url);
//           debugPrint('✅ Uploaded $uniqueName -> $url');
//         } else {
//           debugPrint('❌ Failed to upload $uniqueName');
//         }
//       }

//       if (urls.isNotEmpty) {
//         result['galleryImages'] = urls;
//         debugPrint('✅ New gallery images uploaded: ${urls.length}');
//       }
//     } else {
//       debugPrint('ℹ️ No new gallery images to upload');
//     }

//     return result;
//   }

//   /// Delete all images in a folder
//   Future<void> _deleteFolderContents(String path) async {
//     try {
//       debugPrint('🗑️ Deleting folder: $path');
//       final folder = FirebaseStorage.instance.ref(path);
//       final listResult = await folder.listAll();

//       debugPrint('🗑️ Found ${listResult.items.length} files to delete');

//       // Delete all files in the folder
//       for (final item in listResult.items) {
//         await item.delete();
//         debugPrint('🗑️ Deleted file: ${item.fullPath}');
//       }

//       debugPrint('✅ Folder deleted successfully: $path');
//     } catch (e) {
//       debugPrint('❌ Error deleting folder $path: $e');
//     }
//   }

//   /// Delete all images for an event
//   Future<void> _deleteEventImages(String eventId) async {
//     await _deleteFolderContents("event_posters/$eventId");
//   }

//   // ─── TIME OF DAY HELPERS ─────────────────────────────────────────
//   Map<String, int> _timeOfDayToMap(TimeOfDay time) => {
//     'hour': time.hour,
//     'minute': time.minute,
//   };

//   TimeOfDay _mapToTimeOfDay(Map<String, dynamic>? map) =>
//       TimeOfDay(hour: map?['hour'] ?? 18, minute: map?['minute'] ?? 0);

//   // ─── FIRESTORE CRUD ──────────────────────────────────────────────

//   /// Convert provider data to Firestore map (WITHOUT image URLs)
//   Map<String, dynamic> _buildBaseData() {
//     // Build days list for Firestore
//     final daysData = <Map<String, dynamic>>[];
//     for (int i = 0; i < days.length; i++) {
//       daysData.add({
//         'day${i + 1}': {
//           'date': Timestamp.fromDate(days[i]['date']),
//           'startTime': _timeOfDayToMap(days[i]['startTime']),
//           'endTime': _timeOfDayToMap(days[i]['endTime']),
//         },
//       });
//     }

//     return {
//       'name': name,
//       'category': category,
//       'ageRestriction': ageRestriction,
//       'ticketRequiredAge': ticketRequiredAge,
//       'layout': layout,
//       'languages': languages,
//       'days': daysData,
//       'venue': {
//         'name': venueName,
//         'fullAddress': venueFullAddress,
//         'venueLat': venueLat,
//         'venueLng': venueLng,
//         'mapsLink': venueMapsLink,
//       },
//       'organiser': {
//         'companyName': organiserCompany,
//         'contactPerson': organiserContactPerson,
//         'contactPhone': organiserPhone,
//         'contactEmail': organiserEmail,
//       },
//       'artistLineup': artistLineup,
//       'tickets': tickets.map((t) => t.toMap()).toList(),
//       'financial': {
//         'accountNumber': bankAccount,
//         'ifsc': ifsc,
//         'panOrGst': panOrGst,
//         'bankName': bankName,
//         'accountHolder': accountHolder,
//       },
//       'promotion': {'hashtags': hashtags, 'socialLinks': socialLinks},
//       'legal': {
//         'noc': nocLinks,
//         'gstNo': gstNo,
//         'liabilityText': liabilityText,
//       },
//       'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
//     };
//   }

//   /// CREATE: Create new event with images
//   Future<String> createEvent() async {
//     try {
//       debugPrint('🚀 ===== STARTING EVENT CREATION =====');

//       // Step 1: Create document to get ID
//       final doc = FirebaseFirestore.instance.collection("events").doc();
//       final eventId = doc.id;
//       debugPrint('✅ Generated event ID: $eventId');

//       // Step 2: Upload images to event_folder/{eventId}/
//       debugPrint('📤 ===== STARTING IMAGE UPLOAD =====');
//       final uploadedImages = await _uploadImages(eventId);
//       debugPrint(
//         '✅ Image upload complete. Uploaded: ${uploadedImages.keys.toList()}',
//       );

//       // Step 3: Build base event data
//       debugPrint('📝 Building base event data...');
//       final eventData = _buildBaseData();

//       // Step 4: Add media section with uploaded URLs
//       eventData['media'] = {
//         'posterLink': uploadedImages['posterLink'] ?? '',
//         'videoLink': videoDriveLink,
//         'galleryImages': uploadedImages['galleryImages'] ?? [],
//       };

//       debugPrint('📝 Final media data: ${eventData['media']}');

//       // Step 5: Save to Firestore with timestamps
//       debugPrint('💾 Saving to Firestore...');
//       await doc.set({
//         ...eventData,
//         'eventId': eventId,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       debugPrint('✅ ===== EVENT CREATED SUCCESSFULLY =====');
//       debugPrint('✅ Event ID: $eventId');
//       return eventId;
//     } catch (e, stackTrace) {
//       debugPrint('❌ ===== ERROR CREATING EVENT =====');
//       debugPrint('❌ Error: $e');
//       debugPrint('❌ Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   /// UPDATE: Update existing event with new images
//   // Future<String> updateEvent(String eventId) async {
//   //   try {
//   //     debugPrint('🔄 ===== STARTING EVENT UPDATE =====');
//   //     debugPrint('🔄 Event ID: $eventId');
//   //     debugPrint('🔄 Existing poster URL: $posterDriveLink');
//   //     debugPrint('🔄 Existing gallery URLs: ${galleryImageUrls.length}');
//   //     debugPrint('🔄 New poster file: ${posterImageFile != null}');
//   //     debugPrint('🔄 New gallery files: ${galleryImageFiles.length}');

//   //     // Step 1: Upload NEW images only
//   //     debugPrint('📤 ===== UPLOADING NEW IMAGES =====');
//   //     final uploadedImages = await _uploadImages(eventId);
//   //     debugPrint('✅ New images uploaded: ${uploadedImages.keys.toList()}');

//   //     // Step 2: Build base event data
//   //     debugPrint('📝 Building base event data...');
//   //     final eventData = _buildBaseData();

//   //     // Step 3: Build media section
//   //     // Use new poster URL if uploaded, otherwise keep existing
//   //     final finalPosterLink = uploadedImages['posterLink'] ?? posterDriveLink;

//   //     // Combine existing gallery URLs with new uploaded URLs
//   //     final finalGalleryImages = <String>[
//   //       ...galleryImageUrls, // Keep existing
//   //       ...(uploadedImages['galleryImages'] as List<String>? ?? []), // Add new
//   //     ];

//   //     eventData['media'] = {
//   //       'posterLink': finalPosterLink,
//   //       'videoLink': videoDriveLink,
//   //       'galleryImages': finalGalleryImages,
//   //     };

//   //     debugPrint('📝 Final poster link: $finalPosterLink');
//   //     debugPrint('📝 Final gallery count: ${finalGalleryImages.length}');

//   //     // Step 4: Update Firestore document
//   //     debugPrint('💾 Updating Firestore...');
//   //     await FirebaseFirestore.instance.collection("events").doc(eventId).update(
//   //       {...eventData, 'updatedAt': FieldValue.serverTimestamp()},
//   //     );

//   //     debugPrint('✅ ===== EVENT UPDATED SUCCESSFULLY =====');
//   //     return eventId;
//   //   } catch (e, stackTrace) {
//   //     debugPrint('❌ ===== ERROR UPDATING EVENT =====');
//   //     debugPrint('❌ Error: $e');
//   //     debugPrint('❌ Stack trace: $stackTrace');
//   //     rethrow;
//   //   }
//   // }
//   Future<String> updateEvent(String eventId) async {
//     try {
//       debugPrint('🔄 ===== STARTING EVENT UPDATE =====');
//       debugPrint('🔄 Event ID: $eventId');
//       debugPrint('🔄 Existing poster URL: $posterDriveLink');
//       debugPrint('🔄 Existing gallery URLs: ${galleryImageUrls.length}');
//       debugPrint('🔄 New poster file: ${posterImageFile != null}');
//       debugPrint('🔄 New gallery files: ${galleryImageFiles.length}');

//       // Step 1: Upload NEW gallery files with unique names
//       debugPrint('📤 ===== UPLOADING NEW GALLERY FILES =====');
//       final uploadedImages = await _uploadImages(eventId);
//       debugPrint('✅ New images uploaded: ${uploadedImages.keys.toList()}');

//       // Step 2: Build base event data
//       debugPrint('📝 Building base event data...');
//       final eventData = _buildBaseData();

//       // Step 3: Build media section
//       // Use new poster URL if uploaded, otherwise keep existing
//       final finalPosterLink = uploadedImages['posterLink'] ?? posterDriveLink;

//       // Combine existing gallery URLs (those the user kept) with new uploaded URLs (unique names)
//       final finalGalleryImages = <String>[
//         ...galleryImageUrls, // existing urls (kept)
//         ...(uploadedImages['galleryImages'] as List<String>? ??
//             []), // newly uploaded files
//       ];

//       eventData['media'] = {
//         'posterLink': finalPosterLink,
//         'videoLink': videoDriveLink,
//         'galleryImages': finalGalleryImages,
//       };

//       debugPrint('📝 Final poster link: $finalPosterLink');
//       debugPrint('📝 Final gallery count: ${finalGalleryImages.length}');

//       // Step 4: Update Firestore document
//       debugPrint('💾 Updating Firestore...');
//       await FirebaseFirestore.instance.collection("events").doc(eventId).update(
//         {...eventData, 'updatedAt': FieldValue.serverTimestamp()},
//       );

//       debugPrint('✅ ===== EVENT UPDATED SUCCESSFULLY =====');
//       return eventId;
//     } catch (e, stackTrace) {
//       debugPrint('❌ ===== ERROR UPDATING EVENT =====');
//       debugPrint('❌ Error: $e');
//       debugPrint('❌ Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   String _generateUniqueFilename(String prefix, String originalPath) {
//     final ts = DateTime.now().millisecondsSinceEpoch;
//     final rand =
//         (1000 + (DateTime.now().microsecond % 9000)); // simple pseudo-random
//     final ext =
//         originalPath.contains('.') ? originalPath.split('.').last : 'jpg';
//     return '${prefix}_${ts}_$rand.$ext';
//   }

//   /// DELETE: Delete event and all associated images
//   Future<void> deleteEvent(String eventId) async {
//     try {
//       debugPrint('🗑️ ===== STARTING EVENT DELETION =====');
//       debugPrint('🗑️ Event ID: $eventId');

//       // Step 1: Delete Firestore document first
//       debugPrint('🗑️ Deleting Firestore document...');
//       await FirebaseFirestore.instance
//           .collection("events")
//           .doc(eventId)
//           .delete();
//       debugPrint('✅ Firestore document deleted');

//       // Step 2: Delete images from storage
//       debugPrint('🗑️ Deleting images...');
//       await _deleteEventImages(eventId);
//       debugPrint('✅ Images deleted');

//       debugPrint('✅ ===== EVENT DELETED SUCCESSFULLY =====');
//     } catch (e, stackTrace) {
//       debugPrint('❌ ===== ERROR DELETING EVENT =====');
//       debugPrint('❌ Error: $e');
//       debugPrint('❌ Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   // /// Delete a specific gallery image from storage
//   // Future<void> deleteGalleryImageFromStorage(String eventId, int index) async {
//   //   try {
//   //     debugPrint('🗑️ Deleting gallery image $index from storage...');
//   //     final ref = FirebaseStorage.instance.ref().child(
//   //       "event_posters/$eventId/gallery_$index.jpg",
//   //     );
//   //     await ref.delete();
//   //     debugPrint('✅ Gallery image $index deleted from storage');
//   //   } catch (e) {
//   //     debugPrint('❌ Error deleting gallery image: $e');
//   //   }
//   // }

//   Future<bool> deleteImageFromStorage(String filePathOrUrl) async {
//     try {
//       final storage = FirebaseStorage.instance;

//       // If the input is a full URL, convert to reference path
//       Reference ref;
//       if (filePathOrUrl.startsWith('http')) {
//         ref = storage.refFromURL(filePathOrUrl);
//       } else {
//         ref = storage.ref().child(filePathOrUrl);
//       }

//       await ref.delete();
//       print('✅ File deleted successfully: $filePathOrUrl');
//       return true;
//     } catch (e) {
//       print('❌ Failed to delete file: $e');
//       return false;
//     }
//   }

//   // ─── LOAD FROM FIRESTORE ─────────────────────────────────────────

//   /// Load event data from Firestore for editing
//   void loadFromFirestore(Map<String, dynamic> data, String? id) {
//     debugPrint('📥 ===== LOADING EVENT DATA =====');
//     debugPrint('📥 Event ID: $id');

//     name = data['name'] ?? '';
//     category = data['category'] ?? 'Music';
//     ageRestriction = data['ageRestriction'] ?? 'None';
//     ticketRequiredAge = data['ticketRequiredAge'] ?? 'All Ages';
//     layout = data['layout'] ?? 'Indoor';

//     languages.clear();
//     if (data['languages'] != null) {
//       languages.addAll(List<String>.from(data['languages']));
//     }

//     // Load days
//     days.clear();
//     if (data['days'] != null && data['days'] is List) {
//       for (final dayData in data['days']) {
//         if (dayData is Map) {
//           // Find the day key (day1, day2, etc.)
//           final dayKey = dayData.keys.firstWhere(
//             (key) => key.toString().startsWith('day'),
//             orElse: () => 'day1',
//           );

//           final dayInfo = dayData[dayKey];
//           if (dayInfo is Map) {
//             days.add({
//               'date':
//                   (dayInfo['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
//               'startTime': _mapToTimeOfDay(dayInfo['startTime']),
//               'endTime': _mapToTimeOfDay(dayInfo['endTime']),
//             });
//           }
//         }
//       }
//     }

//     // If no days loaded, add default
//     if (days.isEmpty) {
//       days.add({
//         'date': DateTime.now().add(const Duration(days: 1)),
//         'startTime': const TimeOfDay(hour: 18, minute: 0),
//         'endTime': const TimeOfDay(hour: 21, minute: 0),
//       });
//     }

//     venueName = data['venue']?['name'] ?? '';
//     venueFullAddress = data['venue']?['fullAddress'] ?? '';
//     venueLat = data['venue']?['venueLat'] ?? '';
//     venueLng = data['venue']?['venueLng'] ?? '';
//     venueMapsLink = data['venue']?['mapsLink'] ?? '';

//     organiserCompany = data['organiser']?['companyName'] ?? '';
//     organiserContactPerson = data['organiser']?['contactPerson'] ?? '';
//     organiserPhone = data['organiser']?['contactPhone'] ?? '';
//     organiserEmail = data['organiser']?['contactEmail'] ?? '';

//     artistLineup.clear();
//     if (data['artistLineup'] != null) {
//       artistLineup.addAll(List<String>.from(data['artistLineup']));
//     }

//     posterDriveLink = data['media']?['posterLink'] ?? '';
//     videoDriveLink = data['media']?['videoLink'] ?? '';

//     galleryImageUrls.clear();
//     if (data['media']?['galleryImages'] != null) {
//       galleryImageUrls.addAll(
//         List<String>.from(data['media']['galleryImages']),
//       );
//     }

//     tickets.clear();
//     if (data['tickets'] != null) {
//       for (final t in data['tickets']) {
//         tickets.add(TicketCategory.fromMap(Map<String, dynamic>.from(t)));
//       }
//     }

//     bankAccount = data['financial']?['accountNumber'] ?? '';
//     ifsc = data['financial']?['ifsc'] ?? '';
//     panOrGst = data['financial']?['panOrGst'] ?? '';
//     bankName = data['financial']?['bankName'] ?? '';
//     accountHolder = data['financial']?['accountHolder'] ?? '';

//     hashtags.clear();
//     if (data['promotion']?['hashtags'] != null) {
//       hashtags.addAll(List<String>.from(data['promotion']['hashtags']));
//     }

//     socialLinks = Map<String, String>.from(
//       data['promotion']?['socialLinks'] ??
//           {'instagram': '', 'facebook': '', 'twitter': ''},
//     );

//     nocLinks.clear();
//     if (data['legal']?['noc'] != null) {
//       nocLinks.addAll(List<String>.from(data['legal']['noc']));
//     }

//     gstNo = data['legal']?['gstNo'] ?? '';
//     liabilityText = data['legal']?['liabilityText'] ?? '';

//     // Update text controllers
//     nameController.text = name;
//     venueNameController.text = venueName;
//     venueAddressController.text = venueFullAddress;
//     venueMapsLinkController.text = venueMapsLink;
//     organiserCompanyController.text = organiserCompany;
//     organiserPersonController.text = organiserContactPerson;
//     organiserPhoneController.text = organiserPhone;
//     organiserEmailController.text = organiserEmail;
//     bankAccountController.text = bankAccount;
//     ifscController.text = ifsc;
//     panGstController.text = panOrGst;
//     gstNoController.text = gstNo;
//     liabilityController.text = liabilityText;
//     posterController.text = posterDriveLink;
//     videoController.text = videoDriveLink;

//     debugPrint('✅ Event data loaded successfully');
//     notifyListeners();
//   }

//   // ─── RESET PROVIDER ──────────────────────────────────────────────
//   void reset() {
//     name = '';
//     category = 'Music';
//     ageRestriction = 'None';
//     ticketRequiredAge = 'All Ages';
//     layout = 'Indoor';
//     languages.clear();

//     days = [
//       {
//         'date': DateTime.now().add(const Duration(days: 1)),
//         'startTime': const TimeOfDay(hour: 18, minute: 0),
//         'endTime': const TimeOfDay(hour: 21, minute: 0),
//       },
//     ];

//     venueName = '';
//     venueFullAddress = '';
//     venueLat = '';
//     venueLng = '';
//     venueMapsLink = '';
//     organiserCompany = '';
//     organiserContactPerson = '';
//     organiserPhone = '';
//     organiserEmail = '';
//     artistLineup.clear();
//     posterDriveLink = '';
//     videoDriveLink = '';
//     hashtags.clear();
//     socialLinks = {'instagram': '', 'facebook': '', 'twitter': ''};
//     tickets.clear();
//     bankAccount = '';
//     ifsc = '';
//     panOrGst = '';
//     bankName = '';
//     accountHolder = '';
//     nocLinks.clear();
//     gstNo = '';
//     liabilityText = '';
//     posterImageFile = null;
//     galleryImageFiles.clear();
//     galleryImageUrls.clear();

//     // Clear controllers
//     nameController.clear();
//     venueNameController.clear();
//     venueAddressController.clear();
//     venueMapsLinkController.clear();
//     organiserCompanyController.clear();
//     organiserPersonController.clear();
//     organiserPhoneController.clear();
//     organiserEmailController.clear();
//     bankAccountController.clear();
//     ifscController.clear();
//     panGstController.clear();
//     gstNoController.clear();
//     liabilityController.clear();
//     posterController.clear();
//     videoController.clear();

//     submitting = false;
//     notifyListeners();
//   }

//   void setSubmitting(bool value) {
//     submitting = value;
//     notifyListeners();
//   }
// }
// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/material.dart';
// // import '../constants/ticketcategory.dart';

// // class EventFormProvider extends ChangeNotifier {
// //   // ─── BASIC DETAILS ────────────────────────────────────────────────
// //   String name = '';
// //   String category = 'Music';
// //   String ageRestriction = 'None';
// //   String ticketRequiredAge = 'All Ages';
// //   String layout = 'Indoor';
// //   final List<String> languages = [];

// //   // ─── EVENT DAYS (SIMPLIFIED) ─────────────────────────────────────
// //   List<Map<String, dynamic>> days = [
// //     {
// //       'date': DateTime.now().add(const Duration(days: 1)),
// //       'startTime': const TimeOfDay(hour: 18, minute: 0),
// //       'endTime': const TimeOfDay(hour: 21, minute: 0),
// //     },
// //   ];

// //   // ─── TEXT CONTROLLERS ─────────────────────────────────────────────
// //   final nameController = TextEditingController();
// //   final venueNameController = TextEditingController();
// //   final venueAddressController = TextEditingController();
// //   final venueMapsLinkController = TextEditingController();
// //   final organiserCompanyController = TextEditingController();
// //   final organiserPersonController = TextEditingController();
// //   final organiserPhoneController = TextEditingController();
// //   final organiserEmailController = TextEditingController();
// //   final bankAccountController = TextEditingController();
// //   final ifscController = TextEditingController();
// //   final panGstController = TextEditingController();
// //   final gstNoController = TextEditingController();
// //   final liabilityController = TextEditingController();
// //   final posterController = TextEditingController();
// //   final videoController = TextEditingController();

// //   // ─── VENUE ───────────────────────────────────────────────────────
// //   String venueName = '';
// //   String venueFullAddress = '';
// //   String venueLat = '';
// //   String venueLng = '';
// //   String venueMapsLink = '';

// //   // ─── ORGANISER ───────────────────────────────────────────────────
// //   String organiserCompany = '';
// //   String organiserContactPerson = '';
// //   String organiserPhone = '';
// //   String organiserEmail = '';

// //   // ─── ARTISTS / MEDIA / PROMOTION ─────────────────────────────────
// //   final List<String> artistLineup = [];
// //   String posterDriveLink = '';
// //   String videoDriveLink = '';
// //   final List<String> hashtags = [];
// //   Map<String, String> socialLinks = {
// //     'instagram': '',
// //     'facebook': '',
// //     'twitter': '',
// //   };

// //   // ─── TICKETS ─────────────────────────────────────────────────────
// //   final List<TicketCategory> tickets = [];

// //   // ─── FINANCIAL / LEGAL ───────────────────────────────────────────
// //   String bankAccount = '';
// //   String ifsc = '';
// //   String panOrGst = '';
// //   String bankName = '';
// //   String accountHolder = '';
// //   final List<String> nocLinks = [];
// //   String gstNo = '';
// //   String liabilityText = '';

// //   // ─── IMAGE FILES & URLS ──────────────────────────────────────────
// //   File? posterImageFile;
// //   List<File> galleryImageFiles = [];
// //   List<String> galleryImageUrls = [];

// //   bool submitting = false;

// //   // ─── FIELD UPDATER ───────────────────────────────────────────────
// //   void updateField(String field, dynamic value) {
// //     switch (field) {
// //       case 'name':
// //         name = value;
// //         break;
// //       case 'category':
// //         category = value;
// //         break;
// //       case 'ageRestriction':
// //         ageRestriction = value;
// //         break;
// //       case 'ticketRequiredAge':
// //         ticketRequiredAge = value;
// //         break;
// //       case 'layout':
// //         layout = value;
// //         break;
// //       case 'venueName':
// //         venueName = value;
// //         break;
// //       case 'venueFullAddress':
// //         venueFullAddress = value;
// //         break;
// //       case 'venueLat':
// //         venueLat = value;
// //         break;
// //       case 'venueLng':
// //         venueLng = value;
// //         break;
// //       case 'venueMapsLink':
// //         venueMapsLink = value;
// //         break;
// //       case 'organiserCompany':
// //         organiserCompany = value;
// //         break;
// //       case 'organiserContactPerson':
// //         organiserContactPerson = value;
// //         break;
// //       case 'organiserPhone':
// //         organiserPhone = value;
// //         break;
// //       case 'organiserEmail':
// //         organiserEmail = value;
// //         break;
// //       case 'posterDriveLink':
// //         posterDriveLink = value;
// //         break;
// //       case 'videoDriveLink':
// //         videoDriveLink = value;
// //         break;
// //       case 'bankAccount':
// //         bankAccount = value;
// //         break;
// //       case 'ifsc':
// //         ifsc = value;
// //         break;
// //       case 'panOrGst':
// //         panOrGst = value;
// //         break;
// //       case 'bankName':
// //         bankName = value;
// //         break;
// //       case 'accountHolder':
// //         accountHolder = value;
// //         break;
// //       case 'gstNo':
// //         gstNo = value;
// //         break;
// //       case 'liabilityText':
// //         liabilityText = value;
// //         break;
// //     }
// //     notifyListeners();
// //   }

// //   // ─── LANGUAGE HELPERS ─────────────────────────────────────────────
// //   void addLanguage(String lang) {
// //     for (final l in lang
// //         .split(RegExp(r'[,\n]'))
// //         .map((e) => e.trim())
// //         .where((e) => e.isNotEmpty)) {
// //       if (!languages.contains(l)) languages.add(l);
// //     }
// //     notifyListeners();
// //   }

// //   void removeLanguage(String lang) {
// //     languages.remove(lang);
// //     notifyListeners();
// //   }

// //   // ─── DAY HELPERS ─────────────────────────────────────────────────
// //   void addDay() {
// //     days.add({
// //       'date': DateTime.now().add(const Duration(days: 1)),
// //       'startTime': const TimeOfDay(hour: 18, minute: 0),
// //       'endTime': const TimeOfDay(hour: 21, minute: 0),
// //     });
// //     notifyListeners();
// //   }

// //   void removeDay(int index) {
// //     if (days.length > 1) {
// //       days.removeAt(index);
// //       notifyListeners();
// //     }
// //   }

// //   void updateDay(int index, String field, dynamic value) {
// //     days[index][field] = value;
// //     notifyListeners();
// //   }

// //   // ─── ARTISTS / HASHTAGS / TICKETS / NOC ──────────────────────────
// //   void addArtist(String a) {
// //     for (final name in a
// //         .split(RegExp(r'[,\n]'))
// //         .map((e) => e.trim())
// //         .where((e) => e.isNotEmpty)) {
// //       if (!artistLineup.contains(name)) artistLineup.add(name);
// //     }
// //     notifyListeners();
// //   }

// //   void removeArtist(String a) {
// //     artistLineup.remove(a);
// //     notifyListeners();
// //   }

// //   void addHashtag(String h) {
// //     for (final tag in h
// //         .split(RegExp(r'[,\s\n#]+'))
// //         .map((e) => e.trim())
// //         .where((e) => e.isNotEmpty)) {
// //       final formatted = tag.startsWith('#') ? tag : '#$tag';
// //       if (!hashtags.contains(formatted)) hashtags.add(formatted);
// //     }
// //     notifyListeners();
// //   }

// //   void removeHashtag(String h) {
// //     hashtags.remove(h);
// //     notifyListeners();
// //   }

// //   void addTicket(TicketCategory t) {
// //     tickets.add(t);
// //     notifyListeners();
// //   }

// //   void removeTicket(TicketCategory t) {
// //     tickets.removeWhere((x) => x.id == t.id);
// //     notifyListeners();
// //   }

// //   void addNocLink(String u) {
// //     nocLinks.add(u);
// //     notifyListeners();
// //   }

// //   void removeNocLink(String u) {
// //     nocLinks.remove(u);
// //     notifyListeners();
// //   }

// //   // ─── IMAGE HANDLING ──────────────────────────────────────────────
// //   void setPosterImageFile(File file) {
// //     posterImageFile = file;
// //     notifyListeners();
// //   }

// //   void addGalleryImage(File file) {
// //     galleryImageFiles.add(file);
// //     notifyListeners();
// //   }

// //   void removeGalleryImage(int index) {
// //     galleryImageFiles.removeAt(index);
// //     notifyListeners();
// //   }

// //   void clearPosterImage() {
// //     posterImageFile = null;
// //     posterDriveLink = '';
// //     notifyListeners();
// //   }

// //   // ─── STORAGE HELPERS ─────────────────────────────────────────────

// //   /// Upload a single image to Firebase Storage
// //   Future<String?> _uploadImage(File file, String path) async {
// //     try {
// //       debugPrint('📤 Starting upload: $path');
// //       final ref = FirebaseStorage.instance.ref().child(path);

// //       // Upload file
// //       final uploadTask = ref.putFile(file);

// //       // Wait for upload to complete
// //       final snapshot = await uploadTask;

// //       // Get download URL
// //       final downloadUrl = await snapshot.ref.getDownloadURL();

// //       debugPrint('✅ Upload successful: $path');
// //       debugPrint('✅ Download URL: $downloadUrl');

// //       return downloadUrl;
// //     } catch (e) {
// //       debugPrint('❌ Error uploading image to $path: $e');
// //       return null;
// //     }
// //   }

// //   /// Upload all images (poster + gallery) to Firebase Storage
// //   Future<Map<String, dynamic>> _uploadImages(String eventId) async {
// //     final result = <String, dynamic>{};

// //     debugPrint('📤 Starting image upload for event: $eventId');
// //     debugPrint('📤 Poster file exists: ${posterImageFile != null}');
// //     debugPrint('📤 Gallery files count: ${galleryImageFiles.length}');

// //     // Upload poster image if exists
// //     if (posterImageFile != null) {
// //       debugPrint('📤 Uploading poster image...');
// //       final posterUrl = await _uploadImage(
// //         posterImageFile!,
// //         "event_posters/$eventId/poster.jpg",
// //       );
// //       if (posterUrl != null) {
// //         result["posterLink"] = posterUrl;
// //         debugPrint('✅ Poster uploaded: $posterUrl');
// //       } else {
// //         debugPrint('❌ Poster upload failed');
// //       }
// //     } else {
// //       debugPrint('ℹ️ No poster image to upload');
// //     }

// //     // Upload gallery images if exist
// //     if (galleryImageFiles.isNotEmpty) {
// //       debugPrint('📤 Uploading ${galleryImageFiles.length} gallery images...');
// //       final urls = <String>[];
// //       for (int i = 0; i < galleryImageFiles.length; i++) {
// //         debugPrint('📤 Uploading gallery image $i...');
// //         final url = await _uploadImage(
// //           galleryImageFiles[i],
// //           "event_posters/$eventId/gallery_$i.jpg",
// //         );
// //         if (url != null) {
// //           urls.add(url);
// //           debugPrint('✅ Gallery image $i uploaded: $url');
// //         } else {
// //           debugPrint('❌ Gallery image $i upload failed');
// //         }
// //       }
// //       if (urls.isNotEmpty) {
// //         result["galleryImages"] = urls;
// //         debugPrint('✅ All gallery images uploaded: ${urls.length} images');
// //       }
// //     } else {
// //       debugPrint('ℹ️ No gallery images to upload');
// //     }

// //     debugPrint('📤 Upload complete. Result keys: ${result.keys.toList()}');
// //     return result;
// //   }

// //   /// Delete all images in a folder
// //   Future<void> _deleteFolderContents(String path) async {
// //     try {
// //       debugPrint('🗑️ Deleting folder: $path');
// //       final folder = FirebaseStorage.instance.ref(path);
// //       final listResult = await folder.listAll();

// //       debugPrint('🗑️ Found ${listResult.items.length} files to delete');

// //       // Delete all files in the folder
// //       for (final item in listResult.items) {
// //         await item.delete();
// //         debugPrint('🗑️ Deleted file: ${item.fullPath}');
// //       }

// //       debugPrint('✅ Folder deleted successfully: $path');
// //     } catch (e) {
// //       debugPrint('❌ Error deleting folder $path: $e');
// //     }
// //   }

// //   /// Delete all images for an event
// //   Future<void> _deleteEventImages(String eventId) async {
// //     await _deleteFolderContents("event_posters/$eventId");
// //   }

// //   // ─── TIME OF DAY HELPERS ─────────────────────────────────────────
// //   Map<String, int> _timeOfDayToMap(TimeOfDay time) => {
// //     'hour': time.hour,
// //     'minute': time.minute,
// //   };

// //   TimeOfDay _mapToTimeOfDay(Map<String, dynamic>? map) =>
// //       TimeOfDay(hour: map?['hour'] ?? 18, minute: map?['minute'] ?? 0);

// //   // ─── FIRESTORE CRUD ──────────────────────────────────────────────

// //   /// Convert provider data to Firestore map (WITHOUT image URLs)
// //   Map<String, dynamic> _buildBaseData() {
// //     // Build days list for Firestore
// //     final daysData = <Map<String, dynamic>>[];
// //     for (int i = 0; i < days.length; i++) {
// //       daysData.add({
// //         'day${i + 1}': {
// //           'date': Timestamp.fromDate(days[i]['date']),
// //           'startTime': _timeOfDayToMap(days[i]['startTime']),
// //           'endTime': _timeOfDayToMap(days[i]['endTime']),
// //         },
// //       });
// //     }

// //     return {
// //       'name': name,
// //       'category': category,
// //       'ageRestriction': ageRestriction,
// //       'ticketRequiredAge': ticketRequiredAge,
// //       'layout': layout,
// //       'languages': languages,
// //       'days': daysData,
// //       'venue': {
// //         'name': venueName,
// //         'fullAddress': venueFullAddress,
// //         'venueLat': venueLat,
// //         'venueLng': venueLng,
// //         'mapsLink': venueMapsLink,
// //       },
// //       'organiser': {
// //         'companyName': organiserCompany,
// //         'contactPerson': organiserContactPerson,
// //         'contactPhone': organiserPhone,
// //         'contactEmail': organiserEmail,
// //       },
// //       'artistLineup': artistLineup,
// //       'tickets': tickets.map((t) => t.toMap()).toList(),
// //       'financial': {
// //         'accountNumber': bankAccount,
// //         'ifsc': ifsc,
// //         'panOrGst': panOrGst,
// //         'bankName': bankName,
// //         'accountHolder': accountHolder,
// //       },
// //       'promotion': {'hashtags': hashtags, 'socialLinks': socialLinks},
// //       'legal': {
// //         'noc': nocLinks,
// //         'gstNo': gstNo,
// //         'liabilityText': liabilityText,
// //       },
// //       'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
// //     };
// //   }

// //   /// CREATE: Create new event with images
// //   Future<String> createEvent() async {
// //     try {
// //       debugPrint('🚀 ===== STARTING EVENT CREATION =====');

// //       // Step 1: Create document to get ID
// //       final doc = FirebaseFirestore.instance.collection("events").doc();
// //       final eventId = doc.id;
// //       debugPrint('✅ Generated event ID: $eventId');

// //       // Step 2: Upload images to event_folder/{eventId}/
// //       debugPrint('📤 ===== STARTING IMAGE UPLOAD =====');
// //       final uploadedImages = await _uploadImages(eventId);
// //       debugPrint(
// //         '✅ Image upload complete. Uploaded: ${uploadedImages.keys.toList()}',
// //       );

// //       // Step 3: Build base event data
// //       debugPrint('📝 Building base event data...');
// //       final eventData = _buildBaseData();

// //       // Step 4: Add media section with uploaded URLs
// //       eventData['media'] = {
// //         'posterLink': uploadedImages['posterLink'] ?? '',
// //         'videoLink': videoDriveLink,
// //         'galleryImages': uploadedImages['galleryImages'] ?? [],
// //       };

// //       debugPrint('📝 Final media data: ${eventData['media']}');

// //       // Step 5: Save to Firestore with timestamps
// //       debugPrint('💾 Saving to Firestore...');
// //       await doc.set({
// //         ...eventData,
// //         'eventId': eventId,
// //         'createdAt': FieldValue.serverTimestamp(),
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       });

// //       debugPrint('✅ ===== EVENT CREATED SUCCESSFULLY =====');
// //       debugPrint('✅ Event ID: $eventId');
// //       return eventId;
// //     } catch (e, stackTrace) {
// //       debugPrint('❌ ===== ERROR CREATING EVENT =====');
// //       debugPrint('❌ Error: $e');
// //       debugPrint('❌ Stack trace: $stackTrace');
// //       rethrow;
// //     }
// //   }

// //   /// UPDATE: Update existing event with new images
// //   Future<String> updateEvent(String eventId) async {
// //     try {
// //       debugPrint('🔄 ===== STARTING EVENT UPDATE =====');
// //       debugPrint('🔄 Event ID: $eventId');

// //       // Step 1: Delete old images from storage
// //       debugPrint('🗑️ Deleting old images...');
// //       await _deleteEventImages(eventId);
// //       debugPrint('✅ Old images deleted');

// //       // Step 2: Upload new images to event_folder/{eventId}/
// //       debugPrint('📤 ===== STARTING IMAGE UPLOAD =====');
// //       final uploadedImages = await _uploadImages(eventId);
// //       debugPrint('✅ New images uploaded: ${uploadedImages.keys.toList()}');

// //       // Step 3: Build base event data
// //       debugPrint('📝 Building base event data...');
// //       final eventData = _buildBaseData();

// //       // Step 4: Add media section with uploaded URLs
// //       eventData['media'] = {
// //         'posterLink': uploadedImages['posterLink'] ?? '',
// //         'videoLink': videoDriveLink,
// //         'galleryImages': uploadedImages['galleryImages'] ?? [],
// //       };

// //       debugPrint('📝 Final media data: ${eventData['media']}');

// //       // Step 5: Update Firestore document
// //       debugPrint('💾 Updating Firestore...');
// //       await FirebaseFirestore.instance.collection("events").doc(eventId).update(
// //         {...eventData, 'updatedAt': FieldValue.serverTimestamp()},
// //       );

// //       debugPrint('✅ ===== EVENT UPDATED SUCCESSFULLY =====');
// //       return eventId;
// //     } catch (e, stackTrace) {
// //       debugPrint('❌ ===== ERROR UPDATING EVENT =====');
// //       debugPrint('❌ Error: $e');
// //       debugPrint('❌ Stack trace: $stackTrace');
// //       rethrow;
// //     }
// //   }

// //   /// DELETE: Delete event and all associated images
// //   Future<void> deleteEvent(String eventId) async {
// //     try {
// //       debugPrint('🗑️ ===== STARTING EVENT DELETION =====');
// //       debugPrint('🗑️ Event ID: $eventId');

// //       // Step 1: Delete images from storage
// //       debugPrint('🗑️ Deleting images...');
// //       await _deleteEventImages(eventId);
// //       debugPrint('✅ Images deleted');

// //       // Step 2: Delete Firestore document
// //       debugPrint('🗑️ Deleting Firestore document...');
// //       await FirebaseFirestore.instance
// //           .collection("events")
// //           .doc(eventId)
// //           .delete();

// //       debugPrint('✅ ===== EVENT DELETED SUCCESSFULLY =====');
// //     } catch (e, stackTrace) {
// //       debugPrint('❌ ===== ERROR DELETING EVENT =====');
// //       debugPrint('❌ Error: $e');
// //       debugPrint('❌ Stack trace: $stackTrace');
// //       rethrow;
// //     }
// //   }

// //   // ─── LOAD FROM FIRESTORE ─────────────────────────────────────────

// //   /// Load event data from Firestore for editing
// //   void loadFromFirestore(Map<String, dynamic> data, String? id) {
// //     debugPrint('📥 ===== LOADING EVENT DATA =====');
// //     debugPrint('📥 Event ID: $id');

// //     name = data['name'] ?? '';
// //     category = data['category'] ?? 'Music';
// //     ageRestriction = data['ageRestriction'] ?? 'None';
// //     ticketRequiredAge = data['ticketRequiredAge'] ?? 'All Ages';
// //     layout = data['layout'] ?? 'Indoor';

// //     languages.clear();
// //     if (data['languages'] != null) {
// //       languages.addAll(List<String>.from(data['languages']));
// //     }

// //     // Load days
// //     days.clear();
// //     if (data['days'] != null && data['days'] is List) {
// //       for (final dayData in data['days']) {
// //         if (dayData is Map) {
// //           // Find the day key (day1, day2, etc.)
// //           final dayKey = dayData.keys.firstWhere(
// //             (key) => key.toString().startsWith('day'),
// //             orElse: () => 'day1',
// //           );

// //           final dayInfo = dayData[dayKey];
// //           if (dayInfo is Map) {
// //             days.add({
// //               'date':
// //                   (dayInfo['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
// //               'startTime': _mapToTimeOfDay(dayInfo['startTime']),
// //               'endTime': _mapToTimeOfDay(dayInfo['endTime']),
// //             });
// //           }
// //         }
// //       }
// //     }

// //     // If no days loaded, add default
// //     if (days.isEmpty) {
// //       days.add({
// //         'date': DateTime.now().add(const Duration(days: 1)),
// //         'startTime': const TimeOfDay(hour: 18, minute: 0),
// //         'endTime': const TimeOfDay(hour: 21, minute: 0),
// //       });
// //     }

// //     venueName = data['venue']?['name'] ?? '';
// //     venueFullAddress = data['venue']?['fullAddress'] ?? '';
// //     venueLat = data['venue']?['venueLat'] ?? '';
// //     venueLng = data['venue']?['venueLng'] ?? '';
// //     venueMapsLink = data['venue']?['mapsLink'] ?? '';

// //     organiserCompany = data['organiser']?['companyName'] ?? '';
// //     organiserContactPerson = data['organiser']?['contactPerson'] ?? '';
// //     organiserPhone = data['organiser']?['contactPhone'] ?? '';
// //     organiserEmail = data['organiser']?['contactEmail'] ?? '';

// //     artistLineup.clear();
// //     if (data['artistLineup'] != null) {
// //       artistLineup.addAll(List<String>.from(data['artistLineup']));
// //     }

// //     posterDriveLink = data['media']?['posterLink'] ?? '';
// //     videoDriveLink = data['media']?['videoLink'] ?? '';

// //     galleryImageUrls.clear();
// //     if (data['media']?['galleryImages'] != null) {
// //       galleryImageUrls.addAll(
// //         List<String>.from(data['media']['galleryImages']),
// //       );
// //     }

// //     tickets.clear();
// //     if (data['tickets'] != null) {
// //       for (final t in data['tickets']) {
// //         tickets.add(TicketCategory.fromMap(Map<String, dynamic>.from(t)));
// //       }
// //     }

// //     bankAccount = data['financial']?['accountNumber'] ?? '';
// //     ifsc = data['financial']?['ifsc'] ?? '';
// //     panOrGst = data['financial']?['panOrGst'] ?? '';
// //     bankName = data['financial']?['bankName'] ?? '';
// //     accountHolder = data['financial']?['accountHolder'] ?? '';

// //     hashtags.clear();
// //     if (data['promotion']?['hashtags'] != null) {
// //       hashtags.addAll(List<String>.from(data['promotion']['hashtags']));
// //     }

// //     socialLinks = Map<String, String>.from(
// //       data['promotion']?['socialLinks'] ??
// //           {'instagram': '', 'facebook': '', 'twitter': ''},
// //     );

// //     nocLinks.clear();
// //     if (data['legal']?['noc'] != null) {
// //       nocLinks.addAll(List<String>.from(data['legal']['noc']));
// //     }

// //     gstNo = data['legal']?['gstNo'] ?? '';
// //     liabilityText = data['legal']?['liabilityText'] ?? '';

// //     // Update text controllers
// //     nameController.text = name;
// //     venueNameController.text = venueName;
// //     venueAddressController.text = venueFullAddress;
// //     venueMapsLinkController.text = venueMapsLink;
// //     organiserCompanyController.text = organiserCompany;
// //     organiserPersonController.text = organiserContactPerson;
// //     organiserPhoneController.text = organiserPhone;
// //     organiserEmailController.text = organiserEmail;
// //     bankAccountController.text = bankAccount;
// //     ifscController.text = ifsc;
// //     panGstController.text = panOrGst;
// //     gstNoController.text = gstNo;
// //     liabilityController.text = liabilityText;
// //     posterController.text = posterDriveLink;
// //     videoController.text = videoDriveLink;

// //     debugPrint('✅ Event data loaded successfully');
// //     notifyListeners();
// //   }

// //   // ─── RESET PROVIDER ──────────────────────────────────────────────
// //   void reset() {
// //     name = '';
// //     category = 'Music';
// //     ageRestriction = 'None';
// //     ticketRequiredAge = 'All Ages';
// //     layout = 'Indoor';
// //     languages.clear();

// //     days = [
// //       {
// //         'date': DateTime.now().add(const Duration(days: 1)),
// //         'startTime': const TimeOfDay(hour: 18, minute: 0),
// //         'endTime': const TimeOfDay(hour: 21, minute: 0),
// //       },
// //     ];

// //     venueName = '';
// //     venueFullAddress = '';
// //     venueLat = '';
// //     venueLng = '';
// //     venueMapsLink = '';
// //     organiserCompany = '';
// //     organiserContactPerson = '';
// //     organiserPhone = '';
// //     organiserEmail = '';
// //     artistLineup.clear();
// //     posterDriveLink = '';
// //     videoDriveLink = '';
// //     hashtags.clear();
// //     socialLinks = {'instagram': '', 'facebook': '', 'twitter': ''};
// //     tickets.clear();
// //     bankAccount = '';
// //     ifsc = '';
// //     panOrGst = '';
// //     bankName = '';
// //     accountHolder = '';
// //     nocLinks.clear();
// //     gstNo = '';
// //     liabilityText = '';
// //     posterImageFile = null;
// //     galleryImageFiles.clear();
// //     galleryImageUrls.clear();

// //     // Clear controllers
// //     nameController.clear();
// //     venueNameController.clear();
// //     venueAddressController.clear();
// //     venueMapsLinkController.clear();
// //     organiserCompanyController.clear();
// //     organiserPersonController.clear();
// //     organiserPhoneController.clear();
// //     organiserEmailController.clear();
// //     bankAccountController.clear();
// //     ifscController.clear();
// //     panGstController.clear();
// //     gstNoController.clear();
// //     liabilityController.clear();
// //     posterController.clear();
// //     videoController.clear();

// //     submitting = false;
// //     notifyListeners();
// //   }

// //   void setSubmitting(bool value) {
// //     submitting = value;
// //     notifyListeners();
// //   }
// // }
