import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

Future<Uint8List> getRoundedMarker(String url, {int size = 120}) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;

  final codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: size,
    targetHeight: size,
  );
  final frame = await codec.getNextFrame();
  final image = frame.image;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint();
  final center = size / 2;

  // Clip lingkaran
  final clipPath = Path()
    ..addOval(Rect.fromCircle(center: Offset(center, center), radius: center));
  canvas.clipPath(clipPath);

  // Gambar gambar aslinya
  canvas.drawImage(image, Offset.zero, paint);

  final picture = recorder.endRecording();
  final img = await picture.toImage(size, size);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}
