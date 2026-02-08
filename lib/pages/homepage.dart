// dining_homepage.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:ticpin_dining/pages/addTurf/adddiningpage.dart';
import 'package:ticpin_dining/services/diningformprovider.dart';

class DiningHomepage extends StatefulWidget {
  const DiningHomepage({super.key});

  @override
  State<DiningHomepage> createState() => _DiningHomepageState();
}

class _DiningHomepageState extends State<DiningHomepage> {
  bool _isInitialized = false;

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

  Future<void> _deleteDining(String docId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('dining')
          .doc(docId)
          .get();

      if (!doc.exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Dining not found")));
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      final createdBy = data['createdBy'];
      final diningId = data['diningId'];

      if (createdBy != FirebaseAuth.instance.currentUser?.uid) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You can only delete dinings you created"),
          ),
        );
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
            "Delete Dining",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to permanently delete this dining? This action cannot be undone.",
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

      if (confirm != true) return;

      // Delete storage files for all image types
      final imageFolders = ['carousel', 'menu', 'about'];

      for (final folder in imageFolders) {
        try {
          final folderRef = FirebaseStorage.instance.ref(
            "dining_posters/$diningId/$folder",
          );
          final listResult = await folderRef.listAll();

          debugPrint(
            '🗑️ Found ${listResult.items.length} files in $folder to delete',
          );

          for (final item in listResult.items) {
            await item.delete();
            debugPrint('🗑️ Deleted file: ${item.fullPath}');
          }

          debugPrint('✅ Folder deleted successfully: $folder');
        } catch (e) {
          debugPrint('⚠️ Error deleting $folder: $e');
        }
      }

      await FirebaseFirestore.instance.collection('dining').doc(docId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("✅ Dining deleted successfully"),
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
              content: Text("❌ Failed to delete dining: $e"),
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
        child: Stack(
          children: [
            Container(
              height: kToolbarHeight + MediaQuery.of(context).padding.top * 1.2,
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
                              onTap: () {}, // Navigate to profile
                              child: CircleAvatar(
                                radius: size.width * 0.055,
                                backgroundColor: Colors.white54,
                                child: CircleAvatar(
                                  radius: size.width * 0.04,
                                  backgroundColor: Colors.white70,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'My Dinings',
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              fontFamily: 'Medium',
                              color: Colors.white.withAlpha(230),
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
                    stream: FirebaseFirestore.instance
                        .collection('dining')
                        .where(
                          'createdBy',
                          isEqualTo:
                              FirebaseAuth.instance.currentUser?.uid ?? '',
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!_isInitialized) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1E1E82),
                          ),
                        );
                      }

                      if (FirebaseAuth.instance.currentUser == null) {
                        return const Center(
                          child: Text('Please sign in to view dinings'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1E1E82),
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
                            'No dinings created yet.',
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
                              top: index == 0 ? size.width * 0.05 : 0,
                            ),
                            child: Card(
                              color: const Color(0xFF1E1E82),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  title: Text(data['name'] ?? 'Untitled'),
                                  subtitle: Text(
                                    data['owner']?['name'] ?? 'No owner info',
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
                                          () => AddDiningPage(
                                            existingDiningId: doc.id,
                                            existingData: data,
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        _deleteDining(doc.id);
                                      }
                                    },
                                    itemBuilder: (context) => const [
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
                    alignment: const Alignment(0.8, 0.9),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      customBorder: const CircleBorder(),
                      onTap: () {
                        final prov = context.read<DiningFormProvider>();
                        prov.reset();
                        Get.to(() => const AddDiningPage());
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
                          child: Icon(Icons.add_rounded, color: Colors.white),
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
