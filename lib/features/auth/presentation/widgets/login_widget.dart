import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/providers/toast_provider.dart';
import 'package:famora/core/routes/route_name.dart';
import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:famora/core/themes/extensions/spacing_ext.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginWidget extends StatefulHookConsumerWidget {
  const LoginWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final rememberMe = useState(false);
    final showPassword = useState(false);
    final loading = useState(false);
    return Padding(
      padding: 16.pa,
      child: Column(
        spacing: 24,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {});
            },
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Iconsax.direct_inbox_copy),
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: passController,
            obscureText: !showPassword.value,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: InkWell(
                onTap: () {
                  showPassword.value = !showPassword.value;
                },
                child: Icon(
                  showPassword.value
                      ? Iconsax.eye_slash_copy
                      : Iconsax.eye_copy,
                ),
              ),
              prefixIcon: Icon(Iconsax.check_copy),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: rememberMe.value,
                onChanged: (value) => {rememberMe.value = !rememberMe.value},
              ),
              Text('Remember me'),
              Spacer(),
              // TextButton(onPressed: () {}, child: Text('Forgot Password')),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary.withValues(
                  alpha:
                      (!loading.value &&
                          (emailController.text.isNotEmpty &&
                              emailController.text != "") &&
                          (passController.text.isNotEmpty &&
                              passController.text != ""))
                      ? 1
                      : .7,
                ),
              ),
              onPressed: () async {
                if (loading.value) return;
                loading.value = true;
                final email = emailController.text;
                final password = passController.text;
                final token = await FirebaseMessaging.instance.getToken();
                final db = ref.read(databaseProvider);
                try {
                  final user = await ref
                      .read(authControllerProvider)
                      .login(email: email, password: password);
                  final memberRef = db.child("members/${user.user?.uid}");
                  await memberRef.update({"fcmToken": token});
                  ref
                      .read(toastServiceProvider)
                      .showInfo("Bagus, Berhasil login");
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    context.push(RouteName.splash);
                  });
                } catch (e) {
                  String errorMessage = 'Terjadi kesalahan, coba lagi nanti.';

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
                      case 'invalid-credential':
                        errorMessage = 'Ups! Email atau password salah';
                        break;
                      default:
                        errorMessage = 'Ups! Ada kesalahan nih';
                    }
                  }

                  ref.read(toastServiceProvider).showError(errorMessage);
                } finally {
                  loading.value = false;
                }
              },
              child: Text(loading.value ? "Sedang Login..." : 'Login'),
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(child: Divider()),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 12),
          //       child: Text(
          //         'Atau Login dengan',
          //         style: context.textTheme.bodyMedium,
          //       ),
          //     ),
          //     Expanded(child: Divider()),
          //   ],
          // ),
          // Row(
          //   spacing: 8,
          //   children: [
          //     Expanded(
          //       child: OutlinedButton(
          //         onPressed: () {},
          //         child: Row(
          //           spacing: 8,
          //           mainAxisAlignment: context.mainCenter,
          //           crossAxisAlignment: context.crossCenter,
          //           children: [
          //             SvgPicture.asset(
          //               'assets/images/logos/google.svg',
          //               width: 24,
          //               height: 24,
          //             ),
          //             // Text('Google'),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
