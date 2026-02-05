// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:ticpin_partner/constants/colors.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// class MediaUploadPage extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   const MediaUploadPage({required this.formKey, super.key});

//   @override
//   State<MediaUploadPage> createState() => _MediaUploadPageState();
// }

// class _MediaUploadPageState extends State<MediaUploadPage> {
//   String? posterError;
//   String? videoError;
//   VideoPlayerController? _videoController;
//   bool _isMuted = false;
//   bool _isInitialized = false;

//   bool _isValidUrl(String url) {
//     final uri = Uri.tryParse(url);
//     return uri != null && uri.hasAbsolutePath && uri.scheme.startsWith('http');
//   }

//   bool _isImageUrl(String url) {
//     final lower = url.toLowerCase();
//     return lower.endsWith('.jpg') ||
//         lower.endsWith('.jpeg') ||
//         lower.endsWith('.png') ||
//         lower.endsWith('.gif') ||
//         url.contains('drive.google.com');
//   }

//   bool _isVideoUrl(String url) {
//     final lower = url.toLowerCase();
//     return lower.endsWith('.mp4') ||
//         lower.endsWith('.mov') ||
//         lower.endsWith('.avi') ||
//         lower.endsWith('.mkv') ||
//         url.contains('drive.google.com');
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   Future<void> _initVideo(String link) async {
//     try {
//       _videoController?.dispose();
//       _videoController = null;
//       _isInitialized = false;

//       final playableLink = _convertDriveVideo(link);
//       debugPrint('Initializing video from: $playableLink');

//       _videoController = VideoPlayerController.networkUrl(
//         Uri.parse(playableLink),
//       );

//       await _videoController!.initialize();
//       _videoController!.setLooping(true);
//       _videoController!.setVolume(_isMuted ? 0 : 1);

//       if (mounted) {
//         setState(() => _isInitialized = true);
//       }
//     } catch (e) {
//       debugPrint('Video init error: $e');
//       if (mounted) {
//         setState(() {
//           _isInitialized = false;
//           videoError = 'Failed to load video. Please check the URL.';
//         });
//       }
//     }
//   }

//   String _convertDriveVideo(String link) {
//     if (link.contains('drive.google.com')) {
//       // Extract file ID from various Google Drive URL formats
//       String? fileId;

//       if (link.contains('/d/')) {
//         fileId = link.split('/d/')[1].split('/')[0];
//       } else if (link.contains('id=')) {
//         fileId = Uri.parse(link).queryParameters['id'];
//       }

//       if (fileId != null && fileId.isNotEmpty) {
//         // Use direct download link for better compatibility
//         return 'https://drive.google.com/uc?export=download&id=$fileId';
//       }
//     }
//     return link;
//   }

//   String _convertDriveImage(String link) {
//     if (link.contains('drive.google.com')) {
//       String? fileId;

//       if (link.contains('/d/')) {
//         fileId = link.split('/d/')[1].split('/')[0];
//       } else if (link.contains('id=')) {
//         fileId = Uri.parse(link).queryParameters['id'];
//       }

//       if (fileId != null && fileId.isNotEmpty) {
//         return 'https://drive.google.com/thumbnail?id=$fileId&sz=w1000';
//       }
//     }
//     return link;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<EventFormProvider>();
//     final size = MediaQuery.of(context).size;

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: widget.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // ───────────── Poster Upload ─────────────
//               FormField<String>(
//                 initialValue: prov.posterDriveLink,
//                 validator: (value) {
//                   if (prov.posterDriveLink.isEmpty) {
//                     return 'Event poster is required';
//                   }
//                   if (!_isValidUrl(prov.posterDriveLink) ||
//                       !_isImageUrl(prov.posterDriveLink)) {
//                     return 'Invalid image URL or Google Drive link';
//                   }
//                   return null;
//                 },
//                 builder:
//                     (state) => _buildPosterUploader(context, size, prov, state),
//               ),

//               const SizedBox(height: 24),

//               // ───────────── Video Upload ─────────────
//               FormField<String>(
//                 initialValue: prov.videoDriveLink,
//                 validator: (value) {
//                   if (prov.videoDriveLink.isNotEmpty &&
//                       (!_isValidUrl(prov.videoDriveLink) ||
//                           !_isVideoUrl(prov.videoDriveLink))) {
//                     return 'Invalid video URL or Google Drive link';
//                   }
//                   return null;
//                 },
//                 builder:
//                     (state) => _buildVideoUploader(context, size, prov, state),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPosterUploader(
//     BuildContext context,
//     Size size,
//     EventFormProvider prov,
//     FormFieldState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: prov.posterDriveLink.isEmpty
//               ? () => _showLinkDialog(context, 'Poster Drive Link', (link) {
//                     if (!_isValidUrl(link) || !_isImageUrl(link)) {
//                       setState(() {
//                         posterError = 'Invalid image URL or Google Drive link';
//                       });
//                     } else {
//                       setState(() => posterError = null);
//                       prov.updateField('posterDriveLink', link);
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         state.didChange(link);
//                         state.validate();
//                       });
//                     }
//                   })
//               : null,
//           child: Container(
//             width: size.width * 0.8,
//             height: (size.width * 0.8) * (2.6 / 2),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: posterError != null || state.hasError
//                     ? Colors.red
//                     : Colors.grey.shade400,
//                 width: posterError != null || state.hasError ? 2 : 1,
//               ),
//               image: prov.posterDriveLink.isNotEmpty
//                   ? DecorationImage(
//                       image: NetworkImage(
//                         _convertDriveImage(prov.posterDriveLink),
//                       ),
//                       fit: BoxFit.cover,
//                       onError: (error, stackTrace) {
//                         debugPrint('Image load error: $error');
//                       },
//                     )
//                   : null,
//             ),
//             child: prov.posterDriveLink.isEmpty
//                 ? _uploadPlaceholder(
//                     size,
//                     'Upload Event Poster',
//                     Icons.image,
//                     '(Google Drive or Image URL)',
//                   )
//                 : _removeOverlay(() {
//                     prov.updateField('posterDriveLink', '');
//                     setState(() => posterError = null);
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       state.didChange('');
//                       state.validate();
//                     });
//                   }),
//           ),
//         ),
//         if (posterError != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               posterError!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//         if (state.hasError)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               state.errorText!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildVideoUploader(
//     BuildContext context,
//     Size size,
//     EventFormProvider prov,
//     FormFieldState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: prov.videoDriveLink.isEmpty
//               ? () => _showLinkDialog(context, 'Video Drive Link', (link) async {
//                     if (!_isValidUrl(link) || !_isVideoUrl(link)) {
//                       setState(() {
//                         videoError = 'Invalid video URL or Google Drive link';
//                       });
//                     } else {
//                       setState(() => videoError = null);
//                       prov.updateField('videoDriveLink', link);
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         state.didChange(link);
//                         state.validate();
//                       });
//                       await _initVideo(link);
//                     }
//                   })
//               : null,
//           child: Container(
//             width: size.width * 0.8,
//             height: (size.width * 0.8) * (2.6 / 2),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: videoError != null || state.hasError
//                     ? Colors.red
//                     : Colors.grey.shade400,
//                 width: videoError != null || state.hasError ? 2 : 1,
//               ),
//             ),
//             child: prov.videoDriveLink.isEmpty
//                 ? _uploadPlaceholder(
//                     size,
//                     'Upload Event Video',
//                     Icons.video_library,
//                     '(Google Drive or Video URL)',
//                   )
//                 : _isInitialized
//                     ? _videoPlayer(size, prov, state)
//                     : const Center(
//                         child: CircularProgressIndicator(
//                           color: Color(0xFF1E1E82),
//                         ),
//                       ),
//           ),
//         ),
//         if (videoError != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               videoError!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//         if (state.hasError)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               state.errorText!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _videoPlayer(Size size, EventFormProvider prov, FormFieldState state) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: SizedBox(
//             width: size.width * 0.8,
//             height: (size.width * 0.8) * (2.6 / 2),
//             child: FittedBox(
//               fit: BoxFit.cover,
//               child: SizedBox(
//                 width: _videoController!.value.size.width,
//                 height: _videoController!.value.size.height,
//                 child: VideoPlayer(_videoController!),
//               ),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             _videoController!.value.isPlaying
//                 ? Icons.pause_circle
//                 : Icons.play_circle_fill,
//             size: 70,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             setState(() {
//               if (_videoController!.value.isPlaying) {
//                 _videoController!.pause();
//               } else {
//                 _videoController!.play();
//               }
//             });
//           },
//         ),
//         Positioned(
//           top: 10,
//           right: 10,
//           child: IconButton(
//             icon: Icon(
//               _isMuted ? Icons.volume_off : Icons.volume_up,
//               color: Colors.white,
//               size: 28,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isMuted = !_isMuted;
//                 _videoController!.setVolume(_isMuted ? 0 : 1);
//               });
//             },
//           ),
//         ),
//         _removeOverlay(() {
//           _videoController?.pause();
//           _videoController?.dispose();
//           _videoController = null;
//           _isInitialized = false;
//           prov.updateField('videoDriveLink', '');
//           setState(() => videoError = null);
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             state.didChange('');
//             state.validate();
//           });
//           setState(() {});
//         }),
//       ],
//     );
//   }

//   Widget _uploadPlaceholder(
//     Size size,
//     String label,
//     IconData icon,
//     String hint,
//   ) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: size.width * 0.15, color: Colors.grey.shade400),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E1E82),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(hint, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }

//   Widget _removeOverlay(VoidCallback onRemove) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Positioned(
//           bottom: 10,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.black26,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TextButton.icon(
//               onPressed: onRemove,
//               icon: const Icon(Icons.delete, color: Colors.white, size: 16),
//               label: const Text(
//                 'Remove',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showLinkDialog(
//     BuildContext context,
//     String title,
//     Function(String) onSave,
//   ) {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text(title),
//         content: TextField(
//           controller: controller,
//           cursorColor: const Color(0xFF1E1E82),
//           decoration: const InputDecoration(
//             hintText: 'Paste Google Drive or media URL',
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Color(0xFF1E1E82)),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF1E1E82),
//             ),
//             onPressed: () {
//               onSave(controller.text.trim());
//               Navigator.pop(ctx);
//             },
//             child: const Text('Save', style: TextStyle(color: whiteColor)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:ticpin_partner/constants/colors.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// class MediaUploadPage extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   const MediaUploadPage({required this.formKey, super.key});

