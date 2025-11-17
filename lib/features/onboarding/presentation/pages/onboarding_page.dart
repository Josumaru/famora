import 'package:flutter/material.dart';
import 'package:famora/features/onboarding/presentation/widgets/onboarding_content_widget.dart';
import 'package:famora/features/onboarding/presentation/widgets/onboarding_gradient_widget.dart';
import 'package:famora/features/onboarding/presentation/widgets/onboarding_page_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController controller = PageController(initialPage: 0);

    return Scaffold(
      body: Expanded(
        child: Stack(
          children: [
            OnboardingPageWidget(controller: controller),
            OnboardingGradientWidget(),
            OnboardingContentWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}
