import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ToastService {
  final GlobalKey<NavigatorState> navigatorKey;

  ToastService(this.navigatorKey);

  void show({
    required String message,
    Color? background = Colors.black,
    required IconData icon,
  }) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      DelightToastBar(
        builder: (context) => ToastCard(
          leading: Icon(icon, size: 28),
          color: background,
          title: Text(message),
        ),
      ).show(context);
    } else {
      debugPrint("Gagal menampilkan toast: context null");
    }
  }

  void showSuccess(String msg) => show(
    message: msg,
    icon: Iconsax.copy_success_copy,
    background: navigatorKey.currentContext?.colorScheme.primary,
  );
  void showError(String msg) => show(
    message: msg,
    icon: Iconsax.danger_copy,
    background: navigatorKey.currentContext?.colorScheme.error,
  );
  void showInfo(String msg) => show(
    message: msg,
    icon: Iconsax.info_circle_copy,
    background: navigatorKey.currentContext?.colorScheme.surface,
  );
}
