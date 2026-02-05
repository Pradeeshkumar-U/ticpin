// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// class VenueOrganizerPage extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   const VenueOrganizerPage({required this.formKey, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<EventFormProvider>();

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildLabel('VENUE'),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Venue Name',
//               (v) => prov.updateField('venueName', v),
//               initialValue: prov.venueName,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Full Address',
//               (v) => prov.updateField('venueFullAddress', v),
//               initialValue: prov.venueFullAddress,
//               maxLines: 3,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//               keyboardType: TextInputType.multiline,
//               textInputAction: TextInputAction.newline,
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Map Link',
//               (v) => prov.updateField('venueMapLink', v),
//               initialValue: prov.venueMapLink,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),

//             const SizedBox(height: 24),
//             _buildLabel('ORGANISER'),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Company Name',
//               (v) => prov.updateField('organiserCompany', v),
//               initialValue: prov.organiserCompany,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Contact Person',
//               (v) => prov.updateField('organiserContactPerson', v),
//               initialValue: prov.organiserContactPerson,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Phone',
//               (v) => prov.updateField('organiserPhone', v),
//               initialValue: prov.organiserPhone,
//               validator: (v) {
//                 if (v == null || v.trim().isEmpty) {
//                   return 'Required';
//                 }
//                 final phoneRegex = RegExp(r'^[0-9]{10,}$');
//                 if (!phoneRegex.hasMatch(v.trim())) {
//                   return 'Enter a valid phone number';
//                 }
//                 return null;
//               },
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Email',
//               (v) => prov.updateField('organiserEmail', v),
//               initialValue: prov.organiserEmail,
//               validator: (v) {
//                 if (v == null || v.trim().isEmpty) {
//                   return 'Required';
//                 }
//                 final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
//                 if (!emailRegex.hasMatch(v.trim())) {
//                   return 'Enter a valid email';
//                 }
//                 return null;
//               },
//               keyboardType: TextInputType.emailAddress,
//             ),
//           ],
//         ),
//       ),
//     );
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

//   Widget _buildTextField(
//     String label,
//     Function(String) onChanged, {
//     String? initialValue,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//     TextInputAction textInputAction = TextInputAction.done,
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
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       maxLines: maxLines,
//       onChanged: onChanged,
//       validator: validator,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_partner/pages/placepickerpage.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// class VenueOrganizerPage extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   VenueOrganizerPage({required this.formKey, super.key});

//   TextEditingController _venueController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();

//   TextEditingController _mapController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<EventFormProvider>();

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildLabel('VENUE'),
//             const SizedBox(height: 16),
//             StatefulBuilder(
//               builder: (context, setStateSB) {
//                 final hasLocation =
//                     prov.venueLat.isNotEmpty && prov.venueLng.isNotEmpty;

//                 return AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 250),
//                   child:
//                       !hasLocation
//                           ? SizedBox(
//                             key: const ValueKey("chooseMapButton"),
//                             width: double.infinity,
//                             child: OutlinedButton.icon(
//                               onPressed: () async {
//                                 final result = await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => PlacePickerPage(),
//                                   ),
//                                 );

//                                 if (result != null) {
//                                   prov.updateField(
//                                     'venueLat',
//                                     result["lat"].toString(),
//                                   );
//                                   prov.updateField(
//                                     'venueLng',
//                                     result["lng"].toString(),
//                                   );
//                                   _venueController.value = result['placeName'];
//                                   _addressController.value = result['address'];
//                                   _mapController.value = result['mapsLink'];
//                                   setStateSB(() {});
//                                 }
//                               },
//                               icon: const Icon(
//                                 Icons.location_on,
//                                 color: Color(0xFF1E1E82),
//                               ),
//                               label: const Text(
//                                 'Choose on Map',
//                                 style: TextStyle(
//                                   color: Color(0xFF1E1E82),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               style: OutlinedButton.styleFrom(
//                                 side: const BorderSide(
//                                   color: Color(0xFF1E1E82),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                             ),
//                           )
//                           :
//                           // LOCATION SAVED BOX
//                           Container(
//                             key: const ValueKey("locationSavedBox"),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 16,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                 color: const Color(0xFF1E1E82),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.check_circle,
//                                   color: Color(0xFF1E1E82),
//                                   size: 22,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 const Expanded(
//                                   child: Text(
//                                     "Location Saved",
//                                     style: TextStyle(
//                                       color: Color(0xFF1E1E82),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     prov.updateField('venueLat', "");
//                                     prov.updateField('venueLng', "");

