import 'package:famora/core/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

final toastServiceProvider = Provider<ToastService>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  return ToastService(navigatorKey);
});
