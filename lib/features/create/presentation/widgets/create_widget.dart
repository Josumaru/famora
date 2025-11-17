import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/providers/toast_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:go_router/go_router.dart';

final TextEditingController _controller = TextEditingController();

SliverWoltModalSheetPage createWidget(WidgetRef ref, BuildContext context) {
  return WoltModalSheetPage(
    hasSabGradient: false,
    topBarTitle: Text('Bikin Grup Keluarga'),
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
              labelText: 'Nama Keluargamu',
              prefixIcon: Icon(Iconsax.people_copy),
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
                    child: Center(child: Text('Batalin')),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    createFamilyGroup(ref, _controller.value.text, context);
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Lanjut')),
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

void createFamilyGroup(WidgetRef ref, String name, BuildContext context) async {
  final user = ref.read(firebaseUserProvider);
  final database = ref.read(databaseProvider);
  if (user == null) {
    ref.read(toastServiceProvider).showError("Kamu belum login");
    return;
  }

  final groupRef = database.child("groups").push();
  await groupRef.set({
    "id": groupRef.key,
    "name": name,
    "createdAt": DateTime.now().toIso8601String(),
    "createdBy": user.uid,
  });
  // final memberRef = database.child("members").push();
  await database.child("members/${user.uid}").update({
    "id": groupRef.key,
    "userId": user.uid,
    "groupId": groupRef.key,
    "createdAt": DateTime.now().toIso8601String(),
  });
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    Navigator.of(context).pop();
    ref
        .read(toastServiceProvider)
        .showSuccess("Mantab, Keluarga '$name' berhasil dibuat, ehehe");
    context.pushReplacement('/');
  });
}
