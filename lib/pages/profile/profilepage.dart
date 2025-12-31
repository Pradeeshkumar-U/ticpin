// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ticpin/constants/colors.dart';
// import 'package:ticpin/constants/services.dart';
// import 'package:ticpin/constants/size.dart';
// import 'package:ticpin/main.dart';
// import 'package:ticpin/pages/login/loginpage.dart';
// import 'package:ticpin/pages/temppage.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   bool visi = true;
//   final wid = Sizes().width;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: true,
//       top: false,
//       child: Scaffold(
//         backgroundColor: whiteColor,
//         appBar:
//             visi
//                 ? AppBar(
//                   elevation: 0,
//                   surfaceTintColor: whiteColor,
//                   backgroundColor: whiteColor,
//                   title: Text(
//                     "Profile",
//                     style: TextStyle(
//                       fontFamily: 'Regular',
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   leading: IconButton(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     icon: Icon(Icons.arrow_back),
//                   ),
//                 )
//                 : null,
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     SizedBox(width: 10),
//                     CircleAvatar(
//                       radius: wid * 0.1,
//                       backgroundColor: Colors.black,
//                     ),
//                     SizedBox(width: 20),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Update Name",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 19,
//                             fontFamily: 'Regular',
//                           ),
//                         ),
//                         Text("Number", style: TextStyle(fontFamily: 'Regular')),
//                       ],
//                     ),
//                     Spacer(),
//                     IconButton(
//                       onPressed: () {
//                         //   Edit profile page
//                       },
//                       icon: Icon(Icons.edit_outlined),
//                     ),
//                     SizedBox(width: 20),
//                   ],
//                 ),
//                 SizedBox(height: 30),
//                 Text(
//                   "All Bookings",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     fontFamily: 'Regular',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       SizedBox(width: 5),
//                       all_booking(
//                         "Table bookings",
//                         Icon(Icons.table_bar_rounded, color: Colors.black54),
//                         Temppage(),
//                         wid,
//                       ),
//                       SizedBox(width: 20),
//                       all_booking(
//                         "Movie tickets",
//                         Icon(Icons.movie_rounded, color: Colors.black54),
//                         Temppage(),
//                         wid,
//                       ),
//                       SizedBox(width: 20),
//                       all_booking(
//                         "Event tickets",
//                         Icon(
//                           CupertinoIcons.tickets_fill,
//                           color: Colors.black54,
//                         ),
//                         Temppage(),
//                         wid,
//                       ),
//                       SizedBox(width: 10),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Text(
//                   "Vouchers",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     fontFamily: 'Regular',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black26, width: 1.5),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         horizon_cont(
//                           "Collected Vouchers",
//                           Icon(
//                             CupertinoIcons.ticket_fill,
//                             color: Colors.black54,
//                           ),
//                           Temppage(),
//                           wid,
//                         ),
//                         // horizon_cont("", Icon(Icons.card_giftcard), Temppage()),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // SizedBox(height: 30),
//                 // Text(
//                 //   "Payments",
//                 //   style: TextStyle(
//                 //     fontWeight: FontWeight.bold,
//                 //     fontSize: 20,
//                 //     fontFamily: 'Regular',
//                 //   ),
//                 // ),
//                 // SizedBox(height: 20),
//                 // Container(
//                 //   decoration: BoxDecoration(
//                 //     border: Border.all(color: Colors.grey, width: 0.5),
//                 //     borderRadius: BorderRadius.circular(20),
//                 //   ),
//                 //   child: Column(
//                 //     children: [
//                 //       horizon_cont(
//                 //         "Dining transactions",
//                 //         Icon(Icons.receipt_long),
//                 //         Temppage(),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 SizedBox(height: 30),
//                 Text(
//                   "Manage",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     fontFamily: 'Regular',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black26, width: 1.5),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         horizon_cont(
//                           "Your Reviews",
//                           Icon(
//                             Icons.rate_review_rounded,
//                             color: Colors.black54,
//                           ),
//                           Temppage(),
//                           wid,
//                         ),
//                         Container(
//                           height: 1.5,
//                           color: Colors.black26,
//                           width: wid * 0.8,
//                         ),
//                         horizon_cont(
//                           "TicList",
//                           Icon(
//                             Icons.local_fire_department_rounded,
//                             color: Colors.black54,
//                           ),
//                           Temppage(),
//                           wid,
//                         ),
//                         Container(
//                           height: 1.5,
//                           color: Colors.black26,
//                           width: wid * 0.8,
//                         ),
//                         horizon_cont(
//                           "Movie Remainders",
//                           Icon(
//                             Icons.notifications_active_rounded,
//                             color: Colors.black54,
//                           ),
//                           Temppage(),
//                           wid,
//                         ),
//                         // Container(
//                         //   height: 1.5,
//                         //   color: Colors.black26,
//                         //   width: wid * 0.8,
//                         // ),
//                         // horizon_cont(
//                         //   "Payment Settings",
//                         //   Icon(Icons.wallet, color: Colors.black54),
//                         //   Temppage(),
//                         //   wid,
//                         // ),
//                         Container(
//                           height: 1.5,
//                           color: Colors.black26,
//                           width: wid * 0.8,
//                         ),
//                         horizon_cont(
//                           "Appearance",
//                           Icon(Icons.color_lens_rounded, color: Colors.black54),
//                           Temppage(),
//                           wid,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Text(
//                   "Support",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     fontFamily: 'Regular',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black26, width: 1.5),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         horizon_cont(
//                           "Frequently Asked Questions",
//                           Icon(Icons.help_rounded, color: Colors.black54),
//                           Temppage(),
//                           wid,
//                         ),
//                         Container(
//                           height: 1.5,
//                           color: Colors.black26,
//                           width: wid * 0.8,
//                         ),
//                         horizon_cont(
//                           "Chat with us",
//                           Icon(
//                             Icons.question_answer_rounded,
//                             color: Colors.black54,
//                           ),
//                           Temppage(),
//                           wid,
//                         ),
//                         Container(
//                           height: 1.5,
//                           color: Colors.black26,
//                           width: wid * 0.8,
//                         ),
//                         horizon_cont(
//                           "Share feedback",
//                           Icon(Icons.feedback_rounded, color: Colors.black54),
//                           Temppage(),
//                           wid,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Text(
//                   "More",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     fontFamily: 'Regular',
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black26, width: 1.5),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         horizon_cont(
//                           "Log out",
//                           Icon(Icons.logout_rounded, color: Colors.black54),
//                           Loginpage(),
//                           wid,
//                         ),
//                         // Container(
//                         //   height: 1.5,
//                         //   color: Colors.black26,
//                         //   width: wid * 0.8,
//                         // ),
//                         // horizon_cont(
//                         //   "Chat with us",
//                         //   Icon(
//                         //     Icons.question_answer_rounded,
//                         //     color: Colors.black54,
//                         //   ),
//                         //   Temppage(),
//                         //   wid,
//                         // ),
//                         // Container(
//                         //   height: 1.5,
//                         //   color: Colors.black26,
//                         //   width: wid * 0.8,
//                         // ),
//                         // horizon_cont(
//                         //   "Share feedback",
//                         //   Icon(Icons.feedback_rounded, color: Colors.black54),
//                         //   Temppage(),
//                         //   wid,
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: Sizes().height * 0.06),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
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
  final wid = Sizes().width;
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    try {
      final data = await _userService.getUserData();
      if (mounted) {
        setState(() {
          userData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Logout', style: TextStyle(fontFamily: 'Regular')),
            content: Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: TextStyle(fontFamily: 'Regular')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Logout', style: TextStyle(fontFamily: 'Regular')),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await _auth.signOut();
        if (mounted) {
          Get.offAll(() => Loginpage());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged out successfully'),
              backgroundColor: Colors.green,
            ),
          );
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

  Sizes size = Sizes();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => Homepage());
        return false; // prevent default back
      },
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar:
              visi
                  ? AppBar(
                    elevation: 0,
                    surfaceTintColor: whiteColor,
                    backgroundColor: whiteColor,
                    title: Text(
                      "Profile",
                      style: TextStyle(
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back),
                    ),
                  )
                  : null,
          body:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                    onRefresh: _loadUserData,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),

                          // Profile Header
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(width: 10),
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
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userData?.name ?? "Complete Profile",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                          fontFamily: 'Regular',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        userData?.phoneNumber ?? "No number",
                                        style: TextStyle(
                                          fontFamily: 'Regular',
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      if (userData?.email != null) ...[
                                        SizedBox(height: 2),
                                        Text(
                                          userData!.email!,
                                          style: TextStyle(
                                            fontFamily: 'Regular',
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ProfileSetupPage(),
                                      ),
                                    );
                                    _loadUserData(); // Refresh data after editing
                                  },
                                  icon: Icon(Icons.edit_outlined),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          // All Bookings Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "All Bookings",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: 15),

                                Row(
                                  children: [
                                    // SizedBox(width: 5),
                                    _buildBookingCard(
                                      "Event Tickets",
                                      Icon(
                                        Icons.celebration,
                                        color: Colors.white,
                                      ),
                                      Colors.blue,
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    UserBookingsPage(index: 1),
                                          ),
                                        );
                                      },
                                      userData?.eventBookings.length ?? 0,
                                    ),
                                    SizedBox(width: 15),
                                    _buildBookingCard(
                                      "Turf Bookings",
                                      Icon(
                                        Icons.sports_soccer,
                                        color: Colors.white,
                                      ),
                                      Colors.green,
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    UserBookingsPage(index: 2),
                                          ),
                                        );
                                      },
                                      userData?.turfBookings.length ?? 0,
                                    ),
                                    SizedBox(width: 15),
                                    _buildBookingCard(
                                      "Dining Bookings",
                                      Icon(
                                        Icons.restaurant_menu,
                                        color: Colors.white,
                                      ),
                                      Colors.orange,
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    UserBookingsPage(index: 3),
                                          ),
                                        );
                                      },
                                      userData?.diningBookings.length ?? 0,
                                    ),
                                    // SizedBox(width: 15),
                                    // _buildBookingCard(
                                    //   "All Bookings",
                                    //   Icon(Icons.receipt_long, color: Colors.white),
                                    //   Colors.orange,
                                    //   () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder:
                                    //             (context) => UserBookingsPage(),
                                    //       ),
                                    //     );
                                    //   },
                                    //   (userData?.eventBookings.length ?? 0) +
                                    //       (userData?.turfBookings.length ?? 0),
                                    // ),
                                  ],
                                ),
                                SizedBox(width: 15),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          // Vouchers Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vouchers",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildMenuItem(
                                          "Collected Vouchers",
                                          Icon(
                                            CupertinoIcons.ticket_fill,
                                            color: Colors.black54,
                                          ),
                                          () {
                                            // Navigate to vouchers page
                                            Get.to(VouchersPage());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 30),

                                // Manage Section
                                Text(
                                  "Manage",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildMenuItem(
                                          "Your Reviews",
                                          Icon(
                                            Icons.rate_review_rounded,
                                            color: Colors.black54,
                                          ),
                                          () {
                                            Get.to(ReviewsPage());
                                          },
                                        ),
                                        _buildDivider(),
                                        _buildMenuItem(
                                          "TicList",
                                          Icon(
                                            Icons.local_fire_department_rounded,
                                            color: Colors.black54,
                                          ),
                                          () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => TicListPage(),
                                              ),
                                            );
                                          },
                                          badge: userData?.ticList.totalCount,
                                        ),
                                        _buildDivider(),
                                        _buildMenuItem(
                                          "Notifications",
                                          Icon(
                                            Icons.notifications_active_rounded,
                                            color: Colors.black54,
                                          ),
                                          () {
                                            Get.to(NotificationsPage());
                                          },
                                        ),
                                        _buildDivider(),
                                        _buildMenuItem(
                                          "Appearance",
                                          Icon(
                                            Icons.color_lens_rounded,
                                            color: Colors.black54,
                                          ),
                                          () {
                                            Get.to(AppearancePage());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 30),

                                // Support Section
                                Text(
                                  "Support",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildMenuItem(
                                          "Frequently Asked Questions",
                                          Icon(
                                            Icons.help_rounded,
                                            color: Colors.black54,
                                          ),
                                          () {
                                            Get.to(FAQPage());
                                          },
                                        ),
                                        _buildDivider(),
                                        _buildMenuItem(
                                          "Chat with us",
                                          Icon(
                                            Icons.question_answer_rounded,
                                            color: Colors.black54,
                                          ),
                                          () {
                                            Get.to(ChatSupportPage());
                                          },
                                        ),
                                        _buildDivider(),
                                        _buildMenuItem(
                                          "Share feedback",
                                          Icon(
                                            Icons.feedback_rounded,
                                            color: Colors.black54,
                                          ),
                                          () {
                                            Get.to(FeedbackPage());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 30),

                                // More Section
                                Text(
                                  "More",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildMenuItem(
                                          "Log out",
                                          Icon(
                                            Icons.logout_rounded,
                                            color: Colors.red,
                                          ),
                                          _handleLogout,
                                          textColor: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: Sizes().height * 0.06),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    String title,
    Icon icon,
    Color color,
    VoidCallback onTap,
    int count,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: wid * 0.4,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          // boxShadow: [
          //   BoxShadow(
          //     color: color.withOpacity(0.3),
          //     blurRadius: 8,
          //     offset: Offset(0, 4),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: icon,
            ),
            SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Regular',
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '$count bookings',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontFamily: 'Regular',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    Icon icon,
    VoidCallback onTap, {
    Color? textColor,
    int? badge,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            icon,
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Regular',
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            // if (badge != null && badge > 0)
            //   CircleAvatar(
            //     radius: size.safeWidth * 0.03,
            //     backgroundColor: Colors.red,
            //     child: Text(
            //       badge.toString(),
            //       style: TextStyle(
            //         color: Colors.white,
            //         // fontSize: 12,
            //         fontWeight: FontWeight.bold,
            //         fontFamily: 'Regular',
            //       ),
            //     ),
            //   ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.5,
      color: Colors.black26,
      margin: EdgeInsets.symmetric(horizontal: wid * 0.1),
    );
  }
}
