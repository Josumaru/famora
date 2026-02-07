import 'dart:convert';
import 'package:famora/core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotificationApiService {
  Future<void> sendDangerNotification({
    required String fcmToken,
    String? avatar,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/api/send-notification',
    );

    final body = {
      "title":
          "Anggota keluarga Anda, ${user?.displayName ?? "Keluarga"} dalam bahaya!",
      "body":
          "Segera beri pertolongan kepada ${user?.displayName ?? "keluarga"}!",
      "fcmToken": fcmToken,
      "type": "danger",
      "userId": user?.uid,
      "name": user?.displayName,
      "avatar": avatar,
    };

    await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }

  Future<void> sendNotification({
    required String fcmToken,
    String? avatar,
    String? title,
    String? body,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/api/send-notification',
    );
    logger.d(uri);

    final bodyRequest = {
      "title": title ?? "Notifikasi dari Famora",
      "body": body ?? "Anda memiliki notifikasi baru",
      "fcmToken": fcmToken,
      "type": "notification",
      "userId": user?.uid,
      "name": user?.displayName,
      "avatar": avatar,
    };

    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(bodyRequest),
    );
    logger.d(res);
  }
}
