import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class LoadingShimmer extends StatelessWidget {
  LoadingShimmer({
    super.key,
    required this.width,
    required this.height,
    required this.isCircle,
    this.baseColor,
    
    this.highColor,
    this.radius = 20,
  });

  final double width;
  final double height;
  final bool isCircle;
  Color? baseColor;
  double radius;
  Color? highColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade200,
      highlightColor: highColor ?? Colors.grey.shade100,
      child:
          isCircle
              ? CircleAvatar(radius: width)
              : ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Container(color: Colors.white),
                ),
              ),
    );
  }
}
