import 'group_entity.dart';
import 'member_entity.dart';

class GroupMemberEntity {
  final GroupEntity group;
  final List<MemberEntity> members;

  GroupMemberEntity(this.group, this.members);
}
