// turf_media_upload_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticpin_play/services/turfformprovider.dart';

class TurfMediaUploadPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const TurfMediaUploadPage({required this.formKey, super.key});

  @override
  State<TurfMediaUploadPage> createState() => _TurfMediaUploadPageState();
}

class _TurfMediaUploadPageState extends State<TurfMediaUploadPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPosterImage(TurfFormProvider prov) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        // source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isEmpty) return;

      for (var image in images) {
        prov.addPosterImage(File(image.path));
      }

      // prov.addPosterImage(File(image.path));
      setState(() {});
    } catch (e) {
      debugPrint('Image picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TurfFormProvider>();
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Turf Posters',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E82),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add high-quality images of your turf',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),

              // Add poster button
              Center(
                child: GestureDetector(
                  onTap: () => _pickPosterImage(prov),
                  child: Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E82).withOpacity(0.05),
                      border: Border.all(
                        color: const Color(0xFF1E1E82),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        '+ Add Turf Poster',
                        style: TextStyle(
                          color: Color(0xFF1E1E82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Display added posters
              if (prov.posterImages.isNotEmpty ||
                  prov.existingPosterUrls.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Added Posters (${prov.posterImages.length + prov.existingPosterUrls.length})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E82),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Grid of posters
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 3.0 / 2.0,
                          ),
                      itemCount:
                          prov.existingPosterUrls.length +
                          prov.posterImages.length,
                      itemBuilder: (context, index) {
                        final isExisting =
                            index < prov.existingPosterUrls.length;

                        if (isExisting) {
                          return _buildPosterTile(
                            imageUrl: prov.existingPosterUrls[index],
                            onDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Poster'),
                                  content: const Text(
                                    'This poster will be permanently deleted. Are you sure?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                // Will be deleted when updating
                                prov.existingPosterUrls.removeAt(index);
                                setState(() {});
                              }
                            },
                          );
                        } else {
                          final fileIndex =
                              index - prov.existingPosterUrls.length;
                          return _buildPosterTile(
                            imageFile: prov.posterImages[fileIndex],
                            onDelete: () {
                              prov.removePosterImage(fileIndex);
                              setState(() {});
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterTile({
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageFile != null
                ? Image.file(imageFile, fit: BoxFit.cover)
                : imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
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
                          size: 32,
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
