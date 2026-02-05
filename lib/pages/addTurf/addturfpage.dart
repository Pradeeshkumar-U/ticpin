// // add_turf_page.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ticpin_play/pages/addEvent/reviewpage.dart';
// import 'package:ticpin_play/pages/addEvent/mediauploadpage.dart';
// import 'package:ticpin_play/pages/addEvent/schedulepage.dart';
// import 'package:ticpin_play/pages/addEvent/turfdetailspage.dart';
// import 'package:ticpin_play/pages/addEvent/venueorganizerpage.dart';
// import 'package:ticpin_play/services/turfformprovider.dart';

// class AddTurfPage extends StatefulWidget {
//   final String? existingTurfId;
//   final Map<String, dynamic>? existingData;

//   const AddTurfPage({super.key, this.existingTurfId, this.existingData});

//   @override
//   State<AddTurfPage> createState() => _AddTurfPageState();
// }

// class _AddTurfPageState extends State<AddTurfPage> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   final List<GlobalKey<FormState>> _formKeys = List.generate(
//     5,
//     (_) => GlobalKey<FormState>(),
//   );

//   @override
//   void initState() {
//     super.initState();
//     if (widget.existingTurfId != null && widget.existingData != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         final provider = context.read<TurfFormProvider>();
//         provider.loadFromFirestore(widget.existingData!, widget.existingTurfId);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _nextPage() {
//     final prov = context.read<TurfFormProvider>();
//     final currentForm = _formKeys[_currentPage].currentState;

//     if (!_validateCurrentPage(prov, currentForm)) return;

