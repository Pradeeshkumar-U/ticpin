import 'package:flutter/material.dart';

class Sizes {
  final double width;
  final double height;
  final double safeWidth;
  final double safeHeight;
  final double topPadding;
  final double bottomPadding;

  Sizes()
      : width = _getWidth(),
        height = _getHeight(),
        safeWidth = _getSafeWidth(),
        safeHeight = _getSafeHeight(),
        topPadding = _getTopPadding(),
        bottomPadding = _getBottomPadding();

  // --------- RAW WIDTH (CAPPED AT 450) ---------
  static double _getWidth() {
    final mq = _mediaQuery();
    final w = mq.size.width;
    return w > 450 ? 450 : w;
  }

  // -------- RAW HEIGHT (CAPPED AT 950) ----------
  static double _getHeight() {
    final mq = _mediaQuery();
    final h = mq.size.height;
    return h > 950 ? 950 : h;
  }

  // -------- SAFE WIDTH (removes curved edges / punch areas) --------
  static double _getSafeWidth() {
    final mq = _mediaQuery();
    final safeW = mq.size.width - mq.padding.left - mq.padding.right;
    return safeW > 450 ? 450 : safeW;
  }

  // -------- SAFE HEIGHT (removes notches & gesture bar) --------
  static double _getSafeHeight() {
    final mq = _mediaQuery();
    final safeH = mq.size.height - mq.padding.top - mq.padding.bottom;
    return safeH > 950 ? 950 : safeH;
  }

  // -------- TOP NOTCH / STATUS BAR HEIGHT ----------
  static double _getTopPadding() {
    return _mediaQuery().padding.top;
  }

  // -------- BOTTOM GESTURE / SAFE AREA ------------
  static double _getBottomPadding() {
    return _mediaQuery().padding.bottom;
  }

  // -------- HELPER (required for background context access) -------
  static MediaQueryData _mediaQuery() {
    return MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first,
    );
  }

  // Aspect ratio of usable safe area
  double get aspectRatio => safeWidth / safeHeight;
}
