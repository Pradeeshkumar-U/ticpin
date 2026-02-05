// // // turf_review_page.dart

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:ticpin_play/services/turfformprovider.dart';

// // class TurfReviewPage extends StatefulWidget {
// //   final GlobalKey<FormState> formKey;

// //   const TurfReviewPage({required this.formKey, super.key});

// //   @override
// //   State<TurfReviewPage> createState() => _TurfReviewPageState();
// // }

// // class _TurfReviewPageState extends State<TurfReviewPage> {
// //   String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

// //   String _formatTime(TimeOfDay time) {
// //     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
// //     final minute = time.minute.toString().padLeft(2, '0');
// //     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
// //     return '$hour:$minute $period';
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final prov = context.watch<TurfFormProvider>();

// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(20),
// //       child: Form(
// //         key: widget.formKey,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _buildLabel('REVIEW YOUR TURF'),
// //             const SizedBox(height: 20),

// //             // Basic Details
// //             _buildReviewItem('Turf Name', prov.name),
// //             _buildReviewItem('City', prov.city),
// //             _buildReviewItem('Address', prov.address),
// //             if (prov.mapLink.isNotEmpty)
// //               _buildReviewItem('Google Maps', prov.mapLink),

// //             const SizedBox(height: 16),
// //             const Divider(),
// //             const SizedBox(height: 16),

// //             // Owner & Contact
// //             _buildLabel('OWNER & CONTACT'),
// //             const SizedBox(height: 12),
// //             _buildReviewItem('Owner Name', prov.ownerName),
// //             _buildReviewItem('Contact', prov.contact),

// //             const SizedBox(height: 16),
// //             const Divider(),
// //             const SizedBox(height: 16),

// //             // Playground Types
// //             _buildLabel('PLAYGROUND TYPES'),
// //             const SizedBox(height: 12),
// //             if (prov.playground.isEmpty)
// //               _buildReviewItem('Playground', 'No types added')
// //             else
// //               ...prov.playground.map(
// //                 (item) => Padding(
// //                   padding: const EdgeInsets.only(bottom: 6),
// //                   child: Row(
// //                     children: [
// //                       const Icon(
// //                         Icons.sports_soccer,
// //                         size: 16,
// //                         color: Color(0xFF1E1E82),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Text(item, style: const TextStyle(fontSize: 14)),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //             const SizedBox(height: 16),
// //             const Divider(),
// //             const SizedBox(height: 16),

