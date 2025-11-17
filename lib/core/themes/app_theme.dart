import 'package:flutter/material.dart';
import 'package:famora/core/themes/color_schemes.dart';
import 'package:famora/core/themes/widgets/chip_theme.dart';
import 'package:famora/core/themes/widgets/divider_theme.dart';
import 'package:famora/core/themes/widgets/input_decoration_theme.dart';
import 'package:famora/core/themes/widgets/outlined_button_theme.dart';
import 'package:famora/core/themes/widgets/tab_bar_theme.dart';
import 'package:famora/core/themes/widgets/text_theme.dart';
import 'widgets/checkbox_theme.dart';
import 'widgets/elevated_button_theme.dart';

ThemeData buildAppTheme(ColorScheme colorScheme) {
  final appColors = AppColors.from(colorScheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    checkboxTheme: TCheckboxTheme.getTheme(appColors),
    elevatedButtonTheme: TElevatedButtonTheme.getTheme(appColors),
    outlinedButtonTheme: TOutlinedButtonTheme.getTheme(appColors),
    textTheme: TTextTheme.getTextTheme(appColors),
    tabBarTheme: TTabBarTheme.getTheme(appColors),
    inputDecorationTheme: TInputDecorationTheme.getTheme(appColors),
    dividerTheme: TDividerTheme.getTheme(appColors),
    chipTheme: TChipTheme.getTheme(appColors),
  );
}
