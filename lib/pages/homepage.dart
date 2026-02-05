// // turf_homepage.dart

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:provider/provider.dart';
// import 'package:get/get.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:ticpin_play/pages/addTurf/addturfpage.dart';
// import 'package:ticpin_play/services/turfformprovider.dart';

// class TurfHomepage extends StatefulWidget {
//   const TurfHomepage({super.key});

//   @override
//   State<TurfHomepage> createState() => _TurfHomepageState();
// }

// class _TurfHomepageState extends State<TurfHomepage> {
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     await FirebaseAuth.instance.authStateChanges().first;
//     if (mounted) {
//       setState(() {
//         _isInitialized = true;
//       });
//     }
//   }

//   Future<void> _deleteTurf(String docId) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('turfs')
//           .doc(docId)
//           .get();

//       if (!doc.exists) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Turf not found")),
//         );
//         return;
//       }

//       final data = doc.data() as Map<String, dynamic>;
//       final createdBy = data['createdBy'];
//       final turfId = data['turfId'];

//       if (createdBy != FirebaseAuth.instance.currentUser?.uid) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("You can only delete turfs you created"),
//           ),
//         );
//         return;
//       }

//       final confirm = await showDialog<bool>(
//         context: context,
//         barrierDismissible: false,
//         builder: (ctx) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text(
//             "Delete Turf",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text(
//             "Are you sure you want to permanently delete this turf? This action cannot be undone.",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx, false),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//               onPressed: () => Navigator.pop(ctx, true),
//               child: const Text("Delete"),
//             ),
//           ],
//         ),
//       );

//       if (confirm != true) return;

//       // Delete storage files
//       final folder = FirebaseStorage.instance.ref("turf_posters/$turfId");
//       final listResult = await folder.listAll();

//       debugPrint('🗑️ Found ${listResult.items.length} files to delete');

//       for (final item in listResult.items) {
//         await item.delete();
//         debugPrint('🗑️ Deleted file: ${item.fullPath}');
//       }

//       debugPrint('✅ Folder deleted successfully: $turfId');

//       await FirebaseFirestore.instance.collection('turfs').doc(docId).delete();

