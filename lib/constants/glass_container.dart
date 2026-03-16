import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:ticpin/constants/colors.dart';

class TicpinGlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double blur;
  final double border;
  final double linearGradientOpacity;
  final double borderGradientOpacity;

  const TicpinGlassContainer({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.borderRadius = 20,
    this.blur = 15,
    this.border = 1.5,
    this.linearGradientOpacity = 0.1,
    this.borderGradientOpacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    bool isIOS = false;
    try {
      isIOS = Platform.isIOS;
    } catch (e) {
      isIOS = false;
    }

    if (isIOS) {
      return GlassmorphicContainer(
        width: width,
        height: height,
        borderRadius: borderRadius,
        blur: blur,
        alignment: Alignment.center,
        border: border,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(linearGradientOpacity),
            Colors.white.withOpacity(0.05),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(borderGradientOpacity),
            Colors.white.withOpacity(0.2),
          ],
        ),
        child: child,
      );
    } else {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: whiteColor.withOpacity(linearGradientOpacity),
          border: Border.all(
            color: whiteColor.withOpacity(borderGradientOpacity * 0.5),
            width: border,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      );
    }
  }
}
