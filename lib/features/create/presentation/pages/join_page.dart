import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/features/create/presentation/widgets/join_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class JoinPage extends ConsumerWidget {
  const JoinPage({super.key});
  static final path = "/join-group";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 16,
          ),
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
      ),
    );
  }
}
