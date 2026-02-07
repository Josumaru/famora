class VoiceState {
  final bool enabled;
  final String keyword;

  const VoiceState({required this.enabled, required this.keyword});

  VoiceState copyWith({bool? enabled, String? keyword}) {
    return VoiceState(
      enabled: enabled ?? this.enabled,
      keyword: keyword ?? this.keyword,
    );
  }
}
