import 'package:famora/core/utils/logger.dart';
import 'package:famora/features/create/presentation/widgets/create_widget.dart';
import 'package:famora/features/create/presentation/widgets/join_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class CreatePage extends HookConsumerWidget {
  const CreatePage({super.key});
  static String path = "/create_group";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/create/create_1.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 16,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModal(ref, context, createWidget);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.add_copy, size: 32),
                      Text('Buat Grup Keluarga'),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    showModal(ref, context, joinWidget);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.login_1_copy, size: 32),
                      Text('Bergabung Grup'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showModal(
  WidgetRef ref,
  BuildContext context,
  SliverWoltModalSheetPage Function(WidgetRef, BuildContext) modal,
) {
  WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (modalSheetContext) {
      return [modal(ref, modalSheetContext)];
    },
    modalTypeBuilder: (context) {
      final size = MediaQuery.sizeOf(context).width;
      if (size < 1) {
        return WoltModalType.bottomSheet();
      } else {
        return WoltModalType.dialog();
      }
    },
    onModalDismissedWithBarrierTap: () {
      logger.d('Closed modal sheet with barrier tap');
      Navigator.of(context).pop();
    },
  );
}
