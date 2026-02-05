// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// // import 'package:ticpin_partner/constants/colors.dart';
// // import 'package:ticpin_partner/constants/size.dart';
// // import 'package:ticpin_partner/services/eventformprovider.dart';

// // class EventDetailsPage extends StatelessWidget {
// //   final GlobalKey<FormState> formKey;
// //   const EventDetailsPage({required this.formKey, super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final prov = context.watch<EventFormProvider>();

// //     return SingleChildScrollView(
// //       child: Form(
// //         key: formKey,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Padding(
// //               padding: EdgeInsets.symmetric(
// //                 horizontal: Sizes().width * 0.05,
// //                 vertical: 20,
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildLabel('EVENT DETAILS'),
// //                   const SizedBox(height: 16),

// //                   _buildTextField(
// //                     'Event Name',
// //                     (v) => prov.updateField('name', v),
// //                     initialValue: prov.name,
// //                     validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
// //                   ),

// //                   const SizedBox(height: 16),

// //                   // MULTI-DAY SWITCH
// //                   Theme(
// //                     data: Theme.of(context).copyWith(
// //                       splashColor: Colors.transparent,
// //                       highlightColor: Colors.transparent,
// //                       hoverColor: Colors.transparent,
// //                     ),
// //                     child: CheckboxListTile(
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       contentPadding: EdgeInsets.zero,
// //                       title: Text(
// //                         'Multiple Days Event',
// //                         style: TextStyle(fontSize: Sizes().width * 0.035),
// //                       ),
// //                       value: prov.isMultiDay,
// //                       onChanged: (v) =>
// //                           prov.updateField('isMultiDay', v ?? false),
// //                       controlAffinity: ListTileControlAffinity.leading,
// //                     ),
// //                   ),

// //                   const SizedBox(height: 16),

// //                   // SINGLE DAY EVENT
// //                   if (!prov.isMultiDay && prov.eventDays.isNotEmpty) ...[
// //                     _buildDateField(
// //                       context,
// //                       'Event Date',
// //                       prov.eventDays.first['start']!,
// //                       (d) => prov.updateDayTime(0, 'start', d),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildTimeField(
// //                       context,
// //                       'Start Time',
// //                       prov.eventDays.first['start']!,
// //                       (d) => prov.updateDayTime(0, 'start', d),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildTimeField(
// //                       context,
// //                       'End Time',
// //                       prov.eventDays.first['end']!,
// //                       (d) => prov.updateDayTime(0, 'end', d),
// //                     ),
// //                   ],

