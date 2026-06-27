import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';

class InventoryLedgerDetailProvider {
  final StorageService _storageService = Get.find<StorageService>();

  // TODO: getLedgerById | Input: String ledgerId | Output: InventoryLedgerDetailRes? | Lấy chi tiết 1 phiếu nhập/xuất theo mã
  Future<InventoryLedgerDetailRes?> getLedgerById(String ledgerId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _storageService.inventoryLedgers.firstWhere(
        (l) => l.ledgerId == ledgerId,
      );
    } catch (_) {
      return null;
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
