// // turf_details_page.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_play/services/turfformprovider.dart';

// class TurfDetailsPage extends StatefulWidget {
//   final GlobalKey<FormState> formKey;

//   const TurfDetailsPage({required this.formKey, super.key});

//   @override
//   State<TurfDetailsPage> createState() => _TurfDetailsPageState();
// }

// class _TurfDetailsPageState extends State<TurfDetailsPage> {
//   final TextEditingController _playgroundController = TextEditingController();
//   final TextEditingController _venueInfoController = TextEditingController();
//   final TextEditingController _amenitiesController = TextEditingController();
//   final TextEditingController _rulesController = TextEditingController();

//   @override
//   void dispose() {
//     _playgroundController.dispose();
//     _venueInfoController.dispose();
//     _amenitiesController.dispose();
//     _rulesController.dispose();
//     super.dispose();
//   }

//   void _addItem(
//     TurfFormProvider prov,
//     String listName,
//     TextEditingController controller,
//   ) {
//     final value = controller.text.trim();
//     if (value.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a value'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     prov.addToList(listName, value);
//     controller.clear();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<TurfFormProvider>();

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: widget.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Playground Types
//             _buildLabel('PLAYGROUND TYPES'),
//             const SizedBox(height: 8),
//             Text(
//               'e.g., Cricket, Football, Tennis, etc.',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 12),
//             _buildInputRow(
//               controller: _playgroundController,
//               hintText: 'Add playground type',
//               onAdd: () => _addItem(prov, 'playground', _playgroundController),
//             ),
//             const SizedBox(height: 8),
//             _buildChipList(prov.playground, (index) {
//               prov.removeFromList('playground', index);
//               setState(() {});
//             }),

//             const SizedBox(height: 24),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 24),

//             // Venue Info
//             _buildLabel('VENUE INFORMATION'),
//             const SizedBox(height: 8),
//             Text(
//               'e.g., Floodlights available, Parking space, etc.',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 12),
//             _buildInputRow(
//               controller: _venueInfoController,
//               hintText: 'Add venue info',
//               onAdd: () => _addItem(prov, 'venueInfo', _venueInfoController),
//             ),
//             const SizedBox(height: 8),
//             _buildChipList(prov.venueInfo, (index) {
//               prov.removeFromList('venueInfo', index);
//               setState(() {});
//             }),

//             const SizedBox(height: 24),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 24),

//             // Amenities
//             _buildLabel('AMENITIES'),
//             const SizedBox(height: 8),
//             Text(
//               'e.g., Changing rooms, Water facility, First aid',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 12),
//             _buildInputRow(
//               controller: _amenitiesController,
//               hintText: 'Add amenity',
//               onAdd: () => _addItem(prov, 'amenities', _amenitiesController),
//             ),
//             const SizedBox(height: 8),
//             _buildChipList(prov.amenities, (index) {
//               prov.removeFromList('amenities', index);
//               setState(() {});
//             }),

//             const SizedBox(height: 24),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 24),

//             // Venue Rules
//             _buildLabel('VENUE RULES'),
//             const SizedBox(height: 8),
//             Text(
//               'e.g., No smoking, Proper sports attire required',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 12),
//             _buildInputRow(
//               controller: _rulesController,
//               hintText: 'Add rule',
//               onAdd: () => _addItem(prov, 'venueRules', _rulesController),
//             ),
//             const SizedBox(height: 8),
//             _buildChipList(prov.venueRules, (index) {
//               prov.removeFromList('venueRules', index);
//               setState(() {});
//             }),
//             const SizedBox(height: 24),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 24),
//             _buildLabel('AVAILABLE FIELD SIZES'),
//             Padding(
//               padding: EdgeInsets.all(0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 8),
//                   Text(
//                     'Select which field sizes are available for booking',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                       fontFamily: 'Regular',
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                   // Field Size Options
//                   _buildFieldSizeOption(
//                     context,
//                     prov,
//                     '4x4',
//                     'Small field (4 vs 4 players)',
//                     Icons.grid_3x3,
//                   ),
//                   SizedBox(height: 12),
//                   _buildFieldSizeOption(
//                     context,
//                     prov,
//                     '6x6',
//                     'Large field (6 vs 6 players)',
//                     Icons.grid_4x4,
//                   ),

//                   SizedBox(height: 20),

