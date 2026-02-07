import 'dart:convert';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/core/utils/modal_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void sendPushMessage(String token) {
  final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/api/send-notification');

  final headers = {'Content-Type': 'application/json'};
  final user = FirebaseAuth.instance.currentUser;

  final bodyData = {
    "title":
        "Anggota keluarga Anda, ${user?.displayName ?? "Keluarga"} Dalam bahaya!",
    "body":
        "Segera beri pertolongan kepada keluarga anda, ${user?.displayName ?? "Keluarga"} untuk menghindari hal yang tidak diinginkan!",
    "fcmToken": token,
    "avatar": "https://avatar.vercel.sh/${user?.displayName}",
    "userId": user?.uid,
    "name": user?.displayName,
    "type": "call",
  };

  http.post(uri, headers: headers, body: jsonEncode(bodyData));
}

void listenFirebaseCloudMessaging(BuildContext context) {
  FirebaseMessaging.onMessage.listen((message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => showModalSheet(context: context, child: Text('data')),
    );
  });
}