//   @override
//   State<MediaUploadPage> createState() => _MediaUploadPageState();
// }

// class _MediaUploadPageState extends State<MediaUploadPage> {
//   String? posterError;
//   String? videoError;
//   VideoPlayerController? _videoController;
//   bool _isMuted = false;
//   bool _isInitialized = false;

//   // Image picker
//   final ImagePicker _picker = ImagePicker();
//   File? _selectedImage;
//   bool _isUploadingImage = false;
//   double _uploadProgress = 0.0;

//   bool _isValidUrl(String url) {
//     final uri = Uri.tryParse(url);
//     return uri != null && uri.hasAbsolutePath && uri.scheme.startsWith('http');
//   }

//   bool _isVideoUrl(String url) {
//     final lower = url.toLowerCase();
//     return lower.endsWith('.mp4') ||
//         lower.endsWith('.mov') ||
//         lower.endsWith('.avi') ||
//         lower.endsWith('.mkv') ||
//         url.contains('drive.google.com');
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   // Pick image from gallery
//   Future<void> _pickImage(EventFormProvider prov, FormFieldState state) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (image == null) return;

//       setState(() {
//         _selectedImage = File(image.path);
//         posterError = null;
//       });

//       // Upload to Firebase Storage
//       await _uploadImageToFirebase(prov, state);
//     } catch (e) {
//       debugPrint('Image picker error: $e');
//       setState(() {
//         posterError = 'Failed to pick image. Please try again.';
//       });
//     }
//   }

