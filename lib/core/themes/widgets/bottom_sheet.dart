import 'package:cached_network_image/cached_network_image.dart';
import 'package:famora/core/providers/navigation_provider.dart';
import 'package:famora/core/providers/toast_provider.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/core/utils/modal_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

final fcmEventHandlerProvider = Provider<FcmEventHandler>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  return FcmEventHandler(navigatorKey: navigatorKey);
});

class FcmEventHandler {
  final GlobalKey<NavigatorState> navigatorKey;

  FcmEventHandler({required this.navigatorKey});

  void showBottomSheet(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showModalSheet(
      context: context,
      child: Consumer(
        builder: (context, ref, child) {
          final controller = ref.read(navigationProvider);
          return SizedBox(
            width: double.infinity,

            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: CachedNetworkImageProvider(
                      message.data["avatar"],
                    ),
                  ),
                  Text(
                    "${message.data["name"]} Lagi keadaan darurat! buruan segera ambil tindakan",
                    style: context.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.pop();
                            controller.jumpToTab(1);
                          },
                          child: Text("Buka Maps"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    // showModalBottomSheet(
    //   context: context,
    //   builder: (_) => Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Text(message.data.toString()),
    //   ),
    // );
  }
}
