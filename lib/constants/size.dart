import 'package:flutter/material.dart';

class Sizes {
  final double width;
  final double height;

  Sizes()
      : width = _getWidth(),
        height = _getHeight();

  static double _getWidth() {
    final mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first,
    );
    return mediaQuery.size.width > 450 ? 450 : mediaQuery.size.width;
  }

  static double _getHeight() {
    final mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first,
    );
    return mediaQuery.size.height > 950 ? 950 : mediaQuery.size.height;
  }

  double get aspectRatio => width / height;
}

const defaultPadding = 16.0;