//   // Upload image to Firebase Storage
//   Future<void> _uploadImageToFirebase(
//     EventFormProvider prov,
//     FormFieldState state,
//   ) async {
//     if (_selectedImage == null) return;

//     setState(() {
//       _isUploadingImage = true;
//       _uploadProgress = 0.0;
//     });

//     try {
//       // Create a unique filename
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final fileName = 'event_posters/poster_$timestamp.jpg';

//       // Create reference to Firebase Storage
//       final storageRef = FirebaseStorage.instance.ref().child(fileName);

//       // Upload file with progress tracking
//       final uploadTask = storageRef.putFile(_selectedImage!);

//       // Listen to upload progress
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         setState(() {
//           _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
//         });
//       });

//       // Wait for upload to complete
//       final snapshot = await uploadTask;

//       // Get download URL
//       final downloadUrl = await snapshot.ref.getDownloadURL();

//       // Update provider with the Firebase URL
//       prov.updateField('posterDriveLink', downloadUrl);

//       // Validate form field
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         state.didChange(downloadUrl);
//         state.validate();
//       });

//       setState(() {
//         _isUploadingImage = false;
//         posterError = null;
//       });

//       debugPrint('✅ Image uploaded successfully: $downloadUrl');
//     } catch (e) {
//       debugPrint('❌ Upload error: $e');
//       setState(() {
//         _isUploadingImage = false;
//         posterError = 'Failed to upload image. Please try again.';
//         _selectedImage = null;
//       });
//     }
//   }

//   Future<void> _initVideo(String link) async {
//     try {
//       _videoController?.dispose();
//       _videoController = null;
//       _isInitialized = false;

//       final playableLink = _convertDriveVideo(link);
//       debugPrint('Initializing video from: $playableLink');

//       _videoController = VideoPlayerController.networkUrl(
//         Uri.parse(playableLink),
//       );

//       await _videoController!.initialize();
//       _videoController!.setLooping(true);
//       _videoController!.setVolume(_isMuted ? 0 : 1);

//       if (mounted) {
//         setState(() => _isInitialized = true);
//       }
//     } catch (e) {
//       debugPrint('Video init error: $e');
//       if (mounted) {
//         setState(() {
//           _isInitialized = false;
//           videoError = 'Failed to load video. Please check the URL.';
//         });
//       }
//     }
//   }

//   String _convertDriveVideo(String link) {
//     if (link.contains('drive.google.com')) {
//       String? fileId;

//       if (link.contains('/d/')) {
//         fileId = link.split('/d/')[1].split('/')[0];
//       } else if (link.contains('id=')) {
//         fileId = Uri.parse(link).queryParameters['id'];
//       }

//       if (fileId != null && fileId.isNotEmpty) {
//         return 'https://drive.google.com/uc?export=download&id=$fileId';
//       }
//     }
//     return link;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<EventFormProvider>();
//     final size = MediaQuery.of(context).size;

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: widget.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // ───────────── Poster Upload ─────────────
//               FormField<String>(
//                 initialValue: prov.posterDriveLink,
//                 validator: (value) {
//                   if (prov.posterDriveLink.isEmpty) {
//                     return 'Event poster is required';
//                   }
//                   return null;
//                 },
//                 builder:
//                     (state) => _buildPosterUploader(context, size, prov, state),
//               ),

//               const SizedBox(height: 24),

//               // ───────────── Video Upload ─────────────
//               FormField<String>(
//                 initialValue: prov.videoDriveLink,
//                 validator: (value) {
//                   if (prov.videoDriveLink.isNotEmpty &&
//                       (!_isValidUrl(prov.videoDriveLink) ||
//                           !_isVideoUrl(prov.videoDriveLink))) {
//                     return 'Invalid video URL or Google Drive link';
//                   }
//                   return null;
//                 },
//                 builder:
//                     (state) => _buildVideoUploader(context, size, prov, state),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPosterUploader(
//     BuildContext context,
//     Size size,
//     EventFormProvider prov,
//     FormFieldState state,
//   ) {
//     final hasImage = prov.posterDriveLink.isNotEmpty || _selectedImage != null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap:
//               !hasImage && !_isUploadingImage
//                   ? () => _pickImage(prov, state)
//                   : null,
//           child: Container(
//             height: (size.width * 0.85) * (3 / 2),
//             width: size.width * 0.85,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color:
//                     posterError != null || state.hasError
//                         ? Colors.red
//                         : Colors.grey.shade400,
//                 width: posterError != null || state.hasError ? 2 : 1,
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child:
//                   _isUploadingImage
//                       ? _uploadingIndicator(size)
//                       : hasImage
//                       ? _imagePreview(prov)
//                       : _uploadPlaceholder(
//                         size,
//                         'Upload Event Poster',
//                         Icons.image,
//                         'Tap to select from gallery',
//                       ),
//             ),
//           ),
//         ),
//         if (posterError != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               posterError!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//         if (state.hasError)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               state.errorText!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _imagePreview(EventFormProvider prov) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         // Show local image while uploading, then Firebase URL
//         if (_selectedImage != null && prov.posterDriveLink.isEmpty)
//           Image.file(_selectedImage!, fit: BoxFit.cover)
//         else
//           Image.network(
//             prov.posterDriveLink,
//             fit: BoxFit.fill,
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) return child;
//               return Center(
//                 child: CircularProgressIndicator(
//                   value:
//                       loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                               loadingProgress.expectedTotalBytes!
//                           : null,
//                   color: const Color(0xFF1E1E82),
//                 ),
//               );
//             },
//             errorBuilder: (context, error, stackTrace) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.error_outline, color: Colors.red, size: 48),
//                     SizedBox(height: 8),
//                     Text('Failed to load image'),
//                   ],
//                 ),
//               );
//             },
//           ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: _removeOverlay(() {
//             prov.updateField('posterDriveLink', '');
//             setState(() {
//               _selectedImage = null;
//               posterError = null;
//             });
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _uploadingIndicator(Size size) {
//     return Container(
//       color: Colors.black12,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             value: _uploadProgress,
//             color: const Color(0xFF1E1E82),
//             strokeWidth: 6,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E1E82),
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Please wait',
//             style: TextStyle(color: Colors.grey, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoUploader(
//     BuildContext context,
//     Size size,
//     EventFormProvider prov,
//     FormFieldState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap:
//               prov.videoDriveLink.isEmpty
//                   ? () => _showLinkDialog(context, 'Video Drive Link', (
//                     link,
//                   ) async {
//                     if (!_isValidUrl(link) || !_isVideoUrl(link)) {
//                       setState(() {
//                         videoError = 'Invalid video URL or Google Drive link';
//                       });
//                     } else {
//                       setState(() => videoError = null);
//                       prov.updateField('videoDriveLink', link);
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         state.didChange(link);
//                         state.validate();
//                       });
//                       await _initVideo(link);
//                     }
//                   })
//                   : null,
//           child: Container(
//             height: (size.width * 0.85) * (3 / 2),
//             width: size.width * 0.85,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color:
//                     videoError != null || state.hasError
//                         ? Colors.red
//                         : Colors.grey.shade400,
//                 width: videoError != null || state.hasError ? 2 : 1,
//               ),
//             ),
//             child:
//                 prov.videoDriveLink.isEmpty
//                     ? _uploadPlaceholder(
//                       size,
//                       'Upload Event Video',
//                       Icons.video_library,
//                       'Google Drive or Video URL',
//                     )
//                     : _isInitialized
//                     ? _videoPlayer(size, prov, state)
//                     : const Center(
//                       child: CircularProgressIndicator(
//                         color: Color(0xFF1E1E82),
//                       ),
//                     ),
//           ),
//         ),
//         if (videoError != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               videoError!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//         if (state.hasError)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               state.errorText!,
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _videoPlayer(Size size, EventFormProvider prov, FormFieldState state) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: SizedBox(
//             width: size.width * 0.8,
//             height: (size.width * 0.8) * (2.6 / 2),
//             child: FittedBox(
//               fit: BoxFit.cover,
//               child: SizedBox(
//                 width: _videoController!.value.size.width,
//                 height: _videoController!.value.size.height,
//                 child: VideoPlayer(_videoController!),
//               ),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             _videoController!.value.isPlaying
//                 ? Icons.pause_circle
//                 : Icons.play_circle_fill,
//             size: 70,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             setState(() {
//               if (_videoController!.value.isPlaying) {
//                 _videoController!.pause();
//               } else {
//                 _videoController!.play();
//               }
//             });
//           },
//         ),
//         Positioned(
//           top: 10,
//           right: 10,
//           child: IconButton(
//             icon: Icon(
//               _isMuted ? Icons.volume_off : Icons.volume_up,
//               color: Colors.white,
//               size: 28,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isMuted = !_isMuted;
//                 _videoController!.setVolume(_isMuted ? 0 : 1);
//               });
//             },
//           ),
//         ),
//         _removeOverlay(() {
//           _videoController?.pause();
//           _videoController?.dispose();
//           _videoController = null;
//           _isInitialized = false;
//           prov.updateField('videoDriveLink', '');
//           setState(() => videoError = null);
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             state.didChange('');
//             state.validate();
//           });
//           setState(() {});
//         }),
//       ],
//     );
//   }

//   Widget _uploadPlaceholder(
//     Size size,
//     String label,
//     IconData icon,
//     String hint,
//   ) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: size.width * 0.15, color: Colors.grey.shade400),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E1E82),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(hint, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }

//   Widget _removeOverlay(VoidCallback onRemove) {
//     return Positioned(
//       bottom: 10,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.black54,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: TextButton.icon(
//           onPressed: onRemove,
//           icon: const Icon(Icons.delete, color: Colors.white, size: 16),
//           label: const Text('Remove', style: TextStyle(color: Colors.white)),
//         ),
//       ),
//     );
//   }

//   void _showLinkDialog(
//     BuildContext context,
//     String title,
//     Function(String) onSave,
//   ) {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder:
//           (ctx) => AlertDialog(
//             title: Text(title),
//             content: TextField(
//               controller: controller,
//               cursorColor: const Color(0xFF1E1E82),
//               decoration: const InputDecoration(
//                 hintText: 'Paste Google Drive or media URL',
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(ctx),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Color(0xFF1E1E82)),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1E1E82),
//                 ),
//                 onPressed: () {
//                   onSave(controller.text.trim());
//                   Navigator.pop(ctx);
//                 },
//                 child: const Text('Save', style: TextStyle(color: whiteColor)),
//               ),
//             ],
//           ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ticpin_partner/constants/colors.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// class MediaUploadPage extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   const MediaUploadPage({required this.formKey, super.key});

//   @override
//   State<MediaUploadPage> createState() => _MediaUploadPageState();
// }

// class _MediaUploadPageState extends State<MediaUploadPage> {
//   String? posterError;
//   String? videoError;
//   VideoPlayerController? _videoController;
//   bool _isMuted = false;
//   bool _isInitialized = false;
//   final ImagePicker _picker = ImagePicker();

//   bool _isValidUrl(String url) {
//     final uri = Uri.tryParse(url);
//     return uri != null && uri.hasAbsolutePath && uri.scheme.startsWith('http');
//   }

//   bool _isVideoUrl(String url) {
//     final lower = url.toLowerCase();
//     return lower.endsWith('.mp4') ||
//         lower.endsWith('.mov') ||
//         lower.endsWith('.avi') ||
//         lower.endsWith('.mkv') ||
//         url.contains('drive.google.com');
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   // Pick single poster image - ONLY STORE LOCALLY
//   Future<void> _pickPosterImage(
//     EventFormProvider prov,
//     FormFieldState state,
//   ) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (image == null) return;

//       // Store file locally in provider (don't upload)
//       prov.setPosterImageFile(File(image.path));

//       setState(() {
//         posterError = null;
//       });

//       // Validate form field
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         state.didChange('local_file_selected');
//         state.validate();
//       });

//       debugPrint('✅ Poster image selected: ${image.path}');
//     } catch (e) {
//       debugPrint('Image picker error: $e');
//       setState(() {
//         posterError = 'Failed to pick image. Please try again.';
//       });
//     }
//   }

//   // Pick multiple gallery images - ONLY STORE LOCALLY
//   Future<void> _pickGalleryImages(EventFormProvider prov) async {
//     try {
//       final List<XFile> images = await _picker.pickMultiImage(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (images.isEmpty) return;

//       // Add files to provider
//       for (var image in images) {
//         prov.addGalleryImage(File(image.path));
//       }

//       setState(() {});
//       debugPrint('✅ ${images.length} gallery images selected');
//     } catch (e) {
//       debugPrint('Gallery picker error: $e');
//     }
//   }

//   Future<void> _initVideo(String link) async {
//     try {
//       _videoController?.dispose();
//       _videoController = null;
//       _isInitialized = false;

//       final playableLink = _convertDriveVideo(link);
//       _videoController = VideoPlayerController.networkUrl(
//         Uri.parse(playableLink),
//       );

//       await _videoController!.initialize();
//       _videoController!.setLooping(true);
//       _videoController!.setVolume(_isMuted ? 0 : 1);

//       if (mounted) setState(() => _isInitialized = true);
//     } catch (e) {
//       debugPrint('Video init error: $e');
//       if (mounted) {
//         setState(() {
//           _isInitialized = false;
//           videoError = 'Failed to load video. Please check the URL.';
//         });
//       }
//     }
//   }

//   String _convertDriveVideo(String link) {
//     if (link.contains('drive.google.com')) {
//       String? fileId;
//       if (link.contains('/d/')) {
//         fileId = link.split('/d/')[1].split('/')[0];
//       } else if (link.contains('id=')) {
//         fileId = Uri.parse(link).queryParameters['id'];
//       }
//       if (fileId != null && fileId.isNotEmpty) {
//         return 'https://drive.google.com/uc?export=download&id=$fileId';
//       }
//     }
//     return link;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<EventFormProvider>();
//     final size = MediaQuery.of(context).size;

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: widget.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // ───────────── Poster Upload ─────────────
//               FormField<String>(
//                 initialValue: prov.posterImageFile != null ? 'local_file' : '',
//                 validator: (value) {
//                   if (prov.posterImageFile == null &&
//                       prov.posterDriveLink.isEmpty) {
//                     return 'Event poster is required';
//                   }
//                   return null;
//                 },
//                 builder:
//                     (state) => _buildPosterUploader(context, size, prov, state),
//               ),

//               const SizedBox(height: 24),

//               // ───────────── Gallery Upload ─────────────
//               _buildGalleryUploader(context, size, prov),

//               const SizedBox(height: 24),

//               // ───────────── Video Upload ─────────────
//               FormField<String>(
//                 initialValue: prov.videoDriveLink,
//                 validator: (value) {
//                   if (prov.videoDriveLink.isNotEmpty &&
//                       (!_isValidUrl(prov.videoDriveLink) ||
//                           !_isVideoUrl(prov.videoDriveLink))) {
//                     return 'Invalid video URL or Google Drive link';
//                   }
//                   return null;
//                 },
//                 builder:
//                     (state) => _buildVideoUploader(context, size, prov, state),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPosterUploader(
//     BuildContext context,
//     Size size,
//     EventFormProvider prov,
//     FormFieldState state,
//   ) {
//     final hasImage =
//         prov.posterImageFile != null || prov.posterDriveLink.isNotEmpty;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Event Poster',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E1E82),
//           ),
//         ),
//         SizedBox(height: 8),
//         GestureDetector(
//           onTap: !hasImage ? () => _pickPosterImage(prov, state) : null,
//           child: Container(
//             height: (size.width * 0.85) * (3 / 2),
//             width: size.width * 0.85,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color:
//                     posterError != null || state.hasError
//                         ? Colors.red
//                         : Colors.grey.shade400,
//                 width: posterError != null || state.hasError ? 2 : 1,
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child:
//                   hasImage
//                       ? _imagePreview(prov)
//                       : _uploadPlaceholder(
//                         size,
//                         'Upload Event Poster',
//                         Icons.image,
//                         'Tap to select from gallery',
//                       ),
//             ),
//           ),
//         ),
//         if (posterError != null || state.hasError)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               posterError ?? state.errorText ?? '',
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildGalleryUploader(
//     BuildContext context,
//     Size size,
//     EventFormProvider prov,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Gallery Images (Optional)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E1E82),
//           ),
//         ),
//         SizedBox(height: 8),
//         Center(
//           child: GestureDetector(
//             onTap: () => _pickGalleryImages(prov),
//             child: Container(
//               width: size.width * 0.85,
//               padding: EdgeInsets.symmetric(vertical: 16),
//               decoration: BoxDecoration(
//                 color: Color(0xFF1E1E82).withOpacity(0.05),
//                 border: Border.all(color: Color(0xFF1E1E82), width: 1.2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Text(
//                   '+ Add Gallery Images',
//                   style: TextStyle(
//                     color: Color(0xFF1E1E82),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (prov.galleryImageFiles.isNotEmpty) ...[
//           SizedBox(height: 12),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children:
//                 prov.galleryImageFiles.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final file = entry.value;
//                   return Stack(
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           image: DecorationImage(
//                             image: FileImage(file),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 4,
//                         right: 4,
//                         child: GestureDetector(
//                           onTap: () {
//                             prov.removeGalleryImage(index);
//                             setState(() {});
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: Colors.black54,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.close,
//                               color: Colors.white,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _imagePreview(EventFormProvider prov) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         if (prov.posterImageFile != null)
//           Image.file(prov.posterImageFile!, fit: BoxFit.fill)
//         else if (prov.posterDriveLink.isNotEmpty)
//           Image.network(prov.posterDriveLink, fit: BoxFit.fill),
//         Padding(
//           padding: EdgeInsets.only(bottom: 8.0),
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black54,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: TextButton.icon(
//                 onPressed: () {
//                   prov.clearPosterImage();
//                   setState(() => posterError = null);
//                 },
//                 icon: Icon(Icons.delete, color: Colors.white, size: 16),
//                 label: Text('Remove', style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVideoUploader(
//     BuildContext context,
//     Size size,
//     EventFormProvider prov,
//     FormFieldState state,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Event Video (Optional)',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E1E82),
//           ),
//         ),
//         SizedBox(height: 8),
//         GestureDetector(
//           onTap:
//               prov.videoDriveLink.isEmpty
//                   ? () => _showLinkDialog(context, 'Video Drive Link', (
//                     link,
//                   ) async {
//                     if (!_isValidUrl(link) || !_isVideoUrl(link)) {
//                       setState(() {
//                         videoError = 'Invalid video URL or Google Drive link';
//                       });
//                     } else {
//                       setState(() => videoError = null);
//                       prov.updateField('videoDriveLink', link);
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         state.didChange(link);
//                         state.validate();
//                       });
//                       await _initVideo(link);
//                     }
//                   })
//                   : null,
//           child: Container(
//             height: (size.width * 0.85) * (3 / 2),
//             width: size.width * 0.85,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color:
//                     videoError != null || state.hasError
//                         ? Colors.red
//                         : Colors.grey.shade400,
//                 width: videoError != null || state.hasError ? 2 : 1,
//               ),
//             ),
//             child:
//                 prov.videoDriveLink.isEmpty
//                     ? _uploadPlaceholder(
//                       size,
//                       'Upload Event Video',
//                       Icons.video_library,
//                       'Google Drive or Video URL',
//                     )
//                     : _isInitialized
//                     ? _videoPlayer(size, prov, state)
//                     : Center(
//                       child: CircularProgressIndicator(
//                         color: Color(0xFF1E1E82),
//                       ),
//                     ),
//           ),
//         ),
//         if (videoError != null || state.hasError)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, top: 8),
//             child: Text(
//               videoError ?? state.errorText ?? '',
//               style: const TextStyle(color: Colors.red, fontSize: 12),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _videoPlayer(Size size, EventFormProvider prov, FormFieldState state) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: FittedBox(
//             fit: BoxFit.cover,
//             child: SizedBox(
//               width: _videoController!.value.size.width,
//               height: _videoController!.value.size.height,
//               child: VideoPlayer(_videoController!),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             _videoController!.value.isPlaying
//                 ? Icons.pause_circle
//                 : Icons.play_circle_fill,
//             size: 70,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             setState(() {
//               _videoController!.value.isPlaying
//                   ? _videoController!.pause()
//                   : _videoController!.play();
//             });
//           },
//         ),
//         Positioned(
//           top: 10,
//           right: 10,
//           child: IconButton(
//             icon: Icon(
//               _isMuted ? Icons.volume_off : Icons.volume_up,
//               color: Colors.white,
//               size: 28,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isMuted = !_isMuted;
//                 _videoController!.setVolume(_isMuted ? 0 : 1);
//               });
//             },
//           ),
//         ),
//         Positioned(
//           bottom: 10,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.black54,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TextButton.icon(
//               onPressed: () {
//                 _videoController?.dispose();
//                 _videoController = null;
//                 _isInitialized = false;
//                 prov.updateField('videoDriveLink', '');
//                 setState(() => videoError = null);
//               },
//               icon: Icon(Icons.delete, color: Colors.white, size: 16),
//               label: Text('Remove', style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _uploadPlaceholder(
//     Size size,
//     String label,
//     IconData icon,
//     String hint,
//   ) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: size.width * 0.15, color: Colors.grey.shade400),
//         SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E1E82),
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(hint, style: TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }

//   void _showLinkDialog(
//     BuildContext context,
//     String title,
//     Function(String) onSave,
//   ) {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder:
//           (ctx) => AlertDialog(
//             title: Text(title),
//             content: TextField(
//               controller: controller,
//               cursorColor: Color(0xFF1E1E82),
//               decoration: InputDecoration(
//                 hintText: 'Paste Google Drive or media URL',
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(ctx),
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(color: Color(0xFF1E1E82)),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF1E1E82),
//                 ),
//                 onPressed: () {
//                   onSave(controller.text.trim());
//                   Navigator.pop(ctx);
//                 },
//                 child: Text('Save', style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticpin_partner/constants/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

class MediaUploadPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const MediaUploadPage({required this.formKey, super.key});

  @override
  State<MediaUploadPage> createState() => _MediaUploadPageState();
}

class _MediaUploadPageState extends State<MediaUploadPage> {
  String? posterError;
  String? videoError;
  final ImagePicker _picker = ImagePicker();

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isMuted = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<EventFormProvider>(context, listen: false);

      if (prov.videoDriveLink.isNotEmpty) {
        _initializeVideoPlayer(prov.videoDriveLink);
      }
    });
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  bool _isValidDriveVideoUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('drive.google.com');
  }

  String _convertDriveVideoToDirectLink(String url) {
    try {
      if (url.contains('drive.google.com')) {
        String? fileId;

        // Extract file ID from different Google Drive URL formats
        if (url.contains('/d/')) {
          fileId = url.split('/d/')[1].split('/')[0];
        } else if (url.contains('id=')) {
          fileId = Uri.parse(url).queryParameters['id'];
        } else if (url.contains('/file/d/')) {
          fileId = url.split('/file/d/')[1].split('/')[0];
        }

        if (fileId != null && fileId.isNotEmpty) {
          // Return direct playable link
          return 'https://drive.google.com/uc?export=download&id=$fileId';
        }
      }
    } catch (e) {
      debugPrint('Error converting drive link: $e');
    }
    return url;
  }

  Future<void> _initializeVideoPlayer(String url) async {
    try {
      _videoController?.dispose();
      _videoController = null;

      setState(() {
        _isVideoInitialized = false;
        videoError = null;
      });

      final playableLink = _convertDriveVideoToDirectLink(url);

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(playableLink),
      );

      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.setVolume(_isMuted ? 0.0 : 1.0);

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      debugPrint('✅ Video initialized successfully');
    } catch (e) {
      debugPrint('❌ Video initialization error: $e');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
          videoError = 'Failed to load video. Please check the link.';
        });
      }
    }
  }

  // ✅ Optimized image picker with compression
  Future<void> _pickPosterImage(
    EventFormProvider prov,
    FormFieldState state,
  ) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      prov.setPosterImageFile(File(image.path));

      setState(() => posterError = null);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        state.didChange('local_file_selected');
        state.validate();
      });

      debugPrint('✅ Poster image selected: ${image.path}');
    } catch (e) {
      debugPrint('Image picker error: $e');
      setState(() => posterError = 'Failed to pick image. Please try again.');
    }
  }

  // ✅ Optimized gallery picker
  Future<void> _pickGalleryImages(EventFormProvider prov) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isEmpty) return;

      for (var image in images) {
        prov.addGalleryImage(File(image.path));
      }

      setState(() {});
      debugPrint('✅ ${images.length} gallery images selected');
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventFormProvider>();
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Poster upload
              FormField<String>(
                initialValue: prov.posterImageFile != null ? 'local_file' : '',
                validator: (value) {
                  if (prov.posterImageFile == null &&
                      prov.posterDriveLink.isEmpty) {
                    return 'Event poster is required';
                  }
                  return null;
                },
                builder:
                    (state) => _buildPosterUploader(context, size, prov, state),
              ),

              const SizedBox(height: 24),

              // Gallery
              _buildGalleryUploader(context, size, prov),

              const SizedBox(height: 24),

              // Video Upload
              FormField<String>(
                initialValue: prov.videoDriveLink,
                validator: (value) {
                  if (prov.videoDriveLink.isNotEmpty) {
                    if (!_isValidUrl(prov.videoDriveLink)) {
                      return 'Invalid URL';
                    }
                    if (!_isValidDriveVideoUrl(prov.videoDriveLink)) {
                      return 'Only Google Drive video links are allowed';
                    }
                  }
                  return null;
                },
                builder:
                    (state) => _buildVideoUploader(context, size, prov, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterUploader(
    BuildContext context,
    Size size,
    EventFormProvider prov,
    FormFieldState state,
  ) {
    final hasImage =
        prov.posterImageFile != null || prov.posterDriveLink.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Poster',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E82),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: !hasImage ? () => _pickPosterImage(prov, state) : null,
            child: AspectRatio(
              aspectRatio: 24.0 / 36.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        posterError != null || state.hasError
                            ? Colors.red
                            : Colors.grey.shade400,
                    width: posterError != null || state.hasError ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      hasImage
                          ? _imagePreview(prov, isPoster: true)
                          : _uploadPlaceholder(
                            size,
                            'Upload Event Poster',
                            Icons.image,
                            'Tap to select from gallery',
                          ),
                ),
              ),
            ),
          ),
        ),
        if (posterError != null || state.hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text(
              posterError ?? state.errorText ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  String getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    } catch (e) {
      debugPrint('❌ Error parsing URL: $e');
      return '';
    }
  }

  Widget _buildGalleryUploader(
    BuildContext context,
    Size size,
    EventFormProvider prov,
  ) {
    final hasGalleryImages =
        prov.galleryImageFiles.isNotEmpty || prov.galleryImageUrls.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gallery Images (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E82),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: () => _pickGalleryImages(prov),
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E82).withOpacity(0.05),
                border: Border.all(color: const Color(0xFF1E1E82), width: 1.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '+ Add Gallery Images',
                  style: TextStyle(
                    color: Color(0xFF1E1E82),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasGalleryImages) ...[
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount:
                prov.galleryImageUrls.length + prov.galleryImageFiles.length,
            itemBuilder: (context, index) {
              final isExistingUrl = index < prov.galleryImageUrls.length;

              if (isExistingUrl) {
                return _buildGalleryImageTile(
                  imageUrl: prov.galleryImageUrls[index],
                  // onDelete: () async {

                  //   bool? isDeleted = await prov.deleteImageFromStorage(
                  //     prov.galleryImageUrls[index],
                  //   );

                  //   print(" check if it is deleted $isDeleted!");

                  //   setState(() {

                  //     prov.galleryImageUrls.removeAt(index);
                  //   });
                  // },
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: const Text('Delete Image'),
                            content: const Text(
                              'This image will be permanently deleted from "Cloud" storage. Are you sure?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: blackColor),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                            ],
                          ),
                    );

                    if (confirm != null && confirm) {
                      try {
                        bool isDeleted = await prov.deleteImageFromStorage(
                          prov.galleryImageUrls[index],
                        );

                        if (isDeleted) {
                          setState(() {
                            prov.galleryImageUrls.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Image deleted successfully.'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to delete image.'),
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint('❌ Error deleting image: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error deleting image.'),
                          ),
                        );
                      }
                    }
                  },
                );
              } else {
                final fileIndex = index - prov.galleryImageUrls.length;
                return _buildGalleryImageTile(
                  imageFile: prov.galleryImageFiles[fileIndex],
                  onDelete: () {
                    prov.removeGalleryImage(fileIndex);
                    setState(() {});
                  },
                );
              }
            },
          ),
        ],
      ],
    );
  }

  Widget _buildGalleryImageTile({
    String? imageUrl,
    File? imageFile,
    required VoidCallback onDelete,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                imageFile != null
                    ? Image.file(imageFile, fit: BoxFit.cover)
                    : imageUrl != null
                    ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                            color: const Color(0xFF1E1E82),
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 24,
                          ),
                        );
                      },
                    )
                    : const SizedBox(),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePreview(EventFormProvider prov, {bool isPoster = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (prov.posterImageFile != null)
          Image.file(prov.posterImageFile!, fit: BoxFit.cover)
        else if (prov.posterDriveLink.isNotEmpty)
          Image.network(
            prov.posterDriveLink,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  color: const Color(0xFF1E1E82),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 8),
                    Text('Failed to load image'),
                  ],
                ),
              );
            },
          ),
        if (isPoster)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    prov.clearPosterImage();
                    setState(() => posterError = null);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white, size: 16),
                  label: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoUploader(
    BuildContext context,
    Size size,
    EventFormProvider prov,
    FormFieldState state,
  ) {
    // final posterWidth = size.width * 0.8;
    // final posterHeight = size.width * (2.6 / 2); // same as poster

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Video (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E82),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Only Google Drive video links are supported',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap:
                prov.videoDriveLink.isEmpty
                    ? () => _showLinkDialog(
                      context,
                      'Google Drive Video Link',
                      (link) {
                        setState(() => videoError = null);

                        if (!_isValidUrl(link)) {
                          setState(() => videoError = 'Invalid URL');
                          return;
                        }

                        if (!_isValidDriveVideoUrl(link)) {
                          setState(
                            () =>
                                videoError =
                                    'Only Google Drive video links are allowed',
                          );
                          return;
                        }

                        prov.updateField('videoDriveLink', link);
                        _initializeVideoPlayer(link);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          state.didChange(link);
                          state.validate();
                        });
                      },
                    )
                    : null,
            child: AspectRatio(
              aspectRatio: 9.0 / 16.0,
              child: Container(
                // height: posterHeight,
                // width: posterWidth,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        videoError != null || state.hasError
                            ? Colors.red
                            : Colors.grey.shade400,
                    width: videoError != null || state.hasError ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      prov.videoDriveLink.isEmpty
                          ? _uploadPlaceholder(
                            size,
                            'Add Drive Video',
                            Icons.video_library,
                            'Paste Google Drive link',
                          )
                          : _videoPlayerContainer(prov),
                ),
              ),
            ),
          ),
        ),
        if (videoError != null || state.hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text(
              videoError ?? state.errorText ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // ✅ Video Player with Play, Pause, Mute controls
  Widget _videoPlayerContainer(
    // double width,
    // double height,
    EventFormProvider prov,
  ) {
    if (!_isVideoInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Color(0xFF1E1E82)),
            SizedBox(height: 12),
            Text('Loading video...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ Video player fills container
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),

        // Play/Pause button (center)
        Center(
          child: IconButton(
            icon: Icon(
              _videoController!.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              size: 64,
              color: Colors.white.withOpacity(0.8),
            ),
            onPressed: () {
              setState(() {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                }
              });
            },
          ),
        ),

        // Mute button (top right)
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  _isMuted = !_isMuted;
                  _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
                });
              },
            ),
          ),
        ),

        // Remove button (bottom center)
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton.icon(
                onPressed: () {
                  _videoController?.dispose();
                  _videoController = null;
                  _isVideoInitialized = false;
                  prov.updateField('videoDriveLink', '');
                  setState(() => videoError = null);
                },
                icon: const Icon(Icons.delete, color: Colors.white, size: 16),
                label: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _uploadPlaceholder(
    Size size,
    String title,
    IconData icon,
    String subtitle,
  ) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: const Color(0xFF1E1E82).withOpacity(0.6)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1E82),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  void _showLinkDialog(
    BuildContext context,
    String title,
    Function(String) onSave,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Only Google Drive video links are supported',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // const Text(
                //   'Example formats:',
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 6),
                // const Text(
                //   '• https://drive.google.com/file/d/FILE_ID/view\n• https://drive.google.com/open?id=FILE_ID',
                //   style: TextStyle(fontSize: 11, color: Colors.grey),
                // ),
                // const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  cursorColor: const Color(0xFF1E1E82),
                  decoration: InputDecoration(
                    hintText: 'Paste Google Drive video URL',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(
                      Icons.link,
                      color: Color(0xFF1E1E82),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E82),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  onSave(controller.text.trim());
                  Navigator.pop(ctx);
                },
                child: const Text('Add Video'),
              ),
            ],
          ),
    );
  }
}
