import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as osm;
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<osm.LatLng>> getOSMRoute(osm.LatLng start, osm.LatLng end) async {
  final url =
      'https://router.project-osrm.org/route/v1/driving/'
      '${start.longitude},${start.latitude};'
      '${end.longitude},${end.latitude}'
      '?overview=full&geometries=geojson';

  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) return [];

  final data = jsonDecode(res.body);
  final coords = data['routes'][0]['geometry']['coordinates'] as List;

  return coords.map((c) => osm.LatLng(c[1], c[0])).toList();
}

List<LatLng> convertToGoogleLatLng(List<osm.LatLng> points) {
  return points.map((p) => LatLng(p.latitude, p.longitude)).toList();
}
