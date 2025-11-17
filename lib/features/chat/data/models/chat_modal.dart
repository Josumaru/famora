class ChatModel {
  final String from;
  final String message;
  final double lat;
  final double lng;
  final String timestamp;

  ChatModel({
    required this.from,
    required this.message,
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  factory ChatModel.fromMap(Map map) {
    return ChatModel(
      from: map['from'] ?? "Unknown",
      message: map['message'] ?? "",
      lat: (map['lat'] ?? 0).toDouble(),
      lng: (map['lng'] ?? 0).toDouble(),
      timestamp: map['timestamp'] ?? "",
    );
  }
}
