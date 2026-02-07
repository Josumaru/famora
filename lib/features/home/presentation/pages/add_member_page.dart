import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:famora/core/themes/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class AddMemberPage extends ConsumerWidget {
  const AddMemberPage({super.key, this.qrcode = ""});
  static final path = "/add-member";
  final String qrcode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // void handleScanResult(BuildContext context, String qrData) {}

    // void showNoCardDialog(BuildContext context, String error) {}

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(title: "My QR Code"),

            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                // child: Row(
                //   spacing: 16,
                //   children: [_buildTab(0, 'Scan QR'), _buildTab(1, 'My QR')],
                // ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: 1 == 0
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.1,
                            ),
                            width: 1,
                          ),
                        ),
                        // child: ClipRRect(
                        //   borderRadius: BorderRadius.circular(24),
                        //   child: AspectRatio(
                        //     aspectRatio: 1 / 1,
                        //     child: MobileScanner(
                        //       onDetect: (capture) {
                        //         final barcode = capture.barcodes.first;
                        //         if (barcode.rawValue != null) {
                        //           handleScanResult(context, barcode.rawValue!);
                        //         }
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),

                          child: QrImageView(
                            data: qrcode,
                            eyeStyle: QrEyeStyle(
                              color: context.colorScheme.onSurface,
                              eyeShape: QrEyeShape.circle,
                            ),
                            semanticsLabel: "FAMORA",
                            foregroundColor: context.colorScheme.onSurface,
                            version: QrVersions.auto,
                            size: MediaQuery.of(context).size.width - 32,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Liatin QR Code nya buat scan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Minta keluarga mu buat gabung pakai QR ini",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              // style: ElevatedButton.styleFrom(
                              //   padding: const EdgeInsets.symmetric(
                              //     vertical: 16,
                              //   ),
                              //   backgroundColor: Colors.yellow.shade600,
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(16),
                              //   ),
                              // ),
                              onPressed: () {
                                SharePlus.instance.share(
                                  ShareParams(
                                    title:
                                        "Masukan kode $qrcode, Ke dalam Aplikasi Famora",
                                    // files:
                                  ),
                                );
                              },
                              child: const Text("Share"),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
