import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';

class NewBookProvider {
  final StorageService _storage = Get.find<StorageService>();

  // API #3: getCategories | GET /api/categories (dùng cache nếu có)
  List<CategoryDetailRes> getCategories() => _storage.categories.toList();

  // TODO:MOCK generateBookId | Input: none | Output: String (mã sách mới, VD: MS-30) | GET /api/books/generate-id
  Future<String> generateBookId() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final nextIndex = _storage.books.length + 1;
    return 'MS-${nextIndex.toString().padLeft(2, '0')}';
  }

  // TODO:MOCK addBook | Input: BookDetailRes (sách mới, chưa có bookId thật) | Output: bool (thành công/thất bại) | POST /api/books
  Future<bool> addBook(BookDetailRes book) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storage.addBook(book);
    return true;
  }
}
