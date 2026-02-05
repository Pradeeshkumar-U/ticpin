// ignore: must_be_immutable
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ticpin_partner/constants/apikeys.dart';
import 'package:ticpin_partner/constants/colors.dart';
import 'package:ticpin_partner/constants/shimmer.dart';
import 'package:ticpin_partner/constants/size.dart';
import 'package:ticpin_partner/pages/addEvent/addeventpage.dart';
import 'package:ticpin_partner/pages/admineventmanagementpage.dart';
import 'package:ticpin_partner/pages/locationpage.dart';
import 'package:ticpin_partner/pages/profilepage.dart';
import 'package:ticpin_partner/services/eventformprovider.dart';
import 'package:ticpin_partner/services/qrcode.dart';

// ignore: must_be_immutable
class Homepage extends StatefulWidget {
  Homepage({super.key, this.fromLoc});
  String? fromLoc;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
 

  bool _isInitialized = false;

  Future<void> _initializeData() async {
    // await _determinePosition();
    // Ensure auth is initialized
    await FirebaseAuth.instance.authStateChanges().first;
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _deleteEvent(String docId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(docId)
              .get();

      if (!doc.exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Event not found")));
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      final createdBy = data['createdBy'];

      final eventId = data['eventId'];

      if (createdBy != FirebaseAuth.instance.currentUser?.uid) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You can only delete events you created"),
          ),
        );
        return;
      }

      // Ask for confirmation
      final confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder:
            (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Delete Event",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Are you sure you want to permanently delete this event? This action cannot be undone.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text("Delete"),
                ),
              ],
            ),
      );

      // Only delete if user confirmed
      if (confirm != true) return;

      final folder = FirebaseStorage.instance.ref("event_posters/$eventId");
      final listResult = await folder.listAll();

      debugPrint('🗑️ Found ${listResult.items.length} files to delete');

      // Delete all files in the folder
      for (final item in listResult.items) {
        await item.delete();
        debugPrint('🗑️ Deleted file: ${item.fullPath}');
      }

      debugPrint('✅ Folder deleted successfully: $eventId');

      // Perform deletion
      await FirebaseFirestore.instance.collection('events').doc(docId).delete();

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("✅ Event deleted successfully"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
      }
    } catch (e) {
      // Error handling
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text("❌ Failed to delete event: $e"),
              backgroundColor: Colors.red,
            ),
          );
      }
    }
  }


  Sizes size = Sizes();

  @override
  void initState() {
    super.initState();
    // _determinePosition();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Stack(
          children: [
            Container(
              height: kToolbarHeight + MediaQuery.of(context).padding.top * 1.2,
              // color: whiteColor,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(colors: [gradient1, gradient2]),
              ),
            ),
            Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: SizedBox(),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,

                excludeHeaderSemantics: true,
                leadingWidth: 0,

                flexibleSpace: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + size.width * 0.02,
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
                              onTap: () => Get.to(Profile()),
                              child: CircleAvatar(
                                radius: size.width * 0.055,
                                backgroundColor: Colors.white54,
                                child: CircleAvatar(
                                  radius: size.width * 0.04,
                                  backgroundColor: Colors.white70,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Hello !',
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              fontFamily: 'Medium',
                              color: Colors.white.withAlpha(230),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: size.width * 0.04),
                            child: GestureDetector(
                              onTap: () => Get.to(QRpage()),
                              child: SvgPicture.asset(
                                'assets/images/icons/qr code.svg',
                                width: size.width * 0.07,
                                height: size.width * 0.07,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    // Remove the outer StreamBuilder for authStateChanges
                    // Use FirebaseAuth.instance.currentUser directly
                    stream:
                        FirebaseFirestore.instance
                            .collection('events')
                            .where(
                              'createdBy',
                              isEqualTo:
                                  FirebaseAuth.instance.currentUser?.uid ?? '',
                            )
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!_isInitialized) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: size.height * 0.04),
                            child: Center(
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (_) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: size.width * 0.06,
                                    ),
                                    child: LoadingShimmer(
                                      width: size.width * 0.9,
                                      height: size.width * 0.3,
                                      isCircle: false,
                                      radius: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      // Check if user is null
                      if (FirebaseAuth.instance.currentUser == null) {
                        return const Center(
                          child: Text('Please sign in to view events'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: size.height * 0.04),
                            child: Center(
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (_) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: size.width * 0.06,
                                    ),
                                    child: LoadingShimmer(
                                      width: size.width * 0.9,
                                      height: size.width * 0.3,
                                      isCircle: false,
                                      radius: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No events created from this device.',
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
                            padding: EdgeInsets.only(
                              top: index == 0 ? Sizes().width * 0.05 : 0,
                            ),
                            child: Card(
                              color: const Color(0xFF1E1E82),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8 + 2),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ListTile(
                                  onTap: () => Get.to(AdminEventManagementPage(eventId:  data['eventId'],eventData:  data)),
                                  tileColor: Colors.white,
                                  title: Text(data['name'] ?? 'Untitled'),
                                  subtitle: Text(
                                    data['venue']?['name'] ?? 'No venue',
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                    right: Sizes().width * 0.03,
                                    left: Sizes().width * 0.04,
                                    top: Sizes().width * 0.01,
                                    bottom: Sizes().width * 0.01,
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Get.to(
                                          () => AddEventPage(
                                            existingEventId: doc.id,
                                            existingData: data,
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        _deleteEvent(doc.id);
                                      }
                                    },
                                    itemBuilder:
                                        (context) => const [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Update'),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Delete'),
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
                  ),
                  Align(
                    alignment: Alignment(0.8, 0.9),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      customBorder: CircleBorder(),
                      onTap: () {
                        final prov = context.read<EventFormProvider>();
                        prov.reset();
                        Get.to(() => AddEventPage());
                      },
                      splashColor: gradient2.withAlpha(200),

                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: gradient1,
                              blurRadius: 4,
                              offset: Offset(0, 0),
                            ),
                          ],
                          color: gradient2.withAlpha(200),
                          shape: BoxShape.circle,
                        ),

                        width: size.width * 0.14,
                        height: size.width * 0.145,
                        
                        child: Center(
                          child: Icon(Icons.add_rounded, color: whiteColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
