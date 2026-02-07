import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/notification_api_service.dart';

final notificationServiceProvider =
    Provider<NotificationApiService>((ref) {
  return NotificationApiService();
});
