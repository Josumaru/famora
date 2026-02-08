import 'dart:convert';
import 'package:famora/core/services/location_service.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendPushMessage(String token) async {
  try {
    logger.d("Mengirim pesan");
    final position = await getCurrentLocation();

    // await db.child("members").child(uid).update({
    // "status": "danger",
    // "timestamp": DateTime.now().toIso8601String(),
    // "lat": position.latitude,
    // "lng": position.longitude,
    // });

    // await db.child("chats").push().set({
    //   "from": FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
    //   "message": "Saya dalam Bahaya!",
    //   "lat": position.latitude,
    //   "lng": position.longitude,
    //   "groupId": groupId,
    //   "timestamp": DateTime.now().toIso8601String(),
    // });

    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/api/send-notification',
    );

    final headers = {'Content-Type': 'application/json'};
    // final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final displayName = prefs.getString("display_name");
    final uid = prefs.getString("uid");
    final groupId = prefs.getString("group_id");
    final bodyData = {
      "title":
          "Anggota keluarga Anda, ${displayName ?? "Keluarga"} Dalam bahaya!",
      "body":
          "Segera beri pertolongan kepada keluarga anda, ${displayName ?? "Keluarga"} untuk menghindari hal yang tidak diinginkan!",
      "fcmToken": token,
      "avatar": "https://avatar.vercel.sh/$uid",
      "userId": uid,
      "name": displayName,
      "type": "call",
      "status": "danger",
      "timestamp": DateTime.now().toIso8601String(),
      "lat": position.latitude,
      "lng": position.longitude,
      "from": displayName ?? "Anonymous",
      "message": "Saya dalam Bahaya!",
      "groupId": groupId,
    };

    await http.post(uri, headers: headers, body: jsonEncode(bodyData));
    logger.d("berhasil kirim telpon");
  } catch (e) {
    logger.f(e);
  }
}
