import 'package:flutter/material.dart';
import 'package:famora/core/providers/theme_provider.dart';
import 'package:famora/core/themes/app_theme.dart';
import 'package:famora/core/themes/color_schemes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:famora/core/routes/app_router.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(AppRouter.routerProvider);
    return MaterialApp.router(
      theme: buildAppTheme(lightColorScheme),
      darkTheme: buildAppTheme(darkColorScheme),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const ScrollBehavior().copyWith(
        overscroll: false,
        physics: const BouncingScrollPhysics(),
      ),
      routerConfig: router,
    );
  }
}
