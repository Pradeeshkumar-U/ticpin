// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DiningFormProvider extends ChangeNotifier {
//   // ───────── BASIC INFO ─────────
//   String name = '';
//   String ownerName = '';
//   String ownerAddress = '';
//   String description = '';
//   String briefDescription = '';
//   String contactNumber = '';

//   // ───────── TIMINGS ─────────
//   String openTime = '';
//   String closeTime = '';

//   // ───────── LOCATION ─────────
//   String venueLat = '';
//   String venueLng = '';

//   // ───────── MEDIA ─────────
//   List<File> carouselImages = [];
//   List<String> existingCarouselUrls = [];

//   List<File> menuImages = [];
//   List<String> existingMenuUrls = [];

//   List<File> aboutImages = [];
//   List<String> existingAboutUrls = [];

//   // ───────── LISTS ─────────
//   List<String> facilities = [];
//   List<String> filterCategories = [];
//   List<String> filterDishes = [];
//   List<String> filterCuisines = [];

//   // ───────── PAYMENT & REVIEWS ─────────
//   String paymentUid = '';
//   String googleReviewUrl = '';
//   double googleRating = 0.0;
//   int googleTotalReviews = 0;

//   bool submitting = false;

//   // ───────── UPDATE METHODS ─────────
//   void updateField(String field, dynamic value) {
//     switch (field) {
//       case 'name':
//         name = value;
//         break;
//       case 'ownerName':
//         ownerName = value;
//         break;
//       case 'ownerAddress':
//         ownerAddress = value;
//         break;
//       case 'description':
//         description = value;
//         break;
//       case 'briefDescription':
//         briefDescription = value;
//         break;
//       case 'contactNumber':
//         contactNumber = value;
//         break;
//       case 'openTime':
//         openTime = value;
//         break;
//       case 'closeTime':
//         closeTime = value;
//         break;
//       case 'venueLat':
//         venueLat = value;
//         break;
//       case 'venueLng':
//         venueLng = value;
//         break;
//       case 'paymentUid':
//         paymentUid = value;
//         break;
//       case 'googleReviewUrl':
//         googleReviewUrl = value;
//         break;
//       case 'googleRating':
//         googleRating = value;
//         break;
//       case 'googleTotalReviews':
//         googleTotalReviews = value;
//         break;
//     }
//     notifyListeners();
//   }

//   // ───────── IMAGE METHODS - CAROUSEL ─────────
//   void addCarouselImage(File file) {
//     carouselImages.add(file);
//     notifyListeners();
//   }

//   void removeCarouselImage(int index) {
//     carouselImages.removeAt(index);
//     notifyListeners();
//   }

//   Future<bool> deleteExistingCarousel(String url, String diningId) async {
//     try {
//       final ref = FirebaseStorage.instance.refFromURL(url);
//       await ref.delete();
//       existingCarouselUrls.remove(url);

//       await FirebaseFirestore.instance
//           .collection('dining')
//           .doc(diningId)
//           .update({'images.carousel': existingCarouselUrls});

//       notifyListeners();
//       return true;
//     } catch (e) {
//       debugPrint('Error deleting carousel: $e');
//       return false;
//     }
//   }

//   // ───────── IMAGE METHODS - MENU ─────────
//   void addMenuImage(File file) {
//     menuImages.add(file);
//     notifyListeners();
//   }

//   void removeMenuImage(int index) {
//     menuImages.removeAt(index);
//     notifyListeners();
//   }

//   Future<bool> deleteExistingMenu(String url, String diningId) async {
//     try {
//       final ref = FirebaseStorage.instance.refFromURL(url);
//       await ref.delete();
//       existingMenuUrls.remove(url);

//       await FirebaseFirestore.instance
//           .collection('dining')
//           .doc(diningId)
//           .update({'images.menu': existingMenuUrls});

//       notifyListeners();
//       return true;
//     } catch (e) {
//       debugPrint('Error deleting menu: $e');
//       return false;
//     }
//   }

//   // ───────── IMAGE METHODS - ABOUT ─────────
//   void addAboutImage(File file) {
//     aboutImages.add(file);
//     notifyListeners();
//   }

//   void removeAboutImage(int index) {
//     aboutImages.removeAt(index);
//     notifyListeners();
//   }

