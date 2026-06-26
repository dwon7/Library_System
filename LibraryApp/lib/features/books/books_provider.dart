import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../mock_data/storage_service.dart';
import '../../models/entities/book_detail_entity.dart';
import '../../models/entities/category_entity.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';

class BooksProvider {
  // Tìm kho lưu trữ toàn cục
  final StorageService _storageService = Get.find<StorageService>();

  // TODO: getCategories | Input: — | Output: List<CategoryEntity> | Lấy toàn bộ danh mục sách
  Future<List<CategoryEntity>> getCategories() async {
    // Giả lập mạng chậm 800ms
    await Future.delayed(const Duration(milliseconds: 800));

    return _storageService.categories
        .map((e) => CategoryEntity.fromModel(e))
        .toList();
  }

  // TODO: getBooksByCategoryId | Input: String categoryId, String textSearch | Output: List<BookDetailEntity> | Lọc sách theo danh mục ("-1"=all) + từ khóa
  Future<List<BookDetailEntity>> getBooksByCategoryId(
    String categoryId,
    String textSearch,
  ) async {
    // Giảm độ trễ xuống 500ms để trải nghiệm gõ tìm kiếm (Search) mượt mà hơn
    await Future.delayed(const Duration(milliseconds: 500));

    // Lấy toàn bộ sách từ kho lưu trữ toàn cục ra để lọc
    List<BookDetailRes> allBooks = _storageService.books;

    // 1. Lọc theo Danh mục (categoryId)
    List<BookDetailRes> filteredBooks = categoryId == "-1"
        ? allBooks
        : allBooks.where((book) => book.categoryId == categoryId).toList();

    // 2. Lọc theo từ khóa tìm kiếm (textSearch)
    if (textSearch.trim() != "") {
      final query = textSearch.trim().toLowerCase();
      filteredBooks = filteredBooks.where((book) {
        final title = (book.title ?? "").toLowerCase();
        final bookId = (book.bookId ?? "").toLowerCase();
        return title.contains(query) || bookId.contains(query);
      }).toList();
    }
    List<BookDetailEntity> result = filteredBooks
        .map((e) => BookDetailEntity.fromModel(e))
        .toList();

    return result;
  }
}
