import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

class LoginResult {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;

  const LoginResult.success(this.accessToken, this.refreshToken)
      : success = true,
        errorMessage = null;

  const LoginResult.failure(this.errorMessage)
      : success = false,
        accessToken = null,
        refreshToken = null;
}

class LoginProvider {
  final ApiClient _client = Get.find<ApiClient>();

  Future<LoginResult> login(String email, String password) async {
    try {
      final response = await _client.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken == null) {
        return const LoginResult.failure("Phản hồi từ máy chủ không hợp lệ");
      }
      return LoginResult.success(accessToken, refreshToken);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      final message = data is Map ? data['message'] as String? : null;

      if (statusCode == 401) {
        return LoginResult.failure(message ?? "Sai email hoặc mật khẩu");
      }
      if (statusCode != null) {
        return LoginResult.failure(message ?? "Máy chủ trả về lỗi ($statusCode)");
      }
      return const LoginResult.failure("Không thể kết nối đến máy chủ, vui lòng kiểm tra đường truyền/địa chỉ API");
    } catch (_) {
      return const LoginResult.failure("Không thể kết nối đến máy chủ");
    }
  }
}
