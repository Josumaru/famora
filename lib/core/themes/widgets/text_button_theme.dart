import 'package:flutter/material.dart';
import 'package:famora/core/themes/color_schemes.dart';
import 'package:famora/core/themes/widgets/text_theme.dart';

class TTextButtonTheme {
  static TextButtonThemeData getTheme(AppColors colors) {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(colors.primary),
        overlayColor: WidgetStateProperty.all(
          colors.primary.withValues(alpha: 0.1),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
        textStyle: WidgetStateProperty.all(
          TTextTheme.getTextTheme(colors).bodyLarge,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
        ),
      ),
    );
  }
}
