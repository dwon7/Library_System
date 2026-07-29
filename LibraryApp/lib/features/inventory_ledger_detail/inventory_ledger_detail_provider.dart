import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';

class InventoryLedgerDetailProvider {
  final ApiClient _client = Get.find<ApiClient>();

  // API #12: getLedgerById | GET /api/stocktransactions/{ledgerId}
  Future<InventoryLedgerDetailRes?> getLedgerById(String ledgerId) async {
    try {
      final response = await _client.dio.get('/stocktransactions/$ledgerId');
      return InventoryLedgerDetailRes.fromJson(response.data);
    } on Exception catch (e) {
      if (e.toString().contains('404')) return null;
      rethrow;
    }
  }

  // deleteLedger | DELETE /api/stocktransactions/{ledgerId}
  Future<bool> deleteLedger(String ledgerId) async {
    final response = await _client.dio.delete('/stocktransactions/$ledgerId');
    return ApiClient.asSuccess(response.data);
  }

  // getBooksByIds | GET /api/books/by-ids?ids= | Trả về theo đúng thứ tự bookIds truyền vào
  Future<List<BookDetailRes>?> getBooksByIds(List<String> bookIds) async {
    if (bookIds.isEmpty) return [];
    try {
      final response = await _client.dio.get(
        '/books/by-ids',
        queryParameters: {'ids': bookIds.join(',')},
      );
      final data = ApiClient.asList(response.data);
      return data.map((e) => BookDetailRes.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }
}