//                   // Selected sizes display
//                   if (prov.availableFieldSizes.isNotEmpty) ...[
//                     Divider(),
//                     SizedBox(height: 12),
//                     Text(
//                       'Selected Sizes:',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Regular',
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: prov.availableFieldSizes.map((size) {
//                         return Chip(
//                           label: Text(
//                             size,
//                             style: TextStyle(
//                               fontFamily: 'Regular',
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           backgroundColor: Color(0xFF1E1E82),
//                           deleteIcon: Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                           onDeleted: () {
//                             prov.removeFieldSize(size);
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ] else ...[
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.orange.shade300),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.warning_amber,
//                             color: Colors.orange.shade700,
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               'Please select at least one field size',
//                               style: TextStyle(
//                                 color: Colors.orange.shade900,
//                                 fontFamily: 'Regular',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFieldSizeOption(
//     BuildContext context,
//     TurfFormProvider provider,
//     String size,
//     String description,
//     IconData icon,
//   ) {
//     final isSelected = provider.availableFieldSizes.contains(size);

//     return InkWell(
//       onTap: () {
//         provider.toggleFieldSize(size);
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? Color(0xFF1E1E82) : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isSelected ? Color(0xFF1E1E82) : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: Colors.white, size: 28),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     size,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Regular',
//                       color: isSelected ? Color(0xFF1E1E82) : Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontFamily: 'Regular',
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               Icon(Icons.check_circle, color: Color(0xFF1E1E82), size: 32)
//             else
//               Icon(
//                 Icons.radio_button_unchecked,
//                 color: Colors.grey.shade400,
//                 size: 32,
//               ),
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

//   Widget _buildInputRow({
//     required TextEditingController controller,
//     required String hintText,
//     required VoidCallback onAdd,
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: controller,
//             textCapitalization: TextCapitalization.sentences,
//             decoration: InputDecoration(
//               hintText: hintText,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//             onSubmitted: (_) => onAdd(),
//           ),
//         ),
//         const SizedBox(width: 8),
//         ElevatedButton(
//           onPressed: onAdd,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF1E1E82),
//             padding: const EdgeInsets.all(16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//       ],
//     );
//   }

//   Widget _buildChipList(List<String> items, Function(int) onDelete) {
//     if (items.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Text(
//           'No items added yet',
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade500,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//       );
//     }

//     return Wrap(
//       spacing: 8,
//       runSpacing: 6,
//       children: items
//           .asMap()
//           .entries
//           .map(
//             (entry) => Chip(
//               backgroundColor: Colors.grey.shade100,
//               label: Text(entry.value, style: const TextStyle(fontSize: 13)),
//               deleteIcon: const Icon(Icons.close, size: 18),
//               onDeleted: () => onDelete(entry.key),
//             ),
//           )
//           .toList(),
//     );
//   }
// }

// turf_details_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_play/services/turfformprovider.dart';

class TurfDetailsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const TurfDetailsPage({required this.formKey, super.key});

  @override
  State<TurfDetailsPage> createState() => _TurfDetailsPageState();
}

class _TurfDetailsPageState extends State<TurfDetailsPage> {
  final TextEditingController _playgroundController = TextEditingController();
  final TextEditingController _venueInfoController = TextEditingController();
  final TextEditingController _amenitiesController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();

