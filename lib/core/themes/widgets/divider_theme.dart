import 'package:flutter/material.dart';
import 'package:famora/core/themes/color_schemes.dart';

class TDividerTheme {
  static DividerThemeData getTheme(AppColors colors) {
    return DividerThemeData(
      color: colors.onSurface.withValues(alpha: .2),
      thickness: 1,
      space: 32, // Jarak antar widget sebelum & sesudah Divider
      indent: 0,
      endIndent: 0,
    );
  }
}
