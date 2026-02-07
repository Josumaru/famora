import 'package:famora/core/providers/firebase_provider.dart';
import 'package:famora/core/providers/location_provider.dart';
import 'package:famora/core/services/directions_service.dart';
import 'package:famora/core/services/voice_service.dart';
import 'package:famora/core/utils/loading.dart';
import 'package:famora/core/utils/logger.dart';
import 'package:famora/core/utils/marker.dart';
import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:famora/features/home/domain/entities/member_entity.dart';
import 'package:famora/features/home/presentation/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart' as osm;

class MonitorPage extends HookConsumerWidget {
  const MonitorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future<void> initPermission() async {
        await requestVoicePermissions();
      }

      initPermission();
      return null;
    }, []);
    final groupAsync = ref.watch(monitorProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final userLocationAsync = ref.watch(userLocationStreamProvider);

    return groupAsync.when(
      loading: () => Center(child: showLoading(context)),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (groupData) {
        final members = groupData?.members
            .where((m) => m.userId != user?.uid)
            .toList();

        if (members == null || members.isEmpty) {
          return const Center(child: Text('Tidak ada anggota untuk dimonitor'));
        }

        return userLocationAsync.when(
          loading: () => Center(child: showLoading(context)),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (userPos) {
            return FutureBuilder(
              future: buildRealtimeMapData(userPos, members),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: showLoading(context));
                }

                final markers = snapshot.data!.$1;
                final polylines = snapshot.data!.$2;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 55),
                  child: GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: userPos,
                      zoom: 14,
                    ),
                    markers: markers,
                    polylines: polylines,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

Future<(Set<Marker>, Set<Polyline>)> buildRealtimeMapData(
  LatLng userPos,
  List<MemberEntity> members,
) async {
  final markers = <Marker>{};
  final polylines = <Polyline>{};

  for (final m in members) {
    if (m.lat == null || m.lng == null) continue;

    // MARKER
    final iconBytes = await getRoundedMarker(m.avatar ?? "");
    markers.add(
      Marker(
        markerId: MarkerId(m.userId ?? ''),
        position: LatLng(m.lat!, m.lng!),
        icon: BitmapDescriptor.fromBytes(iconBytes),
        infoWindow: InfoWindow(title: m.name),
      ),
    );

    // OSM ROUTE
    final route = await getOSMRoute(
      osm.LatLng(userPos.latitude, userPos.longitude),
      osm.LatLng(m.lat!, m.lng!),
    );

    if (route.isEmpty) continue;

    final googlePoints = convertToGoogleLatLng(route);

    polylines.add(
      Polyline(
        polylineId: PolylineId('route-${m.userId}'),
        points: googlePoints,
        width: 4,
        color: Colors.red,
      ),
    );
  }

  return (markers, polylines);
}

final userLocationStreamProvider = StreamProvider<LatLng>((ref) async* {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }

  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // update tiap 5 meter
    ),
  ).map((pos) => LatLng(pos.latitude, pos.longitude));
});
