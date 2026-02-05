import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin_partner/constants/colors.dart';
import 'package:ticpin_partner/constants/size.dart';
import 'package:ticpin_partner/pages/login/loginpage.dart';
import 'package:ticpin_partner/pages/temppage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool visi = true;
  final wid = Sizes().width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              )
              : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: wid * 0.1,
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Update Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          fontFamily: 'Regular',
                        ),
                      ),
                      Text("Number", style: TextStyle(fontFamily: 'Regular')),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      //   Edit profile page
                    },
                    icon: Icon(Icons.edit_outlined),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "All Bookings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Regular',
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    all_booking(
                      "Table bookings",
                      Icon(Icons.table_bar_rounded, color: Colors.black54),
                      Temppage(),
                      wid,
                    ),
                    SizedBox(width: 20),
                    all_booking(
                      "Movie tickets",
                      Icon(Icons.movie_rounded, color: Colors.black54),
                      Temppage(),
                      wid,
                    ),
                    SizedBox(width: 20),
                    all_booking(
                      "Event tickets",
                      Icon(CupertinoIcons.tickets_fill, color: Colors.black54),
                      Temppage(),
                      wid,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(height: 30),
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
                    border: Border.all(color: Colors.black26, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      horizon_cont(
                        "Collected Vouchers",
                        Icon(CupertinoIcons.ticket_fill, color: Colors.black54),
                        Temppage(),
                        wid,
                      ),
                      // horizon_cont("", Icon(Icons.card_giftcard), Temppage()),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),
              // Text(
              //   "Payments",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 20,
              //     fontFamily: 'Regular',
              //   ),
              // ),
              // SizedBox(height: 20),
              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey, width: 0.5),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Column(
              //     children: [
              //       horizon_cont(
              //         "Dining transactions",
              //         Icon(Icons.receipt_long),
              //         Temppage(),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 30),
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
                    border: Border.all(color: Colors.black26, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      horizon_cont(
                        "Your Reviews",
                        Icon(Icons.rate_review_rounded, color: Colors.black54),
                        Temppage(),
                        wid,
                      ),
                      Container(
                        height: 1.5,
                        color: Colors.black26,
                        width: wid * 0.8,
                      ),
                      horizon_cont(
                        "TicList",
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.black54,
                        ),
                        Temppage(),
                        wid,
                      ),
                      Container(
                        height: 1.5,
                        color: Colors.black26,
                        width: wid * 0.8,
                      ),
                      horizon_cont(
                        "Movie Remainders",
                        Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.black54,
                        ),
                        Temppage(),
                        wid,
                      ),
                      // Container(
                      //   height: 1.5,
                      //   color: Colors.black26,
                      //   width: wid * 0.8,
                      // ),
                      // horizon_cont(
                      //   "Payment Settings",
                      //   Icon(Icons.wallet, color: Colors.black54),
                      //   Temppage(),
                      //   wid,
                      // ),
                      Container(
                        height: 1.5,
                        color: Colors.black26,
                        width: wid * 0.8,
                      ),
                      horizon_cont(
                        "Appearance",
                        Icon(Icons.color_lens_rounded, color: Colors.black54),
                        Temppage(),
                        wid,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
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
                    border: Border.all(color: Colors.black26, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      horizon_cont(
                        "Frequently Asked Questions",
                        Icon(Icons.help_rounded, color: Colors.black54),
                        Temppage(),
                        wid,
                      ),
                      Container(
                        height: 1.5,
                        color: Colors.black26,
                        width: wid * 0.8,
                      ),
                      horizon_cont(
                        "Chat with us",
                        Icon(
                          Icons.question_answer_rounded,
                          color: Colors.black54,
                        ),
                        Temppage(),
                        wid,
                      ),
                      Container(
                        height: 1.5,
                        color: Colors.black26,
                        width: wid * 0.8,
                      ),
                      horizon_cont(
                        "Share feedback",
                        Icon(Icons.feedback_rounded, color: Colors.black54),
                        Temppage(),
                        wid,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
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
                    border: Border.all(color: Colors.black26, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      horizon_cont(
                        "Log out",
                        Icon(Icons.logout_rounded, color: Colors.black54),
                        Loginpage(),
                        wid,
                      ),
                      // Container(
                      //   height: 1.5,
                      //   color: Colors.black26,
                      //   width: wid * 0.8,
                      // ),
                      // horizon_cont(
                      //   "Chat with us",
                      //   Icon(
                      //     Icons.question_answer_rounded,
                      //     color: Colors.black54,
                      //   ),
                      //   Temppage(),
                      //   wid,
                      // ),
                      // Container(
                      //   height: 1.5,
                      //   color: Colors.black26,
                      //   width: wid * 0.8,
                      // ),
                      // horizon_cont(
                      //   "Share feedback",
                      //   Icon(Icons.feedback_rounded, color: Colors.black54),
                      //   Temppage(),
                      //   wid,
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Sizes().height * 0.06),
            ],
          ),
        ),
      ),
    );
  }
}
