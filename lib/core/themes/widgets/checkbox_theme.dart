import 'package:flutter/material.dart';
import 'package:famora/core/themes/color_schemes.dart';

class TCheckboxTheme {
  static CheckboxThemeData getTheme(AppColors colors) {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

      side: BorderSide(width: 1.2, color: colors.outline ?? colors.primary),

      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.surfaceVariant ?? colors.primary;
        }
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return Colors.transparent;
      }),

      checkColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.onSurface.withValues(alpha: 0.38);
        }
        return colors.onPrimary;
      }),

      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
          return colors.primary.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return colors.primary.withValues(alpha: 0.12);
        }
        return null;
      }),

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