//                                     setStateSB(() {});
//                                   },
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(
//               'Venue Name',
//               (v) => prov.updateField('venueName', v),
//               controller: _venueController,
//               initialValue: prov.venueName,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),

//             const SizedBox(height: 16),

//             _buildTextField(
//               'Full Address',
//               (v) => prov.updateField('venueFullAddress', v),
//               controller: _addressController,
//               initialValue: prov.venueFullAddress,
//               maxLines: 3,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//               keyboardType: TextInputType.multiline,
//               // textInputAction: TextInputAction.newline,
//             ),

//             const SizedBox(height: 20),
//             _buildTextField(
//               'Venue Map Link',
//               (v) => prov.updateField('venueMapsLink', v),
//               controller: _mapController,
//               initialValue: prov.venueMapsLink,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),

//             const SizedBox(height: 20),

//             //--------------------------------------
//             // 🚀 MAP PICKER BUTTON (REPLACES MAP LINK FIELD)
//             //--------------------------------------
//             // GestureDetector(
//             //   onTap: () async {
//             //     final result = await Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (_) => PlacePickerPage()),
//             //     );

//             //     if (result != null) {
//             //       prov.updateField('venueLat', result["lat"].toString());
//             //       prov.updateField('venueLng', result["lng"].toString());
//             //     }
//             //   },
//             //   child: Container(
//             //     padding: const EdgeInsets.symmetric(
//             //       horizontal: 16,
//             //       vertical: 18,
//             //     ),
//             //     decoration: BoxDecoration(
//             //       borderRadius: BorderRadius.circular(8),
//             //       border: Border.all(color: Colors.grey),
//             //     ),
//             //     child: const Text(
//             //       "Pick Location on Map",
//             //       style: TextStyle(fontSize: 16),
//             //     ),
//             //   ),
//             // ),

//             // const SizedBox(height: 10),

//             // //--------------------------
//             // // ✔ SHOW GREEN TICK IF SELECTED
//             // //--------------------------
//             // if (prov.venueLat != '' && prov.venueLng != '')
//             //   Row(
//             //     children: const [
//             //       Icon(Icons.check_circle, color: Colors.green, size: 20),
//             //       SizedBox(width: 6),
//             //       Text(
//             //         "Location selected",
//             //         style: TextStyle(fontSize: 14, color: Colors.green),
//             //       ),
//             //     ],
//             //   ),
//             //--------------------------------------
//             // 🚀 NEW MAP PICKER WITH ANIMATED UI
//             //--------------------------------------
//             // const SizedBox(height: 16),
//             _buildLabel('ORGANISER'),
//             const SizedBox(height: 16),

//             _buildTextField(
//               'Company Name',
//               (v) => prov.updateField('organiserCompany', v),
//               initialValue: prov.organiserCompany,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),

//             const SizedBox(height: 16),

//             _buildTextField(
//               'Contact Person',
//               (v) => prov.updateField('organiserContactPerson', v),
//               initialValue: prov.organiserContactPerson,
//               validator:
//                   (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//             ),

//             const SizedBox(height: 16),

//             _buildTextField(
//               'Phone',
//               (v) => prov.updateField('organiserPhone', v),
//               initialValue: prov.organiserPhone,
//               validator: (v) {
//                 if (v == null || v.trim().isEmpty) {
//                   return 'Required';
//                 }
//                 final phoneRegex = RegExp(r'^[0-9]{10,}$');
//                 if (!phoneRegex.hasMatch(v.trim())) {
//                   return 'Enter a valid phone number';
//                 }
//                 return null;
//               },
//               keyboardType: TextInputType.phone,
//             ),

//             const SizedBox(height: 16),

//             _buildTextField(
//               'Email',
//               (v) => prov.updateField('organiserEmail', v),
//               initialValue: prov.organiserEmail,
//               validator: (v) {
//                 if (v == null || v.trim().isEmpty) return 'Required';
//                 final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
//                 if (!emailRegex.hasMatch(v.trim())) {
//                   return 'Enter a valid email';
//                 }
//                 return null;
//               },
//               keyboardType: TextInputType.emailAddress,
//             ),
//           ],
//         ),
//       ),
//     );
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

//   Widget _buildTextField(
//     String label,
//     Function(String) onChanged, {
//     String? initialValue,
//     TextEditingController? controller,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextFormField(
//       initialValue: initialValue,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 12,
//         ),
//       ),
//       keyboardType: keyboardType,
//       controller: controller,
//       maxLines: maxLines,
//       onChanged: onChanged,
//       validator: validator,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_partner/pages/placepickerpage.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

class VenueOrganizerPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const VenueOrganizerPage({required this.formKey, super.key});

  @override
  State<VenueOrganizerPage> createState() => _VenueOrganizerPageState();
}

class _VenueOrganizerPageState extends State<VenueOrganizerPage> {
  // Controllers (created once)
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapController = TextEditingController();

  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Clean the address when selecting location
  String cleanAddress(String placeName, String address) {
    String cleaned = address;

    // Remove repeated placeName
    if (cleaned.startsWith(placeName)) {
      cleaned = cleaned.replaceFirst(placeName, "").trim();
      if (cleaned.startsWith(",")) cleaned = cleaned.substring(1).trim();
    }

    // Remove "India" at end
    if (cleaned.endsWith(", India")) {
      cleaned = cleaned.replaceAll(", India", "");
    } else if (cleaned.endsWith("India")) {
      cleaned = cleaned.replaceAll("India", "");
    }

    return cleaned.trim();
  }

  // @override
  // void didChangeDependencies() {
  //   final prov = Provider.of<EventFormProvider>(context, listen: false);

  //   // Sync provider → controllers
  //   _venueController.text = prov.venueName;
  //   _addressController.text = prov.venueFullAddress;
  //   _mapController.text = prov.venueMapsLink;

