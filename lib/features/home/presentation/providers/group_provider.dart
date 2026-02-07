import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:famora/features/home/data/models/group/group_model.dart';
import 'package:famora/features/home/data/models/member/member_model.dart';
import 'package:famora/features/home/domain/entities/group_entity.dart';
import 'package:famora/features/home/domain/entities/group_member_entity.dart';
import 'package:famora/features/home/domain/entities/member_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupProvider = FutureProvider<GroupMemberEntity?>((ref) async {
  final database = ref.watch(databaseProvider);
  final user = ref.watch(firebaseAuthProvider);
  final userId = user.currentUser?.uid;

  if (userId == null) return null;

  final memberSnap = await database
      .child("members")
      .orderByChild("userId")
      .equalTo(userId)
      .get();

  if (!memberSnap.exists || memberSnap.children.isEmpty) return null;

  final firstMemberData = Map<String, dynamic>.from(
    memberSnap.children.first.value as Map,
  );
  logger.d(firstMemberData);
  final groupId = firstMemberData["groupId"];
  if (groupId == null) return null;

  final groupSnap = await database.child("groups/$groupId").get();
  logger.d(groupSnap.exists);
  if (!groupSnap.exists) return null;
  final groupData = Map<String, dynamic>.from(groupSnap.value as Map);

  final group = GroupModel.fromJson(groupData);
  final groupEntity = GroupEntity(
    id: group.id,
    name: group.name,
    createdBy: group.createdBy,
    createdAt: group.createdAt,
  );

  final allMemberSnap = await database
      .child("members")
      .orderByChild("groupId")
      .equalTo(groupId)
      .get();

  if (!allMemberSnap.exists || allMemberSnap.children.isEmpty) return null;

  final members = allMemberSnap.children.map((e) {
    final json = Map<String, dynamic>.from(e.value as Map);
    final member = MemberModel.fromJson(json);
    return MemberEntity(
      id: member.id,
      userId: member.userId,
      groupId: member.groupId,
      createdAt: member.createdAt,
      name: member.name,
      avatar: member.avatar,
      lat: member.lat,
      lng: member.lng,
      fcmToken: member.fcmToken,
    );
  }).toList();

  return GroupMemberEntity(groupEntity, members);
});

final monitorProvider = StreamProvider<GroupMemberEntity?>((ref) async* {
  final database = ref.watch(databaseProvider);
  final user = ref.watch(firebaseAuthProvider);
  final userId = user.currentUser?.uid;

  if (userId == null) {
    yield null;
    return;
  }

  // Ambil groupId user dulu (sekali saja)
  final memberSnap = await database
      .child("members")
      .orderByChild("userId")
      .equalTo(userId)
      .get();

  if (!memberSnap.exists || memberSnap.children.isEmpty) {
    yield null;
    return;
  }

  final firstMemberData = Map<String, dynamic>.from(
    memberSnap.children.first.value as Map,
  );
  final groupId = firstMemberData["groupId"];
  if (groupId == null) {
    yield null;
    return;
  }

  // Stream untuk members & group
  final groupRef = database.child("groups/$groupId");
  final membersRef = database
      .child("members")
      .orderByChild("groupId")
      .equalTo(groupId);

  await for (final event in membersRef.onValue) {
    final membersSnap = event.snapshot;

    if (!membersSnap.exists) {
      yield null;
      continue;
    }

    // Parse members realtime
    final members = membersSnap.children.map((e) {
      final json = Map<String, dynamic>.from(e.value as Map);
      final m = MemberModel.fromJson(json);
      return MemberEntity(
        id: m.id,
        userId: m.userId,
        groupId: m.groupId,
        name: m.name,
        avatar: m.avatar,
        // createdAt: m.createdAt,
        lat: m.lat,
        lng: m.lng,
      );
    }).toList();

    // Ambil data group (boleh sekali, tapi safe juga kalau realtime)
    final groupSnap = await groupRef.get();
    final groupJson = Map<String, dynamic>.from(groupSnap.value as Map);
    final groupEntity = GroupEntity(
      id: groupJson['id'],
      name: groupJson['name'],
      createdBy: groupJson['createdBy'],
      // createdAt: groupJson['createdAt'],
    );

    yield GroupMemberEntity(groupEntity, members);
  }
});
