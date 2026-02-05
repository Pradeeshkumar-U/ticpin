// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_partner/services/storage.dart';
// import 'package:video_player/video_player.dart';
// import 'package:ticpin_partner/constants/size.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// class LegalReviewPage extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   const LegalReviewPage({required this.formKey, super.key});

//   @override
//   State<LegalReviewPage> createState() => _LegalReviewPageState();
// }

// class _LegalReviewPageState extends State<LegalReviewPage> {
//   final _nocCtl = TextEditingController();
//   bool _isAddingNoc = false;
//   VideoPlayerController? _videoController;
//   bool _isVideoInitialized = false;
//   bool _isMuted = false;

//   bool get _isFormComplete {
//     final prov = context.read<EventFormProvider>();
//     return prov.nocLinks.isNotEmpty &&
//         prov.gstNo.trim().isNotEmpty &&
//         prov.liabilityText.trim().isNotEmpty;
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _nocCtl.dispose();
//     super.dispose();
//   }

//   Future<void> _initVideo(String link) async {
//     try {
//       _videoController?.dispose();
//       _videoController = null;
//       _isVideoInitialized = false;

//       final playableLink = _convertDriveVideo(link);
//       _videoController = VideoPlayerController.networkUrl(
//         Uri.parse(playableLink),
//       );

//       await _videoController!.initialize();
//       _videoController!.setLooping(true);
//       _videoController!.setVolume(_isMuted ? 0 : 1);

//       if (mounted) {
//         setState(() => _isVideoInitialized = true);
//       }
//     } catch (e) {
//       debugPrint('Video init error: $e');
//       if (mounted) {
//         setState(() => _isVideoInitialized = false);
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

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: widget.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildLabel('LEGAL & COMPLIANCE'),
//             const SizedBox(height: 16),

//             // ───── NOC Upload Section ─────
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 250),
//               child:
//                   !_isAddingNoc
//                       ? GestureDetector(
//                         onTap: () => setState(() => _isAddingNoc = true),
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 14,
//                             horizontal: 16,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1E1E82).withOpacity(0.05),
//                             border: Border.all(
//                               color: const Color(0xFF1E1E82),
//                               width: 1.2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               '+ Add NOC/Permission Link',
//                               style: TextStyle(
//                                 color: Color(0xFF1E1E82),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                       : Row(
//                         key: const ValueKey('nocInput'),
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _nocCtl,
//                               decoration: InputDecoration(
//                                 hintText: 'Enter Drive/YouTube link',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               onSubmitted: (_) => _addNocLink(prov),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           ElevatedButton(
//                             onPressed: () => _addNocLink(prov),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF1E1E82),
//                               padding: const EdgeInsets.all(16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Icon(Icons.check, color: Colors.white),
//                           ),
//                         ],
//                       ),
//             ),
//             const SizedBox(height: 10),

//             // ───── Added NOCs as Chips ─────
//             Wrap(
//               spacing: 8,
//               runSpacing: 6,
//               children:
//                   prov.nocLinks
//                       .map(
//                         (u) => Chip(
//                           backgroundColor: Colors.grey.shade100,
//                           label: Text(
//                             u.split('/').last,
//                             style: const TextStyle(fontSize: 13),
//                           ),
//                           deleteIcon: const Icon(Icons.close, size: 18),
//                           onDeleted: () => prov.removeNocLink(u),
//                         ),
//                       )
//                       .toList(),
//             ),

//             const SizedBox(height: 24),
//             _buildTextField(
//               'GST Number',
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//               onChanged: (v) => prov.updateField('gstNo', v),
//               initialValue: prov.gstNo,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               'Liability Text',
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//               onChanged: (v) => prov.updateField('liabilityText', v),
//               initialValue: prov.liabilityText,
//               maxLines: 3,
//             ),

//             const SizedBox(height: 24),
//             const Divider(thickness: 2),
//             const SizedBox(height: 16),
//             _buildLabel('REVIEW YOUR EVENT'),
//             const SizedBox(height: 16),

//             _buildReviewItem('Event Name', prov.name),
//             _buildReviewItem(
//               'Date & Time',
//               DateFormat('MMM dd, yyyy HH:mm').format(prov.dateTime),
//             ),
//             _buildReviewItem('Category', prov.category),
//             _buildReviewItem(
//               'Venue',
//               '${prov.venueName}\n${prov.venueFullAddress}',
//             ),
//             _buildReviewItem(
//               'Organiser',
//               '${prov.organiserCompany}\n${prov.organiserContactPerson}',
//             ),
//             _buildReviewItem('Artists', prov.artistLineup.join(', ')),
//             _buildReviewItem('Tickets', '${prov.tickets.length} categories'),

