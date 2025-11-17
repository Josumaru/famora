import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famora/core/themes/color_schemes.dart';

class TInputDecorationTheme {
  static InputDecorationTheme getTheme(AppColors colors) {
    return InputDecorationTheme(
      filled: true,
      // fillColor: colors.onSurface.withValues(alpha: 0.1),
      hintStyle: GoogleFonts.manrope(color: colors.onSurface, fontSize: 14),
      labelStyle: GoogleFonts.manrope(
        color: colors.onSurface,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: colors.onSurface),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: colors.onSurface.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: colors.primary, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: colors.error, width: 1),
      ),
    );
  }
}
