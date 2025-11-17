class MonitorEntity {
  final String userId;
  final double lat;
  final double lng;
  final String groupId;
  final String name;

  MonitorEntity({
    required this.groupId,
    required this.name,
    required this.userId,
    required this.lat,
    required this.lng,
  });
}