//     if (_currentPage < _formKeys.length - 1) {
//       setState(() => _currentPage++);
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _prevPage() {
//     if (_currentPage > 0) {
//       setState(() => _currentPage--);
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   bool _validateCurrentPage(TurfFormProvider prov, FormState? form) {
//     if (form?.validate() == false) return false;

//     // Validate posters on media page
//     if (_currentPage == 0) {
//       if (prov.posterImages.isEmpty && prov.existingPosterUrls.isEmpty) {
//         _showErrorSnack("Please add at least one turf poster.");
//         return false;
//       }
//     }

//     // Validate location on venue page
//     if (_currentPage == 1) {
//       if (prov.venueLat.isEmpty || prov.venueLng.isEmpty) {
//         _showErrorSnack("Please select location on map.");
//         return false;
//       }
//     }

//     // Validate schedule on schedule page
//     if (_currentPage == 3) {
//       bool hasSchedule = false;
//       prov.weeklySchedule.forEach((day, dayData) {
//         if (dayData.isOpen && dayData.shifts.isNotEmpty) {
//           hasSchedule = true;
//         }
//       });

//       if (!hasSchedule) {
//         _showErrorSnack("Please add at least one time slot for any day.");
//         return false;
//       }
//     }

//     return true;
//   }

//   void _showErrorSnack(String message) {
//     ScaffoldMessenger.of(context)
//       ..clearSnackBars()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//   }

//   void _showSuccessSnack(String message) {
//     ScaffoldMessenger.of(context)
//       ..clearSnackBars()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//   }

//   Future<void> _submit(TurfFormProvider prov) async {
//     if (prov.submitting) return;

//     if (_currentPage != 4) {
//       _nextPage();
//       return;
//     }

//     final confirm = await _showConfirmationDialog(
//       title: widget.existingTurfId == null ? 'Create Turf?' : 'Update Turf?',
//       message: widget.existingTurfId == null
//           ? 'Are you sure you want to create this turf?'
//           : 'Are you sure you want to update this turf?',
//     );

//     if (confirm != true) return;

//     try {
//       prov.setSubmitting(true);

//       String turfId;
//       if (widget.existingTurfId == null) {
//         turfId = await prov.createTurf();
//         _showSuccessSnack("Turf created successfully! ID: $turfId");
//       } else {
//         turfId = await prov.updateTurf(widget.existingTurfId!);
//         _showSuccessSnack("Turf updated successfully!");
//       }

//       prov.reset();
//       if (mounted) {
//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       prov.setSubmitting(false);
//       _showErrorSnack("Error: ${e.toString()}");
//       debugPrint('Submit error: $e');
//     }
//   }

//   Future<bool?> _showConfirmationDialog({
//     required String title,
//     required String message,
//   }) {
//     return showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF1E1E82),
//             ),
//             child: const Text(
//               'Confirm',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<TurfFormProvider>();
//     final isEditing = widget.existingTurfId != null;

//     return WillPopScope(
//       onWillPop: () async {
//         if (prov.submitting) {
//           _showErrorSnack("Please wait for the operation to complete.");
//           return false;
//         }

//         if (prov.name.isNotEmpty || prov.posterImages.isNotEmpty) {
//           final confirm = await _showConfirmationDialog(
//             title: 'Discard Changes?',
//             message: 'Are you sure you want to discard your changes?',
//           );
//           return confirm ?? false;
//         }

//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: true,
//           title: Text(
//             isEditing ? 'Update Turf' : 'Add New Turf',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E1E82),
//             ),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E82)),
//             onPressed: prov.submitting
//                 ? null
//                 : () async {
//                     if (prov.name.isNotEmpty || prov.posterImages.isNotEmpty) {
//                       final confirm = await _showConfirmationDialog(
//                         title: 'Discard Changes?',
//                         message: 'Are you sure you want to discard your changes?',
//                       );
//                       if (confirm == true && mounted) {
//                         Navigator.pop(context);
//                       }
//                     } else {
//                       Navigator.pop(context);
//                     }
//                   },
//           ),
//         ),
//         body: Column(
//           children: [
//             LinearProgressIndicator(
//               value: (_currentPage + 1) / _formKeys.length,
//               backgroundColor: Colors.grey[200],
//               color: const Color(0xFF1E1E82),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Text(
//                 'Step ${_currentPage + 1} of ${_formKeys.length}',
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   TurfMediaUploadPage(formKey: _formKeys[0]),
//                   TurfVenueDetailsPage(formKey: _formKeys[1]),
//                   TurfDetailsPage(formKey: _formKeys[2]),
//                   TurfSchedulePage(formKey: _formKeys[3]),
//                   TurfReviewPage(formKey: _formKeys[4]),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             child: Row(
//               children: [
//                 if (_currentPage > 0)
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: prov.submitting ? null : _prevPage,
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: BorderSide(
//                           color: prov.submitting
//                               ? Colors.grey
//                               : const Color(0xFF1E1E82),
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         'Back',
//                         style: TextStyle(
//                           color: prov.submitting
//                               ? Colors.grey
//                               : const Color(0xFF1E1E82),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 if (_currentPage > 0) const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: prov.submitting ? null : () => _submit(prov),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1E1E82),
//                       disabledBackgroundColor: Colors.grey.shade400,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: prov.submitting
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : Text(
//                             _currentPage == 4
//                                 ? (isEditing ? 'Update Turf' : 'Create Turf')
//                                 : 'Next',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// add_turf_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticpin_play/pages/addTurf/reviewpage.dart';
import 'package:ticpin_play/pages/addTurf/mediauploadpage.dart';
import 'package:ticpin_play/pages/addTurf/schedulepage.dart';
import 'package:ticpin_play/pages/addTurf/turfdetailspage.dart';
import 'package:ticpin_play/pages/addTurf/venueorganizerpage.dart';
import 'package:ticpin_play/services/turfformprovider.dart';

class AddTurfPage extends StatefulWidget {
  final String? existingTurfId;
  final Map<String, dynamic>? existingData;

  const AddTurfPage({super.key, this.existingTurfId, this.existingData});

  @override
  State<AddTurfPage> createState() => _AddTurfPageState();
}

class _AddTurfPageState extends State<AddTurfPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<GlobalKey<FormState>> _formKeys = List.generate(
    5,
    (_) => GlobalKey<FormState>(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.existingTurfId != null && widget.existingData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<TurfFormProvider>();
        provider.loadFromFirestore(widget.existingData!, widget.existingTurfId);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final prov = context.read<TurfFormProvider>();
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

  bool _validateCurrentPage(TurfFormProvider prov, FormState? form) {
    if (form?.validate() == false) return false;

    // Validate posters on media page
    if (_currentPage == 0) {
      if (prov.posterImages.isEmpty && prov.existingPosterUrls.isEmpty) {
        _showErrorSnack("Please add at least one turf poster.");
        return false;
      }
    }

    // Validate location on venue page
    if (_currentPage == 1) {
      if (prov.venueLat.isEmpty || prov.venueLng.isEmpty) {
        _showErrorSnack("Please select location on map.");
        return false;
      }
    }

    // Validate schedule on schedule page
    if (_currentPage == 3) {
      // Check if half hour price is set
      if (prov.halfHourPrice <= 0) {
        _showErrorSnack("Please set a valid price per half hour.");
        return false;
      }

      // Check if at least one day is open
      bool hasOpenDay = false;
      prov.weeklySchedule.forEach((day, dayData) {
        if (dayData.isOpen) {
          hasOpenDay = true;
        }
      });

      if (!hasOpenDay) {
        _showErrorSnack("Please select at least one available day.");
        return false;
      }
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

  Future<void> _submit(TurfFormProvider prov) async {
    if (prov.submitting) return;

    if (_currentPage != 4) {
      _nextPage();
      return;
    }

    final confirm = await _showConfirmationDialog(
      title: widget.existingTurfId == null ? 'Create Turf?' : 'Update Turf?',
      message: widget.existingTurfId == null
          ? 'Are you sure you want to create this turf?'
          : 'Are you sure you want to update this turf?',
    );

    if (confirm != true) return;

    try {
      prov.setSubmitting(true);

      String turfId;
      if (widget.existingTurfId == null) {
        turfId = await prov.createTurf();
        _showSuccessSnack("Turf created successfully! ID: $turfId");
      } else {
        turfId = await prov.updateTurf(widget.existingTurfId!);
        _showSuccessSnack("Turf updated successfully!");
      }

      prov.reset();
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      prov.setSubmitting(false);
      _showErrorSnack("Error: ${e.toString()}");
      debugPrint('Submit error: $e');
    }
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
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
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TurfFormProvider>();
    final isEditing = widget.existingTurfId != null;

    return WillPopScope(
      onWillPop: () async {
        if (prov.submitting) {
          _showErrorSnack("Please wait for the operation to complete.");
          return false;
        }

        if (prov.name.isNotEmpty || prov.posterImages.isNotEmpty) {
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
            isEditing ? 'Update Turf' : 'Add New Turf',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E82),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E82)),
            onPressed: prov.submitting
                ? null
                : () async {
                    if (prov.name.isNotEmpty || prov.posterImages.isNotEmpty) {
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
            LinearProgressIndicator(
              value: (_currentPage + 1) / _formKeys.length,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFF1E1E82),
            ),
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
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TurfMediaUploadPage(formKey: _formKeys[0]),
                  TurfVenueDetailsPage(formKey: _formKeys[1]),
                  TurfDetailsPage(formKey: _formKeys[2]),
                  TurfSchedulePage(formKey: _formKeys[3]),
                  TurfReviewPage(formKey: _formKeys[4]),
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
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: prov.submitting ? null : _prevPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: prov.submitting
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
                          color: prov.submitting
                              ? Colors.grey
                              : const Color(0xFF1E1E82),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 12),
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
                    child: prov.submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _currentPage == 4
                                ? (isEditing ? 'Update Turf' : 'Create Turf')
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
