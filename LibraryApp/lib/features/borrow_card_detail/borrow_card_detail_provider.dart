import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';

class BorrowCardDetailProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // API #6: getBorrowCardById | GET /api/borrow/{cardId}
  Future<BorrowCardDetailRes?> getBorrowCardById(String cardId) async {
    try {
      final response = await _client.dio.get('/borrow/$cardId');
      return BorrowCardDetailRes.fromJson(response.data);
    } on Exception catch (e) {
      if (e.toString().contains('404')) return null;
      rethrow;
    }
  }

  // API #7: getUserName — sync, dùng cache đã load từ trước
  String getUserName(String userId) {
    try {
      final user = _storageService.users.firstWhere((u) => u.userId == userId);
      return user.fullName ?? '';
    } catch (_) {
      return '';
    }
  }

  // API: returnBook | PUT /api/borrow/return/{cardId}
  Future<bool> returnBook(String cardId) async {
    final response = await _client.dio.put('/borrow/return/$cardId');
    return ApiClient.asSuccess(response.data);
  }
}
