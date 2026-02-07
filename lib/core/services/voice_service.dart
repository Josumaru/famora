import 'dart:ui';

import 'package:famora/core/providers/voice_provider.dart';
import 'package:famora/core/services/fcm_service.dart';
import 'package:famora/core/services/location_service.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isProcessing = false;
DateTime? lastSentAt;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  logger.d('🔥 Service berhasil nyala!');
  DartPluginRegistrant.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final speech = stt.SpeechToText();
  service.on('stop').listen((event) async {
    await speech.stop();
    service.stopSelf();
  });
  final available = await speech.initialize();

  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (!available || uid == null) return;

  final instance = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: dotenv.env['FIREBASE_DB_URL'],
  );
  final db = instance.ref();

  service.on('danger-detected').listen((event) async {
    await handleDanger(service, db, uid);
  });
  Future<bool> canSendNow() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString('last_sent_at');

    if (last == null) return true;

    final lastTime = DateTime.parse(last);
    return DateTime.now().difference(lastTime) >= const Duration(seconds: 5);
  }

  Future<void> markSentNow() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sent_at', DateTime.now().toIso8601String());
  }

  Future<void> startListening() async {
    final (enabled, keyword) = await loadVoiceSetting();
    // logger.d("keyword: $keyword");
    if (!enabled) return;

    if (!speech.isListening) {
      try {
        await speech.listen(
          onDevice: false,
          cancelOnError: false,
          partialResults: true,
          listenMode: stt.ListenMode.search,
          onResult: (result) async {
            final text = result.recognizedWords.toLowerCase();
            if (!result.finalResult || text.isEmpty) return;

            if (!text.contains(keyword)) return;

            if (isProcessing) return;

            if (!await canSendNow()) return;

            isProcessing = true;

            try {
              await markSentNow(); // 🔐 LOCK GLOBAL
              // await speech.stop();
              await handleDanger(service, db, uid);
            } finally {
              isProcessing = false;
              // logger.d("Set isProcessing to: false");
            }
          },
        );
      } catch (e) {
        // logger.f(e);
      }
    }
  }

  speech.statusListener = (status) {
    // logger.d("starting");
    if (isProcessing) return;

    if (status == 'done' || status == 'notListening') {
      startListening();
    }
  };

  await startListening();
}

Future<(bool, String)> loadVoiceSetting() async {
  final prefs = await SharedPreferences.getInstance();

  final enabled = prefs.getBool('voice_enabled') ?? false;
  final keyword = prefs.getString('voice_keyword') ?? 'help';
  return (enabled, keyword.toLowerCase());
}

Future<void> handleDanger(
  ServiceInstance service,
  DatabaseReference db,
  String uid,
) async {
  try {
    logger.d("🚨 Kata kunci terdeteksi!");

    final userSnapshot = await db
        .child('members')
        .orderByChild('userId')
        .equalTo(uid)
        .once();

    logger.f("userSnapshot: $userSnapshot");

    if (userSnapshot.snapshot.value == null) return;

    final userEntry = (userSnapshot.snapshot.value as Map).entries.first;
    final groupId = userEntry.value['groupId'];

    final position = await getCurrentLocation();

    await db.child("members").child(uid).update({
      "status": "danger",
      "timestamp": DateTime.now().toIso8601String(),
      "lat": position.latitude,
      "lng": position.longitude,
    });

    await db.child("chats").push().set({
      "from": FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
      "message": "Saya dalam Bahaya!",
      "lat": position.latitude,
      "lng": position.longitude,
      "groupId": groupId,
      "timestamp": DateTime.now().toIso8601String(),
    });

    final membersSnapshot = await db.child('members').once();
    final members = membersSnapshot.snapshot.value as Map;

    for (final member in members.values) {
      if (member['groupId'] == groupId &&
          member['userId'] != uid &&
          member['fcmToken'] != null) {
        sendPushMessage(member['fcmToken']);
      }
    }
    service.invoke('voice:disable');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voice_enabled', false);
  } catch (e) {
    logger.e(e);
  }
}

Future<bool> requestVoicePermissions() async {
  // Request dulu
  final micStatus = await Permission.microphone.request();
  final locStatus = await Permission.locationWhenInUse.request();

  // Cek hasil akhirnya
  final isGranted = micStatus.isGranted && locStatus.isGranted;

  return isGranted;
}

Future<void> initializeService() async {
  // final status = await Permission.microphone.request();
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'voice_service',
      initialNotificationTitle: 'Voice Listening',
      initialNotificationContent: 'Famora berjalan di latar belakang',
      foregroundServiceTypes: [AndroidForegroundType.microphone],
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
  // if (status.isGranted) {
  // } else {
  //   logger.e("Error");
  //   // toastServiceProvider.sho
  // }
}