//             if (prov.posterDriveLink.isNotEmpty)
//               _buildPosterPreview(prov),
//             if (prov.videoDriveLink.isNotEmpty)
//               _buildVideoPreview(prov.videoDriveLink),

//             const SizedBox(height: 30),
//             if (_isFormComplete)
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.check_circle, color: Colors.green),
//                     SizedBox(width: 8),
//                     Text(
//                       'All required fields are complete',
//                       style: TextStyle(color: Colors.green),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
// ElevatedButton(
//   onPressed: _isFormComplete ? () => _submitEvent(context, prov) : null,
//   style: ElevatedButton.styleFrom(
//     backgroundColor: Color(0xFF1E1E82),
//     disabledBackgroundColor: Colors.grey,
//     minimumSize: Size(double.infinity, 50),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//   ),
//   child: Text(
//     'Submit Event',
//     style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//   ),
// ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _addNocLink(EventFormProvider prov) {
//     final val = _nocCtl.text.trim();
//     if (val.isNotEmpty) {
//       prov.addNocLink(val);
//       _nocCtl.clear();
//       setState(() => _isAddingNoc = false);
//     } else {
//       setState(() => _isAddingNoc = false);
//     }
//   }

//   Widget _buildLabel(String text) => Text(
//     text,
//     style: const TextStyle(
//       fontSize: 14,
//       fontWeight: FontWeight.bold,
//       color: Color(0xFF1E1E82),
//       letterSpacing: 1.2,
//     ),
//   );

// String _uploadStatus = 'Creating event...';

// Future<void> _submitEvent(BuildContext context, EventFormProvider prov) async {
//   // Show loading dialog
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (ctx) => WillPopScope(
//       onWillPop: () async => false,
//       child: Center(
//         child: Card(
//           margin: EdgeInsets.all(20),
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(color: Color(0xFF1E1E82)),
//                 SizedBox(height: 16),
//                 Text(
//                   _uploadStatus,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text('Please wait...', style: TextStyle(fontSize: 12, color: Colors.grey)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );

//   final service = EventSubmissionService();
//   final eventId = await service.createEvent(
//     prov,
//     // onStatusUpdate: (status) {
//     //   setState(() => _uploadStatus = status);
//     // },
//   );

//   Navigator.pop(context); // Close loading dialog

//   if (eventId != null) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green),
//             SizedBox(width: 8),
//             Text('Success!'),
//           ],
//         ),
//         content: Text('Event created successfully!'),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E1E82)),
//             onPressed: () {
//               prov.reset();
//               Navigator.pop(ctx);
//               Navigator.pop(context);
//             },
//             child: Text('OK', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   } else {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.error, color: Colors.red),
//             SizedBox(width: 8),
//             Text('Error'),
//           ],
//         ),
//         content: Text('Failed to create event. Please try again.'),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E1E82)),
//             onPressed: () => Navigator.pop(ctx),
//             child: Text('OK', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//   Widget _buildTextField(
//     String label, {
//     required String? Function(String?) validator,
//     required Function(String) onChanged,
//     String? initialValue,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       textCapitalization: TextCapitalization.sentences,
//       initialValue: initialValue,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 12,
//         ),
//       ),
//       maxLines: maxLines,
//       onChanged: onChanged,
//       validator: validator,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//     );
//   }

//   Widget _buildReviewItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value.isEmpty ? 'Not provided' : value,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildPosterPreview(String link) {
//   //   return Padding(
//   //     padding: const EdgeInsets.only(top: 12),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         const Text(
//   //           'Poster Preview:',
//   //           style: TextStyle(
//   //             fontWeight: FontWeight.bold,
//   //             color: Color(0xFF1E1E82),
//   //           ),
//   //         ),
//   //         const SizedBox(height: 8),
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             Container(
//   //               width: Sizes().width * 0.8,
//   //               height: (Sizes().width * 0.8) * (2.6 / 2),
//   //               decoration: BoxDecoration(
//   //                 color: Colors.white,
//   //                 borderRadius: BorderRadius.circular(20),
//   //                 border: Border.all(color: Colors.grey.shade400, width: 1),
//   //                 image: DecorationImage(
//   //                   image: NetworkImage(_convertDriveLink(link)),
//   //                   fit: BoxFit.cover,
//   //                 ),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// Widget _buildPosterPreview(EventFormProvider prov) {
//   return Padding(
//     padding: const EdgeInsets.only(top: 12),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Poster Preview:',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1E82)),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: Sizes().width * 0.8,
//               height: (Sizes().width * 0.8) * (2.6 / 2),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade400, width: 1),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: prov.posterImageFile != null
//                     ? Image.file(prov.posterImageFile!, fit: BoxFit.cover)
//                     : prov.posterDriveLink.isNotEmpty
//                         ? Image.network(_convertDriveLink(prov.posterDriveLink), fit: BoxFit.cover)
//                         : Center(child: Text('No poster')),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//   Widget _buildVideoPreview(String link) {
//     // Initialize video when building preview
//     if (_videoController == null && link.isNotEmpty) {
//       _initVideo(link);
//     }

//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Video Preview:',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E1E82),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: Sizes().width * 0.8,
//                 height: (Sizes().width * 0.8) * (2.6 / 2),
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.grey.shade400, width: 1),
//                 ),
//                 child:
//                     _isVideoInitialized
//                         ? _buildVideoPlayer()
//                         : const Center(
//                           child: CircularProgressIndicator(
//                             color: Color(0xFF1E1E82),
//                           ),
//                         ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoPlayer() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: SizedBox(
//             width: Sizes().width * 0.8,
//             height: (Sizes().width * 0.8) * (2.6 / 2),
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
//       ],
//     );
//   }

//   String _convertDriveLink(String link) {
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

//   // ignore: unused_element
//   String _getVideoThumbnail(String link) {
//     if (link.contains('drive.google.com')) {
//       String? fileId;

//       if (link.contains('/d/')) {
//         fileId = link.split('/d/')[1].split('/')[0];
//       } else if (link.contains('id=')) {
//         fileId = Uri.parse(link).queryParameters['id'];
//       }

//       if (fileId != null && fileId.isNotEmpty) {
//         return 'https://drive.google.com/thumbnail?id=$fileId';
//       }
//     }
//     if (link.contains('youtube.com') || link.contains('youtu.be')) {
//       final videoId =
//           link.contains('youtu.be')
//               ? link.split('/').last
//               : Uri.parse(link).queryParameters['v'];
//       return 'https://img.youtube.com/vi/$videoId/0.jpg';
//     }
//     return '';
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:ticpin_partner/constants/size.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

class LegalReviewPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const LegalReviewPage({required this.formKey, super.key});

  @override
  State<LegalReviewPage> createState() => _LegalReviewPageState();
}

