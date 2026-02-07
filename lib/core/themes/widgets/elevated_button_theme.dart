import 'package:flutter/material.dart';
import 'package:famora/core/themes/color_schemes.dart';
import 'package:famora/core/themes/widgets/text_theme.dart';

class TElevatedButtonTheme {
  static ElevatedButtonThemeData getTheme(AppColors colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: colors.surface,
        backgroundColor: colors.primary,
        shadowColor: Colors.transparent,
        disabledBackgroundColor: Colors.grey,
        disabledForegroundColor: Colors.grey,
        side: BorderSide(color: colors.primary),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        textStyle: TTextTheme.getTextTheme(colors).titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
      ),
    );
  }
}
