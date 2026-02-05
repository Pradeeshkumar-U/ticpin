// // // turf_schedule_page.dart

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:ticpin_play/services/turfformprovider.dart';

// // class TurfSchedulePage extends StatefulWidget {
// //   final GlobalKey<FormState> formKey;

// //   const TurfSchedulePage({required this.formKey, super.key});

// //   @override
// //   State<TurfSchedulePage> createState() => _TurfSchedulePageState();
// // }

// // class _TurfSchedulePageState extends State<TurfSchedulePage> {
// //   final List<String> _days = [
// //     'monday',
// //     'tuesday',
// //     'wednesday',
// //     'thursday',
// //     'friday',
// //     'saturday',
// //     'sunday',
// //   ];

// //   String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

// //   Future<TimeOfDay?> _selectTime(BuildContext context, TimeOfDay initial) async {
// //     return await showTimePicker(
// //       context: context,
// //       initialTime: initial,
// //       builder: (context, child) {
// //         return Theme(
// //           data: Theme.of(context).copyWith(
// //             colorScheme: const ColorScheme.light(
// //               primary: Color(0xFF1E1E82),
// //             ),
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //   }

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
// //             const Text(
// //               'WEEKLY SCHEDULE',
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color(0xFF1E1E82),
// //                 letterSpacing: 1.2,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Set available time slots for each day',
// //               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
// //             ),
// //             const SizedBox(height: 20),

// //             ..._days.map((day) {
// //               final dayData = prov.weeklySchedule[day]!;

// //               return Container(
// //                 margin: const EdgeInsets.only(bottom: 16),
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.grey.shade300),
// //                   borderRadius: BorderRadius.circular(12),
// //                   color: dayData.isOpen ? Colors.white : Colors.grey.shade50,
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     // Day Header
// //                     Container(
// //                       decoration: BoxDecoration(
// //                         color: dayData.isOpen
// //                             ? const Color(0xFF1E1E82).withOpacity(0.1)
// //                             : Colors.grey.shade100,
// //                         borderRadius: const BorderRadius.only(
// //                           topLeft: Radius.circular(12),
// //                           topRight: Radius.circular(12),
// //                         ),
// //                       ),
// //                       child: ListTile(
// //                         title: Text(
// //                           _capitalize(day),
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             color: dayData.isOpen
// //                                 ? const Color(0xFF1E1E82)
// //                                 : Colors.grey.shade600,
// //                           ),
// //                         ),
// //                         trailing: Switch(
// //                           value: dayData.isOpen,
// //                           onChanged: (val) {
// //                             prov.toggleDay(day, val);
// //                             setState(() {});
// //                           },
// //                           activeColor: const Color(0xFF1E1E82),
// //                         ),
// //                       ),
// //                     ),

// //                     // Shifts
// //                     if (dayData.isOpen) ...[
// //                       if (dayData.shifts.isEmpty)
// //                         Padding(
// //                           padding: const EdgeInsets.all(16),
// //                           child: Text(
// //                             'No time slots added',
// //                             style: TextStyle(
// //                               color: Colors.grey.shade500,
// //                               fontStyle: FontStyle.italic,
// //                             ),
// //                           ),
// //                         )
// //                       else
// //                         ...dayData.shifts.asMap().entries.map((entry) {
// //                           final index = entry.key;
// //                           final shift = entry.value;

