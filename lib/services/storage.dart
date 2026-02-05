// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:ticpin_play/services/eventformprovider.dart';

// class EventSubmissionService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Upload single image to Firebase Storage
//   Future<String> uploadImage(
//     File file,
//     String eventId,
//     String fileName, {
//     Function(double)? onProgress,
//   }) async {
//     try {
//       final ref = _storage.ref().child('event_posters/$eventId/$fileName');
//       final uploadTask = ref.putFile(file);

//       // Track progress
//       if (onProgress != null) {
//         uploadTask.snapshotEvents.listen((snapshot) {
//           final progress = snapshot.bytesTransferred / snapshot.totalBytes;
//           onProgress(progress);
//         });
//       }

//       final snapshot = await uploadTask;
//       final downloadUrl = await snapshot.ref.getDownloadURL();
      
//       debugPrint('✅ Uploaded: $fileName');
//       return downloadUrl;
//     } catch (e) {
//       debugPrint('❌ Upload error for $fileName: $e');
//       rethrow;
//     }
//   }

//   /// Delete image from Firebase Storage by URL
//   Future<void> deleteImageFromUrl(String url) async {
//     try {
//       if (url.isEmpty) return;
//       final ref = _storage.refFromURL(url);
//       await ref.delete();
//       debugPrint('✅ Deleted image: $url');
//     } catch (e) {
//       debugPrint('⚠️ Delete error (may not exist): $e');
//     }
//   }

//   /// Delete entire event folder from Storage
//   Future<void> deleteEventFolder(String eventId) async {
//     try {
//       final ref = _storage.ref().child('event_posters/$eventId');
//       final listResult = await ref.listAll();

//       for (var item in listResult.items) {
//         await item.delete();
//       }
//       debugPrint('✅ Deleted folder: event_posters/$eventId');
//     } catch (e) {
//       debugPrint('❌ Folder delete error: $e');
//     }
//   }

//   /// CREATE event with image upload
//   Future<String?> createEvent(
//     EventFormProvider prov, {
//     Function(String)? onStatusUpdate,
//   }) async {
//     DocumentReference? docRef;
//     String? eventId;

//     try {
//       onStatusUpdate?.call('Creating event document...');

//       // 1. Create Firestore document first (without image URLs)
//       docRef = await _firestore.collection('events').add({
//         'name': prov.name,
//         'isMultiDay': prov.isMultiDay,
//         'category': prov.category,
//         'ageRestriction': prov.ageRestriction,
//         'dateTime': Timestamp.fromDate(prov.dateTime),
//         'endDateTime': prov.endDateTime != null
//             ? Timestamp.fromDate(prov.endDateTime!)
//             : null,
//         'eventDays': prov.isMultiDay
//             ? prov.eventDays
//                 .map((e) => {
//                       'start': Timestamp.fromDate(e['start']!),
//                       'end': Timestamp.fromDate(e['end']!),
//                     })
//                 .toList()
//             : [],
//         'venue': {
//           'name': prov.venueName,
//           'fullAddress': prov.venueFullAddress,
//           'venueLat': prov.venueLat,
//           'venueLng': prov.venueLng,
//         },
//         'organiser': {
//           'companyName': prov.organiserCompany,
//           'contactPerson': prov.organiserContactPerson,
//           'contactPhone': prov.organiserPhone,
//           'contactEmail': prov.organiserEmail,
//         },
//         'artistLineup': prov.artistLineup,
//         'media': {
//           'posterLink': '', // Will be updated after upload
//           'videoLink': prov.videoDriveLink,
//           'galleryLinks': [], // Will be updated after upload
//         },
//         'tickets': prov.tickets.map((t) => t.toMap()).toList(),
//         'financial': {
//           'accountNumber': prov.bankAccount,
//           'ifsc': prov.ifsc,
//           'panOrGst': prov.panOrGst,
//           'bankName': prov.bankName,
//           'accountHolder': prov.accountHolder,
//         },
//         'promotion': {
//           'hashtags': prov.hashtags,
//           'socialLinks': prov.socialLinks,
//         },
//         'legal': {
//           'noc': prov.nocLinks,
//           'gstNo': prov.gstNo,
//           'liabilityText': prov.liabilityText,
//         },
//         'createdAt': Timestamp.now(),
//         'updatedAt': Timestamp.now(),
//         'createdBy': FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
//       });

//       eventId = docRef.id;
//       debugPrint('✅ Event document created: $eventId');

//       // 2. Upload images to Storage
//       String? posterUrl;
//       List<String> galleryUrls = [];

//       // Upload poster image
//       if (prov.posterImageFile != null) {
//         onStatusUpdate?.call('Uploading poster image...');
//         posterUrl = await uploadImage(
//           prov.posterImageFile!,
//           eventId,
//           'poster.jpg',
//           onProgress: (progress) {
//             debugPrint('Poster upload: ${(progress * 100).toStringAsFixed(0)}%');
//           },
//         );
//       }

//       // Upload gallery images
//       if (prov.galleryImageFiles.isNotEmpty) {
//         onStatusUpdate?.call('Uploading gallery images...');
//         for (int i = 0; i < prov.galleryImageFiles.length; i++) {
//           final url = await uploadImage(
//             prov.galleryImageFiles[i],
//             eventId,
//             'gallery_$i.jpg',
//             onProgress: (progress) {
//               debugPrint('Gallery $i: ${(progress * 100).toStringAsFixed(0)}%');
//             },
//           );
//           galleryUrls.add(url);
//         }
//       }

//       // 3. Update document with image URLs
//       onStatusUpdate?.call('Finalizing event...');
//       await docRef.update({
//         'media.posterLink': posterUrl ?? prov.posterDriveLink,
//         'media.galleryLinks': galleryUrls,
//       });

