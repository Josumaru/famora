// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => _GroupModel(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  createdBy: json['createdBy'] as String?,
  id: json['id'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$GroupModelToJson(_GroupModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'id': instance.id,
      'name': instance.name,
    };
