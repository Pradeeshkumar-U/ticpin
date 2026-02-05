// // // // turf_form_provider.dart

// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:ticpin_play/constants/turf.dart';

// // // class TurfFormProvider extends ChangeNotifier {
// // //   // ───────── BASIC INFO ─────────
// // //   String name = '';
// // //   String city = '';
// // //   String address = '';
// // //   String mapLink = '';
// // //   String contact = '';
// // //   String ownerName = '';
// // //   String ownerUid = '';

// // //   // Location
// // //   String venueLat = '';
// // //   String venueLng = '';

// // //   // ───────── MEDIA ─────────
// // //   List<File> posterImages = [];
// // //   List<String> existingPosterUrls = []; // For edit mode

// // //   // ───────── LISTS ─────────
// // //   List<String> playground = [];
// // //   List<String> venueInfo = [];
// // //   List<String> amenities = [];
// // //   List<String> venueRules = [];

// // //   // ───────── WEEKLY SCHEDULE ─────────
// // //   Map<String, TurfDay> weeklySchedule = {
// // //     "monday": TurfDay(),
// // //     "tuesday": TurfDay(),
// // //     "wednesday": TurfDay(),
// // //     "thursday": TurfDay(),
// // //     "friday": TurfDay(),
// // //     "saturday": TurfDay(),
// // //     "sunday": TurfDay(),
// // //   };

// // //   bool submitting = false;

// // //   // ───────── UPDATE METHODS ─────────
// // //   void updateField(String field, dynamic value) {
// // //     switch (field) {
// // //       case 'name':
// // //         name = value;
// // //         break;
// // //       case 'city':
// // //         city = value;
// // //         break;
// // //       case 'address':
// // //         address = value;
// // //         break;
// // //       case 'mapLink':
// // //         mapLink = value;
// // //         break;
// // //       case 'contact':
// // //         contact = value;
// // //         break;
// // //       case 'ownerName':
// // //         ownerName = value;
// // //         break;
// // //       case 'ownerUid':
// // //         ownerUid = value;
// // //         break;
// // //       case 'venueLat':
// // //         venueLat = value;
// // //         break;
// // //       case 'venueLng':
// // //         venueLng = value;
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   // ───────── POSTER METHODS ─────────
// // //   void addPosterImage(File file) {
// // //     posterImages.add(file);
// // //     notifyListeners();
// // //   }

// // //   void removePosterImage(int index) {
// // //     posterImages.removeAt(index);
// // //     notifyListeners();
// // //   }

// // //   Future<bool> deleteExistingPoster(String url, String turfId) async {
// // //     try {
// // //       final ref = FirebaseStorage.instance.refFromURL(url);
// // //       await ref.delete();
// // //       existingPosterUrls.remove(url);

// // //       // Update Firestore
// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update({
// // //         'poster_urls': existingPosterUrls,
// // //       });

// // //       notifyListeners();
// // //       return true;
// // //     } catch (e) {
// // //       debugPrint('Error deleting poster: $e');
// // //       return false;
// // //     }
// // //   }

