import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/pages/view/dining/timeselectpage.dart';

class DiningBillpage extends StatefulWidget {
  const DiningBillpage({super.key});

  @override
  State<DiningBillpage> createState() => _DiningBillpageState();
}

class _DiningBillpageState extends State<DiningBillpage> {
  Sizes size = Sizes();
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dining name',
              style: TextStyle(
                fontSize: size.safeWidth * 0.035,
                fontFamily: 'Regular',
              ),
            ),
            Text(
              'Location',
              style: TextStyle(
                fontSize: size.safeWidth * 0.03,
                fontFamily: 'Regular',
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: size.safeHeight * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.safeWidth * 0.06,
                  vertical: size.safeWidth * 0.05,
                ),
                child: Row(
                  children: [
                    Text(
                      'Enter your bill amount to pay',
                      style: TextStyle(
                        fontSize: size.safeWidth * 0.04,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.safeWidth * 0.06,
                ),
                child: Container(
                  height: size.safeHeight * 0.07,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: blackColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontSize: size.safeWidth * 0.04,
                              // fontFamily: 'Regular',
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(0),

                        border: InputBorder.none,
                        hintText: '0.00',
                      ),
                      maxLines: 1,
                      cursorColor: Colors.black54,
                      cursorHeight: size.safeWidth * 0.06,

                      style: TextStyle(
                        fontSize: size.safeWidth * 0.04,
                        fontFamily: 'Regular',
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.safeHeight * 0.05),
              SizedBox(
                // height: size.safeHeight * 0.2,
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.safeWidth * 0.05,
                  ),
                  shrinkWrap: true,
                  itemCount: 4,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: size.safeWidth * 0.05,
                    // mainAxisSpacing: size.safeWidth * 0.0,
                    mainAxisExtent: size.safeWidth * 0.28,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          height: size.safeWidth * 0.11,
                          width: size.safeWidth * 0.4,
                          decoration: BoxDecoration(
                            color: gradient2,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.safeWidth * 0.03,
                                ),
                                child: Text(
                                  'Offer name',
                                  style: TextStyle(
                                    fontSize: size.safeWidth * 0.03,
                                    fontFamily: 'Regular',
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: size.safeWidth * 0.1,
                          width: size.safeWidth * 0.4,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border(
                              left: BorderSide(width: 1, color: Colors.black87),
                              right: BorderSide(
                                width: 1,
                                color: Colors.black87,
                              ),
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.black87,
                              ),
                            ),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.safeWidth * 0.03,
                                ),
                                child: Text(
                                  'Details',
                                  style: TextStyle(
                                    fontSize: size.safeWidth * 0.03,
                                    fontFamily: 'Regular',
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
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: size.safeWidth * 0.08),
              child: InkWell(
                onTap: () {
                  Get.to(SelectTimingpage());
                },
                child: Container(
                  width: size.safeWidth * 0.9,
                  height: size.safeWidth * 0.13,
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 30,
                  //   vertical: 10,
                  // ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Proceed to Pay",
                      style: TextStyle(
                        fontFamily: 'Regular',
                        color: Colors.black,
                        fontSize: size.safeWidth * 0.04,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