// //             // Venue Info
// //             _buildLabel('VENUE INFORMATION'),
// //             const SizedBox(height: 12),
// //             if (prov.venueInfo.isEmpty)
// //               _buildReviewItem('Info', 'No information added')
// //             else
// //               ...prov.venueInfo.map(
// //                 (item) => Padding(
// //                   padding: const EdgeInsets.only(bottom: 6),
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Padding(
// //                         padding: EdgeInsets.only(top: 4),
// //                         child: Icon(
// //                           Icons.info_outline,
// //                           size: 16,
// //                           color: Color(0xFF1E1E82),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: Text(item, style: const TextStyle(fontSize: 14)),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //             const SizedBox(height: 16),
// //             const Divider(),
// //             const SizedBox(height: 16),

// //             // Amenities
// //             _buildLabel('AMENITIES'),
// //             const SizedBox(height: 12),
// //             if (prov.amenities.isEmpty)
// //               _buildReviewItem('Amenities', 'No amenities added')
// //             else
// //               Wrap(
// //                 spacing: 8,
// //                 runSpacing: 8,
// //                 children: prov.amenities
// //                     .map(
// //                       (item) => Chip(
// //                         avatar: const Icon(
// //                           Icons.check_circle,
// //                           size: 16,
// //                           color: Color(0xFF1E1E82),
// //                         ),
// //                         label: Text(item),
// //                         backgroundColor: Colors.grey.shade100,
// //                       ),
// //                     )
// //                     .toList(),
// //               ),

// //             const SizedBox(height: 16),
// //             const Divider(),
// //             const SizedBox(height: 16),

// //             // Venue Rules
// //             _buildLabel('VENUE RULES'),
// //             const SizedBox(height: 12),
// //             if (prov.venueRules.isEmpty)
// //               _buildReviewItem('Rules', 'No rules added')
// //             else
// //               ...prov.venueRules.map(
// //                 (item) => Padding(
// //                   padding: const EdgeInsets.only(bottom: 6),
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Padding(
// //                         padding: EdgeInsets.only(top: 4),
// //                         child: Icon(
// //                           Icons.rule,
// //                           size: 16,
// //                           color: Color(0xFF1E1E82),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: Text(item, style: const TextStyle(fontSize: 14)),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //             const SizedBox(height: 16),
// //             const Divider(),
// //             const SizedBox(height: 16),

// //             // Schedule
// //             _buildLabel('WEEKLY SCHEDULE'),
// //             const SizedBox(height: 12),
// //             ...prov.weeklySchedule.entries.map((entry) {
// //               final day = entry.key;
// //               final dayData = entry.value;

// //               if (!dayData.isOpen) return const SizedBox.shrink();

// //               return Container(
// //                 margin: const EdgeInsets.only(bottom: 12),
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade50,
// //                   borderRadius: BorderRadius.circular(8),
// //                   border: Border.all(color: Colors.grey.shade300),
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       _capitalize(day),
// //                       style: const TextStyle(
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.bold,
// //                         color: Color(0xFF1E1E82),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     if (dayData.shifts.isEmpty)
// //                       const Text(
// //                         'No time slots',
// //                         style: TextStyle(fontSize: 13, color: Colors.grey),
// //                       )
// //                     else
// //                       ...dayData.shifts.map(
// //                         (shift) => Padding(
// //                           padding: const EdgeInsets.only(bottom: 4),
// //                           child: Row(
// //                             children: [
// //                               const Icon(
// //                                 Icons.access_time,
// //                                 size: 14,
// //                                 color: Colors.grey,
// //                               ),
// //                               const SizedBox(width: 6),
// //                               Text(
// //                                 '${_formatTime(shift.start)} - ${_formatTime(shift.end)}',
// //                                 style: const TextStyle(fontSize: 13),
// //                               ),
// //                               const Spacer(),
// //                               Text(
// //                                 '₹${shift.price}',
// //                                 style: const TextStyle(
// //                                   fontSize: 13,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Color(0xFF1E1E82),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 ),
// //               );
// //             }).toList(),

// //             const SizedBox(height: 16),
// //             const Divider(),
// //             const SizedBox(height: 16),

// //             // Posters Preview
// //             _buildLabel('TURF POSTERS'),
// //             const SizedBox(height: 12),
// //             if (prov.posterImages.isEmpty && prov.existingPosterUrls.isEmpty)
// //               _buildReviewItem('Posters', 'No posters added')
// //             else
// //               GridView.builder(
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                   crossAxisCount: 1,
// //                   crossAxisSpacing: 12,
// //                   mainAxisSpacing: 12,
// //                   childAspectRatio: 3.0 / 2.0,
// //                 ),
// //                 itemCount:
// //                     prov.existingPosterUrls.length + prov.posterImages.length,
// //                 itemBuilder: (context, index) {
// //                   if (index < prov.existingPosterUrls.length) {
// //                     return ClipRRect(
// //                       borderRadius: BorderRadius.circular(12),
// //                       child: Image.network(
// //                         prov.existingPosterUrls[index],
// //                         fit: BoxFit.cover,
// //                         errorBuilder: (context, error, stackTrace) {
// //                           return Container(
// //                             color: Colors.grey.shade300,
// //                             child: const Center(
// //                               child: Icon(
// //                                 Icons.error_outline,
// //                                 color: Colors.red,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     );
// //                   } else {
// //                     final fileIndex = index - prov.existingPosterUrls.length;
// //                     return ClipRRect(
// //                       borderRadius: BorderRadius.circular(12),
// //                       child: Image.file(
// //                         prov.posterImages[fileIndex],
// //                         fit: BoxFit.cover,
// //                       ),
// //                     );
// //                   }
// //                 },
// //               ),

// //             const SizedBox(height: 30),

// //             // Completion indicator
// //             Container(
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: Colors.green.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: const Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.check_circle, color: Colors.green),
// //                   SizedBox(width: 8),
// //                   Text(
// //                     'Ready to submit',
// //                     style: TextStyle(
// //                       color: Colors.green,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 30),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildLabel(String text) => Text(
// //     text,
// //     style: const TextStyle(
// //       fontSize: 14,
// //       fontWeight: FontWeight.bold,
// //       color: Color(0xFF1E1E82),
// //       letterSpacing: 1.2,
// //     ),
// //   );

// //   Widget _buildReviewItem(String label, String value) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 12),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               fontSize: 12,
// //               color: Colors.grey,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             value.isEmpty ? 'Not provided' : value,
// //             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // turf_review_page.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_play/services/turfformprovider.dart';

// class TurfReviewPage extends StatefulWidget {
//   final GlobalKey<FormState> formKey;

//   const TurfReviewPage({required this.formKey, super.key});

//   @override
//   State<TurfReviewPage> createState() => _TurfReviewPageState();
// }

// class _TurfReviewPageState extends State<TurfReviewPage> {
//   String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
//             _buildLabel('REVIEW YOUR TURF'),
//             const SizedBox(height: 20),

//             // Basic Details
//             _buildReviewItem('Turf Name', prov.name),
//             _buildReviewItem('City', prov.city),
//             _buildReviewItem('Address', prov.address),
//             if (prov.mapLink.isNotEmpty)
//               _buildReviewItem('Google Maps', prov.mapLink),

//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 16),

//             // Owner & Contact
//             _buildLabel('OWNER & CONTACT'),
//             const SizedBox(height: 12),
//             _buildReviewItem('Owner Name', prov.ownerName),
//             _buildReviewItem('Contact', prov.contact),

//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 16),

//             // Playground Types
//             _buildLabel('PLAYGROUND TYPES'),
//             const SizedBox(height: 12),
//             if (prov.playground.isEmpty)
//               _buildReviewItem('Playground', 'No types added')
//             else
//               ...prov.playground.map(
//                 (item) => Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.sports_soccer,
//                         size: 16,
//                         color: Color(0xFF1E1E82),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(item, style: const TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 16),

//             // Venue Info
//             _buildLabel('VENUE INFORMATION'),
//             const SizedBox(height: 12),
//             if (prov.venueInfo.isEmpty)
//               _buildReviewItem('Info', 'No information added')
//             else
//               ...prov.venueInfo.map(
//                 (item) => Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.only(top: 4),
//                         child: Icon(
//                           Icons.info_outline,
//                           size: 16,
//                           color: Color(0xFF1E1E82),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(item, style: const TextStyle(fontSize: 14)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 16),

//             // Amenities
//             _buildLabel('AMENITIES'),
//             const SizedBox(height: 12),
//             if (prov.amenities.isEmpty)
//               _buildReviewItem('Amenities', 'No amenities added')
//             else
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: prov.amenities
//                     .map(
//                       (item) => Chip(
//                         avatar: const Icon(
//                           Icons.check_circle,
//                           size: 16,
//                           color: Color(0xFF1E1E82),
//                         ),
//                         label: Text(item),
//                         backgroundColor: Colors.grey.shade100,
//                       ),
//                     )
//                     .toList(),
//               ),

//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 16),

//             // Venue Rules
//             _buildLabel('VENUE RULES'),
//             const SizedBox(height: 12),
//             if (prov.venueRules.isEmpty)
//               _buildReviewItem('Rules', 'No rules added')
//             else
//               ...prov.venueRules.map(
//                 (item) => Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.only(top: 4),
//                         child: Icon(
//                           Icons.rule,
//                           size: 16,
//                           color: Color(0xFF1E1E82),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(item, style: const TextStyle(fontSize: 14)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 16),

//             // Pricing & Schedule
//             _buildLabel('PRICING & SCHEDULE'),
//             const SizedBox(height: 12),

//             // Price per half hour
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E1E82).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: const Color(0xFF1E1E82)),
//               ),
//               child: Row(
//                 children: [
//                   // const Icon(
//                   //   Icons.currency_rupee,
//                   //   color: Color(0xFF1E1E82),
//                   //   size: 24,
//                   // ),
//                   // const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Price per Half Hour',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '₹${prov.halfHourPrice.toStringAsFixed(0)}',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1E1E82),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Available Days
//             _buildLabel('AVAILABLE DAYS'),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: prov.weeklySchedule.entries.map((entry) {
//                 final day = entry.key;
//                 final dayData = entry.value;

