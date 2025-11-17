import 'package:cached_network_image/cached_network_image.dart';
import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/features/chat/data/models/chat_modal.dart';
import 'package:famora/features/chat/presentation/widgets/chat_widget.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbRef = ref.watch(databaseProvider).child("chats");
    final controller = TextEditingController();
    final group = ref.watch(groupProvider);
    final scrollController = ScrollController();

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
                    Icon(Iconsax.arrow_left_copy),
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        "https://pbs.twimg.com/media/GeSZdOJXQAA6f1a?format=jpg&name=large",
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.value?.group.name ?? "Tidak ada nama",
                            style: context.textTheme.titleMedium,
                          ),
                          Text(
                            group.value!.members.map((e) => e.name).join(", "),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(Iconsax.call_add_copy),
                    Icon(Iconsax.more_copy),
                  ],
                ),
              ),

              // Spacer(),
              Expanded(
                child: StreamBuilder(
                  stream: dbRef.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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
                            .map((e) => ChatModel.fromMap(e.value))
                            .toList()
                          ..sort(
                            (a, b) => DateTime.parse(
                              a.timestamp,
                            ).compareTo(DateTime.parse(b.timestamp)),
                          );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController.jumpTo(
                          scrollController.position.maxScrollExtent,
                        );
                      }
                    });
                    return ListView.builder(
                      itemCount: messages.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        final chat = messages[index];

                        final rawTime = chat.timestamp;
                        final dateTime = DateTime.parse(rawTime);
                        final formattedTime = DateFormat(
                          'dd MMMM yyyy, HH:mm',
                          'id_ID',
                        ).format(dateTime);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: ChatWidget(
                            time: formattedTime,
                            lat: chat.lat,
                            lng: chat.lng,
                            sender: chat.from,
                            message: chat.message,
                            image: "https://avatar.vercel.sh/${chat.from[0]}",
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
                        await dbRef.push().set({
                          "from":
                              FirebaseAuth.instance.currentUser?.displayName ??
                              "Anonymous",
                          "timestamp": DateTime.now().toIso8601String(),
                          "message": controller.text,
                          "groupId": group.value?.group.id,
                          // "lat": position.latitude,
                          // "lng": position.longitude,
                        });
                      } catch (e) {
                        logger.e(e);
                      }

                      // FocusScope.of(context).unfocus();
                      controller.clear();
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
