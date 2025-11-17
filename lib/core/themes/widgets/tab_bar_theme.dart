import 'package:flutter/material.dart';
import 'package:famora/core/themes/color_schemes.dart';
import 'package:famora/core/themes/widgets/text_theme.dart';

class TTabBarTheme {
  static TabBarThemeData getTheme(AppColors colors) {
    final textTheme = TTextTheme.getTextTheme(colors);

    return TabBarThemeData(
      labelColor: colors.onPrimary,
      unselectedLabelColor: colors.onSurface.withValues(alpha: 0.6),
      labelStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
      unselectedLabelStyle: textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w800,
      ),
      indicator: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      overlayColor: WidgetStatePropertyAll(
        colors.primary.withValues(alpha: 0.1),
      ),
    );
  }
}
