import 'package:famora/core/notifier/voice_notifier.dart';
import 'package:famora/core/services/voice_service.dart';
import 'package:famora/core/state/voice_state.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final voiceProvider = StateNotifierProvider<VoiceNotifier, VoiceState>(
  (ref) => VoiceNotifier(),
);

final voiceServiceProvider = Provider<VoiceService>((ref) {
  return VoiceService();
});

class VoiceService {
  Future<void> start() async {
    final service = FlutterBackgroundService();

    final isRunning = await service.isRunning();
    logger.d("🎧 isRunning = $isRunning");

    if (isRunning) return;

    await initializeService();
    await service.startService();
  }

  Future<void> restart() async {
    await stop();
    await Future.delayed(const Duration(milliseconds: 300));
    await start();
  }

  Future<void> stop() async {
    final service = FlutterBackgroundService();
    service.invoke("stop");
    // _running = false;
  }
}
