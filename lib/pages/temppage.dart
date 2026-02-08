import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin_dining/pages/login/loginpage.dart';
import 'package:ticpin_dining/services/profilesupport/supportpage.dart';

class Temppage extends StatefulWidget {
  const Temppage({super.key});

  @override
  State<Temppage> createState() => _TemppageState();
}

class _TemppageState extends State<Temppage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Hello there')));
  }
}

// ignore: non_constant_identifier_names
Widget all_booking(String name, Icon ico, Widget nav, double wid) {
  return InkWell(
    splashColor: Colors.transparent,
    overlayColor: WidgetStatePropertyAll(Colors.transparent),
    onTap: () {
      // Table booking edit page
      Get.to(nav);
    },
    child: Container(
      width: wid * 0.4,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        // color: Colors.black.withAlpha(10),
        border: Border.all(color: Colors.black26, width: 1.5),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          ico,
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Regular',
              color: Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget horizon_cont(String tex, Icon ico, Widget? page, double wid) {
  return Container(
    width: wid * 0.9,
    padding: EdgeInsets.all(15),
    child: InkWell(
      splashColor: Colors.transparent,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: () async {
        if (page == Loginpage()) {
          // await FirebaseAuth.instance.signOut();

          Get.offAll(page);
        }
        Get.to(page);
      },
      child: Row(
        children: [
          ico,
          SizedBox(width: 10),
          Text(
            tex,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Regular',
              color: Colors.black54,
            ),
          ),
          Spacer(),
          Icon(Icons.navigate_next, color: Colors.black54),
        ],
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget horizon_cont_big(String tex, Icon ico, Navigator nav, double wid) {
  return Container(
    width: wid * 0.9,
    padding: EdgeInsets.all(15),
    child: InkWell(
      splashColor: Colors.transparent,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: () {
        Get.to(Supportpage());
      },
      child: Row(
        children: [
          ico,
          SizedBox(width: 10),
          Text(
            tex,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Regular',
              color: Colors.black54,
            ),
          ),
          Spacer(),
          Icon(Icons.navigate_next, color: Colors.black54),
        ],
      ),
    ),
  );
}

final dini_cate = [
  {
    "title": "Party\nVibes",
    "1linetitle": "Party Vibes",
    "image": "assets/images/party_vibes1.png",
    "uncrop": "assets/images/party_vibes.png",
  },
  {
    "title": "Cozy\nCafes",
    "1linetitle": "Cozy Cafes",
    "image": "assets/images/cozy_cafes1.png",
    "uncrop": "assets/images/cozy_cafes.png",
  },
  {
    "title": "Drink and\nDine",
    "1linetitle": "Drink and Dine",
    "image": "assets/images/drink_dine1.png",
    "uncrop": "assets/images/drink_dine.png",
  },
  {
    "title": "Family\nDining",
    "1linetitle": "Family Dining",
    "image": "assets/images/family_dining1.png",
    "uncrop": "assets/images/family_dining.png",
  },
  {
    "title": "Pure\nVeg",
    "1linetitle": "Pure Veg",
    "image": "assets/images/pure_veg1.png",
    "uncrop": "assets/images/pure_veg.png",
  },
  {
    "title": "Premium\nDining",
    "1linetitle": "Premium Dining",
    "image": "assets/images/premium_dining1.png",
    "uncrop": "assets/images/premium_dining.png",
  },
];
