import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticpin_partner/constants/colors.dart';
import 'package:ticpin_partner/constants/size.dart';

class Supportpage extends StatefulWidget {
  const Supportpage({super.key});

  @override
  State<Supportpage> createState() => _SupportpageState();
}

class _SupportpageState extends State<Supportpage> {
  Sizes size = Sizes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        actions: [
          Text(
            'All support tickets    ',
            style: TextStyle(
              fontSize: size.width * 0.035,
              fontFamily: 'Regular',
            ),
          ),
        ],
        surfaceTintColor: whiteColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Chat with us',
              style: TextStyle(fontSize: 20, fontFamily: 'Medium'),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: chatwithusContainer(
                      Icon(Icons.textsms_rounded, color: Colors.black54),
                      'App support',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    child: chatwithusContainer(
                      Icon(Icons.movie_rounded, color: Colors.black54),
                      'Movie support',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    child: chatwithusContainer(
                      Icon(Icons.local_dining_rounded, color: Colors.black54),
                      'Dining support',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    child: chatwithusContainer(
                      Icon(CupertinoIcons.tickets_fill, color: Colors.black54),
                      'Event support',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Open Tickets',
              style: TextStyle(fontSize: 20, fontFamily: 'Medium'),
            ),
          ),
          // Add more FAQs as needed
        ],
      ),
    );
  }

  Container chatwithusContainer(Icon ico, String tex) => Container(
    height: size.width * 0.15,
    width: size.width * 0.9,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26, width: 1.5),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: size.width * 0.03),
        ico,
        SizedBox(width: size.width * 0.03),
        Text(
          tex,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Regular',
            fontSize: size.width * 0.038,
            color: Colors.black54,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.navigate_next, color: Colors.black54),
        ),
      ],
    ),
  );
}
