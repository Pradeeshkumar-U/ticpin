import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_dining/services/diningformprovider.dart';

class DiningReviewPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const DiningReviewPage({required this.formKey, super.key});

  @override
  State<DiningReviewPage> createState() => _DiningReviewPageState();
}

class _DiningReviewPageState extends State<DiningReviewPage> {
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DiningFormProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('REVIEW YOUR DINING'),
            const SizedBox(height: 20),

            // Basic Details
            _buildReviewItem('Dining Name', prov.name),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Owner & Contact
            _buildLabel('OWNER & CONTACT'),
            const SizedBox(height: 12),
            _buildReviewItem('Owner Name', prov.ownerName),
            _buildReviewItem('Owner Address', prov.ownerAddress),
            _buildReviewItem('Contact Number', prov.contactNumber),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Descriptions
            _buildLabel('DESCRIPTIONS'),
            const SizedBox(height: 12),
            _buildReviewItem('Brief Description', prov.briefDescription),
            _buildReviewItem('Full Description', prov.description),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Timings
            _buildLabel('TIMINGS'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E82).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E1E82)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFF1E1E82),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Operating Hours',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${prov.openTime} - ${prov.closeTime}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Facilities
            _buildLabel('FACILITIES'),
            const SizedBox(height: 12),
            if (prov.facilities.isEmpty)
              _buildReviewItem('Facilities', 'No facilities added')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prov.facilities
                    .map(
                      (item) => Chip(
                        avatar: const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(0xFF1E1E82),
                        ),
                        label: Text(item),
                        backgroundColor: Colors.grey.shade100,
                      ),
                    )
                    .toList(),
              ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Filters
            _buildLabel('FILTER CATEGORIES'),
            const SizedBox(height: 12),
            if (prov.filterCategories.isEmpty)
              const Text('No categories added', style: TextStyle(fontSize: 14))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prov.filterCategories
                    .map((item) => Chip(
                          label: Text(item),
                          backgroundColor: const Color(0xFF1E1E82).withOpacity(0.1),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 16),

            _buildLabel('FILTER DISHES'),
            const SizedBox(height: 12),
            if (prov.filterDishes.isEmpty)
              const Text('No dishes added', style: TextStyle(fontSize: 14))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prov.filterDishes
                    .map((item) => Chip(
                          label: Text(item),
                          backgroundColor: const Color(0xFF1E1E82).withOpacity(0.1),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 16),

            _buildLabel('FILTER CUISINES'),
            const SizedBox(height: 12),
            if (prov.filterCuisines.isEmpty)
              const Text('No cuisines added', style: TextStyle(fontSize: 14))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prov.filterCuisines
                    .map((item) => Chip(
                          label: Text(item),
                          backgroundColor: const Color(0xFF1E1E82).withOpacity(0.1),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Payment & Reviews
            _buildLabel('PAYMENT & REVIEWS'),
            const SizedBox(height: 12),
            _buildReviewItem('Payment UID', prov.paymentUid),
            _buildReviewItem('Google Review URL', prov.googleReviewUrl),
            if (prov.googleRating > 0)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '${prov.googleRating} / 5.0',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '(${prov.googleTotalReviews} reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Images Preview
            _buildLabel('CAROUSEL IMAGES'),
            const SizedBox(height: 12),
            _buildImagePreview(
              prov.carouselImages,
              prov.existingCarouselUrls,
              'carousel',
            ),

            const SizedBox(height: 16),

            _buildLabel('MENU IMAGES'),
            const SizedBox(height: 12),
            _buildImagePreview(
              prov.menuImages,
              prov.existingMenuUrls,
              'menu',
            ),

            const SizedBox(height: 16),

            _buildLabel('ABOUT IMAGES'),
            const SizedBox(height: 12),
            _buildImagePreview(
              prov.aboutImages,
              prov.existingAboutUrls,
              'about',
            ),

            const SizedBox(height: 30),

            // Completion indicator
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
                    'Ready to submit',
                    style: TextStyle(
                      color: Colors.green,
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
    );
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

  Widget _buildImagePreview(
    List<File> newImages,
    List<String> existingUrls,
    String type,
  ) {
    final totalCount = newImages.length + existingUrls.length;

    if (totalCount == 0) {
      return Text(
        'No ${type} images added',
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total: $totalCount image${totalCount > 1 ? "s" : ""}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: totalCount,
          itemBuilder: (context, index) {
            if (index < existingUrls.length) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  existingUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              final fileIndex = index - existingUrls.length;
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  newImages[fileIndex],
                  fit: BoxFit.cover,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}