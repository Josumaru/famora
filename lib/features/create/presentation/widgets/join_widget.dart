import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/providers/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:go_router/go_router.dart';

final TextEditingController _controller = TextEditingController();
bool loading = false;

SliverWoltModalSheetPage joinWidget(WidgetRef ref, BuildContext context) {
  return WoltModalSheetPage(
    hasSabGradient: false,
    topBarTitle: Text('Masukan Kode Undangan'),
    isTopBarLayerAlwaysVisible: true,
    trailingNavBarWidget: IconButton(
      padding: const EdgeInsets.all(16),
      icon: const Icon(Icons.close),
      onPressed: Navigator.of(context).pop,
    ),
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Kode',
              prefixIcon: Icon(Iconsax.chart_copy),
              suffixIcon: Icon(Iconsax.scan_barcode_copy),
            ),
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Batal')),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    loading = false;
                    if (!loading) {
                      joinFamilyGroup(ref, _controller.text, context);
                    } else {
                      return;
                    }
                  },

                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: Text(loading ? 'Gabung' : 'Tunggu')),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void joinFamilyGroup(
  WidgetRef ref,
  String groupId,
  BuildContext context,
) async {
  final user = ref.read(firebaseUserProvider);
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

    print("✅ groupId berhasil diupdate!");
  } else {
    print("❌ Data user belum ada di members.");
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
