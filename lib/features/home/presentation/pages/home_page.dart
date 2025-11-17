import 'package:cached_network_image/cached_network_image.dart';
import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider);
    final member = ref.watch(currentMemberProvider).value;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: group.when(
            data: (data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat Malam,",
                            style: context.textTheme.titleLarge,
                          ),
                          Text(member?["name"] ?? "-"),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Icon(Iconsax.notification_1),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          member?["avatar"] ?? "https://avatar.vercel.sh/null",
                        ),
                      ),
                    ],
                  ),
                  Text("Anggota Keluarga ${data?.group.name}"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          data?.members
                              .asMap()
                              .entries
                              .map(
                                (entry) => entry.key == 0
                                    ? Row(
                                        spacing: 8,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                              border: Border.all(
                                                color: context
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                            child: Icon(Iconsax.add_copy),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                        entry.value.avatar ??
                                                            "https://avatar.vercel.sh/null",
                                                      ),
                                                ),
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: Colors.green,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                    entry.value.avatar ??
                                                        "https://avatar.vercel.sh/null",
                                                  ),
                                            ),
                                            CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                              )
                              .toList() ??
                          [],
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) => Text("ads"),
            loading: () => Text('loading'),
          ),
        ),
      ),
    );
  }
}
