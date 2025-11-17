import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: OutlinedButton(
            onPressed: () {},
            child: Row(children: [Icon(Iconsax.google_copy), Text('Google')]),
          ),
        ),
      ),
    );
  }
}