//   Future<bool> deleteExistingAbout(String url, String diningId) async {
//     try {
//       final ref = FirebaseStorage.instance.refFromURL(url);
//       await ref.delete();
//       existingAboutUrls.remove(url);

//       await FirebaseFirestore.instance
//           .collection('dining')
//           .doc(diningId)
//           .update({'images.about': existingAboutUrls});

//       notifyListeners();
//       return true;
//     } catch (e) {
//       debugPrint('Error deleting about: $e');
//       return false;
//     }
//   }

//   // ───────── LIST METHODS ─────────
//   void addToList(String listName, String value) {
//     switch (listName) {
//       case 'facilities':
//         facilities.add(value);
//         break;
//       case 'filterCategories':
//         filterCategories.add(value);
//         break;
//       case 'filterDishes':
//         filterDishes.add(value);
//         break;
//       case 'filterCuisines':
//         filterCuisines.add(value);
//         break;
//     }
//     notifyListeners();
//   }

//   void removeFromList(String listName, int index) {
//     switch (listName) {
//       case 'facilities':
//         facilities.removeAt(index);
//         break;
//       case 'filterCategories':
//         filterCategories.removeAt(index);
//         break;
//       case 'filterDishes':
//         filterDishes.removeAt(index);
//         break;
//       case 'filterCuisines':
//         filterCuisines.removeAt(index);
//         break;
//     }
//     notifyListeners();
//   }

//   // ───────── SAVE TO FIRESTORE ─────────
//   Future<String> createDining() async {
//     try {
//       setSubmitting(true);

//       final diningId = FirebaseFirestore.instance.collection('dining').doc().id;

//       // Upload carousel images
//       List<String> carouselUrls = [];
//       for (int i = 0; i < carouselImages.length; i++) {
//         final randomId = DateTime.now().millisecondsSinceEpoch + i;
//         final ref = FirebaseStorage.instance.ref(
//           'dining_posters/$diningId/carousel/img_$randomId.jpg',
//         );
//         await ref.putFile(carouselImages[i]);
//         final url = await ref.getDownloadURL();
//         carouselUrls.add(url);
//       }

//       // Upload menu images
//       List<String> menuUrls = [];
//       for (int i = 0; i < menuImages.length; i++) {
//         final randomId = DateTime.now().millisecondsSinceEpoch + i + 1000;
//         final ref = FirebaseStorage.instance.ref(
//           'dining_posters/$diningId/menu/img_$randomId.jpg',
//         );
//         await ref.putFile(menuImages[i]);
//         final url = await ref.getDownloadURL();
//         menuUrls.add(url);
//       }

//       // Upload about images
//       List<String> aboutUrls = [];
//       for (int i = 0; i < aboutImages.length; i++) {
//         final randomId = DateTime.now().millisecondsSinceEpoch + i + 2000;
//         final ref = FirebaseStorage.instance.ref(
//           'dining_posters/$diningId/about/img_$randomId.jpg',
//         );
//         await ref.putFile(aboutImages[i]);
//         final url = await ref.getDownloadURL();
//         aboutUrls.add(url);
//       }

//       final data = {
//         'diningId': diningId,
//         'name': name,
//         'owner': {'name': ownerName, 'address': ownerAddress},
//         'description': description,
//         'briefDescription': briefDescription,
//         'contactNumber': contactNumber,
//         'timings': {'open': openTime, 'close': closeTime},
//         'location': {'lat': venueLat, 'lng': venueLng},
//         'images': {
//           'carousel': carouselUrls,
//           'menu': menuUrls,
//           'about': aboutUrls,
//         },
//         'facilities': facilities,
//         'paymentUid': paymentUid,
//         'reviews': {
//           'source': 'google',
//           'url': googleReviewUrl,
//           'rating': googleRating,
//           'total': googleTotalReviews,
//         },
//         'filters': {
//           'categories': filterCategories,
//           'dishes': filterDishes,
//           'cuisines': filterCuisines,
//         },
//         'created_at': FieldValue.serverTimestamp(),
//         'createdBy': FirebaseAuth.instance.currentUser?.uid ?? '',
//       };

//       await FirebaseFirestore.instance
//           .collection('dining')
//           .doc(diningId)
//           .set(data);

//       setSubmitting(false);
//       return diningId;
//     } catch (e) {
//       setSubmitting(false);
//       rethrow;
//     }
//   }