  @override
  void dispose() {
    _playgroundController.dispose();
    _venueInfoController.dispose();
    _amenitiesController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  void _addItem(
    TurfFormProvider prov,
    String listName,
    TextEditingController controller,
  ) {
    final value = controller.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a value'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    prov.addToList(listName, value);
    controller.clear();
    setState(() {});
  }

  void _showAddGroundDialog(TurfFormProvider prov) {
    final groundNameController = TextEditingController();
    String? selectedFieldSize;
    final customFieldSizeController = TextEditingController();
    bool showCustomInput = false;

    final fieldSizes = [
      '3-a-side',
      '4-a-side',
      '5-a-side (Mini-Soccer / Futsal)',
      '6-a-side',
      '7-a-side',
      '8-a-side',
      '9-a-side',
      '10-a-side',
      '11-a-side (Full-Size / Professional)',
      'Box Cricket',
      'Mini Cricket Stadium',
      'Full-size Cricket Ground',
      'Multi-Purpose Turf (MUGA)',
      'Training Pitch',
      'Others',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(
            'Add New Ground',
            style: TextStyle(
              fontFamily: 'Regular',
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E82),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ground Name Input
                const Text(
                  'Ground Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Regular',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: groundNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'e.g., Turf 1, Play A, Court A',
                    hintStyle: TextStyle(
                      fontFamily: 'Regular',
                      color: Colors.grey.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Field Size Selection
                const Text(
                  'Field Size',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Regular',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: fieldSizes.map((size) {
                      return RadioListTile<String>(
                        title: Text(
                          size,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Regular',
                          ),
                        ),
                        value: size,
                        groupValue: selectedFieldSize,
                        activeColor: const Color(0xFF1E1E82),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedFieldSize = value;
                            showCustomInput = value == 'Others';
                            if (value != 'Others') {
                              customFieldSizeController.clear();
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

                // Custom Field Size Input
                if (showCustomInput) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: customFieldSizeController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Enter custom field size',
                      hintStyle: TextStyle(
                        fontFamily: 'Regular',
                        color: Colors.grey.shade400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'Regular', color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final groundName = groundNameController.text.trim();
                String? fieldSize = selectedFieldSize;

                if (showCustomInput) {
                  fieldSize = customFieldSizeController.text.trim();
                }

                if (groundName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a ground name'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                if (fieldSize == null ||
                    fieldSize.isEmpty ||
                    fieldSize == 'Others') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select or enter a field size'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                prov.addGround(groundName, fieldSize);
                Navigator.pop(context);
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E82),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Ground',
                style: TextStyle(fontFamily: 'Regular', color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TurfFormProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Playground Types
            _buildLabel('PLAYGROUND TYPES'),
            const SizedBox(height: 8),
            Text(
              'e.g., Cricket, Football, Tennis, etc.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            _buildInputRow(
              controller: _playgroundController,
              hintText: 'Add playground type',
              onAdd: () => _addItem(prov, 'playground', _playgroundController),
            ),
            const SizedBox(height: 8),
            _buildChipList(prov.playground, (index) {
              prov.removeFromList('playground', index);
              setState(() {});
            }),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            // Venue Info
            _buildLabel('VENUE INFORMATION'),
            const SizedBox(height: 8),
            Text(
              'e.g., Floodlights available, Parking space, etc.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            _buildInputRow(
              controller: _venueInfoController,
              hintText: 'Add venue info',
              onAdd: () => _addItem(prov, 'venueInfo', _venueInfoController),
            ),
            const SizedBox(height: 8),
            _buildChipList(prov.venueInfo, (index) {
              prov.removeFromList('venueInfo', index);
              setState(() {});
            }),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            // Amenities
            _buildLabel('AMENITIES'),
            const SizedBox(height: 8),
            Text(
              'e.g., Changing rooms, Water facility, First aid',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            _buildInputRow(
              controller: _amenitiesController,
              hintText: 'Add amenity',
              onAdd: () => _addItem(prov, 'amenities', _amenitiesController),
            ),
            const SizedBox(height: 8),
            _buildChipList(prov.amenities, (index) {
              prov.removeFromList('amenities', index);
              setState(() {});
            }),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            // Venue Rules
            _buildLabel('VENUE RULES'),
            const SizedBox(height: 8),
            Text(
              'e.g., No smoking, Proper sports attire required',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            _buildInputRow(
              controller: _rulesController,
              hintText: 'Add rule',
              onAdd: () => _addItem(prov, 'venueRules', _rulesController),
            ),
            const SizedBox(height: 8),
            _buildChipList(prov.venueRules, (index) {
              prov.removeFromList('venueRules', index);
              setState(() {});
            }),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 24),

            // Available Grounds Section
            _buildLabel('AVAILABLE GROUNDS'),
            const SizedBox(height: 8),
            Text(
              'Add all grounds/turfs available at your venue',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: 'Regular',
              ),
            ),
            const SizedBox(height: 16),

            // Add Ground Button
            OutlinedButton.icon(
              onPressed: () => _showAddGroundDialog(prov),
              icon: const Icon(Icons.add, color: Color(0xFF1E1E82)),
              label: const Text(
                'Add Ground',
                style: TextStyle(
                  color: Color(0xFF1E1E82),
                  fontFamily: 'Regular',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1E1E82), width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Grounds List
            if (prov.availableGrounds.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please add at least one ground',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prov.availableGrounds.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final ground = prov.availableGrounds[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1E1E82),
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E82),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.sports_soccer,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        ground['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular',
                          color: Color(0xFF1E1E82),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          ground['fieldSize']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Regular',
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          prov.removeGround(index);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
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

  Widget _buildInputRow({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onAdd,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onSubmitted: (_) => onAdd(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E82),
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildChipList(List<String> items, Function(int) onDelete) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No items added yet',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: items
          .asMap()
          .entries
          .map(
            (entry) => Chip(
              backgroundColor: Colors.grey.shade100,
              label: Text(entry.value, style: const TextStyle(fontSize: 13)),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => onDelete(entry.key),
            ),
          )
          .toList(),
    );
  }
}
