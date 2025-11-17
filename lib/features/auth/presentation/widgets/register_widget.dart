import 'package:famora/core/providers/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:famora/core/routes/route_name.dart';
import 'package:famora/core/themes/extensions/alignment_ext.dart';
import 'package:famora/core/themes/extensions/spacing_ext.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class RegisterWidget extends StatefulHookConsumerWidget {
  const RegisterWidget({super.key});

  @override
  ConsumerState<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends ConsumerState<RegisterWidget> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool agreed = true;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);
    return Padding(
      padding: 16.pa,
      child: Column(
        spacing: 16,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nama',
              prefixIcon: Icon(Iconsax.user_copy),
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Iconsax.direct_inbox_copy),
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: passController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: Icon(Iconsax.eye_copy),
              prefixIcon: Icon(Iconsax.check_copy),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: agreed,
                onChanged: (value) {
                  setState(() {
                    agreed = value ?? false;
                  });
                },
              ),
              Text('Saya setuju dengan syarat dan ketentuan.'),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: agreed
                  ? () async {
                      loading.value = true;
                      final name = nameController.text;
                      final email = emailController.text;
                      final password = passController.text;
                      final token = await FirebaseMessaging.instance.getToken();
                      final db = ref.read(databaseProvider);
                      try {
                        final user = await ref
                            .read(authControllerProvider)
                            .register(
                              name: name,
                              email: email,
                              password: password,
                            );
                        final memberRef = db.child("members/${user.user?.uid}");
                        await memberRef.set({
                          "id": memberRef.key,
                          "userId": user.user?.uid,
                          "name": name,
                          "avatar":
                              "https://avatar.vercel.sh/${user.user?.uid}",
                          "createdAt": DateTime.now().toIso8601String(),
                          "fcmToken": token,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Bagus, Berhasil Mendaftar')),
                        );
                        WidgetsBinding.instance.addPostFrameCallback((
                          timeStamp,
                        ) {
                          context.push(RouteName.create);
                        });
                      } catch (e) {
                        String errorMessage =
                            'Terjadi kesalahan, coba lagi nanti.';

                        if (e is FirebaseAuthException) {
                          switch (e.code) {
                            case 'weak-password':
                              errorMessage = 'Password kamu terlalu lemah~';
                              break;
                            case 'email-already-in-use':
                              errorMessage = 'Email ini sudah terdaftar lho!';
                              break;
                            case 'invalid-email':
                              errorMessage = 'Format emailnya salah tuh~';
                              break;
                            default:
                              errorMessage = 'Ups! ${e.message}';
                          }
                        }

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(errorMessage)));
                      } finally {
                        loading.value = false;
                      }
                    }
                  : null,
              child: Text(loading.value ? "Mohon tunggu..." : 'Buat Akun'),
            ),
          ),
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Atau login dengan',
                  style: context.textTheme.bodyMedium,
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    spacing: 8,
                    mainAxisAlignment: context.mainCenter,
                    children: [Icon(Iconsax.google_copy), Text('Google')],
                  ),
                ),
              ),
              // Expanded(
              //   child: OutlinedButton(
              //     onPressed: () {},
              //     child: Row(
              //       spacing: 8,
              //       mainAxisAlignment: context.mainCenter,
              //       children: [Icon(Iconsax.facebook_copy), Text('Facebook')],
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