//   Future<String> updateDining(String diningId) async {
//     try {
//       setSubmitting(true);

//       // Upload new carousel images
//       List<String> newCarouselUrls = List.from(existingCarouselUrls);
//       for (int i = 0; i < carouselImages.length; i++) {
//         final randomId = DateTime.now().millisecondsSinceEpoch + i;
//         final ref = FirebaseStorage.instance.ref(
//           'dining_posters/$diningId/carousel/img_$randomId.jpg',
//         );
//         await ref.putFile(carouselImages[i]);
//         final url = await ref.getDownloadURL();
//         newCarouselUrls.add(url);
//       }

//       // Upload new menu images
//       List<String> newMenuUrls = List.from(existingMenuUrls);
//       for (int i = 0; i < menuImages.length; i++) {
//         final randomId = DateTime.now().millisecondsSinceEpoch + i + 1000;
//         final ref = FirebaseStorage.instance.ref(
//           'dining_posters/$diningId/menu/img_$randomId.jpg',
//         );
//         await ref.putFile(menuImages[i]);
//         final url = await ref.getDownloadURL();
//         newMenuUrls.add(url);
//       }

//       // Upload new about images
//       List<String> newAboutUrls = List.from(existingAboutUrls);
//       for (int i = 0; i < aboutImages.length; i++) {
//         final randomId = DateTime.now().millisecondsSinceEpoch + i + 2000;
//         final ref = FirebaseStorage.instance.ref(
//           'dining_posters/$diningId/about/img_$randomId.jpg',
//         );
//         await ref.putFile(aboutImages[i]);
//         final url = await ref.getDownloadURL();
//         newAboutUrls.add(url);
//       }

//       final data = {
//         'name': name,
//         'owner': {'name': ownerName, 'address': ownerAddress},
//         'description': description,
//         'briefDescription': briefDescription,
//         'contactNumber': contactNumber,
//         'timings': {'open': openTime, 'close': closeTime},
//         'location': {'lat': venueLat, 'lng': venueLng},
//         'images': {
//           'carousel': newCarouselUrls,
//           'menu': newMenuUrls,
//           'about': newAboutUrls,
//         },
//         'facilities': facilities,
//         'paymentUid': paymentUid,
//         'reviews': {
//           'source': 'google',
//           'url': googleReviewUrl,
//           'rating': googleRating,
//           'total': googleTotalReviews,
//         },
//         'filters': {
//           'categories': filterCategories,
//           'dishes': filterDishes,
//           'cuisines': filterCuisines,
//         },
//         'updated_at': FieldValue.serverTimestamp(),
//       };

//       await FirebaseFirestore.instance
//           .collection('dining')
//           .doc(diningId)
//           .update(data);

//       setSubmitting(false);
//       return diningId;
//     } catch (e) {
//       setSubmitting(false);
//       rethrow;
//     }
//   }

//   // ───────── LOAD FROM FIRESTORE ─────────
//   void loadFromFirestore(Map<String, dynamic> data, String? diningId) {
//     name = data['name'] ?? '';

//     final owner = data['owner'] as Map<String, dynamic>?;
//     ownerName = owner?['name'] ?? '';
//     ownerAddress = owner?['address'] ?? '';

//     description = data['description'] ?? '';
//     briefDescription = data['briefDescription'] ?? '';
//     contactNumber = data['contactNumber'] ?? '';

//     final timings = data['timings'] as Map<String, dynamic>?;
//     openTime = timings?['open'] ?? '';
//     closeTime = timings?['close'] ?? '';

//     final location = data['location'] as Map<String, dynamic>?;
//     venueLat = location?['lat'] ?? '';
//     venueLng = location?['lng'] ?? '';

//     final images = data['images'] as Map<String, dynamic>?;
//     existingCarouselUrls = List<String>.from(images?['carousel'] ?? []);
//     existingMenuUrls = List<String>.from(images?['menu'] ?? []);
//     existingAboutUrls = List<String>.from(images?['about'] ?? []);

//     facilities = List<String>.from(data['facilities'] ?? []);

//     paymentUid = data['paymentUid'] ?? '';

//     final reviews = data['reviews'] as Map<String, dynamic>?;
//     googleReviewUrl = reviews?['url'] ?? '';
//     googleRating = (reviews?['rating'] ?? 0.0).toDouble();
//     googleTotalReviews = reviews?['total'] ?? 0;

