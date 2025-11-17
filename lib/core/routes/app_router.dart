import 'package:famora/core/providers/toast_provider.dart';
import 'package:famora/features/create/presentation/pages/create_page.dart';
import 'package:famora/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:famora/features/splash/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:famora/core/routes/route_name.dart';
import 'package:famora/features/auth/presentation/pages/auth_page.dart';
import 'package:famora/features/navigation/presentation/pages/navigation_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppRouter {
  static final routerProvider = Provider<GoRouter>((ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: RouteName.splash,
      routes: [
        GoRoute(
          path: RouteName.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RouteName.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: RouteName.auth,
          builder: (context, state) => const AuthPage(),
        ),
        GoRoute(
          path: RouteName.root,
          builder: (context, state) => const NavigationPage(),
        ),
        GoRoute(
          path: RouteName.create,
          builder: (context, state) => const CreatePage(),
        ),
      ],
    );
  });
}
