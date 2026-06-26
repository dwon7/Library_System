import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'app_config.dart';

class ApiClient extends GetxService {
  late final Dio dio;
  String? _token;

  @override
  void onInit() {
    super.onInit();
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
  }

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  /// Trích xuất danh sách từ response: hỗ trợ cả dạng `[...]` và `{ "items": [...] }`
  static List<dynamic> asList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data.containsKey('items')) return data['items'] as List;
    return [];
  }

  /// Lấy giá trị int từ response: hỗ trợ dạng `N` và `{ "count": N }`
  static int asInt(dynamic data) {
    if (data is int) return data;
    if (data is Map) {
      return (data['count'] ?? data['value'] ?? data['total'] ?? 0) as int;
    }
    return 0;
  }

  /// Lấy chuỗi từ response: hỗ trợ dạng `"str"` và `{ "value": "str" }`
  static String asString(dynamic data) {
    if (data is String) return data;
    if (data is Map) return (data['value'] ?? data['id'] ?? '').toString();
    return '';
  }

  /// Kiểm tra response thành công: hỗ trợ `true` và `{ "success": true }`
  static bool asSuccess(dynamic data) {
    if (data is bool) return data;
    if (data is Map) return (data['success'] ?? data['ok'] ?? true) as bool;
    return true;
  }
}
