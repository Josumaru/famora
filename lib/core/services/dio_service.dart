import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          connectTimeout: const Duration(seconds: 110),
          receiveTimeout: const Duration(seconds: 110),
          responseType: ResponseType.json,
          headers: {'Accept': 'application/json'},
        ),
      );
}
