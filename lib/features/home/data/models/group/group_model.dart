// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

GroupModel groupModelFromJson(String str) => GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

@freezed
abstract class GroupModel with _$GroupModel {
    const factory GroupModel({
        DateTime? createdAt,
        String? createdBy,
        String? id,
        String? name,
    }) = _GroupModel;

    factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
}
