import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'api_client.dart';
import 'app_config.dart';

class AuthProvider {
  /// Tự động đăng nhập với tài khoản admin khi khởi động app.
  /// Nếu thất bại (API chưa sẵn sàng) thì bỏ qua, các màn đọc vẫn hoạt động.
  static Future<void> autoLoginAsAdmin() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ));
      final response = await dio.post('/auth/login', data: {
        'email': 'admin@library.com',
        'password': 'Admin@123',
      });
      final token = response.data['accessToken'] as String?;
      if (token != null) {
        Get.find<ApiClient>().setToken(token);
      }
    } catch (_) {
      // Không có token → app chạy ở chế độ chỉ đọc
    }
  }
}
