import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class AppConfig {
  // Backend chạy local (dotnet run) ở port 5001 (xem LibraryAPI/Properties/launchSettings.json).
  // Android emulator không thấy "localhost" của máy host nên phải dùng 10.0.2.2.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5001/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:5001/api';
    return 'http://localhost:5001/api';
  }
}
