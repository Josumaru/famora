import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/providers/toast_provider.dart';
import 'package:famora/core/providers/voice_provider.dart';
import 'package:famora/core/routes/route_name.dart';
import 'package:famora/core/services/voice_service.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/core/utils/loading.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:famora/features/home/presentation/pages/add_member_page.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final member = ref.watch(currentUserProvider).value;

    void handleShowCommingSoon() {
      ref.read(toastServiceProvider).showError("Menu belum tersedia");
    }

    final voice = ref.watch(voiceProvider);

    useEffect(() {
      controller.text = voice.keyword;
      return null;
    }, [voice.keyword]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
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
                member?["name"] ?? "Belum ada nama",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),

              // --- MENU LIST ---
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        "Aktivasi kata rahasia",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      value: voice.enabled,
                      onChanged: (v) async {
                        try {
                          if (v) {
                            final agreed = await showTosBottomSheet(context);
                            if (!agreed) return;
                            final permission = await requestVoicePermissions();
                            if (!permission) {
                              ref
                                  .read(toastServiceProvider)
                                  .showError(
                                    "Permintaan ke ijin di tolak nih~",
                                  );
                              return;
                            }
                          }

                          showLoadingDialog(context);
                          await Future.delayed(Duration(seconds: 2));
                          await ref.read(voiceProvider.notifier).toggle(v);
                          WidgetsBinding.instance.addPostFrameCallback((
                            timeStamp,
                          ) {
                            hideLoadingDialog(context);
                          });
                        } catch (e) {
                          ref
                              .read(toastServiceProvider)
                              .showError(
                                "Terjadi kesalahan, silahkan coba lagi.",
                              );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Kata rahasia (B.Inggris)",
                        ),
                        controller: controller,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            try {
                              final agree = await showTosBottomSheet(context);
                              if (!agree) return;
                              final permission =
                                  await requestVoicePermissions();
                              if (!permission) {
                                ref
                                    .read(toastServiceProvider)
                                    .showError(
                                      "Permintaan ke ijin di tolak nih~",
                                    );
                                return;
                              }
                              showLoadingDialog(context);
                              final text = controller.text;
                              await ref
                                  .read(voiceProvider.notifier)
                                  .setKeyword(text);

                              if (voice.enabled) {
                                await ref
                                    .read(voiceProvider.notifier)
                                    .toggle(false);
                                await Future.delayed(
                                  const Duration(seconds: 3),
                                );
                                await ref
                                    .read(voiceProvider.notifier)
                                    .toggle(true);
                              }
                              await Future.delayed(const Duration(seconds: 5));
                              ref
                                  .read(toastServiceProvider)
                                  .showSuccess(
                                    "Kata rahasia berhasil diperbarui",
                                  );
                              WidgetsBinding.instance.addPostFrameCallback((
                                timeStamp,
                              ) {
                                hideLoadingDialog(context);
                              });
                            } catch (e) {
                              ref
                                  .read(toastServiceProvider)
                                  .showInfo(
                                    "Terjadi kesalahan, silahkan coba lagi.",
                                  );
                              WidgetsBinding.instance.addPostFrameCallback((
                                timeStamp,
                              ) {
                                hideLoadingDialog(context);
                              });
                            }
                          },
                          child: const Text("Ganti kata rahasia"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _MenuTile(
                icon: Iconsax.user_copy,
                title: "Akun",
                subtitle: "Lihat & ubah informasi pribadi",
                onTap: () {
                  handleShowCommingSoon();
                },
              ),
              _MenuTile(
                icon: Iconsax.user_add_copy,
                title: "Undang",
                subtitle: "Undang keluarga anda",
                onTap: () async {
                  final group = await ref.watch(groupProvider.future);

                  context.push(AddMemberPage.path, extra: group?.group.id);
                },
              ),

              _MenuTile(
                icon: Iconsax.notification_1_copy,
                title: "Notifikasi",
                subtitle: "Atur preferensi pemberitahuan",
                onTap: () {
                  handleShowCommingSoon();
                },
              ),

              // _MenuTile(
              //   icon: Iconsax.lock_copy,
              //   title: "Privasi",
              //   subtitle: "Kelola izin & keamanan",
              //   onTap: () {
              //     handleShowCommingSoon();
              //   },
              // ),
              // _MenuTile(
              //   icon: Iconsax.warning_2_copy,
              //   title: "Bantuan",
              //   subtitle: "Pusat bantuan & FAQ",
              //   onTap: () {
              //     handleShowCommingSoon();
              //   },
              // ),

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
      ),
    );
  }
}

Future<bool> showTosBottomSheet(BuildContext context) async {
  const String tosHtml = '''
          <p>Dengan mengaktifkan fitur <b>kata rahasia</b>, kamu menyetujui bahwa:</p>

          <ol>
            <li>Aplikasi akan mendengarkan suara untuk mendeteksi kata darurat.</li>
            <li>Saat kata darurat terdeteksi, aplikasi akan membagikan lokasi kamu saat ini kepada anggota keluarga yang terhubung.</li>
            <li>Data hanya digunakan untuk keperluan keadaan darurat.</li>
          </ol>

          <p>Pastikan kamu memahami dan menyetujui penggunaan fitur ini.</p>
          ''';

  return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Syarat & Ketentuan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  Flexible(
                    child: SingleChildScrollView(
                      child: Html(
                        data: tosHtml,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            fontSize: FontSize(14),
                            lineHeight: LineHeight.number(1.5),
                          ),
                          "ol": Style(padding: HtmlPaddings.only(left: 20)),
                          "li": Style(margin: Margins.only(bottom: 8)),
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Setuju"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
      false;
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          leading: Icon(icon, size: 32),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        ),
      ),
    );
  }
}
