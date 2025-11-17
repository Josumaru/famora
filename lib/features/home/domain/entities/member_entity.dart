class MemberEntity {
  final String? id;
  final String? userId;
  final String? groupId;
  final String? name;
  final String? avatar;
  final double? lat;
  final double? lng;
  final DateTime? createdAt;

  const MemberEntity({
    this.id,
    this.name,
    this.userId,
    this.groupId,
    this.createdAt,
    this.avatar,
    this.lat,
    this.lng,
  });
}
