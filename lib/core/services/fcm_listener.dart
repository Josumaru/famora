import 'package:famora/core/utils/modal_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void listenFirebaseCloudMessaging(BuildContext context) {
  FirebaseMessaging.onMessage.listen((message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => showModalSheet(context: context, child: Text('data')),
    );
  });
}
