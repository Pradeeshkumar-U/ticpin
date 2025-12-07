import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final ButtonsTabBar _tabBar;

  // final double minTopPadding = Sizes().width * 0.5;
  TabBarDelegate(this._tabBar);
  Sizes size = Sizes();

  @override
  double get minExtent => size.width * 0.41;
  @override
  double get maxExtent => size.width * 0.41;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color: gradient1,
                gradient: LinearGradient(
                  colors: [gradient1, gradient2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // begin: Alignment.topCenter,
                  // end: Alignment.bottomCenter,
                  // stops: [0.1, 1.0],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.05,
                  top: size.width * 0.03,
                  right: size.width * 0.05,
                  bottom: size.height * 0.02,
                ),
                child: Container(
                  height: size.width * 0.12,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white10, width: 1),
                    borderRadius: BorderRadius.circular(13.5),
                  ),
                ),
              ),
            ),

            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.05,
                  // bottom: size.width * 0.05,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // physics: NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.045),
                      _tabBar,
                      SizedBox(width: size.width * 0.045),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant TabBarDelegate oldDelegate) {
    return true;
    // return  ||
    //     minTopPadding != oldDelegate.minTopPadding;
  }
}

class TheatreTabBarDelegate extends SliverPersistentHeaderDelegate {
  final ButtonsTabBar _tabBar;

  // final double minTopPadding = Sizes().width * 0.5;
  TheatreTabBarDelegate(this._tabBar);
  Sizes size = Sizes();

  @override
  double get minExtent => size.width * 0.3;
  @override
  double get maxExtent => size.width * 0.3;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(20),
          //     bottomRight: Radius.circular(20),
          //   ),
          //   child: Container(
          //     width: double.infinity,

          //     decoration: BoxDecoration(
          //       color: gradient1,
          //       gradient: LinearGradient(
          //         colors: [gradient1, gradient2],
          //         // begin: Alignment.topCenter,
          //         // end: Alignment.bottomCenter,
          //         // stops: [0.1, 1.0],
          //       ),
          //     ),
          //     child: Padding(
          //       padding: EdgeInsets.only(
          //         left: size.width * 0.05,
          //         top: size.width * 0.03,
          //         right: size.width * 0.05,
          //         bottom: size.height * 0.02,
          //       ),
          //       child: Container(
          //         height: size.width * 0.12,
          //         width: size.width * 0.9,
          //         decoration: BoxDecoration(
          //           color: Colors.transparent,
          //           border: Border.all(color: Colors.white24, width: 1),
          //           borderRadius: BorderRadius.circular(13.5),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              height: size.height * 0.13,
              width: size.width,
              decoration: BoxDecoration(
                // color: gradient1,
                gradient: LinearGradient(
                  colors: [gradient1, gradient2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // stops: [0.1, 1.0],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: size.width * 0.02),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // physics: NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.01),
                      _tabBar,
                      SizedBox(width: size.width * 0.01),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant TheatreTabBarDelegate oldDelegate) {
    return true;
    // return  ||
    //     minTopPadding != oldDelegate.minTopPadding;
  }
}
