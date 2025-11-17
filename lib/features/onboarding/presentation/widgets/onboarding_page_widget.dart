import 'package:flutter/material.dart';

class OnboardingPageWidget extends StatelessWidget {
  const OnboardingPageWidget({super.key, required this.controller});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) => Positioned.fill(
          child: Image.asset(
            "assets/images/onboarding/onboarding_${index + 1}.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
