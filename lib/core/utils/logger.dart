import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // tampilkan jumlah stack trace
    errorMethodCount: 5,
    // lineLength: 80,
    printTime: true,
  ),
);
