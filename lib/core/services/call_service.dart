import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

Future<void> showCallNotification({
  required String name,
  required String avatar,
}) async {
  final currentUuid = Uuid().v4();
  CallKitParams callKitParams = CallKitParams(
    id: currentUuid,
    nameCaller: name,
    appName: 'Saya dalam bahaya!',
    avatar: avatar,
    handle: '0123456789',
    type: 0,
    textAccept: 'Terima',
    textDecline: 'Tolak',
    missedCallNotification: NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Keluarga anda $name, Dalam bahaya!',
      callbackText: 'Call back',
    ),
    callingNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Calling...',
      callbackText: 'Hang Up',
    ),
    duration: 30000,
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      logoUrl:
          'https://a.storyblok.com/f/178900/750x422/a988012833/4f2576a9281b601a152146aec41dfe961652868603_main.jpg/m/filters:quality(95)format(webp)',
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      // backgroundUrl:
      //     'https://i.pinimg.com/736x/df/23/e9/df23e903fe0417e0883a7447d2d20e4d.jpg',
      actionColor: '#4CAF50',
      textColor: '#ffffff',
      incomingCallNotificationChannelName: "Incoming Call",
      missedCallNotificationChannelName: "Missed Call",
      isShowCallID: false,
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
}
