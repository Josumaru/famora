import 'package:famora/core/themes/extensions/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

showLoading<Widget>(BuildContext context) {
  return LoadingAnimationWidget.stretchedDots(
    color: context.colorScheme.primary,
    size: 50,
  );
}

Widget loadingWidget(BuildContext context) {
  return LoadingAnimationWidget.stretchedDots(
    color: context.colorScheme.primary,
    size: 50,
  );
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(child: loadingWidget(context)),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  if (Navigator.of(context, rootNavigator: true).canPop()) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