// // //   // ───────── LIST METHODS ─────────
// // //   void addToList(String listName, String value) {
// // //     switch (listName) {
// // //       case 'playground':
// // //         playground.add(value);
// // //         break;
// // //       case 'venueInfo':
// // //         venueInfo.add(value);
// // //         break;
// // //       case 'amenities':
// // //         amenities.add(value);
// // //         break;
// // //       case 'venueRules':
// // //         venueRules.add(value);
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   void removeFromList(String listName, int index) {
// // //     switch (listName) {
// // //       case 'playground':
// // //         playground.removeAt(index);
// // //         break;
// // //       case 'venueInfo':
// // //         venueInfo.removeAt(index);
// // //         break;
// // //       case 'amenities':
// // //         amenities.removeAt(index);
// // //         break;
// // //       case 'venueRules':
// // //         venueRules.removeAt(index);
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   // ───────── SCHEDULE METHODS ─────────
// // //   void toggleDay(String day, bool open) {
// // //     weeklySchedule[day]!.isOpen = open;
// // //     if (!open) {
// // //       weeklySchedule[day]!.shifts.clear();
// // //     }
// // //     notifyListeners();
// // //   }

// // //   void addShift(String day) {
// // //     weeklySchedule[day]!.shifts.add(
// // //       TurfShift(
// // //         start: const TimeOfDay(hour: 9, minute: 0),
// // //         end: const TimeOfDay(hour: 10, minute: 0),
// // //         price: 0.0,
// // //       ),
// // //     );
// // //     notifyListeners();
// // //   }

// // //   void removeShift(String day, int index) {
// // //     weeklySchedule[day]!.shifts.removeAt(index);
// // //     notifyListeners();
// // //   }

// // //   void updateShift(String day, int index, {TimeOfDay? start, TimeOfDay? end, double? price}) {
// // //     if (start != null) weeklySchedule[day]!.shifts[index].start = start;
// // //     if (end != null) weeklySchedule[day]!.shifts[index].end = end;
// // //     if (price != null) weeklySchedule[day]!.shifts[index].price = price;
// // //     notifyListeners();
// // //   }

// // //   // ───────── SAVE TO FIRESTORE ─────────
// // //   Future<String> createTurf() async {
// // //     try {
// // //       setSubmitting(true);

// // //       final turfId = FirebaseFirestore.instance.collection('turfs').doc().id;

// // //       // Upload posters
// // //       List<String> posterUrls = [];
// // //       for (int i = 0; i < posterImages.length; i++) {
// // //         final ref = FirebaseStorage.instance
// // //             .ref('turf_posters/$turfId/poster_$i.jpg');
// // //         await ref.putFile(posterImages[i]);
// // //         final url = await ref.getDownloadURL();
// // //         posterUrls.add(url);
// // //       }

// // //       final data = {
// // //         'turfId': turfId,
// // //         'name': name,
// // //         'city': city,
// // //         'address': address,
// // //         'map_link': mapLink,
// // //         'contact': contact,
// // //         'owner_name': ownerName,
// // //         'owner_uid': FirebaseAuth.instance.currentUser?.uid ?? '',
// // //         'venue_lat': venueLat,
// // //         'venue_lng': venueLng,
// // //         'playground': playground,
// // //         'venue_info': venueInfo,
// // //         'amenities': amenities,
// // //         'venue_rules': venueRules,
// // //         'schedule': weeklySchedule.map((day, d) => MapEntry(day, d.toMap())),
// // //         'poster_urls': posterUrls,
// // //         'created_at': FieldValue.serverTimestamp(),
// // //         'createdBy': FirebaseAuth.instance.currentUser?.uid ?? '',
// // //       };

// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).set(data);

// // //       setSubmitting(false);
// // //       return turfId;
// // //     } catch (e) {
// // //       setSubmitting(false);
// // //       rethrow;
// // //     }
// // //   }

// // //   Future<String> updateTurf(String turfId) async {
// // //     try {
// // //       setSubmitting(true);

// // //       // Upload new posters
// // //       List<String> newPosterUrls = List.from(existingPosterUrls);
// // //       for (int i = 0; i < posterImages.length; i++) {
// // //         final ref = FirebaseStorage.instance
// // //             .ref('turf_posters/$turfId/poster_${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
// // //         await ref.putFile(posterImages[i]);
// // //         final url = await ref.getDownloadURL();
// // //         newPosterUrls.add(url);
// // //       }

// // //       final data = {
// // //         'name': name,
// // //         'city': city,
// // //         'address': address,
// // //         'map_link': mapLink,
// // //         'contact': contact,
// // //         'owner_name': ownerName,
// // //         'venue_lat': venueLat,
// // //         'venue_lng': venueLng,
// // //         'playground': playground,
// // //         'venue_info': venueInfo,
// // //         'amenities': amenities,
// // //         'venue_rules': venueRules,
// // //         'schedule': weeklySchedule.map((day, d) => MapEntry(day, d.toMap())),
// // //         'poster_urls': newPosterUrls,
// // //         'updated_at': FieldValue.serverTimestamp(),
// // //       };

// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update(data);

// // //       setSubmitting(false);
// // //       return turfId;
// // //     } catch (e) {
// // //       setSubmitting(false);
// // //       rethrow;
// // //     }
// // //   }

// // //   // ───────── LOAD FROM FIRESTORE ─────────
// // //   void loadFromFirestore(Map<String, dynamic> data, String? turfId) {
// // //     name = data['name'] ?? '';
// // //     city = data['city'] ?? '';
// // //     address = data['address'] ?? '';
// // //     mapLink = data['map_link'] ?? '';
// // //     contact = data['contact'] ?? '';
// // //     ownerName = data['owner_name'] ?? '';
// // //     ownerUid = data['owner_uid'] ?? '';
// // //     venueLat = data['venue_lat'] ?? '';
// // //     venueLng = data['venue_lng'] ?? '';

// // //     playground = List<String>.from(data['playground'] ?? []);
// // //     venueInfo = List<String>.from(data['venue_info'] ?? []);
// // //     amenities = List<String>.from(data['amenities'] ?? []);
// // //     venueRules = List<String>.from(data['venue_rules'] ?? []);

// // //     existingPosterUrls = List<String>.from(data['poster_urls'] ?? []);

// // //     // Load schedule
// // //     if (data['schedule'] != null) {
// // //       final scheduleMap = data['schedule'] as Map<String, dynamic>;
// // //       scheduleMap.forEach((day, dayData) {
// // //         weeklySchedule[day] = TurfDay.fromMap(dayData as Map<String, dynamic>);
// // //       });
// // //     }

// // //     notifyListeners();
// // //   }

// // //   // ───────── UTILITY ─────────
// // //   void setSubmitting(bool value) {
// // //     submitting = value;
// // //     notifyListeners();
// // //   }

// // //   void reset() {
// // //     name = '';
// // //     city = '';
// // //     address = '';
// // //     mapLink = '';
// // //     contact = '';
// // //     ownerName = '';
// // //     ownerUid = '';
// // //     venueLat = '';
// // //     venueLng = '';
// // //     posterImages.clear();
// // //     existingPosterUrls.clear();
// // //     playground.clear();
// // //     venueInfo.clear();
// // //     amenities.clear();
// // //     venueRules.clear();
// // //     weeklySchedule.updateAll((key, value) => TurfDay());
// // //     submitting = false;
// // //     notifyListeners();
// // //   }
// // // }

// // // turf_form_provider.dart

// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:ticpin_play/constants/turf.dart';

// // // class TurfFormProvider extends ChangeNotifier {
// // //   // ───────── BASIC INFO ─────────
// // //   String name = '';
// // //   String city = '';
// // //   String address = '';
// // //   String mapLink = '';
// // //   String contact = '';
// // //   String ownerName = '';
// // //   String ownerUid = '';

// // //   // Location
// // //   String venueLat = '';
// // //   String venueLng = '';

// // //   // ───────── MEDIA ─────────
// // //   List<File> posterImages = [];
// // //   List<String> existingPosterUrls = []; // For edit mode

// // //   // ───────── LISTS ─────────
// // //   List<String> playground = [];
// // //   List<String> venueInfo = [];
// // //   List<String> amenities = [];
// // //   List<String> venueRules = [];

// // //   // ───────── PRICING ─────────
// // //   double halfHourPrice = 0.0;

// // //   // ───────── WEEKLY SCHEDULE (Simplified - just on/off days) ─────────
// // //   Map<String, TurfDay> weeklySchedule = {
// // //     "monday": TurfDay(isOpen: true),
// // //     "tuesday": TurfDay(isOpen: true),
// // //     "wednesday": TurfDay(isOpen: true),
// // //     "thursday": TurfDay(isOpen: true),
// // //     "friday": TurfDay(isOpen: true),
// // //     "saturday": TurfDay(isOpen: true),
// // //     "sunday": TurfDay(isOpen: true),
// // //   };

// // //   bool submitting = false;

// // //   // ───────── UPDATE METHODS ─────────
// // //   void updateField(String field, dynamic value) {
// // //     switch (field) {
// // //       case 'name':
// // //         name = value;
// // //         break;
// // //       case 'city':
// // //         city = value;
// // //         break;
// // //       case 'address':
// // //         address = value;
// // //         break;
// // //       case 'mapLink':
// // //         mapLink = value;
// // //         break;
// // //       case 'contact':
// // //         contact = value;
// // //         break;
// // //       case 'ownerName':
// // //         ownerName = value;
// // //         break;
// // //       case 'ownerUid':
// // //         ownerUid = value;
// // //         break;
// // //       case 'venueLat':
// // //         venueLat = value;
// // //         break;
// // //       case 'venueLng':
// // //         venueLng = value;
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   void updateHalfHourPrice(double price) {
// // //     halfHourPrice = price;
// // //     notifyListeners();
// // //   }

// // //   // ───────── POSTER METHODS ─────────
// // //   void addPosterImage(File file) {
// // //     posterImages.add(file);
// // //     notifyListeners();
// // //   }

// // //   void removePosterImage(int index) {
// // //     posterImages.removeAt(index);
// // //     notifyListeners();
// // //   }

// // //   Future<bool> deleteExistingPoster(String url, String turfId) async {
// // //     try {
// // //       final ref = FirebaseStorage.instance.refFromURL(url);
// // //       await ref.delete();
// // //       existingPosterUrls.remove(url);

// // //       // Update Firestore
// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update({
// // //         'poster_urls': existingPosterUrls,
// // //       });

// // //       notifyListeners();
// // //       return true;
// // //     } catch (e) {
// // //       debugPrint('Error deleting poster: $e');
// // //       return false;
// // //     }
// // //   }

// // //   // ───────── LIST METHODS ─────────
// // //   void addToList(String listName, String value) {
// // //     switch (listName) {
// // //       case 'playground':
// // //         playground.add(value);
// // //         break;
// // //       case 'venueInfo':
// // //         venueInfo.add(value);
// // //         break;
// // //       case 'amenities':
// // //         amenities.add(value);
// // //         break;
// // //       case 'venueRules':
// // //         venueRules.add(value);
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   void removeFromList(String listName, int index) {
// // //     switch (listName) {
// // //       case 'playground':
// // //         playground.removeAt(index);
// // //         break;
// // //       case 'venueInfo':
// // //         venueInfo.removeAt(index);
// // //         break;
// // //       case 'amenities':
// // //         amenities.removeAt(index);
// // //         break;
// // //       case 'venueRules':
// // //         venueRules.removeAt(index);
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   // ───────── SCHEDULE METHODS (Simplified) ─────────
// // //   void toggleDay(String day, bool open) {
// // //     weeklySchedule[day]!.isOpen = open;
// // //     notifyListeners();
// // //   }

// // //   // ───────── SAVE TO FIRESTORE ─────────
// // //   Future<String> createTurf() async {
// // //     try {
// // //       setSubmitting(true);

// // //       final turfId = FirebaseFirestore.instance.collection('turfs').doc().id;

// // //       // Upload posters
// // //       List<String> posterUrls = [];
// // //       for (int i = 0; i < posterImages.length; i++) {
// // //         final ref = FirebaseStorage.instance
// // //             .ref('turf_posters/$turfId/poster_$i.jpg');
// // //         await ref.putFile(posterImages[i]);
// // //         final url = await ref.getDownloadURL();
// // //         posterUrls.add(url);
// // //       }

// // //       final data = {
// // //         'turfId': turfId,
// // //         'name': name,
// // //         'city': city,
// // //         'address': address,
// // //         'map_link': mapLink,
// // //         'contact': contact,
// // //         'owner_name': ownerName,
// // //         'owner_uid': FirebaseAuth.instance.currentUser?.uid ?? '',
// // //         'venue_lat': venueLat,
// // //         'venue_lng': venueLng,
// // //         'playground': playground,
// // //         'venue_info': venueInfo,
// // //         'amenities': amenities,
// // //         'venue_rules': venueRules,
// // //         'half_hour_price': halfHourPrice,
// // //         'schedule': weeklySchedule.map((day, d) => MapEntry(day, {'isOpen': d.isOpen})),
// // //         'poster_urls': posterUrls,
// // //         'created_at': FieldValue.serverTimestamp(),
// // //         'createdBy': FirebaseAuth.instance.currentUser?.uid ?? '',
// // //       };

// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).set(data);

// // //       setSubmitting(false);
// // //       return turfId;
// // //     } catch (e) {
// // //       setSubmitting(false);
// // //       rethrow;
// // //     }
// // //   }

// // //   Future<String> updateTurf(String turfId) async {
// // //     try {
// // //       setSubmitting(true);

// // //       // Upload new posters
// // //       List<String> newPosterUrls = List.from(existingPosterUrls);
// // //       for (int i = 0; i < posterImages.length; i++) {
// // //         final ref = FirebaseStorage.instance
// // //             .ref('turf_posters/$turfId/poster_${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
// // //         await ref.putFile(posterImages[i]);
// // //         final url = await ref.getDownloadURL();
// // //         newPosterUrls.add(url);
// // //       }

// // //       final data = {
// // //         'name': name,
// // //         'city': city,
// // //         'address': address,
// // //         'map_link': mapLink,
// // //         'contact': contact,
// // //         'owner_name': ownerName,
// // //         'venue_lat': venueLat,
// // //         'venue_lng': venueLng,
// // //         'playground': playground,
// // //         'venue_info': venueInfo,
// // //         'amenities': amenities,
// // //         'venue_rules': venueRules,
// // //         'half_hour_price': halfHourPrice,
// // //         'schedule': weeklySchedule.map((day, d) => MapEntry(day, {'isOpen': d.isOpen})),
// // //         'poster_urls': newPosterUrls,
// // //         'updated_at': FieldValue.serverTimestamp(),
// // //       };

// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update(data);

// // //       setSubmitting(false);
// // //       return turfId;
// // //     } catch (e) {
// // //       setSubmitting(false);
// // //       rethrow;
// // //     }
// // //   }

// // //   // ───────── LOAD FROM FIRESTORE ─────────
// // //   void loadFromFirestore(Map<String, dynamic> data, String? turfId) {
// // //     name = data['name'] ?? '';
// // //     city = data['city'] ?? '';
// // //     address = data['address'] ?? '';
// // //     mapLink = data['map_link'] ?? '';
// // //     contact = data['contact'] ?? '';
// // //     ownerName = data['owner_name'] ?? '';
// // //     ownerUid = data['owner_uid'] ?? '';
// // //     venueLat = data['venue_lat'] ?? '';
// // //     venueLng = data['venue_lng'] ?? '';

// // //     playground = List<String>.from(data['playground'] ?? []);
// // //     venueInfo = List<String>.from(data['venue_info'] ?? []);
// // //     amenities = List<String>.from(data['amenities'] ?? []);
// // //     venueRules = List<String>.from(data['venue_rules'] ?? []);

// // //     existingPosterUrls = List<String>.from(data['poster_urls'] ?? []);

// // //     halfHourPrice = (data['half_hour_price'] ?? 0.0).toDouble();

// // //     // Load schedule
// // //     if (data['schedule'] != null) {
// // //       final scheduleMap = data['schedule'] as Map<String, dynamic>;
// // //       scheduleMap.forEach((day, dayData) {
// // //         if (dayData is Map) {
// // //           weeklySchedule[day]!.isOpen = dayData['isOpen'] ?? true;
// // //         }
// // //       });
// // //     }

// // //     notifyListeners();
// // //   }

// // //   // ───────── UTILITY ─────────
// // //   void setSubmitting(bool value) {
// // //     submitting = value;
// // //     notifyListeners();
// // //   }

// // //   void reset() {
// // //     name = '';
// // //     city = '';
// // //     address = '';
// // //     mapLink = '';
// // //     contact = '';
// // //     ownerName = '';
// // //     ownerUid = '';
// // //     venueLat = '';
// // //     venueLng = '';
// // //     posterImages.clear();
// // //     existingPosterUrls.clear();
// // //     playground.clear();
// // //     venueInfo.clear();
// // //     amenities.clear();
// // //     venueRules.clear();
// // //     halfHourPrice = 0.0;
// // //     weeklySchedule.updateAll((key, value) => TurfDay(isOpen: true));
// // //     submitting = false;
// // //     notifyListeners();
// // //   }
// // // }

// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:ticpin_play/constants/turf.dart';

// // // class TurfFormProvider extends ChangeNotifier {
// // //   // ───────── BASIC INFO ─────────
// // //   String name = '';
// // //   String city = '';
// // //   String address = '';
// // //   String mapLink = '';
// // //   String contact = '';
// // //   String ownerName = '';
// // //   String ownerUid = '';

// // //   // Location
// // //   String venueLat = '';
// // //   String venueLng = '';

// // //   // ───────── MEDIA ─────────
// // //   List<File> posterImages = [];
// // //   List<String> existingPosterUrls = []; // For edit mode

// // //   // ───────── LISTS ─────────
// // //   List<String> playground = [];
// // //   List<String> venueInfo = [];
// // //   List<String> amenities = [];
// // //   List<String> venueRules = [];

// // //   // ───────── PRICING ─────────
// // //   double halfHourPrice = 0.0;

// // //   // ───────── WEEKLY SCHEDULE (Simplified - just on/off days) ─────────
// // //   Map<String, TurfDay> weeklySchedule = {
// // //     "monday": TurfDay(isOpen: true),
// // //     "tuesday": TurfDay(isOpen: true),
// // //     "wednesday": TurfDay(isOpen: true),
// // //     "thursday": TurfDay(isOpen: true),
// // //     "friday": TurfDay(isOpen: true),
// // //     "saturday": TurfDay(isOpen: true),
// // //     "sunday": TurfDay(isOpen: true),
// // //   };

// // //   bool submitting = false;

// // //   // ───────── UPDATE METHODS ─────────
// // //   void updateField(String field, dynamic value) {
// // //     switch (field) {
// // //       case 'name':
// // //         name = value;
// // //         break;
// // //       case 'city':
// // //         city = value;
// // //         break;
// // //       case 'address':
// // //         address = value;
// // //         break;
// // //       case 'mapLink':
// // //         mapLink = value;
// // //         break;
// // //       case 'contact':
// // //         contact = value;
// // //         break;
// // //       case 'ownerName':
// // //         ownerName = value;
// // //         break;
// // //       case 'ownerUid':
// // //         ownerUid = value;
// // //         break;
// // //       case 'venueLat':
// // //         venueLat = value;
// // //         break;
// // //       case 'venueLng':
// // //         venueLng = value;
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   void updateHalfHourPrice(double price) {
// // //     halfHourPrice = price;
// // //     notifyListeners();
// // //   }

// // //   // ───────── POSTER METHODS ─────────
// // //   void addPosterImage(File file) {
// // //     posterImages.add(file);
// // //     notifyListeners();
// // //   }

// // //   void removePosterImage(int index) {
// // //     posterImages.removeAt(index);
// // //     notifyListeners();
// // //   }

// // //   Future<bool> deleteExistingPoster(String url, String turfId) async {
// // //     try {
// // //       final ref = FirebaseStorage.instance.refFromURL(url);
// // //       await ref.delete();
// // //       existingPosterUrls.remove(url);

// // //       // Update Firestore
// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update({
// // //         'poster_urls': existingPosterUrls,
// // //       });

// // //       notifyListeners();
// // //       return true;
// // //     } catch (e) {
// // //       debugPrint('Error deleting poster: $e');
// // //       return false;
// // //     }
// // //   }

// // //   // ───────── LIST METHODS ─────────
// // //   void addToList(String listName, String value) {
// // //     switch (listName) {
// // //       case 'playground':
// // //         playground.add(value);
// // //         break;
// // //       case 'venueInfo':
// // //         venueInfo.add(value);
// // //         break;
// // //       case 'amenities':
// // //         amenities.add(value);
// // //         break;
// // //       case 'venueRules':
// // //         venueRules.add(value);
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   void removeFromList(String listName, int index) {
// // //     switch (listName) {
// // //       case 'playground':
// // //         playground.removeAt(index);
// // //         break;
// // //       case 'venueInfo':
// // //         venueInfo.removeAt(index);
// // //         break;
// // //       case 'amenities':
// // //         amenities.removeAt(index);
// // //         break;
// // //       case 'venueRules':
// // //         venueRules.removeAt(index);
// // //         break;
// // //     }
// // //     notifyListeners();
// // //   }

// // //   // ───────── SCHEDULE METHODS (Simplified) ─────────
// // //   void toggleDay(String day, bool open) {
// // //     weeklySchedule[day]!.isOpen = open;
// // //     notifyListeners();
// // //   }

// // //   // ───────── SAVE TO FIRESTORE ─────────
// // //   Future<String> createTurf() async {
// // //     try {
// // //       setSubmitting(true);

// // //       final turfId = FirebaseFirestore.instance.collection('turfs').doc().id;

// // //       // Upload posters with random naming
// // //       List<String> posterUrls = [];
// // //       for (int i = 0; i < posterImages.length; i++) {
// // //         final randomId = DateTime.now().millisecondsSinceEpoch + i;
// // //         final ref = FirebaseStorage.instance
// // //             .ref('turf_posters/$turfId/poster_$randomId.jpg');
// // //         await ref.putFile(posterImages[i]);
// // //         final url = await ref.getDownloadURL();
// // //         posterUrls.add(url);
// // //       }

// // //       final data = {
// // //         'turfId': turfId,
// // //         'name': name,
// // //         'city': city,
// // //         'address': address,
// // //         'map_link': mapLink,
// // //         'contact': contact,
// // //         'owner_name': ownerName,
// // //         'owner_uid': FirebaseAuth.instance.currentUser?.uid ?? '',
// // //         'venue_lat': venueLat,
// // //         'venue_lng': venueLng,
// // //         'playground': playground,
// // //         'venue_info': venueInfo,
// // //         'amenities': amenities,
// // //         'venue_rules': venueRules,
// // //         'half_hour_price': halfHourPrice,
// // //         'schedule': weeklySchedule.map((day, d) => MapEntry(day, {'isOpen': d.isOpen})),
// // //         'poster_urls': posterUrls,
// // //         'created_at': FieldValue.serverTimestamp(),
// // //         'createdBy': FirebaseAuth.instance.currentUser?.uid ?? '',
// // //       };

// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).set(data);

// // //       setSubmitting(false);
// // //       return turfId;
// // //     } catch (e) {
// // //       setSubmitting(false);
// // //       rethrow;
// // //     }
// // //   }

// // //   Future<String> updateTurf(String turfId) async {
// // //     try {
// // //       setSubmitting(true);

// // //       // Upload new posters with random naming
// // //       List<String> newPosterUrls = List.from(existingPosterUrls);
// // //       for (int i = 0; i < posterImages.length; i++) {
// // //         final randomId = DateTime.now().millisecondsSinceEpoch + i;
// // //         final ref = FirebaseStorage.instance
// // //             .ref('turf_posters/$turfId/poster_$randomId.jpg');
// // //         await ref.putFile(posterImages[i]);
// // //         final url = await ref.getDownloadURL();
// // //         newPosterUrls.add(url);
// // //       }

// // //       final data = {
// // //         'name': name,
// // //         'city': city,
// // //         'address': address,
// // //         'map_link': mapLink,
// // //         'contact': contact,
// // //         'owner_name': ownerName,
// // //         'venue_lat': venueLat,
// // //         'venue_lng': venueLng,
// // //         'playground': playground,
// // //         'venue_info': venueInfo,
// // //         'amenities': amenities,
// // //         'venue_rules': venueRules,
// // //         'half_hour_price': halfHourPrice,
// // //         'schedule': weeklySchedule.map((day, d) => MapEntry(day, {'isOpen': d.isOpen})),
// // //         'poster_urls': newPosterUrls,
// // //         'updated_at': FieldValue.serverTimestamp(),
// // //       };

// // //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update(data);

// // //       setSubmitting(false);
// // //       return turfId;
// // //     } catch (e) {
// // //       setSubmitting(false);
// // //       rethrow;
// // //     }
// // //   }

// // //   // ───────── LOAD FROM FIRESTORE ─────────
// // //   void loadFromFirestore(Map<String, dynamic> data, String? turfId) {
// // //     name = data['name'] ?? '';
// // //     city = data['city'] ?? '';
// // //     address = data['address'] ?? '';
// // //     mapLink = data['map_link'] ?? '';
// // //     contact = data['contact'] ?? '';
// // //     ownerName = data['owner_name'] ?? '';
// // //     ownerUid = data['owner_uid'] ?? '';
// // //     venueLat = data['venue_lat'] ?? '';
// // //     venueLng = data['venue_lng'] ?? '';

// // //     playground = List<String>.from(data['playground'] ?? []);
// // //     venueInfo = List<String>.from(data['venue_info'] ?? []);
// // //     amenities = List<String>.from(data['amenities'] ?? []);
// // //     venueRules = List<String>.from(data['venue_rules'] ?? []);

// // //     existingPosterUrls = List<String>.from(data['poster_urls'] ?? []);

// // //     halfHourPrice = (data['half_hour_price'] ?? 0.0).toDouble();

// // //     // Load schedule
// // //     if (data['schedule'] != null) {
// // //       final scheduleMap = data['schedule'] as Map<String, dynamic>;
// // //       scheduleMap.forEach((day, dayData) {
// // //         if (dayData is Map) {
// // //           weeklySchedule[day]!.isOpen = dayData['isOpen'] ?? true;
// // //         }
// // //       });
// // //     }

// // //     notifyListeners();
// // //   }

// // //   // ───────── UTILITY ─────────
// // //   void setSubmitting(bool value) {
// // //     submitting = value;
// // //     notifyListeners();
// // //   }

// // //   void reset() {
// // //     name = '';
// // //     city = '';
// // //     address = '';
// // //     mapLink = '';
// // //     contact = '';
// // //     ownerName = '';
// // //     ownerUid = '';
// // //     venueLat = '';
// // //     venueLng = '';
// // //     posterImages.clear();
// // //     existingPosterUrls.clear();
// // //     playground.clear();
// // //     venueInfo.clear();
// // //     amenities.clear();
// // //     venueRules.clear();
// // //     halfHourPrice = 0.0;
// // //     weeklySchedule.updateAll((key, value) => TurfDay(isOpen: true));
// // //     submitting = false;
// // //     notifyListeners();
// // //   }
// // // }
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:ticpin_play/constants/turf.dart';

// // class TurfFormProvider extends ChangeNotifier {
// //   // ───────── BASIC INFO ─────────
// //   String name = '';
// //   String city = '';
// //   String address = '';
// //   String mapLink = '';
// //   String contact = '';
// //   String ownerName = '';
// //   String ownerUid = '';

// //   // Location
// //   String venueLat = '';
// //   String venueLng = '';

// //   // ───────── MEDIA ─────────
// //   List<File> posterImages = [];
// //   List<String> existingPosterUrls = [];

// //   // ───────── LISTS ─────────
// //   List<String> playground = [];
// //   List<String> venueInfo = [];
// //   List<String> amenities = [];
// //   List<String> venueRules = [];

// //   // ───────── PRICING ─────────
// //   double halfHourPrice = 0.0;

// //   // ───────── FIELD SIZES (NEW) ─────────
// //   List<String> availableFieldSizes = []; // e.g., ["4x4", "6x6"]

// //   // ───────── WEEKLY SCHEDULE ─────────
// //   Map<String, TurfDay> weeklySchedule = {
// //     "monday": TurfDay(isOpen: true),
// //     "tuesday": TurfDay(isOpen: true),
// //     "wednesday": TurfDay(isOpen: true),
// //     "thursday": TurfDay(isOpen: true),
// //     "friday": TurfDay(isOpen: true),
// //     "saturday": TurfDay(isOpen: true),
// //     "sunday": TurfDay(isOpen: true),
// //   };

// //   bool submitting = false;

// //   // ───────── UPDATE METHODS ─────────
// //   void updateField(String field, dynamic value) {
// //     switch (field) {
// //       case 'name':
// //         name = value;
// //         break;
// //       case 'city':
// //         city = value;
// //         break;
// //       case 'address':
// //         address = value;
// //         break;
// //       case 'mapLink':
// //         mapLink = value;
// //         break;
// //       case 'contact':
// //         contact = value;
// //         break;
// //       case 'ownerName':
// //         ownerName = value;
// //         break;
// //       case 'ownerUid':
// //         ownerUid = value;
// //         break;
// //       case 'venueLat':
// //         venueLat = value;
// //         break;
// //       case 'venueLng':
// //         venueLng = value;
// //         break;
// //     }
// //     notifyListeners();
// //   }

// //   void updateHalfHourPrice(double price) {
// //     halfHourPrice = price;
// //     notifyListeners();
// //   }

// //   // ───────── FIELD SIZE METHODS (NEW) ─────────
// //   void addFieldSize(String size) {
// //     if (!availableFieldSizes.contains(size)) {
// //       availableFieldSizes.add(size);
// //       notifyListeners();
// //     }
// //   }

// //   void removeFieldSize(String size) {
// //     availableFieldSizes.remove(size);
// //     notifyListeners();
// //   }

// //   void toggleFieldSize(String size) {
// //     if (availableFieldSizes.contains(size)) {
// //       availableFieldSizes.remove(size);
// //     } else {
// //       availableFieldSizes.add(size);
// //     }
// //     notifyListeners();
// //   }

// //   // ───────── POSTER METHODS ─────────
// //   void addPosterImage(File file) {
// //     posterImages.add(file);
// //     notifyListeners();
// //   }

// //   void removePosterImage(int index) {
// //     posterImages.removeAt(index);
// //     notifyListeners();
// //   }

// //   Future<bool> deleteExistingPoster(String url, String turfId) async {
// //     try {
// //       final ref = FirebaseStorage.instance.refFromURL(url);
// //       await ref.delete();
// //       existingPosterUrls.remove(url);

// //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update({
// //         'poster_urls': existingPosterUrls,
// //       });

// //       notifyListeners();
// //       return true;
// //     } catch (e) {
// //       debugPrint('Error deleting poster: $e');
// //       return false;
// //     }
// //   }

// //   // ───────── LIST METHODS ─────────
// //   void addToList(String listName, String value) {
// //     switch (listName) {
// //       case 'playground':
// //         playground.add(value);
// //         break;
// //       case 'venueInfo':
// //         venueInfo.add(value);
// //         break;
// //       case 'amenities':
// //         amenities.add(value);
// //         break;
// //       case 'venueRules':
// //         venueRules.add(value);
// //         break;
// //     }
// //     notifyListeners();
// //   }

// //   void removeFromList(String listName, int index) {
// //     switch (listName) {
// //       case 'playground':
// //         playground.removeAt(index);
// //         break;
// //       case 'venueInfo':
// //         venueInfo.removeAt(index);
// //         break;
// //       case 'amenities':
// //         amenities.removeAt(index);
// //         break;
// //       case 'venueRules':
// //         venueRules.removeAt(index);
// //         break;
// //     }
// //     notifyListeners();
// //   }

// //   // ───────── SCHEDULE METHODS ─────────
// //   void toggleDay(String day, bool open) {
// //     weeklySchedule[day]!.isOpen = open;
// //     notifyListeners();
// //   }

// //   // ───────── SAVE TO FIRESTORE ─────────
// //   Future<String> createTurf() async {
// //     try {
// //       setSubmitting(true);

// //       final turfId = FirebaseFirestore.instance.collection('turfs').doc().id;

// //       // Upload posters
// //       List<String> posterUrls = [];
// //       for (int i = 0; i < posterImages.length; i++) {
// //         final randomId = DateTime.now().millisecondsSinceEpoch + i;
// //         final ref = FirebaseStorage.instance
// //             .ref('turf_posters/$turfId/poster_$randomId.jpg');
// //         await ref.putFile(posterImages[i]);
// //         final url = await ref.getDownloadURL();
// //         posterUrls.add(url);
// //       }

// //       final data = {
// //         'turfId': turfId,
// //         'name': name,
// //         'city': city,
// //         'address': address,
// //         'map_link': mapLink,
// //         'contact': contact,
// //         'owner_name': ownerName,
// //         'owner_uid': FirebaseAuth.instance.currentUser?.uid ?? '',
// //         'venue_lat': venueLat,
// //         'venue_lng': venueLng,
// //         'playground': playground,
// //         'venue_info': venueInfo,
// //         'amenities': amenities,
// //         'venue_rules': venueRules,
// //         'half_hour_price': halfHourPrice,
// //         'available_field_sizes': availableFieldSizes, // NEW
// //         'schedule': weeklySchedule.map((day, d) => MapEntry(day, {'isOpen': d.isOpen})),
// //         'poster_urls': posterUrls,
// //         'created_at': FieldValue.serverTimestamp(),
// //         'createdBy': FirebaseAuth.instance.currentUser?.uid ?? '',
// //       };

// //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).set(data);

// //       setSubmitting(false);
// //       return turfId;
// //     } catch (e) {
// //       setSubmitting(false);
// //       rethrow;
// //     }
// //   }

// //   Future<String> updateTurf(String turfId) async {
// //     try {
// //       setSubmitting(true);

// //       // Upload new posters
// //       List<String> newPosterUrls = List.from(existingPosterUrls);
// //       for (int i = 0; i < posterImages.length; i++) {
// //         final randomId = DateTime.now().millisecondsSinceEpoch + i;
// //         final ref = FirebaseStorage.instance
// //             .ref('turf_posters/$turfId/poster_$randomId.jpg');
// //         await ref.putFile(posterImages[i]);
// //         final url = await ref.getDownloadURL();
// //         newPosterUrls.add(url);
// //       }

// //       final data = {
// //         'name': name,
// //         'city': city,
// //         'address': address,
// //         'map_link': mapLink,
// //         'contact': contact,
// //         'owner_name': ownerName,
// //         'venue_lat': venueLat,
// //         'venue_lng': venueLng,
// //         'playground': playground,
// //         'venue_info': venueInfo,
// //         'amenities': amenities,
// //         'venue_rules': venueRules,
// //         'half_hour_price': halfHourPrice,
// //         'available_field_sizes': availableFieldSizes, // NEW
// //         'schedule': weeklySchedule.map((day, d) => MapEntry(day, {'isOpen': d.isOpen})),
// //         'poster_urls': newPosterUrls,
// //         'updated_at': FieldValue.serverTimestamp(),
// //       };

// //       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update(data);

// //       setSubmitting(false);
// //       return turfId;
// //     } catch (e) {
// //       setSubmitting(false);
// //       rethrow;
// //     }
// //   }

// //   // ───────── LOAD FROM FIRESTORE ─────────
// //   void loadFromFirestore(Map<String, dynamic> data, String? turfId) {
// //     name = data['name'] ?? '';
// //     city = data['city'] ?? '';
// //     address = data['address'] ?? '';
// //     mapLink = data['map_link'] ?? '';
// //     contact = data['contact'] ?? '';
// //     ownerName = data['owner_name'] ?? '';
// //     ownerUid = data['owner_uid'] ?? '';
// //     venueLat = data['venue_lat'] ?? '';
// //     venueLng = data['venue_lng'] ?? '';

// //     playground = List<String>.from(data['playground'] ?? []);
// //     venueInfo = List<String>.from(data['venue_info'] ?? []);
// //     amenities = List<String>.from(data['amenities'] ?? []);
// //     venueRules = List<String>.from(data['venue_rules'] ?? []);

// //     existingPosterUrls = List<String>.from(data['poster_urls'] ?? []);

// //     halfHourPrice = (data['half_hour_price'] ?? 0.0).toDouble();

// //     // Load field sizes
// //     availableFieldSizes = List<String>.from(data['available_field_sizes'] ?? ['4x4']);

// //     // Load schedule
// //     if (data['schedule'] != null) {
// //       final scheduleMap = data['schedule'] as Map<String, dynamic>;
// //       scheduleMap.forEach((day, dayData) {
// //         if (dayData is Map) {
// //           weeklySchedule[day]!.isOpen = dayData['isOpen'] ?? true;
// //         }
// //       });
// //     }

// //     notifyListeners();
// //   }

// //   // ───────── UTILITY ─────────
// //   void setSubmitting(bool value) {
// //     submitting = value;
// //     notifyListeners();
// //   }

// //   void reset() {
// //     name = '';
// //     city = '';
// //     address = '';
// //     mapLink = '';
// //     contact = '';
// //     ownerName = '';
// //     ownerUid = '';
// //     venueLat = '';
// //     venueLng = '';
// //     posterImages.clear();
// //     existingPosterUrls.clear();
// //     playground.clear();
// //     venueInfo.clear();
// //     amenities.clear();
// //     venueRules.clear();
// //     halfHourPrice = 0.0;
// //     availableFieldSizes.clear();
// //     weeklySchedule.updateAll((key, value) => TurfDay(isOpen: true));
// //     submitting = false;
// //     notifyListeners();
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class TurfDay {
//   bool isOpen;

//   TurfDay({required this.isOpen});
// }

// class TurfFormProvider extends ChangeNotifier {
//   // ───────── BASIC INFO ─────────
//   String name = '';
//   String city = '';
//   String address = '';
//   String mapLink = '';
//   String contact = '';
//   String ownerName = '';
//   String ownerUid = '';

//   // Location
//   String venueLat = '';
//   String venueLng = '';

//   // ───────── MEDIA ─────────
//   List<File> posterImages = [];
//   List<String> existingPosterUrls = [];

//   // ───────── LISTS ─────────
//   List<String> playground = [];
//   List<String> venueInfo = [];
//   List<String> amenities = [];
//   List<String> venueRules = [];

//   // ───────── PRICING ─────────
//   double halfHourPrice = 0.0;

//   // ───────── GROUNDS (UPDATED) ─────────
//   // Each ground has a name and field size
//   // Format: [{"name": "Turf 1", "fieldSize": "5-a-side"}]
//   List<Map<String, String>> availableGrounds = [];

//   // ───────── WEEKLY SCHEDULE ─────────
//   Map<String, TurfDay> weeklySchedule = {
//     "monday": TurfDay(isOpen: true),
//     "tuesday": TurfDay(isOpen: true),
//     "wednesday": TurfDay(isOpen: true),
//     "thursday": TurfDay(isOpen: true),
//     "friday": TurfDay(isOpen: true),
//     "saturday": TurfDay(isOpen: true),
//     "sunday": TurfDay(isOpen: true),
//   };

//   bool submitting = false;

//   // ───────── UPDATE METHODS ─────────
//   void updateField(String field, dynamic value) {
//     switch (field) {
//       case 'name':
//         name = value;
//         break;
//       case 'city':
//         city = value;
//         break;
//       case 'address':
//         address = value;
//         break;
//       case 'mapLink':
//         mapLink = value;
//         break;
//       case 'contact':
//         contact = value;
//         break;
//       case 'ownerName':
//         ownerName = value;
//         break;
//       case 'ownerUid':
//         ownerUid = value;
//         break;
//       case 'venueLat':
//         venueLat = value;
//         break;
//       case 'venueLng':
//         venueLng = value;
//         break;
//     }
//     notifyListeners();
//   }

//   void updateHalfHourPrice(double price) {
//     halfHourPrice = price;
//     notifyListeners();
//   }

//   // ───────── GROUND METHODS (UPDATED) ─────────
//   void addGround(String name, String fieldSize) {
//     availableGrounds.add({
//       'name': name,
//       'fieldSize': fieldSize,
//     });
//     notifyListeners();
//   }

//   void removeGround(int index) {
//     if (index >= 0 && index < availableGrounds.length) {
//       availableGrounds.removeAt(index);
//       notifyListeners();
//     }
//   }

//   void updateGround(int index, String name, String fieldSize) {
//     if (index >= 0 && index < availableGrounds.length) {
//       availableGrounds[index] = {
//         'name': name,
//         'fieldSize': fieldSize,
//       };
//       notifyListeners();
//     }
//   }

//   // ───────── POSTER METHODS ─────────
//   void addPosterImage(File file) {
//     posterImages.add(file);
//     notifyListeners();
//   }

//   void removePosterImage(int index) {
//     posterImages.removeAt(index);
//     notifyListeners();
//   }

//   Future<bool> deleteExistingPoster(String url, String turfId) async {
//     try {
//       final ref = FirebaseStorage.instance.refFromURL(url);
//       await ref.delete();
//       existingPosterUrls.remove(url);

//       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update({
//         'poster_urls': existingPosterUrls,
//       });

//       notifyListeners();
//       return true;
//     } catch (e) {
//       debugPrint('Error deleting poster: $e');
//       return false;
//     }
//   }

//   // ───────── LIST METHODS ─────────
//   void addToList(String listName, String value) {
//     switch (listName) {
//       case 'playground':
//         playground.add(value);
//         break;
//       case 'venueInfo':
//         venueInfo.add(value);
//         break;
//       case 'amenities':
//         amenities.add(value);
//         break;
//       case 'venueRules':
//         venueRules.add(value);
//         break;
//     }
//     notifyListeners();
//   }

//   void removeFromList(String listName, int index) {
//     switch (listName) {
//       case 'playground':
//         playground.removeAt(index);
//         break;
//       case 'venueInfo':
//         venueInfo.removeAt(index);
//         break;
//       case 'amenities':
//         amenities.removeAt(index);
//         break;
//       case 'venueRules':
//         venueRules.removeAt(index);
//         break;
//     }
//     notifyListeners();
//   }

//   // ───────── SCHEDULE METHODS ─────────
//   void toggleDay(String day, bool open) {
//     weeklySchedule[day]!.isOpen = open;
//     notifyListeners();
//   }

//   // ───────── SAVE TO FIRESTORE ─────────
//   Future<String> createTurf() async {
//     try {
//       setSubmitting(true);

//       final turfId = FirebaseFirestore.instance.collection('turfs').doc().id;

//       // Upload posters
//       List<String> posterUrls = [];
//       for (int i = 0; i < posterImages.length; i++) {
//         final randomId = DateTime.now().millisecondsSinceEpoch + i;
//         final ref = FirebaseStorage.instance
//             .ref('turf_posters/$turfId/poster_$randomId.jpg');
//         await ref.putFile(posterImages[i]);
//         final url = await ref.getDownloadURL();
//         posterUrls.add(url);
//       }

//       final data = {
//         'turfId': turfId,
//         'name': name,
//         'city': city,
//         'address': address,
//         'map_link': mapLink,
//         'contact': contact,
//         'owner_name': ownerName,
//         'owner_uid': FirebaseAuth.instance.currentUser?.uid ?? '',
//         'venue_lat': venueLat,
//         'venue_lng': venueLng,
//         'playground': playground,
//         'venue_info': venueInfo,
//         'amenities': amenities,
//         'venue_rules': venueRules,
//         'half_hour_price': halfHourPrice,
//         'available_grounds': availableGrounds, // UPDATED
//         'schedule': weeklySchedule.map((day, d) => MapEntry(day, {'isOpen': d.isOpen})),
//         'poster_urls': posterUrls,
//         'created_at': FieldValue.serverTimestamp(),
//         'createdBy': FirebaseAuth.instance.currentUser?.uid ?? '',
//       };

//       await FirebaseFirestore.instance.collection('turfs').doc(turfId).set(data);

//       setSubmitting(false);
//       return turfId;
//     } catch (e) {
//       setSubmitting(false);
//       rethrow;
//     }
//   }

//   Future<String> updateTurf(String turfId) async {
//     try {
//       setSubmitting(true);

//       // Upload new posters
//       List<String> newPosterUrls = List.from(existingPosterUrls);
//       for (int i = 0; i < posterImages.length; i++) {
//         final randomId = DateTime.now().millisecondsSinceEpoch + i;
//         final ref = FirebaseStorage.instance
//             .ref('turf_posters/$turfId/poster_$randomId.jpg');
//         await ref.putFile(posterImages[i]);
//         final url = await ref.getDownloadURL();
//         newPosterUrls.add(url);
//       }

//       final data = {
//         'name': name,
//         'city': city,
//         'address': address,
//         'map_link': mapLink,
//         'contact': contact,
//         'owner_name': ownerName,
//         'venue_lat': venueLat,
//         'venue_lng': venueLng,
//         'playground': playground,
//         'venue_info': venueInfo,
//         'amenities': amenities,
//         'venue_rules': venueRules,
//         'half_hour_price': halfHourPrice,
//         'available_grounds': availableGrounds, // UPDATED
//         'schedule': weeklySchedule.map((day, d) => MapEntry(day, {'isOpen': d.isOpen})),
//         'poster_urls': newPosterUrls,
//         'updated_at': FieldValue.serverTimestamp(),
//       };

//       await FirebaseFirestore.instance.collection('turfs').doc(turfId).update(data);

//       setSubmitting(false);
//       return turfId;
//     } catch (e) {
//       setSubmitting(false);
//       rethrow;
//     }
//   }

//   // ───────── LOAD FROM FIRESTORE ─────────
//   void loadFromFirestore(Map<String, dynamic> data, String? turfId) {
//     name = data['name'] ?? '';
//     city = data['city'] ?? '';
//     address = data['address'] ?? '';
//     mapLink = data['map_link'] ?? '';
//     contact = data['contact'] ?? '';
//     ownerName = data['owner_name'] ?? '';
//     ownerUid = data['owner_uid'] ?? '';
//     venueLat = data['venue_lat'] ?? '';
//     venueLng = data['venue_lng'] ?? '';

//     playground = List<String>.from(data['playground'] ?? []);
//     venueInfo = List<String>.from(data['venue_info'] ?? []);
//     amenities = List<String>.from(data['amenities'] ?? []);
//     venueRules = List<String>.from(data['venue_rules'] ?? []);

//     existingPosterUrls = List<String>.from(data['poster_urls'] ?? []);

//     halfHourPrice = (data['half_hour_price'] ?? 0.0).toDouble();

//     // Load grounds (UPDATED)
//     availableGrounds.clear();
//     if (data['available_grounds'] != null) {
//       final groundsList = data['available_grounds'] as List;
//       for (var ground in groundsList) {
//         if (ground is Map) {
//           availableGrounds.add({
//             'name': ground['name']?.toString() ?? '',
//             'fieldSize': ground['fieldSize']?.toString() ?? '',
//           });
//         }
//       }
//     }

//     // Backward compatibility: convert old field sizes to grounds
//     if (availableGrounds.isEmpty && data['available_field_sizes'] != null) {
//       final oldFieldSizes = List<String>.from(data['available_field_sizes']);
//       for (int i = 0; i < oldFieldSizes.length; i++) {
//         availableGrounds.add({
//           'name': 'Ground ${i + 1}',
//           'fieldSize': oldFieldSizes[i],
//         });
//       }
//     }

//     // Load schedule
//     if (data['schedule'] != null) {
//       final scheduleMap = data['schedule'] as Map<String, dynamic>;
//       scheduleMap.forEach((day, dayData) {
//         if (dayData is Map) {
//           weeklySchedule[day]!.isOpen = dayData['isOpen'] ?? true;
//         }
//       });
//     }

//     notifyListeners();
//   }

//   // ───────── UTILITY ─────────
//   void setSubmitting(bool value) {
//     submitting = value;
//     notifyListeners();
//   }

//   void reset() {
//     name = '';
//     city = '';
//     address = '';
//     mapLink = '';
//     contact = '';
//     ownerName = '';
//     ownerUid = '';
//     venueLat = '';
//     venueLng = '';
//     posterImages.clear();
//     existingPosterUrls.clear();
//     playground.clear();
//     venueInfo.clear();
//     amenities.clear();
//     venueRules.clear();
//     halfHourPrice = 0.0;
//     availableGrounds.clear();
//     weeklySchedule.updateAll((key, value) => TurfDay(isOpen: true));
//     submitting = false;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

// ─────────────────────────────────────────────────────────────
// TurfDay  –  now carries per-day open hours
// Firestore stores: { isOpen: bool, startHour: int, startMinute: int, endHour: int, endMinute: int }
// ─────────────────────────────────────────────────────────────
class TurfDay {
  bool isOpen;
  TimeOfDay startTime;
  TimeOfDay endTime;

  TurfDay({
    required this.isOpen,
    this.startTime = const TimeOfDay(hour: 6, minute: 0), // default 6:00 AM
    this.endTime = const TimeOfDay(hour: 22, minute: 0), // default 10:00 PM
  });

  /// Total minutes from midnight – used for ordering / comparison
  static int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  /// Pretty-print: "6:00 AM"
  static String format(TimeOfDay t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }
}

class TurfFormProvider extends ChangeNotifier {
  // ───────── BASIC INFO ─────────
  String name = '';
  String city = '';
  String address = '';
  String mapLink = '';
  String contact = '';
  String ownerName = '';
  String ownerUid = '';

  // Location
  String venueLat = '';
  String venueLng = '';

  // ───────── MEDIA ─────────
  List<File> posterImages = [];
  List<String> existingPosterUrls = [];

  // ───────── LISTS ─────────
  List<String> playground = [];
  List<String> venueInfo = [];
  List<String> amenities = [];
  List<String> venueRules = [];

  // ───────── PRICING ─────────
  double halfHourPrice = 0.0;

  // ───────── GROUNDS ─────────
  List<Map<String, String>> availableGrounds = [];

  // ───────── WEEKLY SCHEDULE (with per-day times) ─────────
  Map<String, TurfDay> weeklySchedule = {
    "monday": TurfDay(isOpen: true),
    "tuesday": TurfDay(isOpen: true),
    "wednesday": TurfDay(isOpen: true),
    "thursday": TurfDay(isOpen: true),
    "friday": TurfDay(isOpen: true),
    "saturday": TurfDay(isOpen: true),
    "sunday": TurfDay(isOpen: true),
  };

  bool submitting = false;

  // ───────── UPDATE METHODS ─────────
  void updateField(String field, dynamic value) {
    switch (field) {
      case 'name':
        name = value;
        break;
      case 'city':
        city = value;
        break;
      case 'address':
        address = value;
        break;
      case 'mapLink':
        mapLink = value;
        break;
      case 'contact':
        contact = value;
        break;
      case 'ownerName':
        ownerName = value;
        break;
      case 'ownerUid':
        ownerUid = value;
        break;
      case 'venueLat':
        venueLat = value;
        break;
      case 'venueLng':
        venueLng = value;
        break;
    }
    notifyListeners();
  }

  void updateHalfHourPrice(double price) {
    halfHourPrice = price;
    notifyListeners();
  }

  // ───────── GROUND METHODS ─────────
  void addGround(String name, String fieldSize) {
    availableGrounds.add({'name': name, 'fieldSize': fieldSize});
    notifyListeners();
  }

  void removeGround(int index) {
    if (index >= 0 && index < availableGrounds.length) {
      availableGrounds.removeAt(index);
      notifyListeners();
    }
  }

  void updateGround(int index, String name, String fieldSize) {
    if (index >= 0 && index < availableGrounds.length) {
      availableGrounds[index] = {'name': name, 'fieldSize': fieldSize};
      notifyListeners();
    }
  }

  // ───────── POSTER METHODS ─────────
  void addPosterImage(File file) {
    posterImages.add(file);
    notifyListeners();
  }

  void removePosterImage(int index) {
    posterImages.removeAt(index);
    notifyListeners();
  }

  Future<bool> deleteExistingPoster(String url, String turfId) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
      existingPosterUrls.remove(url);

      await FirebaseFirestore.instance.collection('turfs').doc(turfId).update({
        'poster_urls': existingPosterUrls,
      });

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting poster: $e');
      return false;
    }
  }

  // ───────── LIST METHODS ─────────
  void addToList(String listName, String value) {
    switch (listName) {
      case 'playground':
        playground.add(value);
        break;
      case 'venueInfo':
        venueInfo.add(value);
        break;
      case 'amenities':
        amenities.add(value);
        break;
      case 'venueRules':
        venueRules.add(value);
        break;
    }
    notifyListeners();
  }

  void removeFromList(String listName, int index) {
    switch (listName) {
      case 'playground':
        playground.removeAt(index);
        break;
      case 'venueInfo':
        venueInfo.removeAt(index);
        break;
      case 'amenities':
        amenities.removeAt(index);
        break;
      case 'venueRules':
        venueRules.removeAt(index);
        break;
    }
    notifyListeners();
  }

  // ───────── SCHEDULE METHODS ─────────
  void toggleDay(String day, bool open) {
    weeklySchedule[day]!.isOpen = open;
    notifyListeners();
  }

  /// Update start or end time for a single day.
  /// [type] is either 'start' or 'end'.
  void setDayTime(String day, String type, TimeOfDay time) {
    final d = weeklySchedule[day];
    if (d == null) return;

    if (type == 'start') {
      d.startTime = time;
    } else {
      d.endTime = time;
    }
    notifyListeners();
  }

  // ───────── SERIALISE schedule for Firestore ─────────
  Map<String, dynamic> _serializeSchedule() {
    return weeklySchedule.map(
      (day, d) => MapEntry(day, {
        'isOpen': d.isOpen,
        'startHour': d.startTime.hour,
        'startMinute': d.startTime.minute,
        'endHour': d.endTime.hour,
        'endMinute': d.endTime.minute,
      }),
    );
  }

  // ───────── SAVE TO FIRESTORE ─────────
  Future<String> createTurf() async {
    try {
      setSubmitting(true);

      final turfId = FirebaseFirestore.instance.collection('turfs').doc().id;

      List<String> posterUrls = [];
      for (int i = 0; i < posterImages.length; i++) {
        final randomId = DateTime.now().millisecondsSinceEpoch + i;
        final ref = FirebaseStorage.instance.ref(
          'turf_posters/$turfId/poster_$randomId.jpg',
        );
        await ref.putFile(posterImages[i]);
        posterUrls.add(await ref.getDownloadURL());
      }

      final data = {
        'turfId': turfId,
        'name': name,
        'city': city,
        'address': address,
        'map_link': mapLink,
        'contact': contact,
        'owner_name': ownerName,
        'owner_uid': FirebaseAuth.instance.currentUser?.uid ?? '',
        'venue_lat': venueLat,
        'venue_lng': venueLng,
        'playground': playground,
        'venue_info': venueInfo,
        'amenities': amenities,
        'venue_rules': venueRules,
        'half_hour_price': halfHourPrice,
        'available_grounds': availableGrounds,
        'schedule': _serializeSchedule(),
        'poster_urls': posterUrls,
        'created_at': FieldValue.serverTimestamp(),
        'createdBy': FirebaseAuth.instance.currentUser?.uid ?? '',
      };

      await FirebaseFirestore.instance
          .collection('turfs')
          .doc(turfId)
          .set(data);

      setSubmitting(false);
      return turfId;
    } catch (e) {
      setSubmitting(false);
      rethrow;
    }
  }

  Future<String> updateTurf(String turfId) async {
    try {
      setSubmitting(true);

      List<String> newPosterUrls = List.from(existingPosterUrls);
      for (int i = 0; i < posterImages.length; i++) {
        final randomId = DateTime.now().millisecondsSinceEpoch + i;
        final ref = FirebaseStorage.instance.ref(
          'turf_posters/$turfId/poster_$randomId.jpg',
        );
        await ref.putFile(posterImages[i]);
        newPosterUrls.add(await ref.getDownloadURL());
      }

      final data = {
        'name': name,
        'city': city,
        'address': address,
        'map_link': mapLink,
        'contact': contact,
        'owner_name': ownerName,
        'venue_lat': venueLat,
        'venue_lng': venueLng,
        'playground': playground,
        'venue_info': venueInfo,
        'amenities': amenities,
        'venue_rules': venueRules,
        'half_hour_price': halfHourPrice,
        'available_grounds': availableGrounds,
        'schedule': _serializeSchedule(),
        'poster_urls': newPosterUrls,
        'updated_at': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('turfs')
          .doc(turfId)
          .update(data);

      setSubmitting(false);
      return turfId;
    } catch (e) {
      setSubmitting(false);
      rethrow;
    }
  }

  // ───────── LOAD FROM FIRESTORE ─────────
  void loadFromFirestore(Map<String, dynamic> data, String? turfId) {
    name = data['name'] ?? '';
    city = data['city'] ?? '';
    address = data['address'] ?? '';
    mapLink = data['map_link'] ?? '';
    contact = data['contact'] ?? '';
    ownerName = data['owner_name'] ?? '';
    ownerUid = data['owner_uid'] ?? '';
    venueLat = data['venue_lat'] ?? '';
    venueLng = data['venue_lng'] ?? '';

    playground = List<String>.from(data['playground'] ?? []);
    venueInfo = List<String>.from(data['venue_info'] ?? []);
    amenities = List<String>.from(data['amenities'] ?? []);
    venueRules = List<String>.from(data['venue_rules'] ?? []);

    existingPosterUrls = List<String>.from(data['poster_urls'] ?? []);
    halfHourPrice = (data['half_hour_price'] ?? 0.0).toDouble();

    // Grounds
    availableGrounds.clear();
    if (data['available_grounds'] != null) {
      for (var ground in data['available_grounds'] as List) {
        if (ground is Map) {
          availableGrounds.add({
            'name': ground['name']?.toString() ?? '',
            'fieldSize': ground['fieldSize']?.toString() ?? '',
          });
        }
      }
    }
    // Backward compat
    if (availableGrounds.isEmpty && data['available_field_sizes'] != null) {
      final old = List<String>.from(data['available_field_sizes']);
      for (int i = 0; i < old.length; i++) {
        availableGrounds.add({'name': 'Ground ${i + 1}', 'fieldSize': old[i]});
      }
    }

    // Schedule – with backward compat for docs that only have isOpen
    if (data['schedule'] != null) {
      final scheduleMap = data['schedule'] as Map<String, dynamic>;
      scheduleMap.forEach((day, dayData) {
        if (dayData is Map && weeklySchedule.containsKey(day)) {
          weeklySchedule[day] = TurfDay(
            isOpen: dayData['isOpen'] ?? true,
            startTime: TimeOfDay(
              hour: dayData['startHour'] ?? 6,
              minute: dayData['startMinute'] ?? 0,
            ),
            endTime: TimeOfDay(
              hour: dayData['endHour'] ?? 22,
              minute: dayData['endMinute'] ?? 0,
            ),
          );
        }
      });
    }

    notifyListeners();
  }

  // ───────── UTILITY ─────────
  void setSubmitting(bool value) {
    submitting = value;
    notifyListeners();
  }

  void reset() {
    name = '';
    city = '';
    address = '';
    mapLink = '';
    contact = '';
    ownerName = '';
    ownerUid = '';
    venueLat = '';
    venueLng = '';
    posterImages.clear();
    existingPosterUrls.clear();
    playground.clear();
    venueInfo.clear();
    amenities.clear();
    venueRules.clear();
    halfHourPrice = 0.0;
    availableGrounds.clear();
    weeklySchedule.updateAll((key, value) => TurfDay(isOpen: true));
    submitting = false;
    notifyListeners();
  }
}
