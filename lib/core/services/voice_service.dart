import 'dart:ui';

import 'package:famora/core/services/fcm_service.dart';
import 'package:famora/core/services/location_service.dart';
import 'package:famora/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print('🔥 Service berhasil nyala!');
  await dotenv.load(fileName: ".env");

  DartPluginRegistrant.ensureInitialized();
  final speech = stt.SpeechToText();
  DartPluginRegistrant.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final instance = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: dotenv.env['FIREBASE_DB_URL'],
  );
  final db = instance.ref();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  bool available = await speech.initialize();

  if (!available || uid == null) {
    return;
  } else {}

  speech.listen(
    onResult: (result) async {
      final text = result.recognizedWords.toLowerCase();
      print("🗣️ Dengar: $text");

      if (text.contains("help")) {
        await db.child("member").child(uid).update({
          "status": "danger",
          "timestamp": DateTime.now().toIso8601String(),
        });
        final position = await getCurrentLocation();
        await db.child("chats").push().set({
          "from": FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
          "timestamp": DateTime.now().toIso8601String(),
          "message": "Saya dalam Bahaya!",
          "lat": position.latitude,
          "lng": position.longitude,
        });
        print("🚨 Kata kunci terdeteksi!");
        final userSnapshot = await db
            .child('members')
            .orderByChild('userId')
            .equalTo(uid)
            .once();
        if (userSnapshot.snapshot.value == null) return;

        final userMemberEntry =
            (userSnapshot.snapshot.value as Map).entries.first;
        final userGroupId = userMemberEntry.value['groupId'];

        final membersSnapshot = await db.child('members').once();
        final members = membersSnapshot.snapshot.value as Map;

        List<String> tokensToSend = [];

        members.forEach((_, member) {
          if (member['groupId'] == userGroupId &&
              member['userId'] != uid &&
              member['fcmToken'] != null) {
            tokensToSend.add(member['fcmToken']);
          }
        });

        for (var token in tokensToSend) {
          await sendPushMessage(token);
        }
      }
    },
    listenMode: stt.ListenMode.confirmation,
    partialResults: true,
    onSoundLevelChange: (level) {
      // opsional: print level suara
    },
    onDevice: true,
    cancelOnError: false,
    pauseFor: const Duration(seconds: 5), // tahan sebentar sebelum timeout
    listenFor: const Duration(seconds: 10), // setiap sesi dengar
  );

  speech.statusListener = (status) {
    print("🔄 Status: $status");
    if (status == "notListening") {
      Future.delayed(Duration(seconds: 1), () {
        speech.listen(
          onResult: (result) async {
            final text = result.recognizedWords.toLowerCase();
            print("🗣️ Dengar (ulang): $text");

            if (text.contains("help")) {
              print("🚨 Kata kunci terdeteksi ulang!");
              await db.child("status").child(uid).set({
                "status": "danger",
                "timestamp": DateTime.now().toIso8601String(),
              });
              final position = await getCurrentLocation();
              await db.child("chats").push().set({
                "from":
                    FirebaseAuth.instance.currentUser?.displayName ??
                    "Anonymous",
                "timestamp": DateTime.now().toIso8601String(),
                "message": "Saya dalam Bahaya",
                "lat": position.latitude,
                "lng": position.longitude,
              });
              final userSnapshot = await db
                  .child('members')
                  .orderByChild('userId')
                  .equalTo(uid)
                  .once();
              if (userSnapshot.snapshot.value == null) return;

              final userMemberEntry =
                  (userSnapshot.snapshot.value as Map).entries.first;
              final userGroupId = userMemberEntry.value['groupId'];

              final membersSnapshot = await db.child('members').once();
              final members = membersSnapshot.snapshot.value as Map;

              List<String> tokensToSend = [];

              members.forEach((_, member) {
                if (member['groupId'] == userGroupId &&
                    member['userId'] != uid &&
                    member['fcmToken'] != null) {
                  tokensToSend.add(member['fcmToken']);
                }
              });

              for (var token in tokensToSend) {
                await sendPushMessage(token);
              }
            }
          },
          listenMode: stt.ListenMode.confirmation,
          partialResults: true,
          pauseFor: const Duration(seconds: 5),
          listenFor: const Duration(seconds: 10),
        );
      });
    }
  };
}

Future<void> initializeService() async {
  await Permission.microphone.request();
  await Permission.location.request();
  final status = await Permission.microphone.request();
  final service = FlutterBackgroundService();

  if (status.isGranted) {
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
  } else {
    // toastServiceProvider.sho
  }
}
