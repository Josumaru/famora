import 'dart:async';

import 'package:famora/core/providers/toast_provider.dart';
import 'package:famora/core/providers/voice_provider.dart';
import 'package:famora/core/services/call_service.dart';
import 'package:famora/core/services/message_service.dart';
import 'package:famora/core/services/notification_service.dart';
import 'package:famora/core/services/voice_service.dart';
import 'package:famora/core/state/voice_state.dart';
import 'package:famora/core/themes/widgets/bottom_sheet.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/my_app.dart';
import 'package:famora/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['type'] == 'call') {
    final data = message.data;
    showCallNotification(avatar: data["avatar"], name: data["name"]);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final fcmEventHandler = container.read(fcmEventHandlerProvider);

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await setupNotificationChannel();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  await MessageService.instance.initialize();
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();

  FirebaseMessaging.onMessage.listen((message) {
    if (message.data['type'] == 'call') {
      final data = message.data;
      showCallNotification(avatar: data["avatar"], name: data["name"]);
      fcmEventHandler.showBottomSheet(message);
    } else {}
  });

  await FlutterCallkitIncoming.requestNotificationPermission({
    "title": "Notification permission",
    "rationaleMessagePermission":
        "Notification permission is required, to show notification.",
    "postNotificationMessageRequired":
        "Notification permission is required, Please allow notification permission from setting.",
  });

  // Check if can use full screen intent
  await FlutterCallkitIncoming.canUseFullScreenIntent();

  // Request full intent permission
  await FlutterCallkitIncoming.requestFullIntentPermission();

  await initializeDateFormatting('id_ID', null);

  container.listen<VoiceState>(voiceProvider, (prev, next) async {
    final voiceService = container.read(voiceServiceProvider);

    if (next.enabled) {
      await Future.delayed(const Duration(milliseconds: 300));
      await voiceService.start();
      logger.d("🎧 Voice Service START");
    } else {
      await voiceService.stop();
      logger.d("🛑 Voice Service STOP");
    }
  });

  final service = FlutterBackgroundService();

  service.on('voice:disable').listen((event) {
    logger.d("📩 voice:disable diterima di UI");
    final secretMessage = prefs.getString("voice_keyword");
    container.read(voiceProvider.notifier).toggle(false);
    container
        .read(toastServiceProvider)
        .showInfo("Kata rahasia Kamu '$secretMessage', berhasil di panggil");
  });

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}