// //                   // MULTI-DAY EVENT
// //                   if (prov.isMultiDay) ...[
// //                     for (int i = 0; i < prov.eventDays.length; i++) ...[
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Text(
// //                             'Day ${i + 1}',
// //                             style: const TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                           if (prov.eventDays.length > 1)
// //                             IconButton(
// //                               icon: const Icon(Icons.delete, color: Colors.red),
// //                               onPressed: () => prov.removeEventDay(i),
// //                             ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 8),
// //                       _buildDateField(
// //                         context,
// //                         'Event Date',
// //                         prov.eventDays[i]['start']!,
// //                         (d) => prov.updateDayTime(i, 'start', d),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       _buildTimeField(
// //                         context,
// //                         'Start Time',
// //                         prov.eventDays[i]['start']!,
// //                         (d) => prov.updateDayTime(i, 'start', d),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       _buildTimeField(
// //                         context,
// //                         'End Time',
// //                         prov.eventDays[i]['end']!,
// //                         (d) => prov.updateDayTime(i, 'end', d),
// //                       ),
// //                       const SizedBox(height: 24),
// //                     ],

// //                     // ADD NEW DAY BUTTON
// //                     Center(
// //                       child: ElevatedButton.icon(
// //                         onPressed: prov.addEventDay,
// //                         icon: const Icon(Icons.add),
// //                         label: const Text('Add Another Day'),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: const Color(0xFF1E1E82),
// //                           foregroundColor: Colors.white,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),

// //             // DROPDOWNS
// //             Padding(
// //               padding: EdgeInsets.symmetric(horizontal: Sizes().width * 0.025),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   const SizedBox(height: 16),
// //                   _buildDropdown(
// //                     'Category',
// //                     prov.category,
// //                     ['Music', 'Comedy', 'Performance', 'Sports'],
// //                     (v) => prov.updateField('category', v!),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   _buildDropdown(
// //                     'Age Restriction',
// //                     prov.ageRestriction,
// //                     ['None', '3+', '14+', '16+', '18+', '21+'],
// //                     (v) => prov.updateField('ageRestriction', v!),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ─── UI HELPERS ───────────────────────────────────────────────

// //   Widget _buildLabel(String text) => Text(
// //         text,
// //         style: const TextStyle(
// //           fontSize: 14,
// //           fontWeight: FontWeight.bold,
// //           color: Color(0xFF1E1E82),
// //           letterSpacing: 1.2,
// //         ),
// //       );

// //   Widget _buildTextField(
// //     String label,
// //     Function(String) onChanged, {
// //     String? initialValue,
// //     String? Function(String?)? validator,
// //     int maxLines = 1,
// //   }) {
// //     return TextFormField(
// //       textCapitalization: TextCapitalization.sentences,
// //       initialValue: initialValue,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //         contentPadding:
// //             const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       ),
// //       maxLines: maxLines,
// //       onChanged: onChanged,
// //       validator: validator,
// //       autovalidateMode: AutovalidateMode.onUserInteraction,
// //     );
// //   }

// //   Widget _buildDateField(
// //     BuildContext context,
// //     String label,
// //     DateTime date,
// //     Function(DateTime) onChanged,
// //   ) {
// //     return InkWell(
// //       borderRadius: BorderRadius.circular(8),
// //       onTap: () async {
// //         final picked = await showDatePicker(
// //           context: context,
// //           initialDate: date,
// //           firstDate: DateTime.now(),
// //           lastDate: DateTime(2100),
// //         );
// //         if (picked != null) onChanged(picked);
// //       },
// //       child: InputDecorator(
// //         decoration: InputDecoration(
// //           labelText: label,
// //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //         ),
// //         child: Text(
// //           DateFormat('MMM dd, yyyy').format(date),
// //           style: const TextStyle(fontSize: 16),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTimeField(
// //     BuildContext context,
// //     String label,
// //     DateTime time,
// //     Function(DateTime) onChanged,
// //   ) {
// //     return InkWell(
// //       borderRadius: BorderRadius.circular(8),
// //       onTap: () async {
// //         final picked = await showTimePicker(
// //           context: context,
// //           initialTime: TimeOfDay.fromDateTime(time),
// //         );
// //         if (picked != null) {
// //           final newTime = DateTime(
// //             time.year,
// //             time.month,
// //             time.day,
// //             picked.hour,
// //             picked.minute,
// //           );
// //           onChanged(newTime);
// //         }
// //       },
// //       child: InputDecorator(
// //         decoration: InputDecoration(
// //           labelText: label,
// //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //         ),
// //         child: Text(
// //           DateFormat('hh:mm a').format(time),
// //           style: const TextStyle(fontSize: 16),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDropdown(
// //     String label,
// //     String value,
// //     List<String> items,
// //     Function(String?) onChanged,
// //   ) {
// //     final safeValue = items.contains(value) ? value : items.first;

// //     return Padding(
// //       padding: EdgeInsets.symmetric(
// //         horizontal: Sizes().width * 0.025,
// //         vertical: Sizes().width * 0.01,
// //       ),
// //       child: DropdownButtonFormField<String>(
// //         initialValue: safeValue,
// //         isExpanded: true,
// //         dropdownColor: whiteColor,
// //         borderRadius: const BorderRadius.all(Radius.circular(10)),
// //         decoration: InputDecoration(
// //           labelText: label,
// //           contentPadding:
// //               EdgeInsets.symmetric(horizontal: Sizes().width * 0.025),
// //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //         ),
// //         items: items
// //             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
// //             .toList(),
// //         onChanged: onChanged,
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_partner/constants/colors.dart';
// import 'package:ticpin_partner/constants/size.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// class EventDetailsPage extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   const EventDetailsPage({required this.formKey, super.key});

//   @override
//   State<EventDetailsPage> createState() => EventDetailsPageState();
// }

// class EventDetailsPageState extends State<EventDetailsPage> {
//   final _languageController = TextEditingController();
//   final _languageFocus = FocusNode();
//   bool _isAddingLanguage = false;
//   bool _showLanguageError = false;

//   @override
//   void initState() {
//     super.initState();
//     _languageController.addListener(_onLanguageChange);
//     _languageFocus.addListener(() {
//       if (!_languageFocus.hasFocus &&
//           _languageController.text.trim().isNotEmpty) {
//         _addLanguage(context);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _languageController.dispose();
//     _languageFocus.dispose();
//     super.dispose();
//   }

//   void _onLanguageChange() {
//     if (_languageController.text.trim().isNotEmpty) {
//       setState(() => _showLanguageError = false);
//     }
//   }

//   Future<void> _addLanguage(BuildContext context)async {
//     final prov = context.read<EventFormProvider>();
//     final raw = _languageController.text.trim();

//     if (raw.isNotEmpty) {
//       prov.addLanguage(raw); // <-- handles comma/newline & duplicates
//     }

//     _languageController.clear();

//     setState(() {
//       _isAddingLanguage = false;
//       _showLanguageError = false;
//     });

//     FocusScope.of(context).unfocus();
//   }

//   // Validate languages before proceeding
//   Future<bool> validateLanguages() async {
//     final prov = context.read<EventFormProvider>();

//     // Add whatever is typed in the box
//     if (_languageController.text.trim().isNotEmpty) {
//      await _addLanguage(context);
//     }

//     // Show error if list is empty
//     setState(() {
//       _showLanguageError = prov.languages.isEmpty;
//     });

//     return !_showLanguageError;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<EventFormProvider>();

//     return SingleChildScrollView(
//       child: Form(
//         key: widget.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: Sizes().width * 0.05,
//                 vertical: 20,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildLabel('EVENT DETAILS'),
//                   const SizedBox(height: 16),

//                   _buildTextField(
//                     'Event Name',
//                     (v) => prov.updateField('name', v),
//                     initialValue: prov.name,
//                     validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//                   ),

//                   const SizedBox(height: 16),

//                   // ✅ NEW: Languages Section
//                   _buildLabel('LANGUAGES'),
//                   const SizedBox(height: 8),
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 250),
//                     child:
//                         _isAddingLanguage
//                             ? Row(
//                               key: const ValueKey('languageField'),
//                               children: [
//                                 Expanded(
//                                   child: TextField(
//                                     controller: _languageController,
//                                     focusNode: _languageFocus,
//                                     autofocus: true,
//                                     decoration: InputDecoration(
//                                       hintText:
//                                           'Enter language(s) - comma separated',
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                             horizontal: 16,
//                                             vertical: 12,
//                                           ),
//                                     ),
//                                     onSubmitted: (_) => _addLanguage(context),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 ElevatedButton(
//                                   onPressed: () => _addLanguage(context),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF1E1E82),
//                                     padding: const EdgeInsets.all(16),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: const Icon(
//                                     Icons.check,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             )
//                             : SizedBox(
//                               key: const ValueKey('languageButton'),
//                               width: double.infinity,
//                               child: OutlinedButton.icon(
//                                 onPressed:
//                                     () => setState(
//                                       () => _isAddingLanguage = true,
//                                     ),
//                                 icon: const Icon(
//                                   Icons.add,
//                                   color: Color(0xFF1E1E82),
//                                 ),
//                                 label: const Text(
//                                   'Add Language',
//                                   style: TextStyle(
//                                     color: Color(0xFF1E1E82),
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 style: OutlinedButton.styleFrom(
//                                   side: const BorderSide(
//                                     color: Color(0xFF1E1E82),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 6,
//                     children:
//                         prov.languages
//                             .map(
//                               (lang) => Chip(
//                                 backgroundColor: Colors.grey.shade100,
//                                 label: Text(lang),
//                                 deleteIcon: const Icon(Icons.close, size: 18),
//                                 onDeleted: () {
//                                   prov.removeLanguage(lang);
//                                   setState(() {});
//                                 },
//                               ),
//                             )
//                             .toList(),
//                   ),
//                   if (_showLanguageError &&
//                       prov.languages.isEmpty &&
//                       _languageController.text.trim().isEmpty)
//                     const Padding(
//                       padding: EdgeInsets.only(top: 4),
//                       child: Text(
//                         'Please add or enter at least one language',
//                         style: TextStyle(color: Colors.red, fontSize: 13),
//                       ),
//                     ),

//                   const SizedBox(height: 24),

//                   // MULTI-DAY SWITCH
//                   Theme(
//                     data: Theme.of(context).copyWith(
//                       splashColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       hoverColor: Colors.transparent,
//                     ),
//                     child: CheckboxListTile(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       contentPadding: EdgeInsets.zero,
//                       title: Text(
//                         'Multiple Days Event',
//                         style: TextStyle(fontSize: Sizes().width * 0.035),
//                       ),
//                       value: prov.isMultiDay,
//                       onChanged:
//                           (v) => prov.updateField('isMultiDay', v ?? false),
//                       controlAffinity: ListTileControlAffinity.leading,
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // ✅ UPDATED: SINGLE DAY EVENT - Now includes TimeOfDay fields
//                   if (!prov.isMultiDay && prov.eventDays.isNotEmpty) ...[
//                     _buildDateField(
//                       context,
//                       'Event Date',
//                       prov.eventDays.first['start']!,
//                       (d) => prov.updateDayTime(0, 'start', d),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTimeOfDayField(
//                       context,
//                       'Start Time',
//                       prov.startTime,
//                       (t) => prov.updateField('startTime', t),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTimeOfDayField(
//                       context,
//                       'End Time',
//                       prov.endTime,
//                       (t) => prov.updateField('endTime', t),
//                     ),
//                   ],

//                   // ✅ UPDATED: MULTI-DAY EVENT - Now includes TimeOfDay for each day
//                   if (prov.isMultiDay) ...[
//                     for (int i = 0; i < prov.eventDays.length; i++) ...[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Day ${i + 1}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           if (prov.eventDays.length > 1)
//                             IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => prov.removeEventDay(i),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       _buildDateField(
//                         context,
//                         'Event Date',
//                         prov.eventDays[i]['start']!,
//                         (d) => prov.updateDayTime(i, 'start', d),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTimeOfDayField(
//                         context,
//                         'Start Time',
//                         prov.eventDays[i]['startTime'] as TimeOfDay,
//                         (t) => prov.updateDayTime(i, 'startTime', t),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTimeOfDayField(
//                         context,
//                         'End Time',
//                         prov.eventDays[i]['endTime'] as TimeOfDay,
//                         (t) => prov.updateDayTime(i, 'endTime', t),
//                       ),
//                       const SizedBox(height: 24),
//                     ],

//                     // ADD NEW DAY BUTTON
//                     Center(
//                       child: ElevatedButton.icon(
//                         onPressed: prov.addEventDay,
//                         icon: const Icon(Icons.add),
//                         label: const Text('Add Another Day'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF1E1E82),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),

//             // DROPDOWNS
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: Sizes().width * 0.025),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 16),
//                   _buildDropdown('Category', prov.category, [
//                     'Music',
//                     'Comedy',
//                     'Performance',
//                     'Sports',
//                   ], (v) => prov.updateField('category', v!)),
//                   const SizedBox(height: 16),
//                   _buildDropdown(
//                     'Age Restriction',
//                     prov.ageRestriction,
//                     ['None', '3+', '14+', '16+', '18+', '21+'],
//                     (v) => prov.updateField('ageRestriction', v!),
//                   ),
//                   const SizedBox(height: 16),
//                   // ✅ NEW: Ticket Required Age
//                   _buildDropdown(
//                     'Ticket Required Age',
//                     prov.ticketRequiredAge,
//                     [
//                       'All Ages',
//                       '5+',
//                       '12+',
//                       '16+',
//                       '18+',
//                       '21+',
//                       'Free Entry',
//                     ],
//                     (v) => prov.updateField('ticketRequiredAge', v!),
//                   ),
//                   const SizedBox(height: 16),
//                   // ✅ NEW: Layout
//                   _buildDropdown('Event Layout', prov.layout, [
//                     'Indoor',
//                     'Outdoor',
//                     'Hybrid',
//                   ], (v) => prov.updateField('layout', v!)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─── UI HELPERS ───────────────────────────────────────────────

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

