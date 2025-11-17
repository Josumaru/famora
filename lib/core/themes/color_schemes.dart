import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 78, 187, 241),
  onPrimary: Color(0xFF1D1D1D),
  primaryContainer: Color.fromARGB(255, 185, 251, 248),
  onPrimaryContainer: Color(0xFF1A1A1A),
  secondary: Color(0xFF7D7D7D),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD8D8D8),
  onSecondaryContainer: Color(0xFF1A1A1A),

  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1A1A1A),

  error: Color(0xFFB00020),
  onError: Color(0xFFFFFFFF),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 78, 187, 241),
  onPrimary: Color(0xFF1A1A1A),
  primaryContainer: Color.fromARGB(255, 0, 90, 108),
  onPrimaryContainer: Color.fromARGB(255, 230, 252, 255),

  secondary: Color(0xFFB5B5B5),
  onSecondary: Color(0xFF1A1A1A),
  secondaryContainer: Color(0xFF3D3D3D),
  onSecondaryContainer: Color(0xFFEAEAEA),

  surface: Color(0xFF1E1E1E),
  onSurface: Color(0xFFFFFFFF),

  error: Color.fromARGB(255, 250, 51, 41),
  onError: Color.fromARGB(255, 29, 29, 29),
);

class AppColors {
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;

  final Color surface;
  final Color onSurface;

  final Color error;
  final Color onError;

  final Color? background;
  final Color? onBackground;
  final Color? surfaceVariant;
  final Color? onSurfaceVariant;
  final Color? outline;
  final Color? outlineVariant;
  final Color? inverseSurface;
  final Color? onInverseSurface;
  final Color? inversePrimary;
  final Color? shadow;
  final Color? scrim;
  final Color? surfaceTint;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    this.background,
    this.onBackground,
    this.surfaceVariant,
    this.onSurfaceVariant,
    this.outline,
    this.outlineVariant,
    this.inverseSurface,
    this.onInverseSurface,
    this.inversePrimary,
    this.shadow,
    this.scrim,
    this.surfaceTint,
  });

  static AppColors from(ColorScheme scheme) => AppColors(
    primary: scheme.primary,
    onPrimary: scheme.onPrimary,
    primaryContainer: scheme.primaryContainer,
    onPrimaryContainer: scheme.onPrimaryContainer,
    secondary: scheme.secondary,
    onSecondary: scheme.onSecondary,
    secondaryContainer: scheme.secondaryContainer,
    onSecondaryContainer: scheme.onSecondaryContainer,
    surface: scheme.surface,
    onSurface: scheme.onSurface,
    error: scheme.error,
    onError: scheme.onError,
    background: scheme.surface,
    onBackground: scheme.onSurface,
    surfaceVariant: scheme.surfaceContainerHighest,
    onSurfaceVariant: scheme.onSurfaceVariant,
    outline: scheme.outline,
    outlineVariant: scheme.outlineVariant,
    inverseSurface: scheme.inverseSurface,
    onInverseSurface: scheme.onInverseSurface,
    inversePrimary: scheme.inversePrimary,
    shadow: scheme.shadow,
    scrim: scheme.scrim,
    surfaceTint: scheme.surfaceTint,
  );
}