// //                           return Container(
// //                             margin: const EdgeInsets.symmetric(
// //                               horizontal: 12,
// //                               vertical: 8,
// //                             ),
// //                             padding: const EdgeInsets.all(12),
// //                             decoration: BoxDecoration(
// //                               color: Colors.grey.shade50,
// //                               borderRadius: BorderRadius.circular(8),
// //                               border: Border.all(color: Colors.grey.shade300),
// //                             ),
// //                             child: Column(
// //                               children: [
// //                                 Row(
// //                                   children: [
// //                                     Expanded(
// //                                       child: OutlinedButton.icon(
// //                                         onPressed: () async {
// //                                           final time = await _selectTime(
// //                                             context,
// //                                             shift.start,
// //                                           );
// //                                           if (time != null) {
// //                                             prov.updateShift(
// //                                               day,
// //                                               index,
// //                                               start: time,
// //                                             );
// //                                           }
// //                                         },
// //                                         icon: const Icon(Icons.access_time,
// //                                             size: 16),
// //                                         label: Text(
// //                                           _formatTime(shift.start),
// //                                           style: const TextStyle(fontSize: 13),
// //                                         ),
// //                                         style: OutlinedButton.styleFrom(
// //                                           foregroundColor:
// //                                               const Color(0xFF1E1E82),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     const Padding(
// //                                       padding:
// //                                           EdgeInsets.symmetric(horizontal: 8),
// //                                       child: Icon(Icons.arrow_forward, size: 16),
// //                                     ),
// //                                     Expanded(
// //                                       child: OutlinedButton.icon(
// //                                         onPressed: () async {
// //                                           final time = await _selectTime(
// //                                             context,
// //                                             shift.end,
// //                                           );
// //                                           if (time != null) {
// //                                             prov.updateShift(
// //                                               day,
// //                                               index,
// //                                               end: time,
// //                                             );
// //                                           }
// //                                         },
// //                                         icon: const Icon(Icons.access_time,
// //                                             size: 16),
// //                                         label: Text(
// //                                           _formatTime(shift.end),
// //                                           style: const TextStyle(fontSize: 13),
// //                                         ),
// //                                         style: OutlinedButton.styleFrom(
// //                                           foregroundColor:
// //                                               const Color(0xFF1E1E82),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 const SizedBox(height: 8),
// //                                 Row(
// //                                   children: [
// //                                     Expanded(
// //                                       child: TextField(
// //                                         decoration: InputDecoration(
// //                                           labelText: 'Price (₹)',
// //                                           border: OutlineInputBorder(
// //                                             borderRadius:
// //                                                 BorderRadius.circular(8),
// //                                           ),
// //                                           contentPadding:
// //                                               const EdgeInsets.symmetric(
// //                                             horizontal: 12,
// //                                             vertical: 8,
// //                                           ),
// //                                         ),
// //                                         keyboardType: TextInputType.number,
// //                                         onChanged: (val) {
// //                                           prov.updateShift(
// //                                             day,
// //                                             index,
// //                                             price: double.tryParse(val) ?? 0,
// //                                           );
// //                                         },
// //                                         controller: TextEditingController(
// //                                           text: shift.price.toString(),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     const SizedBox(width: 8),
// //                                     IconButton(
// //                                       onPressed: () {
// //                                         prov.removeShift(day, index);
// //                                         setState(() {});
// //                                       },
// //                                       icon: const Icon(Icons.delete_outline),
// //                                       color: Colors.red,
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           );
// //                         }).toList(),

// //                       // Add Shift Button
// //                       Padding(
// //                         padding: const EdgeInsets.all(12),
// //                         child: SizedBox(
// //                           width: double.infinity,
// //                           child: OutlinedButton.icon(
// //                             onPressed: () {
// //                               prov.addShift(day);
// //                               setState(() {});
// //                             },
// //                             icon: const Icon(Icons.add),
// //                             label: const Text('Add Time Slot'),
// //                             style: OutlinedButton.styleFrom(
// //                               foregroundColor: const Color(0xFF1E1E82),
// //                               side: const BorderSide(color: Color(0xFF1E1E82)),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ],
// //                 ),
// //               );
// //             }).toList(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // turf_schedule_page.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_play/services/turfformprovider.dart';

// class TurfSchedulePage extends StatefulWidget {
//   final GlobalKey<FormState> formKey;

//   const TurfSchedulePage({required this.formKey, super.key});

//   @override
//   State<TurfSchedulePage> createState() => _TurfSchedulePageState();
// }

// class _TurfSchedulePageState extends State<TurfSchedulePage> {
//   final List<String> _days = [
//     'monday',
//     'tuesday',
//     'wednesday',
//     'thursday',
//     'friday',
//     'saturday',
//     'sunday',
//   ];

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
//             const Text(
//               'WEEKLY SCHEDULE',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF1E1E82),
//                 letterSpacing: 1.2,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'All days are open by default. To declare a holiday, unselect the day.',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 20),

//             // Half Hour Price Input
//             Container(
//               margin: const EdgeInsets.only(bottom: 20),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E1E82).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: const Color(0xFF1E1E82)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Price per Half Hour (Applicable to all days)',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1E1E82),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     initialValue: prov.halfHourPrice.toString(),
//                     decoration: InputDecoration(
//                       labelText: 'Price (₹)',
//                       prefixText: '₹ ',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Please enter a price';
//                       }
//                       if (double.tryParse(val) == null || double.parse(val) <= 0) {
//                         return 'Please enter a valid price';
//                       }
//                       return null;
//                     },
//                     onChanged: (val) {
//                       prov.updateHalfHourPrice(double.tryParse(val) ?? 0);
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             // Days Selection
//             const Text(
//               'Select Available Days',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 12),

//             ..._days.map((day) {
//               final isOpen = prov.weeklySchedule[day]!.isOpen;

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: isOpen ? const Color(0xFF1E1E82) : Colors.grey.shade300,
//                     width: isOpen ? 2 : 1,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                   color: isOpen ? Colors.white : Colors.grey.shade50,
//                 ),
//                 child: ListTile(
//                   title: Text(
//                     _capitalize(day),
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: isOpen ? const Color(0xFF1E1E82) : Colors.grey.shade600,
//                     ),
//                   ),
//                   trailing: Switch(
//                     value: isOpen,
//                     onChanged: (val) {
//                       prov.toggleDay(day, val);
//                       setState(() {});
//                     },
//                     activeColor: const Color(0xFF1E1E82),
//                   ),
//                 ),
//               );
//             }).toList(),