//   Widget _buildDateField(
//     BuildContext context,
//     String label,
//     DateTime date,
//     Function(DateTime) onChanged,
//   ) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(8),
//       onTap: () async {
//         final picked = await showDatePicker(
//           context: context,
//           initialDate: date,
//           firstDate: DateTime.now(),
//           lastDate: DateTime(2100),
//         );
//         if (picked != null) onChanged(picked);
//       },
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: Text(
//           DateFormat('MMM dd, yyyy').format(date),
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }

//   // ✅ NEW: TimeOfDay field (replaces old time field)
//   Widget _buildTimeOfDayField(
//     BuildContext context,
//     String label,
//     TimeOfDay time,
//     Function(TimeOfDay) onChanged,
//   ) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(8),
//       onTap: () async {
//         final picked = await showTimePicker(
//           context: context,
//           initialTime: time,
//         );
//         if (picked != null) {
//           onChanged(picked);
//         }
//       },
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: Text(
//           _formatTimeOfDay(time),
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }

//   // ✅ NEW: Helper to format TimeOfDay
//   String _formatTimeOfDay(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }

//   Widget _buildDropdown(
//     String label,
//     String value,
//     List<String> items,
//     Function(String?) onChanged,
//   ) {
//     final safeValue = items.contains(value) ? value : items.first;

