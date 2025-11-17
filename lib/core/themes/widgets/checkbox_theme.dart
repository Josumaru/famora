import 'package:flutter/material.dart';
import 'package:famora/core/themes/color_schemes.dart';

class TCheckboxTheme {
  static CheckboxThemeData getTheme(AppColors colors) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey;
        }
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return colors.onSurface;
      }),
      checkColor: WidgetStateProperty.all(colors.onPrimary),
      overlayColor: WidgetStateProperty.all(
        colors.primary.withValues(alpha: 0.2, red: 0.2, green: 0.2, blue: 0.2),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}
