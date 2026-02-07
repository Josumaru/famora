import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/providers/toast_provider.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:go_router/go_router.dart';

final TextEditingController _controller = TextEditingController();
bool loading = false;

SliverWoltModalSheetPage joinWidget(WidgetRef ref, BuildContext context) {
  return WoltModalSheetPage(
    hasSabGradient: false,
    topBarTitle: Text('Scan Kode Undangan'),
    isTopBarLayerAlwaysVisible: true,
    trailingNavBarWidget: IconButton(
      padding: const EdgeInsets.all(16),
      icon: const Icon(Icons.close),
      onPressed: Navigator.of(context).pop,
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: context.colorScheme.onSurface.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: MobileScanner(
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                if (barcode.rawValue != null) {
                  joinFamilyGroup(ref, barcode.rawValue!, context);
                }
              },
            ),
          ),
        ),
      ),
    ),
  );
}

void joinFamilyGroup(
  WidgetRef ref,
  String groupId,
  BuildContext context,
) async {
  final user = ref.read(firebaseAuthProvider).currentUser;
  final database = ref.read(databaseProvider);
  if (user == null) {
    ref.read(toastServiceProvider).showError("Kamu belum login");
    return;
  }

  final groupSnapshot = await database.child("groups/$groupId").get();

  if (!groupSnapshot.exists) {
    ref.read(toastServiceProvider).showError("Kode Keluarga gak valid");
    loading = false;

    return;
  }

  final memberSnapshot = await database
      .child("members")
      .orderByChild("userId")
      .equalTo(user.uid)
      .get();

  if (memberSnapshot.exists) {
    final members = memberSnapshot.value as Map;
    final entry = members.entries.first; // ambil data pertama yang cocok

    final key = entry.key;

    await database.child("members").child(key).update({"groupId": groupId});

    logger.d("✅ groupId berhasil diupdate!");
  } else {
    logger.e("❌ Data user belum ada di members.");
  }
  loading = false;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.of(context).pop();
    ref
        .read(toastServiceProvider)
        .showSuccess("Berhasil join keluarga! Jangan bikin onar ya");
    context.pushReplacement('/');
  });
}
