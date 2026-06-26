import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';

class BookDetailProvider {
  final StorageService _storageService = Get.find<StorageService>();

  // TODO: getBookById | Input: String bookId | Output: BookDetailRes? | Lấy chi tiết 1 sách theo mã. null nếu không thấy
  Future<BookDetailRes?> getBookById(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _storageService.books.firstWhere(
        (book) => book.bookId == bookId,
      );
    } catch (_) {
      return null;
    }
  }
}
