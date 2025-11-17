import 'package:famora/core/utils/logger.dart';
import 'package:famora/core/utils/marker.dart';
import 'package:famora/features/home/domain/entities/member_entity.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MonitorPage extends HookConsumerWidget {
  const MonitorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(monitorProvider);

    return groupAsync.when(
      data: (groupData) {
        final groupId = groupData?.group.id;

        final filtered = groupData?.members
            .where((loc) => loc.groupId == groupId)
            .toList();

        if (filtered == null || filtered.isEmpty) {
          return const Center(
            child: Text('Tidak ada lokasi anggota dalam grup ini.'),
          );
        }

        // Tentukan center map (fallback Jakarta)
        final center = filtered.first.lat != null
            ? LatLng(filtered.first.lat!, filtered.first.lng!)
            : const LatLng(-6.2, 106.8);

        return FutureBuilder(
          future: Future.wait([
            getCurrentPosition(), // posisi user saat ini
            buildMarkers(filtered), // build marker semua member
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final userPosition = snapshot.data![0] as LatLng?;
            final markers = snapshot.data![1] as Set<Marker>;
            logger.d(userPosition);
            logger.d(markers);

            return Padding(
              padding: const EdgeInsets.only(bottom: 55),
              child: GoogleMap(
                markers: markers,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: userPosition!,
                  zoom: 14,
                ),

                // Tambahkan polyline di sini ✨
                polylines: buildPolylines(userPosition, filtered),
              ),
            );
          },
        );
      },

      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

Future<Set<Marker>> buildMarkers(List<MemberEntity> filtered) async {
  final Set<Marker> markers = {};

  for (final loc in filtered) {
    final iconBytes = await getRoundedMarker(loc.avatar ?? "");

    markers.add(
      Marker(
        markerId: MarkerId(loc.userId ?? ""),
        position: LatLng(loc.lat ?? 0, loc.lng ?? 0),
        icon: BitmapDescriptor.fromBytes(iconBytes),
        infoWindow: InfoWindow(title: loc.name),
      ),
    );
  }

  return markers;
}

Set<Polyline> buildPolylines(LatLng userPos, List<MemberEntity> members) {
  final Set<Polyline> polylines = {};

  for (final m in members) {
    if (m.lat != null && m.lng != null) {
      polylines.add(
        Polyline(
          polylineId: PolylineId("line-${m.userId}"),
          width: 4,
          color: Color.fromARGB(255, 78, 187, 241),
          points: [userPos, LatLng(m.lat!, m.lng!)],
        ),
      );
    }
  }

  return polylines;
}

Future<LatLng?> getCurrentPosition() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever ||
      permission == LocationPermission.denied) {
    return null;
  }

  final pos = await Geolocator.getCurrentPosition();
  return LatLng(pos.latitude, pos.longitude);
}
