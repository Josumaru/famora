import 'package:flutter/material.dart';

extension AlignmentContextExt on BuildContext {
  MainAxisAlignment get mainCenter => MainAxisAlignment.center;
  MainAxisAlignment get mainSpaceBetween => MainAxisAlignment.spaceBetween;
  CrossAxisAlignment get crossCenter => CrossAxisAlignment.center;
  MainAxisAlignment get mainStart => MainAxisAlignment.start;
  CrossAxisAlignment get crossStart => CrossAxisAlignment.start;
}
