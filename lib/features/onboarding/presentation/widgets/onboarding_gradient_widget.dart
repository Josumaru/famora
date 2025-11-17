import 'package:flutter/material.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';

class OnboardingGradientWidget extends StatelessWidget {
  const OnboardingGradientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              context.colorScheme.surface.withValues(alpha: 1),
              context.colorScheme.surface.withValues(alpha: 0.2),
              context.colorScheme.surface.withValues(alpha: 1),
            ],
          ),
        ),
      ),
    );
  }
}
