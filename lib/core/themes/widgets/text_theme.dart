import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:famora/core/themes/color_schemes.dart';

class TTextTheme {
  static TextTheme getTextTheme(AppColors colors) {
    return TextTheme(
      // Display
      displayLarge: GoogleFonts.outfit(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        height: 64 / 57,
        color: colors.onSurface,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 52 / 45,
        color: colors.onSurface,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 44 / 36,
        color: colors.onSurface,
      ),

      // Headline
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        color: colors.onSurface,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 36 / 28,
        color: colors.onSurface,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: colors.onSurface,
      ),

      // Title
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 28 / 22,
        color: colors.onSurface,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        color: colors.onSurface,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        color: colors.onSurface,
      ),

      // Body
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: colors.onSurface,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: colors.onSurface,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: colors.onSurface,
      ),

      // Label
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        color: colors.onSurface,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: colors.onSurface.withOpacity(0.85),
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 16 / 11,
        color: colors.onSurface.withOpacity(0.7),
      ),
    );
  }
}
