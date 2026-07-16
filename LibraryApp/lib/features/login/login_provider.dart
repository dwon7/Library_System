import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

class LoginProvider {
  final ApiClient _client = Get.find<ApiClient>();

  // TODO: login | Input: String username, String password | Output: int (1: thành công, 2: thất bại)
  Future<int> login(String username, String password) async {
    try {
      final response = await _client.dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      return response.data == 1 ? 1 : 2;
    } catch (_) {
      return 2;
    }
  }
}
