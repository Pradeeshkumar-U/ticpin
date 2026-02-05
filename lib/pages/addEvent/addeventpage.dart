// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_partner/pages/addEvent/artistspromotionpage.dart';
// import 'package:ticpin_partner/pages/addEvent/eventdetailspage.dart';
// import 'package:ticpin_partner/pages/addEvent/financialpage.dart';
// import 'package:ticpin_partner/pages/addEvent/legalreviewpage.dart';
// import 'package:ticpin_partner/pages/addEvent/mediauploadpage.dart';
// import 'package:ticpin_partner/pages/addEvent/ticketspage.dart';
// import 'package:ticpin_partner/pages/addEvent/venueorganizerpage.dart';
// import 'package:ticpin_partner/services/eventformprovider.dart';

// class AddEventPage extends StatefulWidget {
//   final String? existingEventId;
//   final Map<String, dynamic>? existingData;

//   const AddEventPage({super.key, this.existingEventId, this.existingData});

//   @override
//   State<AddEventPage> createState() => _AddEventPageState();
// }

// class _AddEventPageState extends State<AddEventPage> {
//   final PageController _pc = PageController();
//   int pageIndex = 0;

//   final _formKeys = List.generate(7, (_) => GlobalKey<FormState>());
//   final _artistsPageKey = GlobalKey<ArtistsPromotionPageState>();
//   final _eventDetailsKey = GlobalKey<EventDetailsPageState>();

//   @override
//   void initState() {
//     super.initState();

//     // 🔹 Preload data if editing - use addPostFrameCallback to avoid build errors
//     if (widget.existingEventId != null && widget.existingData != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         final prov = context.read<EventFormProvider>();
//         prov.loadFromFirestore(widget.existingData!, widget.existingEventId!);
//       });
//     }
//   }

//   void nextPage() {
//     final prov = context.read<EventFormProvider>();

//     final currentForm = _formKeys[pageIndex].currentState;
//     final isValid = currentForm?.validate() ?? true;
//     if (pageIndex == 1) {
//       print(_eventDetailsKey.currentState?.validateLanguages());
//       final valid = _eventDetailsKey.currentState?.validateLanguages() ?? false;
//       if (valid == false) {
//         ScaffoldMessenger.of(context)
//           ..clearSnackBars()
//           ..showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Please complete all required fields. ${_eventDetailsKey.currentState?.validateLanguages()}',
//               ),
//               backgroundColor: Colors.red,
//             ),
//           );
//         return;
//       }
//     }
//     // 🔹 Validate ArtistsPromotionPage
//     if (pageIndex == 3) {
//       final valid =
//           _artistsPageKey.currentState?.validateAndSave(context) ?? false;
//       if (!valid) {
//         ScaffoldMessenger.of(context)
//           ..clearSnackBars()
//           ..showSnackBar(
//             const SnackBar(
//               content: Text('Please complete all required fields.'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         return;
//       }
//     }

//     // 🔹 Tickets Page check
//     if (pageIndex == 4 && prov.tickets.isEmpty) {
//       ScaffoldMessenger.of(context)
//         ..clearSnackBars()
//         ..showSnackBar(
//           const SnackBar(
//             content: Text('Please add at least one ticket category.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       return;
//     }

//     // ✅ Move to next page
//     if (isValid && pageIndex < 6) {
//       ScaffoldMessenger.of(context).clearSnackBars();
//       setState(() => pageIndex++);
//       _pc.animateToPage(
//         pageIndex,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void prevPage() {
//     if (pageIndex > 0) {
//       ScaffoldMessenger.of(context).clearSnackBars();
//       setState(() => pageIndex--);
//       _pc.animateToPage(
//         pageIndex,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<EventFormProvider>();

//     final bool canSubmit =
//         pageIndex == 6 &&
//         prov.nocLinks.isNotEmpty &&
//         prov.gstNo.trim().isNotEmpty &&
//         prov.liabilityText.trim().isNotEmpty;