//                 return Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: dayData.isOpen
//                         ? const Color(0xFF1E1E82)
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     _capitalize(day),
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: dayData.isOpen
//                           ? Colors.white
//                           : Colors.grey.shade600,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),

//             const SizedBox(height: 16),

//             // Closed Days Info (if any)
//             Builder(
//               builder: (context) {
//                 final closedDays = prov.weeklySchedule.entries
//                     .where((e) => !e.value.isOpen)
//                     .map((e) => _capitalize(e.key))
//                     .toList();

//                 if (closedDays.isEmpty) {
//                   return Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.green.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.green.shade200),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.check_circle,
//                           color: Colors.green.shade700,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 12),
//                         const Expanded(
//                           child: Text(
//                             'Open all days',
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.orange.shade200),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         Icons.event_busy,
//                         color: Colors.orange.shade700,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Closed on: ${closedDays.join(", ")}',
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 16),

//             // Posters Preview
//             _buildLabel('TURF POSTERS'),
//             const SizedBox(height: 12),
//             if (prov.posterImages.isEmpty && prov.existingPosterUrls.isEmpty)
//               _buildReviewItem('Posters', 'No posters added')
//             else
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 1,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 3.0 / 2.0,
//                 ),
//                 itemCount:
//                     prov.existingPosterUrls.length + prov.posterImages.length,
//                 itemBuilder: (context, index) {
//                   if (index < prov.existingPosterUrls.length) {
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         prov.existingPosterUrls[index],
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             color: Colors.grey.shade300,
//                             child: const Center(
//                               child: Icon(
//                                 Icons.error_outline,
//                                 color: Colors.red,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   } else {
//                     final fileIndex = index - prov.existingPosterUrls.length;
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.file(
//                         prov.posterImages[fileIndex],
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   }
//                 },
//               ),

