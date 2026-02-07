import 'package:famora/core/state/voice_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceNotifier extends StateNotifier<VoiceState> {
  VoiceNotifier() : super(const VoiceState(enabled: false, keyword: 'help')) {
    _loadFromLocal();
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('voice_enabled') ?? false;
    final keyword = prefs.getString('voice_keyword') ?? 'help';

    state = state.copyWith(enabled: enabled, keyword: keyword);
  }

  Future<void> toggle(bool value) async {
    state = state.copyWith(enabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voice_enabled', value);
  }

  Future<void> setKeyword(String value) async {
    final keyword = value.toLowerCase();
    state = state.copyWith(keyword: keyword);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voice_keyword', keyword);
  }
}
