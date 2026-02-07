import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/providers/notification_provider.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/core/utils/loading.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/features/chat/data/models/chat_modal.dart';
import 'package:famora/features/chat/presentation/widgets/chat_widget.dart';
import 'package:famora/features/home/presentation/pages/add_member_page.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});
  static String path = "/chat";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbRef = ref.watch(databaseProvider).child("chats");
    final controller = TextEditingController();
    final group = ref.watch(groupProvider);
    final user = ref.watch(currentUserProvider);
    final scrollController = useScrollController(initialScrollOffset: 0);
    final notificationService = ref.read(notificationServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: BoxBorder.fromSTEB(
                    bottom: BorderSide(
                      color: context.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    // Icon(Iconsax.arrow_left_copy),
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        final args = group.value?.group.id;
                        context.push(AddMemberPage.path, extra: args);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.05,
                          ),
                          border: BoxBorder.all(
                            width: 2,
                            color: context.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Icon(Icons.add),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Keluarga ${group.value?.group.name ?? "Tidak ada nama"}",
                            style: context.textTheme.titleMedium,
                          ),
                          Text(
                            (group.value?.members ?? [])
                                .map(
                                  (e) => e.userId == user.value?["userId"]
                                      ? "Kamu"
                                      : e.name ?? "Ga ada nama",
                                )
                                .join(", "),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Icon(Iconsax.call_add_copy),
                    // Icon(Iconsax.more_copy),
                  ],
                ),
              ),

              // Spacer(),
              Expanded(
                child: StreamBuilder(
                  stream: dbRef.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: showLoading(context));
                    }

                    if (!snapshot.hasData ||
                        snapshot.data?.snapshot.value == null) {
                      return Center(child: Text("Belum ada chat"));
                    }

                    final raw = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map,
                    );

                    final messages =
                        raw.entries
                            .map((e) {
                              if (e.value["groupId"] == group.value?.group.id) {
                                return ChatModel.fromMap(e.value);
                              }
                              return null;
                            })
                            .where((element) => element != null)
                            .toList()
                          ..sort(
                            (a, b) =>
                                DateTime.parse(
                                  a?.timestamp ??
                                      DateTime.now().toIso8601String(),
                                ).compareTo(
                                  DateTime.parse(
                                    b?.timestamp ??
                                        DateTime.now().toIso8601String(),
                                  ),
                                ),
                          );
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      if (!scrollController.hasClients) return;

                      await Future.delayed(const Duration(milliseconds: 100));

                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });

                    return ListView.builder(
                      itemCount: messages.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        final chat = messages[index];

                        final rawTime = chat?.timestamp;
                        final dateTime = DateTime.parse(rawTime!);
                        final formattedTime = DateFormat(
                          'dd MMMM yyyy, HH:mm',
                          'id_ID',
                        ).format(dateTime);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 8),
                          child: ChatWidget(
                            time: formattedTime,
                            lat: chat?.lat,
                            lng: chat?.lng,
                            sender: chat?.from ?? "",
                            message: chat?.message ?? "",
                            image: "https://avatar.vercel.sh/${chat?.from}",
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Tulis pesanmu',
                        prefixIcon: Icon(Iconsax.emoji_happy_copy),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Iconsax.camera_copy),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        final message = controller.text;
                        controller.clear();

                        await dbRef.push().set({
                          "from":
                              FirebaseAuth.instance.currentUser?.displayName ??
                              "Anonymous",
                          "timestamp": DateTime.now().toIso8601String(),
                          "message": message,
                          "groupId": group.value?.group.id,
                        });
                        // final members = ref.read(currentUserProvider);
                        // final groupMember = await group.value;
                        final members = group.value?.members ?? [];

                        await Future.wait(
                          members
                              .where(
                                (e) =>
                                    e.fcmToken != null &&
                                    e.userId !=
                                        FirebaseAuth.instance.currentUser?.uid
                                            .toString(),
                              )
                              .map((e) async {
                                await notificationService.sendNotification(
                                  avatar: "https://avatar.vercel.sh/asdad",
                                  fcmToken: e.fcmToken!,
                                  body: message,
                                  title:
                                      "Ada pesan masuk dari Keluarga ${group.value?.group.name} nih!",
                                );
                              }),
                        );
                      } catch (e) {
                        logger.e(e);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Icon(Iconsax.direct_right_copy),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
