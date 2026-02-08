// dining_details_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_dining/services/diningformprovider.dart';

class DiningDetailsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const DiningDetailsPage({required this.formKey, super.key});

  @override
  State<DiningDetailsPage> createState() => _DiningDetailsPageState();
}

class _DiningDetailsPageState extends State<DiningDetailsPage> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _briefDescController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _paymentUidController = TextEditingController();
  final TextEditingController _googleReviewUrlController =
      TextEditingController();
  final TextEditingController _googleRatingController = TextEditingController();
  final TextEditingController _googleTotalReviewsController =
      TextEditingController();

  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;

  @override
  void initState() {
    super.initState();
    final prov = Provider.of<DiningFormProvider>(context, listen: false);

    _descController.text = prov.description;
    _briefDescController.text = prov.briefDescription;
    _paymentUidController.text = prov.paymentUid;
    _googleReviewUrlController.text = prov.googleReviewUrl;
    _googleRatingController.text = prov.googleRating > 0
        ? prov.googleRating.toString()
        : '';
    _googleTotalReviewsController.text = prov.googleTotalReviews > 0
        ? prov.googleTotalReviews.toString()
        : '';

    // Parse existing times if available
    if (prov.openTime.isNotEmpty) {
      _parseTime(prov.openTime, true);
    }
    if (prov.closeTime.isNotEmpty) {
      _parseTime(prov.closeTime, false);
    }
  }

  void _parseTime(String timeStr, bool isOpen) {
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1].split(' ')[0]);

        if (timeStr.toLowerCase().contains('pm') && hour != 12) {
          hour += 12;
        } else if (timeStr.toLowerCase().contains('am') && hour == 12) {
          hour = 0;
        }

        if (isOpen) {
          _openTime = TimeOfDay(hour: hour, minute: minute);
        } else {
          _closeTime = TimeOfDay(hour: hour, minute: minute);
        }
      }
    } catch (e) {
      debugPrint('Error parsing time: $e');
    }
  }

  Future<void> _pickTime(bool isOpen) async {
    final initial = isOpen
        ? _openTime ?? const TimeOfDay(hour: 10, minute: 0)
        : _closeTime ?? const TimeOfDay(hour: 22, minute: 0);

    final t = await showTimePicker(context: context, initialTime: initial);
    if (t != null) {
      final formatted = t.format(context);
      final prov = context.read<DiningFormProvider>();

      setState(() {
        if (isOpen) {
          _openTime = t;
          prov.updateField('openTime', formatted);
        } else {
          _closeTime = t;
          prov.updateField('closeTime', formatted);
        }
      });
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _briefDescController.dispose();
    _facilityController.dispose();
    _paymentUidController.dispose();
    _googleReviewUrlController.dispose();
    _googleRatingController.dispose();
    _googleTotalReviewsController.dispose();
    super.dispose();
  }

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
            _buildLabel("DESCRIPTIONS"),
            const SizedBox(height: 16),

            _buildTextField(
              'Brief Description',
              _briefDescController,
              (v) => prov.updateField('briefDescription', v),
              maxLines: 2,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              'Full Description',
              _descController,
              (v) => prov.updateField('description', v),
              maxLines: 4,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            _buildLabel("TIMINGS"),
            const SizedBox(height: 16),

            _buildTimeField(
              'Opening Time',
              prov.openTime,
              () => _pickTime(true),
            ),
            const SizedBox(height: 16),
            _buildTimeField(
              'Closing Time',
              prov.closeTime,
              () => _pickTime(false),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            _buildLabel("FACILITIES"),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _facilityController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: "Add Facility",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_facilityController.text.trim().isNotEmpty) {
                      prov.addToList(
                        'facilities',
                        _facilityController.text.trim(),
                      );
                      _facilityController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E82),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (prov.facilities.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prov.facilities.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF1E1E82),
                    ),
                    title: Text(prov.facilities[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => prov.removeFromList('facilities', index),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            _buildLabel("PAYMENT & REVIEWS"),
            const SizedBox(height: 16),

            _buildTextField(
              'Payment UID',
              _paymentUidController,
              (v) => prov.updateField('paymentUid', v),
            ),

            const SizedBox(height: 16),

            _buildTextField(
              'Google Review URL',
              _googleReviewUrlController,
              (v) => prov.updateField('googleReviewUrl', v),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Rating (e.g., 4.5)',
                    _googleRatingController,
                    (v) {
                      final rating = double.tryParse(v) ?? 0.0;
                      prov.updateField('googleRating', rating);
                    },
                    keyboard: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Total Reviews',
                    _googleTotalReviewsController,
                    (v) {
                      final total = int.tryParse(v) ?? 0;
                      prov.updateField('googleTotalReviews', total);
                    },
                    keyboard: TextInputType.number,
                  ),
                ),
              ],
            ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Function(String) onChanged, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.multiline,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,

      textCapitalization: TextCapitalization.sentences,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onChanged: onChanged,
      validator: validator,

      textInputAction: TextInputAction.newline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildTimeField(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isEmpty ? 'Tap to select time' : value,
                    style: TextStyle(
                      fontSize: 16,
                      color: value.isEmpty ? Colors.grey : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.access_time, color: Color(0xFF1E1E82)),
          ],
        ),
      ),
    );
  }
}