//       debugPrint('✅ Event created successfully with all images');
//       return eventId;
      
//     } catch (e) {
//       debugPrint('❌ Create event error: $e');

//       // Rollback: Delete Firestore document if it was created
//       if (docRef != null && eventId != null) {
//         try {
//           await docRef.delete();
//           debugPrint('⚠️ Rolled back event document');
//         } catch (rollbackError) {
//           debugPrint('⚠️ Rollback failed: $rollbackError');
//         }
//       }

//       return null;
//     }
//   }

//   /// UPDATE event (handles image changes)
//   Future<bool> updateEvent(
//     String eventId,
//     EventFormProvider prov, {
//     String? oldPosterUrl,
//     List<String>? oldGalleryUrls,
//     Function(String)? onStatusUpdate,
//   }) async {
//     try {
//       onStatusUpdate?.call('Updating event...');

//       // Get existing data to preserve createdAt and createdBy
//       final existingDoc = await _firestore.collection('events').doc(eventId).get();
//       final existingData = existingDoc.data();
//       final createdAt = existingData?['createdAt'];
//       final createdBy = existingData?['createdBy'];

//       List<String> urlsToDelete = [];
//       String? newPosterUrl = oldPosterUrl;
//       List<String> newGalleryUrls = oldGalleryUrls ?? [];

//       // Handle poster change
//       if (prov.posterImageFile != null) {
//         onStatusUpdate?.call('Uploading new poster...');
        
//         // Delete old poster
//         if (oldPosterUrl != null && oldPosterUrl.isNotEmpty) {
//           urlsToDelete.add(oldPosterUrl);
//         }

//         // Upload new poster
//         newPosterUrl = await uploadImage(
//           prov.posterImageFile!,
//           eventId,
//           'poster.jpg',
//         );
//       } else if (prov.posterDriveLink.isNotEmpty) {
//         newPosterUrl = prov.posterDriveLink;
//       }

//       // Handle gallery images
//       if (prov.galleryImageFiles.isNotEmpty) {
//         onStatusUpdate?.call('Uploading gallery images...');
        
//         // Delete old gallery images
//         if (oldGalleryUrls != null) {
//           urlsToDelete.addAll(oldGalleryUrls);
//         }

//         // Upload new gallery images
//         newGalleryUrls = [];
//         for (int i = 0; i < prov.galleryImageFiles.length; i++) {
//           final url = await uploadImage(
//             prov.galleryImageFiles[i],
//             eventId,
//             'gallery_$i.jpg',
//           );
//           newGalleryUrls.add(url);
//         }
//       }

//       // Update Firestore
//       onStatusUpdate?.call('Saving changes...');
//       await _firestore.collection('events').doc(eventId).update({
//         'name': prov.name,
//         'isMultiDay': prov.isMultiDay,
//         'category': prov.category,
//         'ageRestriction': prov.ageRestriction,
//         'dateTime': Timestamp.fromDate(prov.dateTime),
//         'endDateTime': prov.endDateTime != null
//             ? Timestamp.fromDate(prov.endDateTime!)
//             : null,
//         'eventDays': prov.isMultiDay
//             ? prov.eventDays
//                 .map((e) => {
//                       'start': Timestamp.fromDate(e['start']!),
//                       'end': Timestamp.fromDate(e['end']!),
//                     })
//                 .toList()
//             : [],
//         'venue': {
//           'name': prov.venueName,
//           'fullAddress': prov.venueFullAddress,
//           'venueLat': prov.venueLat,
//           'venueLng': prov.venueLng,
//         },
//         'organiser': {
//           'companyName': prov.organiserCompany,
//           'contactPerson': prov.organiserContactPerson,
//           'contactPhone': prov.organiserPhone,
//           'contactEmail': prov.organiserEmail,
//         },
//         'artistLineup': prov.artistLineup,
//         'media': {
//           'posterLink': newPosterUrl ?? '',
//           'videoLink': prov.videoDriveLink,
//           'galleryLinks': newGalleryUrls,
//         },
//         'tickets': prov.tickets.map((t) => t.toMap()).toList(),
//         'financial': {
//           'accountNumber': prov.bankAccount,
//           'ifsc': prov.ifsc,
//           'panOrGst': prov.panOrGst,
//           'bankName': prov.bankName,
//           'accountHolder': prov.accountHolder,
//         },
//         'promotion': {
//           'hashtags': prov.hashtags,
//           'socialLinks': prov.socialLinks,
//         },
//         'legal': {
//           'noc': prov.nocLinks,
//           'gstNo': prov.gstNo,
//           'liabilityText': prov.liabilityText,
//         },
//         'updatedAt': Timestamp.now(),
//         'createdAt': createdAt,
//         'createdBy': createdBy,
//       });

//       // Delete old images
//       onStatusUpdate?.call('Cleaning up old images...');
//       for (var url in urlsToDelete) {
//         await deleteImageFromUrl(url);
//       }

//       debugPrint('✅ Event updated successfully');
//       return true;
      
//     } catch (e) {
//       debugPrint('❌ Update event error: $e');
//       return false;
//     }
//   }

//   /// DELETE event and all images
//   Future<bool> deleteEvent(String eventId) async {
//     try {
//       // 1. Delete all images from Storage
//       await deleteEventFolder(eventId);

//       // 2. Delete Firestore document
//       await _firestore.collection('events').doc(eventId).delete();

//       debugPrint('✅ Event deleted successfully');
//       return true;
      
//     } catch (e) {
//       debugPrint('❌ Delete event error: $e');
//       return false;
//     }
//   }
// }
