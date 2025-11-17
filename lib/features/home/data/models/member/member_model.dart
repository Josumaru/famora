// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

MemberModel memberModelFromJson(String str) =>
    MemberModel.fromJson(json.decode(str));

String memberModelToJson(MemberModel data) => json.encode(data.toJson());

@freezed
abstract class MemberModel with _$MemberModel {
  const factory MemberModel({
    DateTime? createdAt,
    String? groupId,
    String? id,
    String? name,
    String? avatar,
    String? userId,
    double? lat,
    double? lng,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}
