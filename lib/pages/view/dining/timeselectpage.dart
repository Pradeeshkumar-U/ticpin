import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';

class SelectTimingpage extends StatefulWidget {
  const SelectTimingpage({super.key});

  @override
  State<SelectTimingpage> createState() => _SelectTimingpageState();
}

class _SelectTimingpageState extends State<SelectTimingpage> {
  Sizes size = Sizes();
  int itemSelect = -1;
  int timeSelect = -1;
  int selected_person = 1;
  int limited_seat = 20;
  int sel_ind_scroll_date = 0;
  List<String> day = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  List<String> items = ['Breakfast', 'Lunch', 'Dinner'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.safeWidth * 0.04,
                    vertical: size.safeHeight * 0.01,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.safeWidth * 0.04,
                    vertical: size.safeHeight * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(width: 0.5, color: Colors.black54),
                    borderRadius: BorderRadius.circular(
                      size.safeWidth * 0.04 * 0.4,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Select number of peoples",
                        style: TextStyle(
                          fontSize: size.safeWidth * 0.04,
                          fontFamily: 'Regular',
                        ),
                      ),
                      Spacer(),
                      DropdownButton<int>(
                        underline: SizedBox(),
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: whiteColor,
                        alignment: Alignment.center,
                        hint: Text(
                          "Select",
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: size.safeWidth * 0.03,
                          ),
                        ),
                        value: selected_person,
                        items: [
                          for (int i = 1; i <= limited_seat; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Text("$i"),
                              alignment: Alignment.center,
                            ),
                        ],
                        onChanged:
                            (val) => setState(() => selected_person = val!),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.safeHeight * 0.02),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                      child: Text(
                        "Select Day and Time",
                        style: TextStyle(
                          fontSize: size.safeWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.safeHeight * 0.03),
                Padding(
                  padding: EdgeInsets.only(left: size.safeWidth * 0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: -3.14 / 2,
                        child: Container(
                          width: size.safeWidth * 0.16,
                          height: size.safeWidth * 0.1,
                          padding: EdgeInsets.all(size.safeWidth * 0.025),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Month",
                            style: TextStyle(
                              fontSize: size.safeWidth * 0.033,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: List.generate(day.length, (ind) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    sel_ind_scroll_date = ind;
                                  });
                                },
                                child: Container(
                                  width: size.safeWidth * 0.16,
                                  height: size.safeWidth * 0.16,
                                  margin: EdgeInsets.only(
                                    right: size.safeWidth * 0.03,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        ind == sel_ind_scroll_date
                                            ? gradient1.withAlpha(70)
                                            : Colors.black12,
                                    borderRadius: BorderRadius.circular(
                                      size.safeWidth * 0.02,
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          sel_ind_scroll_date == ind
                                              ? gradient1
                                              : Colors.black45,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(
                                    size.safeWidth * 0.03,
                                  ),
                                  child: Text(
                                    "0${ind + 1}\n${day[ind]}",
                                    style: TextStyle(
                                      color: blackColor,
                                      fontFamily: 'Regular',
                                      // fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.safeHeight * 0.03),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.safeWidth * 0.04,
                  ),
                  child: SizedBox(
                    height: size.safeHeight * 0.055,
                    child: GridView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      // shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: size.safeWidth * 0.04,
                        crossAxisSpacing: size.safeWidth * 0.04,
                        // mainAxisExtent: size.safeHeight * 0.15,
                        childAspectRatio: (0.5),
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (mounted) {
                              if (itemSelect == index) {
                                setState(() {
                                  itemSelect = -1;
                                  timeSelect = -1;
                                });
                              } else {
                                setState(() {
                                  itemSelect = index;
                                  timeSelect = -1;
                                });
                              }
                            }
                          },
                          child: Container(
                            // height: size.safeHeight * 0.05,
                            // width: size.safeWidth,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color:
                                    itemSelect == index
                                        ? gradient1
                                        : Colors.black45,
                              ),
                              borderRadius: BorderRadius.circular(17),
                              color:
                                  itemSelect == index
                                      ? gradient1.withAlpha(70)
                                      : Colors.black12,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 0.02),
                                    child: Text(
                                      items[index],
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        // fontSize: size.safeWidth * 0.025,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.safeHeight * 0.03),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.safeWidth * 0.04,
                  ),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: size.safeWidth * 0.04,
                      crossAxisSpacing: size.safeWidth * 0.04,
                      childAspectRatio: (1 / 0.6),
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            if (timeSelect == index) {
                              setState(() {
                                timeSelect = -1;
                              });
                            } else {
                              setState(() {
                                timeSelect = index;
                              });
                            }
                          }
                        },
                        child: Container(
                          height: size.safeHeight * 0.1,

                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color:
                                  timeSelect == index
                                      ? gradient1
                                      : Colors.black45,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color:
                                timeSelect == index
                                    ? gradient1.withAlpha(70)
                                    : Colors.black12,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    '00:00',
                                    style: TextStyle(fontFamily: 'Medium'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 0.0),
                                  child: Text(
                                    '3 offers',
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      // fontSize: size.safeWidth * 0.025,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                      child: Text(
                        "Offers",
                        style: TextStyle(
                          fontSize: size.safeWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.safeWidth * 0.05,
                    bottom: size.safeWidth * 0.28,
                  ),
                  child: Container(
                    width: size.safeWidth * 0.9,
                    height: size.safeWidth * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: size.safeWidth * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Offer name",
                            style: TextStyle(
                              fontSize: size.safeWidth * 0.035,
                              // fontWeight: FontWeight.w600,
                              fontFamily: 'Regular',
                            ),
                          ),
                          Text(
                            "Offer details",
                            style: TextStyle(
                              fontSize: size.safeWidth * 0.033,
                              color: Colors.black54,
                              // fontWeight: FontWeight.w600,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: whiteColor,
              height: size.safeWidth * 0.24,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: size.safeWidth * 0.08,
                  top: size.safeWidth * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(SelectTimingpage());
                      },
                      child: Container(
                        width: size.safeWidth * 0.55,
                        height: size.safeWidth * 0.13,
                        // padding: EdgeInsets.symmetric(
                        //   horizontal: 30,
                        //   vertical: 10,
                        // ),
                        decoration: BoxDecoration(
                          color: gradient2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Proceed to Pay",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              color: Colors.white,
                              fontSize: size.safeWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(SelectTimingpage());
                      },
                      child: Container(
                        width: size.safeWidth * 0.35,
                        height: size.safeWidth * 0.13,
                        // padding: EdgeInsets.symmetric(
                        //   horizontal: 30,
                        //   vertical: 10,
                        // ),
                        decoration: BoxDecoration(
                          color: gradient2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Rs.10000",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              color: Colors.white,
                              fontSize: size.safeWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
