import 'package:famora/core/services/message_service.dart';
import 'package:famora/core/services/notification_service.dart';
import 'package:famora/core/services/voice_service.dart';
import 'package:famora/my_app.dart';
import 'package:famora/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // FirebaseAuth.instance.signOut();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await setupNotificationChannel();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // await initializeService();
  await MessageService.instance.initialize();
  await initializeDateFormatting('id_ID', null);
  runApp(ProviderScope(child: MyApp()));
}