class _LegalReviewPageState extends State<LegalReviewPage> {
  final _nocCtl = TextEditingController();
  bool _isAddingNoc = false;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isMuted = false;

  bool get _isFormComplete {
    final prov = context.read<EventFormProvider>();
    return prov.nocLinks.isNotEmpty &&
        prov.gstNo.trim().isNotEmpty &&
        prov.liabilityText.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _nocCtl.dispose();
    super.dispose();
  }

  Future<void> _initVideo(String link) async {
    try {
      _videoController?.dispose();
      _videoController = null;
      _isVideoInitialized = false;

      final playableLink = _convertDriveVideo(link);
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(playableLink),
      );

      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.setVolume(_isMuted ? 0 : 1);

      if (mounted) {
        setState(() => _isVideoInitialized = true);
      }
    } catch (e) {
      debugPrint('Video init error: $e');
      if (mounted) {
        setState(() => _isVideoInitialized = false);
      }
    }
  }

  String _convertDriveVideo(String link) {
    if (link.contains('drive.google.com')) {
      String? fileId;

      if (link.contains('/d/')) {
        fileId = link.split('/d/')[1].split('/')[0];
      } else if (link.contains('id=')) {
        fileId = Uri.parse(link).queryParameters['id'];
      }

      if (fileId != null && fileId.isNotEmpty) {
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }
    return link;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventFormProvider>();

    return SingleChildScrollView(
      // padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildLabel('LEGAL & COMPLIANCE'),
                  const SizedBox(height: 16),

                  // ───── NOC Upload Section ─────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child:
                        !_isAddingNoc
                            ? GestureDetector(
                              onTap: () => setState(() => _isAddingNoc = true),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF1E1E82,
                                  ).withOpacity(0.05),
                                  border: Border.all(
                                    color: const Color(0xFF1E1E82),
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    '+ Add NOC/Permission Link',
                                    style: TextStyle(
                                      color: Color(0xFF1E1E82),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : Row(
                              key: const ValueKey('nocInput'),
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _nocCtl,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Drive/YouTube link',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onSubmitted: (_) => _addNocLink(prov),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _addNocLink(prov),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E1E82),
                                    padding: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                  ),
                  const SizedBox(height: 10),

                  // ───── Added NOCs as Chips ─────
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children:
                        prov.nocLinks
                            .map(
                              (u) => Chip(
                                backgroundColor: Colors.grey.shade100,
                                label: Text(
                                  u.split('/').last,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => prov.removeNocLink(u),
                              ),
                            )
                            .toList(),
                  ),

                  const SizedBox(height: 16),
                  _buildTextField(
                    'Liability Text',
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                    onChanged: (v) => prov.updateField('liabilityText', v),
                    initialValue: prov.liabilityText,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    'GST Number',
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                    onChanged: (v) => prov.updateField('gstNo', v),
                    initialValue: prov.gstNo,
                  ),
                  const SizedBox(height: 24),
                  const Divider(thickness: 2),
                  const SizedBox(height: 16),
                  _buildLabel('REVIEW YOUR EVENT'),
                  const SizedBox(height: 16),

                  // ✅ Basic Details
                  _buildReviewItem('Event Name', prov.name),
                  _buildReviewItem('Category', prov.category),
                  _buildReviewItem('Age Restriction', prov.ageRestriction),
                  _buildReviewItem(
                    'Ticket Required Age',
                    prov.ticketRequiredAge,
                  ),
                  _buildReviewItem('Layout', prov.layout),
                  _buildReviewItem(
                    'Languages',
                    prov.languages.isEmpty
                        ? 'Not specified'
                        : prov.languages.join(', '),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ✅ NEW: Event Days Display
                  _buildLabel('EVENT SCHEDULE'),
                  const SizedBox(height: 12),

                  if (prov.days.isEmpty)
                    _buildReviewItem('Days', 'No schedule set')
                  else
                    ...prov.days.asMap().entries.map((entry) {
                      final index = entry.key;
                      final day = entry.value;
                      final date = day['date'] as DateTime;
                      final startTime = day['startTime'] as TimeOfDay;
                      final endTime = day['endTime'] as TimeOfDay;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Day ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF1E1E82),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(date),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${_formatTimeOfDay(startTime)} - ${_formatTimeOfDay(endTime)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ✅ Venue
                  _buildLabel('VENUE'),
                  const SizedBox(height: 12),
                  _buildReviewItem('Name', prov.venueName),
                  _buildReviewItem('Address', prov.venueFullAddress),
                  if (prov.venueMapsLink.isNotEmpty)
                    _buildReviewItem('Google Maps', prov.venueMapsLink),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ✅ Organiser
                  _buildLabel('ORGANISER'),
                  const SizedBox(height: 12),
                  _buildReviewItem('Company', prov.organiserCompany),
                  _buildReviewItem(
                    'Contact Person',
                    prov.organiserContactPerson,
                  ),
                  _buildReviewItem('Phone', prov.organiserPhone),
                  _buildReviewItem('Email', prov.organiserEmail),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ✅ Artists & Promotion
                  _buildLabel('ARTISTS & PROMOTION'),
                  const SizedBox(height: 12),
                  _buildReviewItem(
                    'Artists',
                    prov.artistLineup.isEmpty
                        ? 'No artists added'
                        : prov.artistLineup.join(', '),
                  ),
                  _buildReviewItem(
                    'Hashtags',
                    prov.hashtags.isEmpty
                        ? 'No hashtags'
                        : prov.hashtags.join(', '),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ✅ Tickets
                  _buildLabel('TICKETS'),
                  const SizedBox(height: 12),
                  _buildReviewItem(
                    'Total Categories',
                    '${prov.tickets.length} ${prov.tickets.length == 1 ? 'category' : 'categories'}',
                  ),
                  if (prov.tickets.isNotEmpty)
                    ...prov.tickets.map(
                      (ticket) => Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 8),
                        child: Text(
                          '• ${ticket.type} - ₹${ticket.price}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ✅ Media Preview
                  _buildLabel('MEDIA'),
                  const SizedBox(height: 12),

                  // Poster preview
                  if (prov.posterImageFile != null ||
                      prov.posterDriveLink.isNotEmpty)
                    _buildPosterPreview(prov),
                ],
              ),
            ),

            // Gallery preview
            if (prov.galleryImageFiles.isNotEmpty ||
                prov.galleryImageUrls.isNotEmpty)
              _buildGalleryPreview(prov),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video preview
                  if (prov.videoDriveLink.isNotEmpty)
                    _buildVideoPreview(prov.videoDriveLink),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ✅ Financial Info
                  _buildLabel('FINANCIAL'),
                  const SizedBox(height: 12),
                  _buildReviewItem('Bank Account', prov.bankAccount),
                  _buildReviewItem('IFSC Code', prov.ifsc),
                  _buildReviewItem('Bank Name', prov.bankName),
                  _buildReviewItem('Account Holder', prov.accountHolder),
                  _buildReviewItem('PAN/GST', prov.panOrGst),

                  const SizedBox(height: 30),

                  // Completion status
                  if (_isFormComplete)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'All required fields are complete',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Please complete all required legal fields',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper to format TimeOfDay
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _addNocLink(EventFormProvider prov) {
    final val = _nocCtl.text.trim();
    if (val.isNotEmpty) {
      prov.addNocLink(val);
      _nocCtl.clear();
      setState(() => _isAddingNoc = false);
    } else {
      setState(() => _isAddingNoc = false);
    }
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E1E82),
      letterSpacing: 1.2,
    ),
  );

  Widget _buildTextField(
    String label, {
    required String? Function(String?) validator,
    required Function(String) onChanged,
    String? initialValue,
    int maxLines = 1,
  }) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not provided' : value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ✅ Poster preview
  Widget _buildPosterPreview(EventFormProvider prov) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Poster Preview:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E82),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: AspectRatio(
              aspectRatio: 24.0 / 36.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    prov.posterImageFile != null
                        ? Image.file(prov.posterImageFile!, fit: BoxFit.cover)
                        : prov.posterDriveLink.isNotEmpty
                        ? Image.network(
                          _convertDriveLink(prov.posterDriveLink),
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.error)),
                        )
                        : const Center(child: Text('No poster')),
              ),
            ),
            // child: Container(
            //   width: Sizes().width * 0.8,
            //   height: (Sizes().width * 0.9) * (2.6 / 2),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(color: Colors.grey.shade400, width: 1),
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(20),
            //     child:
            //         prov.posterImageFile != null
            //             ? Image.file(prov.posterImageFile!, fit: BoxFit.cover)
            //             : prov.posterDriveLink.isNotEmpty
            //             ? Image.network(
            //               _convertDriveLink(prov.posterDriveLink),
            //               fit: BoxFit.cover,
            //               errorBuilder:
            //                   (context, error, stackTrace) =>
            //                       const Center(child: Icon(Icons.error)),
            //             )
            //             : const Center(child: Text('No poster')),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  // ✅ Gallery preview
  Widget _buildGalleryPreview(EventFormProvider prov) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              'Gallery Preview:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E82),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  prov.galleryImageFiles.length + prov.galleryImageUrls.length,
              itemBuilder: (context, index) {
                if (index < prov.galleryImageFiles.length) {
                  // Show local files
                  return Padding(
                    padding:
                        (index == 0)
                            ? const EdgeInsets.only(left: 20, right: 8)
                            : (index == prov.galleryImageFiles.length - 1 &&
                                prov.galleryImageUrls.isEmpty)
                            ? EdgeInsets.only(right: 20)
                            : const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        prov.galleryImageFiles[index],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  // Show network images
                  final urlIndex = index - prov.galleryImageFiles.length;
                  return Padding(
                    padding:
                        (urlIndex == 0 && prov.galleryImageFiles.isEmpty)
                            ? const EdgeInsets.only(left: 20, right: 8)
                            : (urlIndex == prov.galleryImageUrls.length - 1)
                            ? EdgeInsets.only(right: 20)
                            : const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        prov.galleryImageUrls[urlIndex],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: 120,
                              height: 120,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.error),
                            ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Video preview
  Widget _buildVideoPreview(String link) {
    if (_videoController == null && link.isNotEmpty) {
      _initVideo(link);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Video Preview:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E82),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: Sizes().width * 0.8,
              height: (Sizes().width) * (2.6 / 2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child:
                  _isVideoInitialized
                      ? _buildVideoPlayer()
                      : const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1E1E82),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: Sizes().width * 0.8,
            height: (Sizes().width * 0.8) * (2.6 / 2),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            _videoController!.value.isPlaying
                ? Icons.pause_circle
                : Icons.play_circle_fill,
            size: 70,
            color: Colors.white,
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
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _isMuted = !_isMuted;
                _videoController!.setVolume(_isMuted ? 0 : 1);
              });
            },
          ),
        ),
      ],
    );
  }

  String _convertDriveLink(String link) {
    if (link.contains('drive.google.com')) {
      String? fileId;

      if (link.contains('/d/')) {
        fileId = link.split('/d/')[1].split('/')[0];
      } else if (link.contains('id=')) {
        fileId = Uri.parse(link).queryParameters['id'];
      }

      if (fileId != null && fileId.isNotEmpty) {
        return 'https://drive.google.com/thumbnail?id=$fileId&sz=w1000';
      }
    }
    return link;
  }
}