//             const SizedBox(height: 20),

//             // Summary Info
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'Turf will be available on selected days at ₹${prov.halfHourPrice.toStringAsFixed(0)} per half hour',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.blue.shade900,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
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

class TurfSchedulePage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const TurfSchedulePage({required this.formKey, super.key});

  @override
  State<TurfSchedulePage> createState() => _TurfSchedulePageState();
}

class _TurfSchedulePageState extends State<TurfSchedulePage> {
  static const List<String> _days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  // Track which day rows are expanded to show the time pickers
  final Set<String> _expanded = {};

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  // ─── Opens the native time-picker and returns the picked TimeOfDay (or null) ───
  Future<TimeOfDay?> _pickTime(BuildContext ctx, TimeOfDay initial) async {
    return showTimePicker(context: ctx, initialTime: initial);
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  int toMinute(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TurfFormProvider>();
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──
            const Text(
              'WEEKLY SCHEDULE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E82),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Toggle each day on/off, then set its operating hours.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            // ── Half-Hour Price ──
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E82).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E1E82), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price per Half Hour',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E82),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: prov.halfHourPrice > 0
                        ? prov.halfHourPrice.toStringAsFixed(0)
                        : '',
                    decoration: InputDecoration(
                      labelText: 'Price (₹)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return 'Enter a price';
                      final v = double.tryParse(val);
                      if (v == null || v <= 0) return 'Enter a valid price > 0';
                      return null;
                    },
                    onChanged: (val) {
                      prov.updateHalfHourPrice(double.tryParse(val) ?? 0);
                    },
                  ),
                ],
              ),
            ),

            // ── Day rows ──
            const Text(
              'OPERATING HOURS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E82),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            ..._days.map((day) {
              final td = prov.weeklySchedule[day]!;
              final isOpen = td.isOpen;
              final isExpanded = _expanded.contains(day);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isOpen
                        ? const Color(0xFF1E1E82)
                        : Colors.grey.shade300,
                    width: isOpen ? 1.8 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isOpen ? 18 : 8),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ── Top row: day name + switch + chevron ──
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        // Day name
                        SizedBox(
                          width: size.width * 0.28,
                          child: Text(
                            _capitalize(day),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isOpen
                                  ? const Color(0xFF1E1E82)
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ),
                        // Time summary (only when open & collapsed, or always as subtle hint)
                        Expanded(
                          child: isOpen
                              ? Text(
                                  '${formatTime(td.startTime)} – ${formatTime(td.endTime)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontFamily: 'Regular',
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        // Toggle switch
                        Switch(
                          value: isOpen,
                          onChanged: (val) {
                            prov.toggleDay(day, val);
                            if (!val) {
                              // collapse when turning off
                              setState(() {
                                _expanded.remove(day);
                              });
                            }
                          },
                          activeColor: const Color(0xFF1E1E82),
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                        // Expand chevron (only meaningful when open)
                        if (isOpen)
                          GestureDetector(
                            onTap: () => setState(() {
                              isExpanded
                                  ? _expanded.remove(day)
                                  : _expanded.add(day);
                            }),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                  Icons.expand_more_rounded,
                                  color: Color(0xFF1E1E82),
                                  size: 22,
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 32),
                      ],
                    ),

                    // ── Expandable time pickers ──
                    if (isOpen && isExpanded) ...[
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // START TIME
                            Expanded(
                              child: _buildTimePicker(
                                context,
                                label: 'Start Time',
                                icon: Icons.access_alarm,
                                time: td.startTime,
                                onTap: () async {
                                  final picked = await _pickTime(
                                    context,
                                    td.startTime,
                                  );
                                  if (picked == null) return;

                                  // Validate: start must be before end
                                  if (toMinute(picked) >=
                                      toMinute(td.endTime)) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Start time must be before end time',
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                    return;
                                  }
                                  prov.setDayTime(day, 'start', picked);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Dash separator
                            Text(
                              '–',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // END TIME
                            Expanded(
                              child: _buildTimePicker(
                                context,
                                label: 'End Time',
                                icon: Icons.alarm_off,
                                time: td.endTime,
                                onTap: () async {
                                  final picked = await _pickTime(
                                    context,
                                    td.endTime,
                                  );
                                  if (picked == null) return;

                                  // Validate: end must be after start
                                  if (toMinute(picked) <=
                                      toMinute(td.startTime)) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'End time must be after start time',
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                    return;
                                  }
                                  prov.setDayTime(day, 'end', picked);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // ── Summary info box ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Time slots are generated automatically in 30-minute intervals between the start and end times you set for each day.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── Single time-picker button ───
  Widget _buildTimePicker(
    BuildContext ctx, {
    required String label,
    required IconData icon,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E82).withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1E1E82).withOpacity(0.25)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatTime(time),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E1E82),
                    ),
                  ),
                  const Icon(
                    Icons.access_time_filled,
                    size: 18,
                    color: Color(0xFF3636B8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
