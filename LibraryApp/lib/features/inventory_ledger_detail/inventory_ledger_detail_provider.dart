import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

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

  // TODO: getBooksByIds | Input: List<String> bookIds | Output: List<BookDetailRes>? | Lấy chi tiết 1 sách theo mã. null nếu không thấy
  Future<List<BookDetailRes>?> getBooksByIds(List<String> bookIds) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _storageService.books.where(
            (book) => bookIds.contains(book.bookId),
      ).toList();
    } catch (_) {
      return null;
    }
  }
}
