import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticpin_dining/services/diningformprovider.dart';

class DiningMediaUploadPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const DiningMediaUploadPage({required this.formKey, super.key});

  @override
  State<DiningMediaUploadPage> createState() => _DiningMediaUploadPageState();
}

class _DiningMediaUploadPageState extends State<DiningMediaUploadPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages(DiningFormProvider prov, String type) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isEmpty) return;

      for (var image in images) {
        switch (type) {
          case 'carousel':
            prov.addCarouselImage(File(image.path));
            break;
          case 'menu':
            prov.addMenuImage(File(image.path));
            break;
          case 'about':
            prov.addAboutImage(File(image.path));
            break;
        }
      }
      
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
    final prov = context.watch<DiningFormProvider>();
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CAROUSEL IMAGES
              const Text(
                'Carousel Images',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E82),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add images for the main carousel',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => _pickImages(prov, 'carousel'),
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
                        '+ Add Carousel Images',
                        style: TextStyle(
                          color: Color(0xFF1E1E82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (prov.carouselImages.isNotEmpty || prov.existingCarouselUrls.isNotEmpty)
                _buildImageSection(
                  'Carousel Images',
                  prov.carouselImages,
                  prov.existingCarouselUrls,
                  'carousel',
                ),

              const SizedBox(height: 24),
              const Divider(thickness: 1.5),
              const SizedBox(height: 24),

              // MENU IMAGES
              const Text(
                'Menu Images',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E82),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add images of your menu',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => _pickImages(prov, 'menu'),
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
                        '+ Add Menu Images',
                        style: TextStyle(
                          color: Color(0xFF1E1E82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (prov.menuImages.isNotEmpty || prov.existingMenuUrls.isNotEmpty)
                _buildImageSection(
                  'Menu Images',
                  prov.menuImages,
                  prov.existingMenuUrls,
                  'menu',
                ),

              const SizedBox(height: 24),
              const Divider(thickness: 1.5),
              const SizedBox(height: 24),

              // ABOUT IMAGES
              const Text(
                'About Images',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E82),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add images showcasing your dining',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => _pickImages(prov, 'about'),
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
                        '+ Add About Images',
                        style: TextStyle(
                          color: Color(0xFF1E1E82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (prov.aboutImages.isNotEmpty || prov.existingAboutUrls.isNotEmpty)
                _buildImageSection(
                  'About Images',
                  prov.aboutImages,
                  prov.existingAboutUrls,
                  'about',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    String title,
    List<File> newImages,
    List<String> existingUrls,
    String type,
  ) {
    final prov = context.read<DiningFormProvider>();
    final totalCount = newImages.length + existingUrls.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title ($totalCount)',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E82),
          ),
        ),
        const SizedBox(height: 12),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3.0/2.0,
          ),
          itemCount: totalCount,
          itemBuilder: (context, index) {
            final isExisting = index < existingUrls.length;
            
            if (isExisting) {
              return _buildImageTile(
                imageUrl: existingUrls[index],
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Image'),
                      content: const Text(
                        'This image will be permanently deleted. Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    existingUrls.removeAt(index);
                    setState(() {});
                  }
                },
              );
            } else {
              final fileIndex = index - existingUrls.length;
              return _buildImageTile(
                imageFile: newImages[fileIndex],
                onDelete: () {
                  switch (type) {
                    case 'carousel':
                      prov.removeCarouselImage(fileIndex);
                      break;
                    case 'menu':
                      prov.removeMenuImage(fileIndex);
                      break;
                    case 'about':
                      prov.removeAboutImage(fileIndex);
                      break;
                  }
                  setState(() {});
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildImageTile({
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
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}