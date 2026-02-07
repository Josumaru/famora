import 'package:flutter/material.dart';

void showModalSheet({
  required BuildContext context,
  required Widget child,
  bool? enableDrag,
  bool? isDismissible,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: enableDrag ?? true,
    isDismissible: isDismissible ?? true,
    // barrierColor: secondaryColor(context: context).withValues(alpha: 0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
    ),
    builder: (context) => FractionallySizedBox(child: child),
  );
}
