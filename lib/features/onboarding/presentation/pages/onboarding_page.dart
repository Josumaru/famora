import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
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
    ref.invalidate(firebaseAuthProvider);
    ref.invalidate(currentUserProvider);
    ref.invalidate(groupProvider);
    ref.invalidate(databaseProvider);

    return Scaffold(
      body: Stack(
        children: [
          OnboardingPageWidget(controller: controller),
          OnboardingGradientWidget(),
          OnboardingContentWidget(controller: controller),
        ],
      ),
    );
  }
}