//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: Sizes().width * 0.025,
//         vertical: Sizes().width * 0.01,
//       ),
//       child: DropdownButtonFormField<String>(
//         value: safeValue,
//         isExpanded: true,
//         dropdownColor: whiteColor,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         decoration: InputDecoration(
//           labelText: label,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: Sizes().width * 0.025,
//           ),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         items:
//             items
//                 .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                 .toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_partner/constants/colors.dart';
import 'package:ticpin_partner/constants/size.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

class EventDetailsPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const EventDetailsPage({required this.formKey, super.key});

  @override
  State<EventDetailsPage> createState() => EventDetailsPageState();
}

class EventDetailsPageState extends State<EventDetailsPage> {
  final _languageController = TextEditingController();
  final _languageFocus = FocusNode();
  bool _isAddingLanguage = false;
  bool _showLanguageError = false;

  @override
  void initState() {
    super.initState();
    _languageController.addListener(_onLanguageChange);
    _languageFocus.addListener(() {
      if (!_languageFocus.hasFocus &&
          _languageController.text.trim().isNotEmpty) {
        _addLanguage(context);
      }
    });
  }

  @override
  void dispose() {
    _languageController.dispose();
    _languageFocus.dispose();
    super.dispose();
  }

  void _onLanguageChange() {
    if (_languageController.text.trim().isNotEmpty) {
      setState(() => _showLanguageError = false);
    }
  }