//             const SizedBox(height: 30),

//             // Completion indicator
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.green),
//                   SizedBox(width: 8),
//                   Text(
//                     'Ready to submit',
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),
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
// }

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_play/services/turfformprovider.dart' hide TurfDay;

// ─────────────────────────────────────────────────────────────
// Assumes TurfDay and TurfFormProvider are defined in TurfFormProvider.dart
// ─────────────────────────────────────────────────────────────

class TurfReviewPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const TurfReviewPage({required this.formKey, super.key});

  @override
  State<TurfReviewPage> createState() => _TurfReviewPageState();
}

class _TurfReviewPageState extends State<TurfReviewPage> {
  // Ordered list so the review always prints Mon→Sun
  static const List<String> _dayOrder = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
            _buildLabel('REVIEW YOUR TURF'),
            const SizedBox(height: 20),

            // ── Basic Details ──
            _buildReviewItem('Turf Name', prov.name),
            _buildReviewItem('City', prov.city),
            _buildReviewItem('Address', prov.address),
            if (prov.mapLink.isNotEmpty)
              _buildReviewItem('Google Maps', prov.mapLink),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // ── Owner & Contact ──
            _buildLabel('OWNER & CONTACT'),
            const SizedBox(height: 12),
            _buildReviewItem('Owner Name', prov.ownerName),
            _buildReviewItem('Contact', prov.contact),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // ── Grounds ──
            _buildLabel('AVAILABLE GROUNDS'),
            const SizedBox(height: 12),
            if (prov.availableGrounds.isEmpty)
              _buildReviewItem('Grounds', 'No grounds added')
            else
              ...prov.availableGrounds.map(
                (g) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sports_soccer,
                        size: 16,
                        color: Color(0xFF1E1E82),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${g['name']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E82).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${g['fieldSize']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1E1E82),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // ── Playground ──
            _buildLabel('PLAYGROUND TYPES'),
            const SizedBox(height: 12),
            if (prov.playground.isEmpty)
              _buildReviewItem('Playground', 'No types added')
            else
              ...prov.playground.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sports_soccer,
                        size: 16,
                        color: Color(0xFF1E1E82),
                      ),
                      const SizedBox(width: 8),
                      Text(item, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // ── Venue Info ──
            _buildLabel('VENUE INFORMATION'),
            const SizedBox(height: 12),
            if (prov.venueInfo.isEmpty)
              _buildReviewItem('Info', 'No information added')
            else
              ...prov.venueInfo.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Color(0xFF1E1E82),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(item, style: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // ── Amenities ──
            _buildLabel('AMENITIES'),
            const SizedBox(height: 12),
            if (prov.amenities.isEmpty)
              _buildReviewItem('Amenities', 'No amenities added')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prov.amenities
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

            // ── Venue Rules ──
            _buildLabel('VENUE RULES'),
            const SizedBox(height: 12),
            if (prov.venueRules.isEmpty)
              _buildReviewItem('Rules', 'No rules added')
            else
              ...prov.venueRules.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.rule,
                          size: 16,
                          color: Color(0xFF1E1E82),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(item, style: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // ══════════════════════════════════════════
            // PRICING & SCHEDULE  (redesigned)
            // ══════════════════════════════════════════
            _buildLabel('PRICING'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E82).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E1E82)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price per Half Hour',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${prov.halfHourPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E82),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _buildLabel('WEEKLY SCHEDULE'),
            const SizedBox(height: 12),

            // ── Per-day schedule cards ──
            ..._dayOrder.map((day) {
              final td = prov.weeklySchedule[day];
              if (td == null) return const SizedBox();

              final isOpen = td.isOpen;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isOpen
                        ? const Color(0xFF1E1E82)
                        : Colors.grey.shade300,
                    width: isOpen ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Day name
                      Row(
                        children: [
                          // Colored circle indicator
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: isOpen
                                  ? Colors.green.shade400
                                  : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _capitalize(day),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isOpen
                                  ? const Color(0xFF1E1E82)
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),

                      // Time range or "Holiday"
                      isOpen
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 15,
                                  color: Color(0xFF3636B8),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${formatTime(td.startTime)} – ${formatTime(td.endTime)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Medium',
                                    color: Color(0xFF1E1E82),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'Holiday',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 16),

            // ── Open / Closed summary box ──
            Builder(
              builder: (context) {
                final closedDays = _dayOrder
                    .where((d) => prov.weeklySchedule[d]?.isOpen == false)
                    .map((d) => _capitalize(d))
                    .toList();

                if (closedDays.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Open all 7 days',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.event_busy,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Closed on: ${closedDays.join(", ")}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // ── Posters ──
            _buildLabel('TURF POSTERS'),
            const SizedBox(height: 12),
            if (prov.posterImages.isEmpty && prov.existingPosterUrls.isEmpty)
              _buildReviewItem('Posters', 'No posters added')
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3.0 / 2.0,
                ),
                itemCount:
                    prov.existingPosterUrls.length + prov.posterImages.length,
                itemBuilder: (context, index) {
                  if (index < prov.existingPosterUrls.length) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        prov.existingPosterUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.error_outline, color: Colors.red),
                          ),
                        ),
                      ),
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      prov.posterImages[index - prov.existingPosterUrls.length],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),

            const SizedBox(height: 30),

            // ── Ready badge ──
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
}
