import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
import 'package:famora/features/monitor/domain/entities/monitor_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final groupLocationStreamProvider = StreamProvider<List<MonitorEntity>>((ref) {
  final db = ref.watch(databaseProvider);
  final futureGroup = ref.watch(groupProvider);

  return futureGroup.when(
    data: (groupData) {
      if (groupData == null) return const Stream<List<MonitorEntity>>.empty();

      final groupId = groupData.group.id;

      return db.child('locations').onValue.map((event) {
        final children = event.snapshot.children;

        return children
            .map((child) {
              final data = Map<String, dynamic>.from(child.value as Map);
              return MonitorEntity(
                userId: data['userId'],
                groupId: data['groupId'],
                name: data['name'],
                lat: (data['lat'] as num).toDouble(),
                lng: (data['lng'] as num).toDouble(),
              );
            })
            .where((loc) => loc.groupId == groupId)
            .toList();
      });
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
