import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:famora/core/routes/route_name.dart';
import 'package:famora/core/themes/extensions/layout_ext.dart';
import 'package:famora/core/themes/extensions/spacing_ext.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingContentWidget extends HookConsumerWidget {
  const OnboardingContentWidget({super.key, required this.controller});

  final PageController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final contents = [
      {
        "title": "Hindari Tindak Kejahatan Keluarga",
        "description":
            "Famora memberikan informasi terkini tentang kejahatan di sekitar Anda.",
      },
      {
        "title": "Hindari Tindak Kejahatan Keluarga",
        "description":
            "Famora memberikan informasi terkini tentang kejahatan di sekitar Anda.",
      },
      {
        "title": "Hindari Tindak Kejahatan Keluarga",
        "description":
            "Famora memberikan informasi terkini tentang kejahatan di sekitar Anda.",
      },
    ];
    return SafeArea(
      child: Positioned.fill(
        top: 0,
        child: Padding(
          padding: 16.pa,
          child: Column(
            spacing: 16,
            children: [
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  onDotClicked: (index) => {
                    controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    currentIndex.value = index,
                  },
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: context.screenWidth * 0.18,
                    activeDotColor: context.colorScheme.primary,
                    dotColor: context.colorScheme.onSurface,
                  ),
                ),
              ),
              Spacer(),
              Text(
                contents[currentIndex.value]['title']!,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                contents[currentIndex.value]['description']!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  // OutlinedButton(
                  //   child: const Icon(Iconsax.arrow_left_copy),
                  //   onPressed: () {
                  //     if (currentIndex.value > 0) {
                  //       currentIndex.value--;
                  //       controller.animateToPage(
                  //         currentIndex.value,
                  //         duration: const Duration(milliseconds: 300),
                  //         curve: Curves.easeInOut,
                  //       );
                  //     }
                  //   },
                  // ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentIndex.value < 2) {
                          currentIndex.value++;
                          controller.animateToPage(
                            currentIndex.value,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go(RouteName.auth);
                        }
                      },
                      child: Text(
                        currentIndex.value == 2
                            ? "Mulai Sekarang"
                            : "Selanjutnya",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