//     final filters = data['filters'] as Map<String, dynamic>?;
//     filterCategories = List<String>.from(filters?['categories'] ?? []);
//     filterDishes = List<String>.from(filters?['dishes'] ?? []);
//     filterCuisines = List<String>.from(filters?['cuisines'] ?? []);

//     notifyListeners();
//   }

//   // ───────── UTILITY ─────────
//   void setSubmitting(bool value) {
//     submitting = value;
//     notifyListeners();
//   }

//   void reset() {
//     name = '';
//     ownerName = '';
//     ownerAddress = '';
//     description = '';
//     briefDescription = '';
//     contactNumber = '';
//     openTime = '';
//     closeTime = '';
//     venueLat = '';
//     venueLng = '';
//     carouselImages.clear();
//     existingCarouselUrls.clear();
//     menuImages.clear();
//     existingMenuUrls.clear();
//     aboutImages.clear();
//     existingAboutUrls.clear();
//     facilities.clear();
//     filterCategories.clear();
//     filterDishes.clear();
//     filterCuisines.clear();
//     paymentUid = '';
//     googleReviewUrl = '';
//     googleRating = 0.0;
//     googleTotalReviews = 0;
//     submitting = false;
//     notifyListeners();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiningFormProvider extends ChangeNotifier {
  // ───────── BASIC INFO ─────────
  String name = '';
  String ownerName = '';
  String ownerAddress = '';
  String description = '';
  String briefDescription = '';
  String contactNumber = '';

  // ───────── TIMINGS ─────────
  String openTime = '';
  String closeTime = '';

  // ───────── LOCATION ─────────
  String venueLat = '';
  String venueLng = '';

  // ───────── MEDIA ─────────
  List<File> carouselImages = [];
  List<String> existingCarouselUrls = [];

  List<File> menuImages = [];
  List<String> existingMenuUrls = [];

  List<File> aboutImages = [];
  List<String> existingAboutUrls = [];

  // ───────── LISTS ─────────
  List<String> facilities = [];
  List<String> filterCategories = [];
  List<String> filterDishes = [];
  List<String> filterCuisines = [];

  // ───────── PAYMENT & REVIEWS ─────────
  String paymentUid = '';
  String googleReviewUrl = '';
  double googleRating = 0.0;
  int googleTotalReviews = 0;

  bool submitting = false;

  // ───────── UPDATE METHODS ─────────
  void updateField(String field, dynamic value) {
    switch (field) {
      case 'name':
        name = value;
        break;
      case 'ownerName':
        ownerName = value;
        break;
      case 'ownerAddress':
        ownerAddress = value;
        break;
      case 'description':
        description = value;
        break;
      case 'briefDescription':
        briefDescription = value;
        break;
      case 'contactNumber':
        contactNumber = value;
        break;
      case 'openTime':
        openTime = value;
        break;
      case 'closeTime':
        closeTime = value;
        break;
      case 'venueLat':
        venueLat = value;
        break;
      case 'venueLng':
        venueLng = value;
        break;
      case 'paymentUid':
        paymentUid = value;
        break;
      case 'googleReviewUrl':
        googleReviewUrl = value;
        break;
      case 'googleRating':
        googleRating = value;
        break;
      case 'googleTotalReviews':
        googleTotalReviews = value;
        break;
    }
    notifyListeners();
  }

  // ───────── IMAGE METHODS - CAROUSEL ─────────
  void addCarouselImage(File file) {
    carouselImages.add(file);
    notifyListeners();
  }

  void removeCarouselImage(int index) {
    carouselImages.removeAt(index);
    notifyListeners();
  }

  Future<bool> deleteExistingCarousel(String url, String diningId) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
      existingCarouselUrls.remove(url);

      await FirebaseFirestore.instance
          .collection('dining')
          .doc(diningId)
          .update({'images.carousel': existingCarouselUrls});

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting carousel: $e');
      return false;
    }
  }

  // ───────── IMAGE METHODS - MENU ─────────
  void addMenuImage(File file) {
    menuImages.add(file);
    notifyListeners();
  }

  void removeMenuImage(int index) {
    menuImages.removeAt(index);
    notifyListeners();
  }

  Future<bool> deleteExistingMenu(String url, String diningId) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
      existingMenuUrls.remove(url);

      await FirebaseFirestore.instance
          .collection('dining')
          .doc(diningId)
          .update({'images.menu': existingMenuUrls});

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting menu: $e');
      return false;
    }
  }

  // ───────── IMAGE METHODS - ABOUT ─────────
  void addAboutImage(File file) {
    aboutImages.add(file);
    notifyListeners();
  }

  void removeAboutImage(int index) {
    aboutImages.removeAt(index);
    notifyListeners();
  }

  Future<bool> deleteExistingAbout(String url, String diningId) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
      existingAboutUrls.remove(url);

      await FirebaseFirestore.instance
          .collection('dining')
          .doc(diningId)
          .update({'images.about': existingAboutUrls});

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting about: $e');
      return false;
    }
  }

  // ───────── LIST METHODS ─────────
  void addToList(String listName, String value) {
    switch (listName) {
      case 'facilities':
        facilities.add(value);
        break;
      case 'filterCategories':
        filterCategories.add(value);
        break;
      case 'filterDishes':
        filterDishes.add(value);
        break;
      case 'filterCuisines':
        filterCuisines.add(value);
        break;
    }
    notifyListeners();
  }

  void removeFromList(String listName, int index) {
    switch (listName) {
      case 'facilities':
        facilities.removeAt(index);
        break;
      case 'filterCategories':
        filterCategories.removeAt(index);
        break;
      case 'filterDishes':
        filterDishes.removeAt(index);
        break;
      case 'filterCuisines':
        filterCuisines.removeAt(index);
        break;
    }
    notifyListeners();
  }

  // ───────── ADD DINING TO ADMIN ACCOUNT ─────────
  Future<void> _addDiningToAdmin(String diningId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint('No user logged in - cannot add dining to admin');
        return;
      }

      final adminId = currentUser.uid;
      final adminDoc = FirebaseFirestore.instance
          .collection('dining_partner_admins')
          .doc(adminId);

      // Check if admin document exists
      final adminSnapshot = await adminDoc.get();
      
      if (adminSnapshot.exists) {
        // Update existing admin document
        await adminDoc.update({
          'diningIds': FieldValue.arrayUnion([diningId]),
          'stats.totalDinings': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Added dining $diningId to admin $adminId');
      } else {
        debugPrint('Admin document does not exist for $adminId');
        // Optionally create admin document if it doesn't exist
        // This is useful if someone creates a dining before logging in as admin
        await adminDoc.set({
          'adminId': adminId,
          'diningIds': [diningId],
          'stats': {
            'totalDinings': 1,
            'totalBookings': 0,
            'activeBookings': 0,
            'completedBookings': 0,
            'cancelledBookings': 0,
            'totalRevenue': 0.0,
            'ticpinAppRevenue': 0.0,
            'advancePaymentRevenue': 0.0,
            'fullPaymentRevenue': 0.0,
            'pendingPayouts': 0.0,
            'averageRating': 0.0,
            'totalReviews': 0,
          },
          'createdAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Created admin document and added dining $diningId');
      }
    } catch (e) {
      debugPrint('Error adding dining to admin: $e');
      // Don't rethrow - we don't want to fail the entire operation if this fails
    }
  }

  // ───────── REMOVE DINING FROM ADMIN ACCOUNT ─────────
  Future<void> _removeDiningFromAdmin(String diningId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint('No user logged in - cannot remove dining from admin');
        return;
      }

      final adminId = currentUser.uid;
      final adminDoc = FirebaseFirestore.instance
          .collection('dining_partner_admins')
          .doc(adminId);

      // Check if admin document exists
      final adminSnapshot = await adminDoc.get();
      
      if (adminSnapshot.exists) {
        await adminDoc.update({
          'diningIds': FieldValue.arrayRemove([diningId]),
          'stats.totalDinings': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Removed dining $diningId from admin $adminId');
      }
    } catch (e) {
      debugPrint('Error removing dining from admin: $e');
    }
  }

  // ───────── SAVE TO FIRESTORE ─────────
  Future<String> createDining() async {
    try {
      setSubmitting(true);

      final diningId = FirebaseFirestore.instance.collection('dining').doc().id;
      final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Upload carousel images
      List<String> carouselUrls = [];
      for (int i = 0; i < carouselImages.length; i++) {
        final randomId = DateTime.now().millisecondsSinceEpoch + i;
        final ref = FirebaseStorage.instance.ref(
          'dining_posters/$diningId/carousel/img_$randomId.jpg',
        );
        await ref.putFile(carouselImages[i]);
        final url = await ref.getDownloadURL();
        carouselUrls.add(url);
      }

      // Upload menu images
      List<String> menuUrls = [];
      for (int i = 0; i < menuImages.length; i++) {
        final randomId = DateTime.now().millisecondsSinceEpoch + i + 1000;
        final ref = FirebaseStorage.instance.ref(
          'dining_posters/$diningId/menu/img_$randomId.jpg',
        );
        await ref.putFile(menuImages[i]);
        final url = await ref.getDownloadURL();
        menuUrls.add(url);
      }

      // Upload about images
      List<String> aboutUrls = [];
      for (int i = 0; i < aboutImages.length; i++) {
        final randomId = DateTime.now().millisecondsSinceEpoch + i + 2000;
        final ref = FirebaseStorage.instance.ref(
          'dining_posters/$diningId/about/img_$randomId.jpg',
        );
        await ref.putFile(aboutImages[i]);
        final url = await ref.getDownloadURL();
        aboutUrls.add(url);
      }

      final data = {
        'diningId': diningId,
        'name': name,
        'owner': {'name': ownerName, 'address': ownerAddress},
        'description': description,
        'briefDescription': briefDescription,
        'contactNumber': contactNumber,
        'timings': {'open': openTime, 'close': closeTime},
        'location': {'lat': venueLat, 'lng': venueLng},
        'images': {
          'carousel': carouselUrls,
          'menu': menuUrls,
          'about': aboutUrls,
        },
        'facilities': facilities,
        'paymentUid': paymentUid,
        'reviews': {
          'source': 'google',
          'url': googleReviewUrl,
          'rating': googleRating,
          'total': googleTotalReviews,
        },
        'filters': {
          'categories': filterCategories,
          'dishes': filterDishes,
          'cuisines': filterCuisines,
        },
        'created_at': FieldValue.serverTimestamp(),
        'createdBy': currentUserId,
        'adminId': currentUserId, // Add admin ID to dining document
      };

      // Create dining document
      await FirebaseFirestore.instance
          .collection('dining')
          .doc(diningId)
          .set(data);

      // Add dining to admin account
      await _addDiningToAdmin(diningId);

      setSubmitting(false);
      return diningId;
    } catch (e) {
      setSubmitting(false);
      rethrow;
    }
  }

  Future<String> updateDining(String diningId) async {
    try {
      setSubmitting(true);

      // Upload new carousel images
      List<String> newCarouselUrls = List.from(existingCarouselUrls);
      for (int i = 0; i < carouselImages.length; i++) {
        final randomId = DateTime.now().millisecondsSinceEpoch + i;
        final ref = FirebaseStorage.instance.ref(
          'dining_posters/$diningId/carousel/img_$randomId.jpg',
        );
        await ref.putFile(carouselImages[i]);
        final url = await ref.getDownloadURL();
        newCarouselUrls.add(url);
      }

      // Upload new menu images
      List<String> newMenuUrls = List.from(existingMenuUrls);
      for (int i = 0; i < menuImages.length; i++) {
        final randomId = DateTime.now().millisecondsSinceEpoch + i + 1000;
        final ref = FirebaseStorage.instance.ref(
          'dining_posters/$diningId/menu/img_$randomId.jpg',
        );
        await ref.putFile(menuImages[i]);
        final url = await ref.getDownloadURL();
        newMenuUrls.add(url);
      }

      // Upload new about images
      List<String> newAboutUrls = List.from(existingAboutUrls);
      for (int i = 0; i < aboutImages.length; i++) {
        final randomId = DateTime.now().millisecondsSinceEpoch + i + 2000;
        final ref = FirebaseStorage.instance.ref(
          'dining_posters/$diningId/about/img_$randomId.jpg',
        );
        await ref.putFile(aboutImages[i]);
        final url = await ref.getDownloadURL();
        newAboutUrls.add(url);
      }

      final data = {
        'name': name,
        'owner': {'name': ownerName, 'address': ownerAddress},
        'description': description,
        'briefDescription': briefDescription,
        'contactNumber': contactNumber,
        'timings': {'open': openTime, 'close': closeTime},
        'location': {'lat': venueLat, 'lng': venueLng},
        'images': {
          'carousel': newCarouselUrls,
          'menu': newMenuUrls,
          'about': newAboutUrls,
        },
        'facilities': facilities,
        'paymentUid': paymentUid,
        'reviews': {
          'source': 'google',
          'url': googleReviewUrl,
          'rating': googleRating,
          'total': googleTotalReviews,
        },
        'filters': {
          'categories': filterCategories,
          'dishes': filterDishes,
          'cuisines': filterCuisines,
        },
        'updated_at': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('dining')
          .doc(diningId)
          .update(data);

      // Ensure dining is in admin account (in case it was removed)
      await _addDiningToAdmin(diningId);

      setSubmitting(false);
      return diningId;
    } catch (e) {
      setSubmitting(false);
      rethrow;
    }
  }

  // ───────── DELETE DINING ─────────
  Future<void> deleteDining(String diningId) async {
    try {
      setSubmitting(true);

      // Delete all images from storage
      for (String url in existingCarouselUrls) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(url);
          await ref.delete();
        } catch (e) {
          debugPrint('Error deleting carousel image: $e');
        }
      }

      for (String url in existingMenuUrls) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(url);
          await ref.delete();
        } catch (e) {
          debugPrint('Error deleting menu image: $e');
        }
      }

      for (String url in existingAboutUrls) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(url);
          await ref.delete();
        } catch (e) {
          debugPrint('Error deleting about image: $e');
        }
      }

      // Remove from admin account
      await _removeDiningFromAdmin(diningId);

      // Delete dining document
      await FirebaseFirestore.instance
          .collection('dining')
          .doc(diningId)
          .delete();

      setSubmitting(false);
    } catch (e) {
      setSubmitting(false);
      rethrow;
    }
  }

  // ───────── LOAD FROM FIRESTORE ─────────
  void loadFromFirestore(Map<String, dynamic> data, String? diningId) {
    name = data['name'] ?? '';

    final owner = data['owner'] as Map<String, dynamic>?;
    ownerName = owner?['name'] ?? '';
    ownerAddress = owner?['address'] ?? '';

    description = data['description'] ?? '';
    briefDescription = data['briefDescription'] ?? '';
    contactNumber = data['contactNumber'] ?? '';

    final timings = data['timings'] as Map<String, dynamic>?;
    openTime = timings?['open'] ?? '';
    closeTime = timings?['close'] ?? '';

    final location = data['location'] as Map<String, dynamic>?;
    venueLat = location?['lat'] ?? '';
    venueLng = location?['lng'] ?? '';

    final images = data['images'] as Map<String, dynamic>?;
    existingCarouselUrls = List<String>.from(images?['carousel'] ?? []);
    existingMenuUrls = List<String>.from(images?['menu'] ?? []);
    existingAboutUrls = List<String>.from(images?['about'] ?? []);

    facilities = List<String>.from(data['facilities'] ?? []);

    paymentUid = data['paymentUid'] ?? '';

    final reviews = data['reviews'] as Map<String, dynamic>?;
    googleReviewUrl = reviews?['url'] ?? '';
    googleRating = (reviews?['rating'] ?? 0.0).toDouble();
    googleTotalReviews = reviews?['total'] ?? 0;

    final filters = data['filters'] as Map<String, dynamic>?;
    filterCategories = List<String>.from(filters?['categories'] ?? []);
    filterDishes = List<String>.from(filters?['dishes'] ?? []);
    filterCuisines = List<String>.from(filters?['cuisines'] ?? []);

    notifyListeners();
  }

  // ───────── UTILITY ─────────
  void setSubmitting(bool value) {
    submitting = value;
    notifyListeners();
  }

  void reset() {
    name = '';
    ownerName = '';
    ownerAddress = '';
    description = '';
    briefDescription = '';
    contactNumber = '';
    openTime = '';
    closeTime = '';
    venueLat = '';
    venueLng = '';
    carouselImages.clear();
    existingCarouselUrls.clear();
    menuImages.clear();
    existingMenuUrls.clear();
    aboutImages.clear();
    existingAboutUrls.clear();
    facilities.clear();
    filterCategories.clear();
    filterDishes.clear();
    filterCuisines.clear();
    paymentUid = '';
    googleReviewUrl = '';
    googleRating = 0.0;
    googleTotalReviews = 0;
    submitting = false;
    notifyListeners();
  }
}