//       if (mounted) {
//         ScaffoldMessenger.of(context)
//           ..clearSnackBars()
//           ..showSnackBar(
//             const SnackBar(
//               content: Text("✅ Turf deleted successfully"),
//               backgroundColor: Colors.green,
//               duration: Duration(seconds: 2),
//             ),
//           );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context)
//           ..clearSnackBars()
//           ..showSnackBar(
//             SnackBar(
//               content: Text("❌ Failed to delete turf: $e"),
//               backgroundColor: Colors.red,
//             ),
//           );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Material(
//       surfaceTintColor: Colors.transparent,
//       child: SafeArea(
//         bottom: true,
//         top: false,
//         child: Stack(
//           children: [
//             Container(
//               height: kToolbarHeight + MediaQuery.of(context).padding.top * 1.2,
//               width: size.width,
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF1E1E82), Color(0xFF3636B8)],
//                 ),
//               ),
//             ),
//             Scaffold(
//               appBar: AppBar(
//                 elevation: 0,
//                 leading: const SizedBox(),
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 foregroundColor: Colors.transparent,
//                 surfaceTintColor: Colors.transparent,
//                 excludeHeaderSemantics: true,
//                 leadingWidth: 0,
//                 flexibleSpace: Padding(
//                   padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).padding.top + size.width * 0.02,
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                               left: size.width * 0.04,
//                               right: size.width * 0.032,
//                             ),
//                             child: GestureDetector(
//                               onTap: () {}, // Navigate to profile
//                               child: CircleAvatar(
//                                 radius: size.width * 0.055,
//                                 backgroundColor: Colors.white54,
//                                 child: CircleAvatar(
//                                   radius: size.width * 0.04,
//                                   backgroundColor: Colors.white70,
//                                   child: const Icon(
//                                     Icons.person,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             'My Turfs',
//                             style: TextStyle(
//                               fontSize: size.width * 0.045,
//                               fontFamily: 'Medium',
//                               color: Colors.white.withAlpha(230),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               backgroundColor: Colors.transparent,
//               body: Stack(
//                 children: [
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('turfs')
//                         .where(
//                           'createdBy',
//                           isEqualTo:
//                               FirebaseAuth.instance.currentUser?.uid ?? '',
//                         )
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!_isInitialized) {
//                         return const Center(
//                           child: CircularProgressIndicator(
//                             color: Color(0xFF1E1E82),
//                           ),
//                         );
//                       }

//                       if (FirebaseAuth.instance.currentUser == null) {
//                         return const Center(
//                           child: Text('Please sign in to view turfs'),
//                         );
//                       }

//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(
//                             color: Color(0xFF1E1E82),
//                           ),
//                         );
//                       }

//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text('Error: ${snapshot.error}'),
//                         );
//                       }

//                       final docs = snapshot.data?.docs ?? [];

//                       if (docs.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             'No turfs created yet.',
//                             style: TextStyle(fontFamily: 'Regular'),
//                           ),
//                         );
//                       }

//                       return ListView.builder(
//                         padding: const EdgeInsets.only(bottom: 80),
//                         itemCount: docs.length,
//                         itemBuilder: (context, index) {
//                           final doc = docs[index];
//                           final data = doc.data() as Map<String, dynamic>;

//                           return Padding(
//                             padding: EdgeInsets.only(
//                               top: index == 0 ? size.width * 0.05 : 0,
//                             ),
//                             child: Card(
//                               color: const Color(0xFF1E1E82),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               margin: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(2.0),
//                                 child: ListTile(
//                                   tileColor: Colors.white,
//                                   title: Text(data['name'] ?? 'Untitled'),
//                                   subtitle: Text(
//                                     data['city'] ?? 'No city',
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   contentPadding: EdgeInsets.only(
//                                     right: size.width * 0.03,
//                                     left: size.width * 0.04,
//                                     top: size.width * 0.01,
//                                     bottom: size.width * 0.01,
//                                   ),
//                                   trailing: PopupMenuButton<String>(
//                                     color: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     onSelected: (value) {
//                                       if (value == 'edit') {
//                                         Get.to(
//                                           () => AddTurfPage(
//                                             existingTurfId: doc.id,
//                                             existingData: data,
//                                           ),
//                                         );
//                                       } else if (value == 'delete') {
//                                         _deleteTurf(doc.id);
//                                       }
//                                     },
//                                     itemBuilder: (context) => const [
//                                       PopupMenuItem(
//                                         value: 'edit',
//                                         child: Text('Update'),
//                                       ),
//                                       PopupMenuItem(
//                                         value: 'delete',
//                                         child: Text('Delete'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   Align(
//                     alignment: const Alignment(0.8, 0.9),
//                     child: InkWell(
//                       splashFactory: NoSplash.splashFactory,
//                       customBorder: const CircleBorder(),
//                       onTap: () {
//                         final prov = context.read<TurfFormProvider>();
//                         prov.reset();
//                         Get.to(() => const AddTurfPage());
//                       },
//                       splashColor: const Color(0xFF3636B8).withAlpha(200),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Color(0xFF1E1E82),
//                               blurRadius: 4,
//                               offset: Offset(0, 0),
//                             ),
//                           ],
//                           color: const Color(0xFF3636B8).withAlpha(200),
//                           shape: BoxShape.circle,
//                         ),
//                         width: size.width * 0.14,
//                         height: size.width * 0.145,
//                         child: const Center(
//                           child: Icon(Icons.add_rounded, color: Colors.white),
//                         ),
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

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:ticpin_play/constants/model.dart';
// import 'package:ticpin_play/pages/profilepage.dart';
// import 'package:ticpin_play/pages/turfdetailpage.dart';
// import 'package:ticpin_play/services/adminservice.dart';

// class TurfHomepage extends StatefulWidget {
//   const TurfHomepage({super.key});

//   @override
//   State<TurfHomepage> createState() => _TurfHomepageState();
// }

// class _TurfHomepageState extends State<TurfHomepage> {
//   bool _isInitialized = false;
//   final TurfPartnerAdminService _adminService = TurfPartnerAdminService();

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     await FirebaseAuth.instance.authStateChanges().first;
//     if (mounted) {
//       setState(() {
//         _isInitialized = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Material(
//       surfaceTintColor: Colors.transparent,
//       child: SafeArea(
//         bottom: true,
//         top: false,
//         child: Stack(
//           children: [
//             Container(
//               height: kToolbarHeight + MediaQuery.of(context).padding.top * 1.2,
//               width: size.width,
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF1E1E82), Color(0xFF3636B8)],
//                 ),
//               ),
//             ),
//             Scaffold(
//               appBar: AppBar(
//                 elevation: 0,
//                 leading: const SizedBox(),
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 foregroundColor: Colors.transparent,
//                 surfaceTintColor: Colors.transparent,
//                 excludeHeaderSemantics: true,
//                 leadingWidth: 0,
//                 flexibleSpace: Padding(
//                   padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).padding.top + size.width * 0.02,
//                   ),
//                   child: StreamBuilder<TurfPartnerAdminModel?>(
//                     stream: _adminService.getAdminDataStream(),
//                     builder: (context, snapshot) {
//                       final adminData = snapshot.data;
//                       return Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   left: size.width * 0.04,
//                                   right: size.width * 0.032,
//                                 ),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Navigate to profile
//                                     Get.to(() => TurfPartnerAdminProfilePage());
//                                   },
//                                   child: CircleAvatar(
//                                     radius: size.width * 0.055,
//                                     backgroundColor: Colors.white54,
//                                     backgroundImage:
//                                         adminData?.profilePicUrl != null
//                                         ? NetworkImage(
//                                             adminData!.profilePicUrl!,
//                                           )
//                                         : null,
//                                     child: adminData?.profilePicUrl == null
//                                         ? CircleAvatar(
//                                             radius: size.width * 0.04,
//                                             backgroundColor: Colors.white70,
//                                             child: const Icon(
//                                               Icons.person,
//                                               color: Colors.black87,
//                                             ),
//                                           )
//                                         : null,
//                                   ),
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     adminData?.name ?? 'Partner Admin',
//                                     style: TextStyle(
//                                       fontSize: size.width * 0.045,
//                                       fontFamily: 'Medium',
//                                       color: Colors.white.withAlpha(230),
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 2,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: _getStatusColor(
//                                         adminData?.status ??
//                                             AdminStatus.pending,
//                                       ),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Text(
//                                       _getStatusText(
//                                         adminData?.status ??
//                                             AdminStatus.pending,
//                                       ),
//                                       style: TextStyle(
//                                         fontSize: size.width * 0.025,
//                                         fontFamily: 'Regular',
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           // Padding(
//                           //   padding: EdgeInsets.only(right: size.width * 0.04),
//                           //   child: IconButton(
//                           //     onPressed: () {
//                           //       // Navigate to analytics
//                           //       Get.to(() => TurfAnalyticspage(turfId: ,));
//                           //     },
//                           //     icon: Icon(
//                           //       Icons.analytics_outlined,
//                           //       color: Colors.white,
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               backgroundColor: Colors.transparent,
//               body: StreamBuilder<TurfPartnerAdminModel?>(
//                 stream: _adminService.getAdminDataStream(),
//                 builder: (context, adminSnapshot) {
//                   if (!_isInitialized) {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         color: Color(0xFF1E1E82),
//                       ),
//                     );
//                   }

//                   if (FirebaseAuth.instance.currentUser == null) {
//                     return const Center(
//                       child: Text('Please sign in to view turfs'),
//                     );
//                   }

//                   final adminData = adminSnapshot.data;

//                   if (adminData?.status == AdminStatus.pending) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.pending_actions,
//                             size: 64,
//                             color: Colors.orange,
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             'Account Pending Approval',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Regular',
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 32),
//                             child: Text(
//                               'Your account is under review. You\'ll be able to manage turfs once approved.',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontFamily: 'Regular'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   if (adminData?.status == AdminStatus.rejected) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.cancel, size: 64, color: Colors.red),
//                           SizedBox(height: 16),
//                           Text(
//                             'Application Rejected',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Regular',
//                             ),
//                           ),
//                           if (adminData?.documentVerification.rejectionReason !=
//                               null)
//                             Padding(
//                               padding: EdgeInsets.all(32),
//                               child: Text(
//                                 adminData!
//                                     .documentVerification
//                                     .rejectionReason!,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontFamily: 'Regular'),
//                               ),
//                             ),
//                         ],
//                       ),
//                     );
//                   }