  //   _companyController.text = prov.organiserCompany;
  //   _contactPersonController.text = prov.organiserContactPerson;
  //   _phoneController.text = prov.organiserPhone;
  //   _emailController.text = prov.organiserEmail;

  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    super.initState();
    final prov = Provider.of<EventFormProvider>(context, listen: false);

    _venueController.text = prov.venueName;
    _addressController.text = prov.venueFullAddress;
    _mapController.text = prov.venueMapsLink;

    _companyController.text = prov.organiserCompany;
    _contactPersonController.text = prov.organiserContactPerson;
    _phoneController.text = prov.organiserPhone;
    _emailController.text = prov.organiserEmail;
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<EventFormProvider>(context, listen: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("VENUE"),
            const SizedBox(height: 16),

            StatefulBuilder(
              builder: (context, setSB) {
                final hasLocation =
                    prov.venueLat.isNotEmpty && prov.venueLng.isNotEmpty;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child:
                      !hasLocation
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

                                  _venueController.text = result['placeName'];
                                  _addressController.text = cleanedAddress;
                                  _mapController.text = result['mapsLink'];

                                  prov.updateField(
                                    'venueName',
                                    result['placeName'],
                                  );
                                  prov.updateField(
                                    'venueFullAddress',
                                    cleanedAddress,
                                  );
                                  prov.updateField(
                                    'venueMapsLink',
                                    result['mapsLink'],
                                  );

                                  setSB(() {});
                                }
                              },
                              icon: const Icon(
                                Icons.location_on,
                                color: Color(0xFF1E1E82),
                              ),
                              label: const Text(
                                "Choose on Map",
                                style: TextStyle(color: Color(0xFF1E1E82)),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF1E1E82),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          )
                          // SizedBox(
                          //                             key: const ValueKey("chooseMapButton"),
                          //                             width: double.infinity,
                          //                             child: OutlinedButton.icon(
                          //                               onPressed: () async {
                          //                                 final result = await Navigator.push(
                          //                                   context,
                          //                                   MaterialPageRoute(
                          //                                     builder: (_) => PlacePickerPage(),
                          //                                   ),
                          //                                 );
                          //                                 if (result != null) {
                          //                                   prov.updateField(
                          //                                     'venueLat',
                          //                                     result["lat"].toString(),
                          //                                   );
                          //                                   prov.updateField(
                          //                                     'venueLng',
                          //                                     result["lng"].toString(),
                          //                                   );
                          //                                   _venueController.value = result['placeName'];
                          //                                   _addressController.value = result['address'];
                          //                                   _mapController.value = result['mapsLink'];
                          //                                   setStateSB(() {});
                          //                                 }
                          //                               },
                          //                               icon: const Icon(
                          //                                 Icons.location_on,
                          //                                 color: Color(0xFF1E1E82),
                          //                               ),
                          //                               label: const Text(
                          //                                 'Choose on Map',
                          //                                 style: TextStyle(
                          //                                   color: Color(0xFF1E1E82),
                          //                                   fontWeight: FontWeight.w600,
                          //                                 ),
                          //                               ),
                          //                               style: OutlinedButton.styleFrom(
                          //                                 side: const BorderSide(
                          //                                   color: Color(0xFF1E1E82),
                          //                                 ),
                          //                                 padding: const EdgeInsets.symmetric(
                          //                                   vertical: 16,
                          //                                 ),
                          //                                 shape: RoundedRectangleBorder(
                          //                                   borderRadius: BorderRadius.circular(8),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           )
                          : Container(
                            key: const ValueKey("saved"),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFF1E1E82)),
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

            _buildTF(
              "Venue Name",
              _venueController,
              (v) => prov.updateField("venueName", v),
            ),

            const SizedBox(height: 16),

            _buildTF(
              "Full Address",
              _addressController,
              (v) => prov.updateField("venueFullAddress", v),
              maxLines: 3,
              keyboard: TextInputType.multiline,
            ),

            const SizedBox(height: 20),

            _buildTF(
              "Venue Map Link",
              _mapController,
              (v) => prov.updateField("venueMapsLink", v),
            ),

            const SizedBox(height: 20),

            _buildLabel("ORGANISER"),
            const SizedBox(height: 16),

            _buildTF(
              "Company Name",
              _companyController,
              (v) => prov.updateField("organiserCompany", v),
            ),

            const SizedBox(height: 16),

            _buildTF(
              "Contact Person",
              _contactPersonController,
              (v) => prov.updateField("organiserContactPerson", v),
            ),

            const SizedBox(height: 16),

            _buildTF(
              "Phone",
              _phoneController,
              (v) => prov.updateField("organiserPhone", v),
              keyboard: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            _buildTF(
              "Email",
              _emailController,
              (v) => prov.updateField("organiserEmail", v),
              keyboard: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String t) => Text(
    t,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E1E82),
    ),
  );

  Widget _buildTF(
    String label,
    TextEditingController c,
    Function(String) onChanged, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: c,
      textCapitalization: TextCapitalization.sentences,
      maxLines: maxLines,
      keyboardType: keyboard,

      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
