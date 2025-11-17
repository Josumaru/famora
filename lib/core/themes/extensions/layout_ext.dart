import 'package:flutter/material.dart';

extension LayoutContext on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isPortrait => screenHeight > screenWidth;
  bool get isLandscape => screenWidth > screenHeight;

  bool get isSmallDevice => screenWidth < 360;
  bool get isTablet => screenWidth >= 600;

  EdgeInsets get safePadding => MediaQuery.of(this).padding;
}