//     final isEditing = widget.existingEventId != null;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           isEditing ? 'Update Event' : 'Upload Event',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E1E82),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           LinearProgressIndicator(
//             value: (pageIndex + 1) / 7,
//             backgroundColor: Colors.grey[200],
//             color: const Color(0xFF1E1E82),
//           ),
//           Expanded(
//             child: PageView(
//               controller: _pc,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 MediaUploadPage(formKey: _formKeys[0]),
//                 EventDetailsPage(key: _eventDetailsKey, formKey: _formKeys[1]),
//                 VenueOrganizerPage(formKey: _formKeys[2]),
//                 ArtistsPromotionPage(
//                   key: _artistsPageKey,
//                   formKey: _formKeys[3],
//                 ),
//                 TicketsPage(formKey: _formKeys[4]),
//                 FinancialPage(formKey: _formKeys[5]),
//                 LegalReviewPage(formKey: _formKeys[6]),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Row(
//             children: [
//               if (pageIndex > 0)
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: prevPage,
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       side: const BorderSide(color: Color(0xFF1E1E82)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Back',
//                       style: TextStyle(
//                         color: Color(0xFF1E1E82),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               if (pageIndex > 0) const SizedBox(width: 12),
//               Expanded(
//                 flex: 1,
//                 child: ElevatedButton(
//                   // onPressed:
//                   //     pageIndex == 6
//                   //         ? (canSubmit && !prov.submitting
//                   //             ? () async {
//                   //               try {
//                   //                 final prov =
//                   //                     context.read<EventFormProvider>();
//                   //                 final id =
//                   //                     isEditing
//                   //                         ? await prov.updateFirestore(
//                   //                           widget.existingEventId!,
//                   //                         )
//                   //                         : await prov.submitToFirestore();

//                   //                 if (!mounted) return;
//                   //                 ScaffoldMessenger.of(context)
//                   //                   ..clearSnackBars()
//                   //                   ..showSnackBar(
//                   //                     SnackBar(
//                   //                       content: Text(
//                   //                         isEditing
//                   //                             ? 'Event updated successfully! ($id)'
//                   //                             : 'Event created successfully! ($id)',
//                   //                       ),
//                   //                       backgroundColor: Colors.green,
//                   //                     ),
//                   //                   );

//                   //                 prov.reset();
//                   //                 Get.back();
//                   //               } catch (e) {
//                   //                 if (!mounted) return;
//                   //                 ScaffoldMessenger.of(context)
//                   //                   ..clearSnackBars()
//                   //                   ..showSnackBar(
//                   //                     SnackBar(
//                   //                       content: Text('Error: $e'),
//                   //                       backgroundColor: Colors.red,
//                   //                     ),
//                   //                   );
//                   //               }
//                   //             }
//                   //             : null)
//                   //         : nextPage,
//                   onPressed: () async {
//   final prov = context.read<EventFormProvider>();

//   if (prov.submitting) return;

//   try {
//     prov.setSubmitting(true); // show loading

//     String eventId;

//     if (widget.existingEventId == null) {
//       /// ➤ CREATE NEW EVENT
//       eventId = await prov.createEvent();
//     } else {
//       /// ➤ UPDATE EXISTING EVENT
//       eventId = await prov.updateEvent(widget.existingEventId!);
//     }

//     prov.setSubmitting(false);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(widget.existingEventId == null
//             ? "Event Created Successfully (ID: $eventId)"
//             : "Event Updated Successfully"),
//         backgroundColor: Colors.green,
//       ),
//     );

//     prov.reset();
//     Navigator.pop(context);

//   } catch (e) {
//     prov.setSubmitting(false);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Error: $e"),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1E1E82),
//                     disabledBackgroundColor: Colors.grey.shade400,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     pageIndex == 6 ? (isEditing ? 'Update' : 'Submit') : 'Next',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_partner/pages/addEvent/artistspromotionpage.dart';
import 'package:ticpin_partner/pages/addEvent/eventdetailspage.dart';
import 'package:ticpin_partner/pages/addEvent/financialpage.dart';
import 'package:ticpin_partner/pages/addEvent/legalreviewpage.dart';
import 'package:ticpin_partner/pages/addEvent/mediauploadpage.dart';
import 'package:ticpin_partner/pages/addEvent/ticketspage.dart';
import 'package:ticpin_partner/pages/addEvent/venueorganizerpage.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';

class AddEventPage extends StatefulWidget {
  final String? existingEventId;
  final Map<String, dynamic>? existingData;

  const AddEventPage({super.key, this.existingEventId, this.existingData});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<GlobalKey<FormState>> _formKeys = List.generate(
    7,
    (_) => GlobalKey<FormState>(),
  );

  final GlobalKey<ArtistsPromotionPageState> _artistsKey = GlobalKey();
  final GlobalKey<EventDetailsPageState> _eventDetailsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Load existing event data if in edit mode
    if (widget.existingEventId != null && widget.existingData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<EventFormProvider>();
        provider.loadFromFirestore(
          widget.existingData!,
          widget.existingEventId,
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final prov = context.read<EventFormProvider>();
    final currentForm = _formKeys[_currentPage].currentState;

    if (!_validateCurrentPage(prov, currentForm)) return;

    if (_currentPage < _formKeys.length - 1) {
      setState(() => _currentPage++);
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentPage(EventFormProvider prov, FormState? form) {
    if (form?.validate() == false) return false;

    // Validate languages on event details page
    if (_currentPage == 1) {
      final valid =
          _eventDetailsKey.currentState?.validateLanguages() ?? false;
      if (!valid) {
        _showErrorSnack("Please add at least one language.");
        return false;
      }
    }

    // Validate artists/promotion page
    if (_currentPage == 3) {
      final valid = _artistsKey.currentState?.validateAndSave(context) ?? false;
      if (!valid) {
        _showErrorSnack("Please complete all required fields on this page.");
        return false;
      }
    }

    // Validate tickets page
    if (_currentPage == 4 && prov.tickets.isEmpty) {
      _showErrorSnack("Please add at least one ticket category.");
      return false;
    }

    return true;
  }

  void _showErrorSnack(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showSuccessSnack(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _submit(EventFormProvider prov) async {
    if (prov.submitting) return;

    // If not on last page, go to next page
    if (_currentPage != 6) {
      _nextPage();
      return;
    }

    // Validate final page fields
    if (!_validateFinalPage(prov)) {
      return;
    }

    // Show confirmation dialog
    final confirm = await _showConfirmationDialog(
      title: widget.existingEventId == null ? 'Create Event?' : 'Update Event?',
      message:
          widget.existingEventId == null
              ? 'Are you sure you want to create this event?'
              : 'Are you sure you want to update this event? Old images will be replaced.',
    );

    if (confirm != true) return;

    try {
      prov.setSubmitting(true);

      String eventId;
      if (widget.existingEventId == null) {
        // CREATE NEW EVENT
        eventId = await prov.createEvent();
        _showSuccessSnack("Event created successfully! ID: $eventId");
      } else {
        // UPDATE EXISTING EVENT
        eventId = await prov.updateEvent(widget.existingEventId!);
        _showSuccessSnack("Event updated successfully!");
      }

      // Reset provider and navigate back
      prov.reset();
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      prov.setSubmitting(false);
      _showErrorSnack("Error: ${e.toString()}");
      debugPrint('Submit error: $e');
    }
  }

  bool _validateFinalPage(EventFormProvider prov) {
    if (prov.nocLinks.isEmpty) {
      _showErrorSnack("Please add at least one NOC/Permission link.");
      return false;
    }
    if (prov.gstNo.trim().isEmpty) {
      _showErrorSnack("Please enter GST number.");
      return false;
    }
    if (prov.liabilityText.trim().isEmpty) {
      _showErrorSnack("Please enter liability text.");
      return false;
    }
    return true;
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E82),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventFormProvider>();
    final isEditing = widget.existingEventId != null;

    return WillPopScope(
      onWillPop: () async {
        if (prov.submitting) {
          _showErrorSnack("Please wait for the operation to complete.");
          return false;
        }

        // Show confirmation if form has been filled
        if (prov.name.isNotEmpty || prov.posterImageFile != null) {
          final confirm = await _showConfirmationDialog(
            title: 'Discard Changes?',
            message: 'Are you sure you want to discard your changes?',
          );
          return confirm ?? false;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            isEditing ? 'Update Event' : 'Create Event',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E82),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E82)),
            onPressed:
                prov.submitting
                    ? null
                    : () async {
                      if (prov.name.isNotEmpty ||
                          prov.posterImageFile != null) {
                        final confirm = await _showConfirmationDialog(
                          title: 'Discard Changes?',
                          message:
                              'Are you sure you want to discard your changes?',
                        );
                        if (confirm == true && mounted) {
                          Navigator.pop(context);
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
          ),
        ),
        body: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentPage + 1) / _formKeys.length,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFF1E1E82),
            ),

            // Page indicator text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Step ${_currentPage + 1} of ${_formKeys.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MediaUploadPage(formKey: _formKeys[0]),
                  EventDetailsPage(
                    key: _eventDetailsKey,
                    formKey: _formKeys[1],
                  ),
                  VenueOrganizerPage(formKey: _formKeys[2]),
                  ArtistsPromotionPage(key: _artistsKey, formKey: _formKeys[3]),
                  TicketsPage(formKey: _formKeys[4]),
                  FinancialPage(formKey: _formKeys[5]),
                  LegalReviewPage(formKey: _formKeys[6]),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                // Back button (only show after first page)
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: prov.submitting ? null : _prevPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color:
                              prov.submitting
                                  ? Colors.grey
                                  : const Color(0xFF1E1E82),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color:
                              prov.submitting
                                  ? Colors.grey
                                  : const Color(0xFF1E1E82),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                if (_currentPage > 0) const SizedBox(width: 12),

                // Next/Submit button
                Expanded(
                  child: ElevatedButton(
                    onPressed: prov.submitting ? null : () => _submit(prov),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E82),
                      disabledBackgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        prov.submitting
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              _currentPage == 6
                                  ? (isEditing
                                      ? 'Update Event'
                                      : 'Create Event')
                                  : 'Next',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
