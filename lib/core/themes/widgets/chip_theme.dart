import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famora/core/themes/color_schemes.dart';

class TChipTheme {
  static ChipThemeData getTheme(AppColors colors) {
    return ChipThemeData(
      backgroundColor: colors.primary.withValues(alpha: 0.25),
      disabledColor: colors.surface.withValues(alpha: 0.5),
      selectedColor: colors.primaryContainer,
      secondarySelectedColor: colors.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: colors.primary,
      ),
      secondaryLabelStyle: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.onSecondaryContainer,
      ),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(color: colors.primary),
      ),
      // deleteIconColor: colors.onSurfaceVariant,
      // selectedShadowColor: colors.shadow,
      // surfaceTintColor: colors.surfaceTint,
      showCheckmark: false,
    );
  }
}
