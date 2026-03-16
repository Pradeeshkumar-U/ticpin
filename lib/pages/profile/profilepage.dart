import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/glass_container.dart';
import 'package:ticpin/constants/models/user/user.dart';
import 'package:ticpin/constants/models/user/userservice.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/home/homepage.dart';
import 'package:ticpin/pages/login/loginpage.dart';
import 'package:ticpin/pages/profile/sub%20pages/appearancepage.dart';
import 'package:ticpin/pages/profile/sub%20pages/faqsupportpage.dart';
import 'package:ticpin/pages/profile/sub%20pages/notificationpage.dart';
import 'package:ticpin/pages/profile/sub%20pages/profilesetuppage.dart';
import 'package:ticpin/pages/profile/sub%20pages/reviewpage.dart';
import 'package:ticpin/pages/profile/sub%20pages/ticlistpage.dart';
import 'package:ticpin/pages/profile/sub%20pages/userbookingspage.dart';
import 'package:ticpin/pages/profile/sub%20pages/voucherspage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool visi = true;
  final double wid = Sizes().width;
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Sizes size = Sizes();

  UserModel? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (mounted) setState(() => isLoading = true);

    try {
      final data = await _userService.getUserData();
      if (mounted) {
        setState(() {
          userData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Logout',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontFamily: 'Regular'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontFamily: 'Regular'),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await _auth.signOut();
        if (mounted) {
          Get.offAll(() => const Loginpage());
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logging out: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => Homepage());
        return false;
      },
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          backgroundColor: Platform.isIOS ? Colors.black : whiteColor,
          appBar:
              visi
                  ? AppBar(
                    elevation: 0,
                    surfaceTintColor:
                        Platform.isIOS ? Colors.black : whiteColor,
                    backgroundColor: Platform.isIOS ? Colors.black : whiteColor,
                    title: Text(
                      "Profile",
                      style: TextStyle(
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w500,
                        color: Platform.isIOS ? whiteColor : Colors.black,
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Platform.isIOS ? whiteColor : Colors.black,
                      ),
                    ),
                  )
                  : null,
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                    children: [
                      if (Platform.isIOS)
                        Container(
                          height: size.height,
                          width: size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [gradient1, gradient2, Colors.black],
                            ),
                          ),
                        ),
                      RefreshIndicator(
                        onRefresh: _loadUserData,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              // Profile Header
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: wid * 0.1,
                                      backgroundColor: Colors.grey.shade300,
                                      backgroundImage:
                                          userData?.profilePicUrl != null
                                              ? NetworkImage(
                                                userData!.profilePicUrl!,
                                              )
                                              : null,
                                      child:
                                          userData?.profilePicUrl == null
                                              ? Icon(
                                                Icons.person,
                                                size: wid * 0.12,
                                                color: Colors.grey.shade600,
                                              )
                                              : null,
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData?.name ??
                                                "Complete Profile",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19,
                                              fontFamily: 'Regular',
                                              color:
                                                  Platform.isIOS
                                                      ? whiteColor
                                                      : Colors.black,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            userData?.phoneNumber ??
                                                "No number",
                                            style: TextStyle(
                                              fontFamily: 'Regular',
                                              color:
                                                  Platform.isIOS
                                                      ? Colors.white70
                                                      : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const ProfileSetupPage(),
                                          ),
                                        );
                                        _loadUserData();
                                      },
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        color:
                                            Platform.isIOS
                                                ? whiteColor
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildSectionTitle("All Bookings"),
                              const SizedBox(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 15),
                                    _buildBookingCard(
                                      "Event Tickets",
                                      const Icon(
                                        Icons.celebration,
                                        color: Colors.white,
                                      ),
                                      Colors.blue,
                                      () => Get.to(
                                        () => UserBookingsPage(index: 1),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    _buildBookingCard(
                                      "Turf Bookings",
                                      const Icon(
                                        Icons.sports_soccer,
                                        color: Colors.white,
                                      ),
                                      Colors.green,
                                      () => Get.to(
                                        () => UserBookingsPage(index: 2),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    _buildBookingCard(
                                      "Dining Bookings",
                                      const Icon(
                                        Icons.restaurant_menu,
                                        color: Colors.white,
                                      ),
                                      Colors.orange,
                                      () => Get.to(
                                        () => UserBookingsPage(index: 3),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildSectionTitle("Vouchers"),
                              const SizedBox(height: 15),
                              _buildMenuBlock([
                                _buildMenuItem(
                                  "Collected Vouchers",
                                  const Icon(
                                    CupertinoIcons.ticket_fill,
                                    color: Colors.black54,
                                  ),
                                  () => Get.to(const VouchersPage()),
                                ),
                              ]),
                              const SizedBox(height: 30),
                              _buildSectionTitle("Manage"),
                              const SizedBox(height: 15),
                              _buildMenuBlock([
                                _buildMenuItem(
                                  "Your Reviews",
                                  const Icon(
                                    Icons.rate_review_rounded,
                                    color: Colors.black54,
                                  ),
                                  () => Get.to(const ReviewsPage()),
                                ),
                                _buildDivider(),
                                _buildMenuItem(
                                  "TicList",
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.black54,
                                  ),
                                  () => Get.to(const TicListPage()),
                                ),
                                _buildDivider(),
                                _buildMenuItem(
                                  "Notifications",
                                  const Icon(
                                    Icons.notifications_active_rounded,
                                    color: Colors.black54,
                                  ),
                                  () => Get.to(const NotificationsPage()),
                                ),
                                _buildDivider(),
                                _buildMenuItem(
                                  "Appearance",
                                  const Icon(
                                    Icons.color_lens_rounded,
                                    color: Colors.black54,
                                  ),
                                  () => Get.to(const AppearancePage()),
                                ),
                              ]),
                              const SizedBox(height: 30),
                              _buildSectionTitle("Support"),
                              const SizedBox(height: 15),
                              _buildMenuBlock([
                                _buildMenuItem(
                                  "Frequently Asked Questions",
                                  const Icon(
                                    Icons.help_rounded,
                                    color: Colors.black54,
                                  ),
                                  () => Get.to(const FAQPage()),
                                ),
                                _buildDivider(),
                                _buildMenuItem(
                                  "Chat with us",
                                  const Icon(
                                    Icons.question_answer_rounded,
                                    color: Colors.black54,
                                  ),
                                  () => Get.to(const ChatSupportPage()),
                                ),
                                _buildDivider(),
                                _buildMenuItem(
                                  "Share feedback",
                                  const Icon(
                                    Icons.feedback_rounded,
                                    color: Colors.black54,
                                  ),
                                  () => Get.to(const FeedbackPage()),
                                ),
                              ]),
                              const SizedBox(height: 30),
                              _buildSectionTitle("More"),
                              const SizedBox(height: 15),
                              _buildMenuBlock([
                                _buildMenuItem(
                                  "Log out",
                                  const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.red,
                                  ),
                                  _handleLogout,
                                  textColor: Colors.red,
                                ),
                              ]),
                              SizedBox(height: Sizes().height * 0.06),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Regular',
          color: Platform.isIOS ? whiteColor : Colors.black,
        ),
      ),
    );
  }

  Widget _buildMenuBlock(List<Widget> children) {
    return Center(
      child: TicpinGlassContainer(
        width: size.safeWidth * 0.92,
        height: size.safeHeight * 0.35,
        borderRadius: 20,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Platform.isIOS ? Colors.white12 : Colors.black12,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    String title,
    Icon icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: TicpinGlassContainer(
        width: wid * 0.4,
        height: wid * 0.4,
        borderRadius: 15,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: icon,
              ),
              const SizedBox(height: 12),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Regular',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    Icon icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            if (Platform.isIOS)
              Icon(icon.icon, color: textColor ?? whiteColor)
            else
              icon,
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Regular',
                  color:
                      textColor ??
                      (Platform.isIOS ? whiteColor : Colors.black87),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Platform.isIOS ? Colors.white38 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Platform.isIOS ? Colors.white12 : Colors.black12,
      margin: EdgeInsets.symmetric(horizontal: wid * 0.05),
    );
  }
}
