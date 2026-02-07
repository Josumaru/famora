import 'package:cached_network_image/cached_network_image.dart';
import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/core/themes/widgets/error_message_widget.dart';
import 'package:famora/core/utils/loading.dart';
import 'package:famora/features/home/domain/entities/group_member_entity.dart';
import 'package:famora/features/home/domain/entities/member_entity.dart';
import 'package:famora/features/home/presentation/pages/add_member_page.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider);
    final user = ref.watch(currentUserProvider).value;
    RefreshController refreshController = RefreshController(
      initialRefresh: false,
    );
    void onRefresh() async {
      await Future.delayed(Duration(milliseconds: 1000));
      var _ = ref.refresh(groupProvider);
      var _ = ref.refresh(currentUserProvider);

      refreshController.refreshCompleted();
    }

    void onLoading() async {
      await Future.delayed(Duration(milliseconds: 1000));
      refreshController.loadComplete();
    }

    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          controller: refreshController,
          onLoading: onLoading,
          header: ClassicHeader(
            idleIcon: Icon(
              Iconsax.direct_down_copy,
              color: context.colorScheme.onSurface,
            ),
            idleText: "Tarik kebawah buat refresh",
            releaseText: "Lepaskan biar ke refresh",
            refreshingText: "Lagi nge refresh",
            releaseIcon: Icon(
              Iconsax.refresh_copy,
              color: context.colorScheme.onSurface,
            ),
          ),
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: group.when(
              data: (data) {
                final sortedMembers = [...?data?.members];

                final currentUserId = user?["userId"];
                sortedMembers.sort((a, b) {
                  if (a.userId == currentUserId && b.userId != currentUserId) {
                    return -1;
                  }
                  if (a.userId != currentUserId && b.userId == currentUserId) {
                    return 1;
                  }
                  return 0;
                });
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
                            Text(user?["name"] ?? "-"),
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
                            user?["avatar"] ??
                                "https://avatar.vercel.sh/null",
                          ),
                        ),
                      ],
                    ),
                    Text("Anggota Keluarga ${data?.group.name}"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            sortedMembers
                                .asMap()
                                .entries
                                .map(
                                  (entry) => AvatarWidget(
                                    context,
                                    data,
                                    entry,
                                    user?["userId"],
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Center(child: Text("Ada masalah"))),
              loading: () => Center(child: showLoading(context)),
            ),
          ),
        ),
      ),
    );
  }

  Row AvatarWidget(
    BuildContext context,
    GroupMemberEntity? data,
    MapEntry<int, MemberEntity> entry,
    String currentUserId,
  ) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (entry.key == 0) ...[
          InkWell(
            onTap: () {
              context.push(AddMemberPage.path, extra: data?.group.id);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(Iconsax.add_copy),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(
                      entry.value.avatar ?? "https://avatar.vercel.sh/null",
                    ),
                  ),
                  CircleAvatar(radius: 8, backgroundColor: Colors.green),
                ],
              ),
              SizedBox(
                width: 59,
                child: Center(
                  child: Text(
                    entry.value.userId == currentUserId
                        ? "Anda"
                        : entry.value.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