//                   if (adminData?.status == AdminStatus.suspended) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.block, size: 64, color: Colors.red),
//                           SizedBox(height: 16),
//                           Text(
//                             'Account Suspended',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Regular',
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 32),
//                             child: Text(
//                               'Your account has been suspended. Please contact support.',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontFamily: 'Regular'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   // Approved status - show turfs
//                   if (adminData == null || adminData.turfIds.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No turfs assigned yet.',
//                         style: TextStyle(fontFamily: 'Regular'),
//                       ),
//                     );
//                   }

//                   return StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('turfs')
//                         .where(
//                           FieldPath.documentId,
//                           whereIn: adminData.turfIds.isEmpty
//                               ? ['dummy'] // Prevent empty whereIn
//                               : adminData.turfIds,
//                         )
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(
//                             color: Color(0xFF1E1E82),
//                           ),
//                         );
//                       }

//                       if (snapshot.hasError) {
//                         return Center(child: Text('Error: ${snapshot.error}'));
//                       }

//                       final docs = snapshot.data?.docs ?? [];

//                       if (docs.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             'No turfs assigned yet.',
//                             style: TextStyle(fontFamily: 'Regular'),
//                           ),
//                         );
//                       }

//                       return ListView.builder(
//                         padding: const EdgeInsets.only(bottom: 20),
//                         itemCount: docs.length,
//                         itemBuilder: (context, index) {
//                           final doc = docs[index];
//                           final data = doc.data() as Map<String, dynamic>;

//                           return Padding(
//                             padding: EdgeInsets.only(
//                               top: index == 0 ? size.width * 0.05 : 0,
//                             ),
//                             child: Card(
//                               color: const Color(0xFF1E1E82),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               margin: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               child: InkWell(
//                                 onTap: () {
//                                   // Navigate to turf detail page
//                                   Get.to(
//                                     () => TurfDetailpage(
//                                       turfId: doc.id,
//                                       turfData: data,
//                                     ),
//                                   );
//                                 },
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(2.0),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: ListTile(
//                                       title: Text(
//                                         data['name'] ?? 'Untitled',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontFamily: 'Regular',
//                                         ),
//                                       ),
//                                       subtitle: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             data['city'] ?? 'No city',
//                                             style: TextStyle(
//                                               fontFamily: 'Regular',
//                                             ),
//                                           ),
//                                           SizedBox(height: 4),
//                                           Row(
//                                             children: [
//                                               Icon(
//                                                 Icons.star,
//                                                 size: 16,
//                                                 color: Colors.amber,
//                                               ),
//                                               SizedBox(width: 4),
//                                               Text(
//                                                 '${data['rating'] ?? 0.0} • ${data['reviews'] ?? 0} reviews',
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontFamily: 'Regular',
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       contentPadding: EdgeInsets.symmetric(
//                                         horizontal: size.width * 0.04,
//                                         vertical: size.width * 0.02,
//                                       ),
//                                       trailing: Icon(
//                                         Icons.arrow_forward_ios,
//                                         size: 16,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(AdminStatus status) {
//     switch (status) {
//       case AdminStatus.approved:
//         return Colors.green;
//       case AdminStatus.pending:
//         return Colors.orange;
//       case AdminStatus.rejected:
//         return Colors.red;
//       case AdminStatus.suspended:
//         return Colors.red.shade700;
//       case AdminStatus.inactive:
//         return Colors.grey;
//     }
//   }

//   String _getStatusText(AdminStatus status) {
//     switch (status) {
//       case AdminStatus.approved:
//         return 'Approved';
//       case AdminStatus.pending:
//         return 'Pending';
//       case AdminStatus.rejected:
//         return 'Rejected';
//       case AdminStatus.suspended:
//         return 'Suspended';
//       case AdminStatus.inactive:
//         return 'Inactive';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:ticpin_play/constants/model.dart';
import 'package:ticpin_play/pages/addTurf/addturfpage.dart';
import 'package:ticpin_play/pages/profilepage.dart';
import 'package:ticpin_play/pages/turfdetailpage.dart';
import 'package:ticpin_play/services/adminservice.dart';

class TurfHomepage extends StatefulWidget {
  const TurfHomepage({super.key});

  @override
  State<TurfHomepage> createState() => TurfHomepageState();
}

class TurfHomepageState extends State<TurfHomepage> {
  bool _isInitialized = false;
  final TurfPartnerAdminService _adminService = TurfPartnerAdminService();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await FirebaseAuth.instance.authStateChanges().first;
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _deleteTurf(String docId, Map<String, dynamic> data) async {
    try {
      final turfId = data['turfId'];
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please sign in")));
        return;
      }

      final confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete Turf",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
            ),
          ),
          content: const Text(
            "Are you sure you want to permanently delete this turf? This action cannot be undone.",
            style: TextStyle(fontFamily: 'Regular'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(
                "Cancel",
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                "Delete",
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Delete storage files
      final folder = FirebaseStorage.instance.ref("turf_posters/$turfId");
      final listResult = await folder.listAll();

      debugPrint('🗑️ Found ${listResult.items.length} files to delete');

      for (final item in listResult.items) {
        await item.delete();
        debugPrint('🗑️ Deleted file: ${item.fullPath}');
      }

      debugPrint('✅ Folder deleted successfully: $turfId');

      // Delete from Firestore
      await FirebaseFirestore.instance.collection('turfs').doc(docId).delete();

      // Remove from admin's turf list
      await _adminService.removeTurf(docId);

      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("✅ Turf deleted successfully"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text("❌ Failed to delete turf: $e"),
              backgroundColor: Colors.red,
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        bottom: true,
        top: false,
        child: StreamBuilder<TurfPartnerAdminModel?>(
          stream: _adminService.getAdminDataStream(),
          builder: (context, adminSnapshot) {
            final adminData = adminSnapshot.data;

            return Stack(
              children: [
                Container(
                  height:
                      kToolbarHeight + MediaQuery.of(context).padding.top * 1.2,
                  width: size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E1E82), Color(0xFF3636B8)],
                    ),
                  ),
                ),
                Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    leading: const SizedBox(),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    excludeHeaderSemantics: true,
                    leadingWidth: 0,
                    flexibleSpace: Padding(
                      padding: EdgeInsets.only(
                        top:
                            MediaQuery.of(context).padding.top +
                            size.width * 0.02,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.width * 0.04,
                                  right: size.width * 0.032,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to profile
                                    Get.to(() => TurfPartnerAdminProfilePage());
                                  },
                                  child: CircleAvatar(
                                    radius: size.width * 0.055,
                                    backgroundColor: Colors.white54,
                                    backgroundImage:
                                        adminData?.profilePicUrl != null
                                        ? NetworkImage(
                                            adminData!.profilePicUrl!,
                                          )
                                        : null,
                                    child: adminData?.profilePicUrl == null
                                        ? CircleAvatar(
                                            radius: size.width * 0.04,
                                            backgroundColor: Colors.white70,
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.black87,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    adminData?.name ?? 'Partner Admin',
                                    style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      fontFamily: 'Medium',
                                      color: Colors.white.withAlpha(230),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Container(
                                  //     // padding: EdgeInsets.symmetric(
                                  //     //   horizontal: 8,
                                  //     //   vertical: 2,
                                  //     // ),
                                  //     decoration: BoxDecoration(
                                  //       color: _getStatusColor(
                                  //         adminData?.status ??
                                  //             AdminStatus.pending,
                                  //       ),
                                  //       borderRadius: BorderRadius.circular(12),
                                  //     ),
                                  //     child: FittedBox(
                                  //       fit: BoxFit.scaleDown,
                                  //       child: Text(
                                  //         '  ${_getStatusText(adminData?.status ?? AdminStatus.pending)}  ',
                                  //         style: TextStyle(
                                  //           fontSize: size.width * 0.025,
                                  //           fontFamily: 'Regular',
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(right: size.width * 0.04),
                          //   child: IconButton(
                          //     onPressed: () {
                          //       // Navigate to analytics
                          //       Get.to(() => TurfAnalyticspage());
                          //     },
                          //     icon: Icon(
                          //       Icons.analytics_outlined,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    children: [
                      _buildBody(adminData, size),

                      // Floating Action Button to Add Turf
                      if (adminData?.status == AdminStatus.approved)
                        Align(
                          alignment: const Alignment(0.8, 0.9),
                          child: InkWell(
                            splashFactory: NoSplash.splashFactory,
                            customBorder: const CircleBorder(),
                            onTap: () {
                              // Navigate to add turf page
                              Get.to(() => const AddTurfPage());
                            },
                            splashColor: const Color(0xFF3636B8).withAlpha(200),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF1E1E82),
                                    blurRadius: 4,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: const Color(0xFF3636B8).withAlpha(200),
                                shape: BoxShape.circle,
                              ),
                              width: size.width * 0.14,
                              height: size.width * 0.145,
                              child: const Center(
                                child: Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(TurfPartnerAdminModel? adminData, Size size) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1E1E82)),
      );
    }

    if (FirebaseAuth.instance.currentUser == null) {
      return const Center(child: Text('Please sign in to view turfs'));
    }

    if (adminData?.status == AdminStatus.pending) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pending_actions, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Account Pending Approval',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Your account is under review. You\'ll be able to manage turfs once approved.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ),
          ],
        ),
      );
    }

    if (adminData?.status == AdminStatus.rejected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Application Rejected',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            if (adminData?.documentVerification.rejectionReason != null)
              Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  adminData!.documentVerification.rejectionReason!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Regular'),
                ),
              ),
          ],
        ),
      );
    }

    if (adminData?.status == AdminStatus.suspended) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Account Suspended',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Your account has been suspended. Please contact support.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ),
          ],
        ),
      );
    }

    // Approved status - show turfs
    if (adminData == null || adminData.turfIds.isEmpty) {
      return const Center(
        child: Text(
          'No turfs assigned yet.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Regular'),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('turfs')
          .where(
            FieldPath.documentId,
            whereIn: adminData.turfIds.isEmpty
                ? ['dummy'] // Prevent empty whereIn
                : adminData.turfIds,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1E1E82)),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'No turfs assigned yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Regular'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? size.width * 0.05 : 0),
              child: Card(
                color: const Color(0xFF1E1E82),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    onTap: () {
                      // Navigate to turf detail page
                      Get.to(
                        () => TurfDetailpage(turfId: doc.id, turfData: data),
                      );
                    },
                    tileColor: Colors.white,
                    title: Text(
                      data['name'] ?? 'Untitled',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Regular',
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['city'] ?? 'No city',
                          style: TextStyle(fontFamily: 'Regular'),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              '${data['rating'] ?? 0.0} • ${data['reviews'] ?? 0} reviews',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.only(
                      right: size.width * 0.03,
                      left: size.width * 0.04,
                      top: size.width * 0.01,
                      bottom: size.width * 0.01,
                    ),
                    trailing: PopupMenuButton<String>(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.to(
                            () => AddTurfPage(
                              existingTurfId: doc.id,
                              existingData: data,
                            ),
                          );
                        } else if (value == 'delete') {
                          _deleteTurf(doc.id, data);
                        } else if (value == 'view') {
                          Get.to(
                            () =>
                                TurfDetailpage(turfId: doc.id, turfData: data),
                          );
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 20),
                              SizedBox(width: 8),
                              Text('View Details'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Update'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Color _getStatusColor(AdminStatus status) {
  //   switch (status) {
  //     case AdminStatus.approved:
  //       return Colors.green;
  //     case AdminStatus.pending:
  //       return Colors.orange;
  //     case AdminStatus.rejected:
  //       return Colors.red;
  //     case AdminStatus.suspended:
  //       return Colors.red.shade700;
  //     case AdminStatus.inactive:
  //       return Colors.grey;
  //   }
  // }

  // String _getStatusText(AdminStatus status) {
  //   switch (status) {
  //     case AdminStatus.approved:
  //       return 'Approved';
  //     case AdminStatus.pending:
  //       return 'Pending';
  //     case AdminStatus.rejected:
  //       return 'Rejected';
  //     case AdminStatus.suspended:
  //       return 'Suspended';
  //     case AdminStatus.inactive:
  //       return 'Inactive';
  //   }
  // }
}
