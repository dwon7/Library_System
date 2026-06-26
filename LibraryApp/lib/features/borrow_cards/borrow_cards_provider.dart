import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';
import '../../models/ressponses/user_detail_res.dart';

class BorrowCardsProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // Tải và cache users để _mapCards trong controller dùng được
  Future<void> getAndCacheUsers() async {
    try {
      final response = await _client.dio.get('/users');
      final data = ApiClient.asList(response.data);
      final users = data.map((e) => UserDetailRes.fromJson(e)).toList();
      _storageService.users.assignAll(users);
    } catch (_) {}
  }

  // API #8: getDueTodayCount | GET /api/borrow/due-today
  Future<int> getDueTodayCount() async {
    final response = await _client.dio.get('/borrow/due-today');
    return ApiClient.asInt(response.data);
  }

  // API #9a: getCountByStatus (BC) | GET /api/borrow/count?status=
  Future<int> getCountByStatus(int status) async {
    final response = await _client.dio.get('/borrow/count', queryParameters: {'status': status});
    return ApiClient.asInt(response.data);
  }

  // API #10: getCardsByStatus | GET /api/borrow/list?status=
  Future<List<BorrowCardDetailRes>> getCardsByStatus(int status) async {
    final response = await _client.dio.get('/borrow/list', queryParameters: {'status': status});
    final data = ApiClient.asList(response.data);
    return data.map((e) => BorrowCardDetailRes.fromJson(e)).toList();
  }
}
