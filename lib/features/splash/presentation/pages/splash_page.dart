// features/splash/presentation/pages/splash_page.dart
import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:famora/core/routes/route_name.dart';
import 'package:go_router/go_router.dart';
import 'package:famora/features/auth/presentation/providers/auth_state_provider.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final database = ref.watch(databaseProvider);

    return authState.when(
      data: (user) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final userId = user?.uid;

          if (user == null) {
            context.go(RouteName.onboarding);
            return;
          }
          final memberRef = database.child("members");
          final snapshot = await memberRef
              .orderByChild("userId")
              .equalTo(userId)
              .get();
          await Future.delayed(Duration(seconds: 2));
          if (context.mounted) {
            if (snapshot.exists) {
              final data = (snapshot.value as Map).values.first;
              final hasGroup = data["groupId"] != null;
              if (hasGroup) {
                context.go(RouteName.root);
              } else {
                context.go(RouteName.create);
              }
            } else {
              context.go(RouteName.create);
            }
          }
        });
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Text(
                  'FAMORA',
                  style: context.textTheme.displayLarge!.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 40,
              //   left: 0,
              //   right: 0,
              //   child: Text(
              //     "Pandu Software Company",
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: Text('FAMORA'))),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
