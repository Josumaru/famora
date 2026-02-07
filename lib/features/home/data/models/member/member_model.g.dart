// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => _MemberModel(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  groupId: json['groupId'] as String?,
  id: json['id'] as String?,
  name: json['name'] as String?,
  avatar: json['avatar'] as String?,
  userId: json['userId'] as String?,
  fcmToken: json['fcmToken'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MemberModelToJson(_MemberModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'groupId': instance.groupId,
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'userId': instance.userId,
      'fcmToken': instance.fcmToken,
      'lat': instance.lat,
      'lng': instance.lng,
    };