  Future<void> _addLanguage(BuildContext context) async {
    final prov = context.read<EventFormProvider>();
    final raw = _languageController.text.trim();

    if (raw.isNotEmpty) {
      prov.addLanguage(raw);
    }

    _languageController.clear();

    setState(() {
      _isAddingLanguage = false;
      _showLanguageError = false;
    });

    FocusScope.of(context).unfocus();
  }

  // Validate languages before proceeding
  bool validateLanguages() {
    final prov = context.read<EventFormProvider>();

    // Add whatever is typed in the box
    if (_languageController.text.trim().isNotEmpty) {
      _addLanguage(context);
    }

    // Show error if list is empty
    setState(() {
      _showLanguageError = prov.languages.isEmpty;
    });

    return !_showLanguageError;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventFormProvider>();

    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes().width * 0.05,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('EVENT DETAILS'),
                  const SizedBox(height: 16),

                  // Event Name
                  _buildTextField(
                    'Event Name',
                    (v) => prov.updateField('name', v),
                    initialValue: prov.name,
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),

                  const SizedBox(height: 24),

                  // ✅ Languages Section
                  _buildLabel('LANGUAGES'),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child:
                        _isAddingLanguage
                            ? Row(
                              key: const ValueKey('languageField'),
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _languageController,
                                    focusNode: _languageFocus,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Enter language(s) - comma separated',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                    ),
                                    onSubmitted: (_) => _addLanguage(context),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _addLanguage(context),
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
                            )
                            : SizedBox(
                              key: const ValueKey('languageButton'),
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed:
                                    () => setState(
                                      () => _isAddingLanguage = true,
                                    ),
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF1E1E82),
                                ),
                                label: const Text(
                                  'Add Language',
                                  style: TextStyle(
                                    color: Color(0xFF1E1E82),
                                    fontWeight: FontWeight.w600,
                                  ),
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
                            ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children:
                        prov.languages
                            .map(
                              (lang) => Chip(
                                backgroundColor: Colors.grey.shade100,
                                label: Text(lang),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () {
                                  prov.removeLanguage(lang);
                                  setState(() {});
                                },
                              ),
                            )
                            .toList(),
                  ),
                  if (_showLanguageError &&
                      prov.languages.isEmpty &&
                      _languageController.text.trim().isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Please add at least one language',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // ✅ EVENT DAYS SECTION
                  _buildLabel('EVENT SCHEDULE'),
                  const SizedBox(height: 16),

                  // Display all days
                  for (int i = 0; i < prov.days.length; i++) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Day header with delete button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Day ${i + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E82),
                                ),
                              ),
                              if (prov.days.length > 1)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () => prov.removeDay(i),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date picker
                          _buildDateField(
                            context,
                            'Event Date',
                            prov.days[i]['date'] as DateTime,
                            (d) => prov.updateDay(i, 'date', d),
                          ),
                          const SizedBox(height: 12),

                          // Start time picker
                          _buildTimeOfDayField(
                            context,
                            'Start Time',
                            prov.days[i]['startTime'] as TimeOfDay,
                            (t) => prov.updateDay(i, 'startTime', t),
                          ),
                          const SizedBox(height: 12),

                          // End time picker
                          _buildTimeOfDayField(
                            context,
                            'End Time',
                            prov.days[i]['endTime'] as TimeOfDay,
                            (t) => prov.updateDay(i, 'endTime', t),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Add another day button
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: prov.addDay,
                      icon: const Icon(Icons.add, color: Color(0xFF1E1E82)),
                      label: const Text(
                        'Add Another Day',
                        style: TextStyle(
                          color: Color(0xFF1E1E82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1E1E82)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // DROPDOWNS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes().width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('ADDITIONAL DETAILS'),
                  const SizedBox(height: 16),

                  _buildDropdown('Category', prov.category, [
                    'Music',
                    'Comedy',
                    'Performance',
                    'Sports',
                  ], (v) => prov.updateField('category', v!)),
                  const SizedBox(height: 16),

                  _buildDropdown(
                    'Age Restriction',
                    prov.ageRestriction,
                    ['None', '3+', '14+', '16+', '18+', '21+'],
                    (v) => prov.updateField('ageRestriction', v!),
                  ),
                  const SizedBox(height: 16),

                  _buildDropdown(
                    'Ticket Required Age',
                    prov.ticketRequiredAge,
                    [
                      'All Ages',
                      '5+',
                      '12+',
                      '16+',
                      '18+',
                      '21+',
                      'Free Entry',
                    ],
                    (v) => prov.updateField('ticketRequiredAge', v!),
                  ),
                  const SizedBox(height: 16),

                  _buildDropdown('Event Layout', prov.layout, [
                    'Indoor',
                    'Outdoor',
                    'Hybrid',
                  ], (v) => prov.updateField('layout', v!)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── UI HELPERS ───────────────────────────────────────────────

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
    Function(String) onChanged, {
    String? initialValue,
    String? Function(String?)? validator,
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

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime date,
    Function(DateTime) onChanged,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 18,
              color: Color(0xFF1E1E82),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('MMM dd, yyyy').format(date),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOfDayField(
    BuildContext context,
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onChanged,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: Color(0xFF1E1E82)),
            const SizedBox(width: 8),
            Text(_formatTimeOfDay(time), style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    final safeValue = items.contains(value) ? value : items.first;

    return DropdownButtonFormField<String>(
      value: safeValue,
      isExpanded: true,
      dropdownColor: whiteColor,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
