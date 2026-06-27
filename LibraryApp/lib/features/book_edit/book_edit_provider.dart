import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';

class BookEditProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  // API #4: getBookById | GET /api/books/{bookId}
  Future<BookDetailRes?> getBookById(String bookId) async {
    try {
      final response = await _client.dio.get('/books/$bookId');
      return BookDetailRes.fromJson(response.data);
    } on Exception catch (e) {
      if (e.toString().contains('404')) return null;
      rethrow;
    }
  }

  // Lấy danh sách tác giả từ cache (đã load khi vào màn sách)
  List<Author> getAuthors() {
    final seen = <String>{};
    final result = <Author>[];
    for (final book in _storage.books) {
      if (book.authors != null) {
        for (final a in book.authors!) {
          final key = '${a.fullName}_${a.degree}';
          if (seen.add(key)) result.add(a);
        }
      }
    }
    return result;
  }

  // API #3: getCategories | GET /api/categories (dùng cache nếu có)
  List<CategoryDetailRes> getCategories() => _storage.categories.toList();

  // PUT /api/books/{bookId}
  Future<bool> updateBook(BookDetailRes book) async {
    final response = await _client.dio.put('/books/${book.bookId}', data: book.toJson());
    _storage.updateBook(book);
    return ApiClient.asSuccess(response.data);
  }

  // DELETE /api/books/{bookId}
  Future<bool> deleteBook(String bookId) async {
    await _client.dio.delete('/books/$bookId');
    _storage.deleteBook(bookId);
    return true;
  }
}
