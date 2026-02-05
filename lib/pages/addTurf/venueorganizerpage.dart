// turf_venue_details_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_play/pages/placepickerpage.dart';
import 'package:ticpin_play/services/turfformprovider.dart';

class TurfVenueDetailsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const TurfVenueDetailsPage({required this.formKey, super.key});

  @override
  State<TurfVenueDetailsPage> createState() => _TurfVenueDetailsPageState();
}

class _TurfVenueDetailsPageState extends State<TurfVenueDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();

  String cleanAddress(String placeName, String address) {
    String cleaned = address;

    if (cleaned.startsWith(placeName)) {
      cleaned = cleaned.replaceFirst(placeName, "").trim();
      if (cleaned.startsWith(",")) cleaned = cleaned.substring(1).trim();
    }

    if (cleaned.endsWith(", India")) {
      cleaned = cleaned.replaceAll(", India", "");
    } else if (cleaned.endsWith("India")) {
      cleaned = cleaned.replaceAll("India", "");
    }

    return cleaned.trim();
  }

  @override
  void initState() {
    super.initState();
    final prov = Provider.of<TurfFormProvider>(context, listen: false);

    _nameController.text = prov.name;
    _cityController.text = prov.city;
    _addressController.text = prov.address;
    _mapController.text = prov.mapLink;
    _contactController.text = prov.contact;
    _ownerController.text = prov.ownerName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _mapController.dispose();
    _contactController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TurfFormProvider>(context, listen: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("VENUE INFORMATION"),
            const SizedBox(height: 16),

            _buildTextField(
              'Turf Name',
              _nameController,
              (v) => prov.updateField('name', v),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              'City',
              _cityController,
              (v) => prov.updateField('city', v),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 20),

            StatefulBuilder(
              builder: (context, setSB) {
                final hasLocation =
                    prov.venueLat.isNotEmpty && prov.venueLng.isNotEmpty;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: !hasLocation
                      ? SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            key: const ValueKey("choose"),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlacePickerPage(),
                                ),
                              );

                              if (result != null) {
                                prov.updateField(
                                  'venueLat',
                                  result["lat"].toString(),
                                );
                                prov.updateField(
                                  'venueLng',
                                  result["lng"].toString(),
                                );

                                final cleanedAddress = cleanAddress(
                                  result['placeName'],
                                  result['address'],
                                );

                                _addressController.text = cleanedAddress;
                                _mapController.text = result['mapsLink'];

                                prov.updateField('address', cleanedAddress);
                                prov.updateField('mapLink', result['mapsLink']);

                                setSB(() {});
                              }
                            },
                            icon: const Icon(
                              Icons.location_on,
                              color: Color(0xFF1E1E82),
                            ),
                            label: const Text(
                              "Choose Location on Map",
                              style: TextStyle(color: Color(0xFF1E1E82)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF1E1E82)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          key: const ValueKey("saved"),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF1E1E82)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF1E1E82),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Location Saved",
                                  style: TextStyle(
                                    color: Color(0xFF1E1E82),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  prov.updateField("venueLat", "");
                                  prov.updateField("venueLng", "");
                                  setSB(() {});
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),

            const SizedBox(height: 20),

            _buildTextField(
              'Full Address',
              _addressController,
              (v) => prov.updateField('address', v),
              maxLines: 3,
              keyboard: TextInputType.multiline,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              'Google Maps Link (Optional)',
              _mapController,
              (v) => prov.updateField('mapLink', v),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            _buildLabel("OWNER & CONTACT"),
            const SizedBox(height: 16),

            _buildTextField(
              'Owner Name',
              _ownerController,
              (v) => prov.updateField('ownerName', v),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              'Contact Number',
              _contactController,
              (v) => prov.updateField('contact', v),
              keyboard: TextInputType.phone,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
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
    TextInputType keyboard = TextInputType.text,
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
