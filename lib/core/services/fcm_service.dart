import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future<void> sendPushMessage(String token) async {
  final uri = Uri.parse('http://192.168.0.101:3000/send-notification');

  final headers = {'Content-Type': 'application/json'};
  final user = FirebaseAuth.instance.currentUser;
  final bodyData = {
    "title":
        "Anggota keluarga Anda, ${user?.displayName ?? "Keluarga"} Dalam bahaya!",
    "body":
        "Segera beri pertolongan kepada keluarga anda, ${user?.displayName ?? "Keluarga"} untuk menghindari hal yang tidak diinginkan!",
    "fcmToken": token,
  };

  final response = await http.post(
    uri,
    headers: headers,
    body: jsonEncode(bodyData),
  );

  if (response.statusCode == 200) {
    print('FCM message sent successfully!');
  } else {
    print('Error sending FCM message: ${response.body}');
  }
}
