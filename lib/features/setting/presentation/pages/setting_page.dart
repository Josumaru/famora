import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/routes/route_name.dart';
import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final member = ref.watch(currentMemberProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 65,
              backgroundImage: NetworkImage(
                member?["avatar"] ?? "https://avatar.vercel.sh/null",
              ),
            ),
            const SizedBox(height: 16),
            Text(
              member?["name"] ?? "-",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 30),

            // --- MENU LIST ---
            _MenuTile(
              icon: Iconsax.user_copy,
              title: "Akun",
              subtitle: "Lihat & ubah informasi pribadi",
              onTap: () {
                // menuju halaman akun
              },
            ),
            _MenuTile(
              icon: Iconsax.notification_1_copy,
              title: "Notifikasi",
              subtitle: "Atur preferensi pemberitahuan",
              onTap: () {},
            ),
            _MenuTile(
              icon: Iconsax.lock_copy,
              title: "Privasi",
              subtitle: "Kelola izin & keamanan",
              onTap: () {},
            ),
            _MenuTile(
              icon: Iconsax.warning_2_copy,
              title: "Bantuan",
              subtitle: "Pusat bantuan & FAQ",
              onTap: () {},
            ),

            // const Spacer(),

            // --- LOGOUT BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  firebaseAuth.signOut();
                  context.go(RouteName.splash);
                },
                child: const Text("Keluar"),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
