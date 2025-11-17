import 'package:flutter/material.dart';

extension SpacingExtension on num {
  /// SizedBox height
  SizedBox get h => SizedBox(height: toDouble());

  /// SizedBox width
  SizedBox get w => SizedBox(width: toDouble());

  /// Gap: SizedBox square (both height & width)
  SizedBox get gap => SizedBox(height: toDouble(), width: toDouble());

  /// Padding horizontal only
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: toDouble());

  /// Padding vertical only
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: toDouble());

  /// Padding all
  EdgeInsets get pa => EdgeInsets.all(toDouble());

  /// Padding only top
  EdgeInsets get pt => EdgeInsets.only(top: toDouble());

  /// Padding only bottom
  EdgeInsets get pb => EdgeInsets.only(bottom: toDouble());

  /// Padding only left
  EdgeInsets get pl => EdgeInsets.only(left: toDouble());

  /// Padding only right
  EdgeInsets get pr => EdgeInsets.only(right: toDouble());
}
