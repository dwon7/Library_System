import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';

class BookEditProvider {
  final StorageService _storage = Get.find<StorageService>();

  Future<BookDetailRes?> getBookById(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _storage.books.firstWhere((b) => b.bookId == bookId);
    } catch (_) {
      return null;
    }
  }

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

  List<CategoryDetailRes> getCategories() => _storage.categories.toList();

  Future<bool> updateBook(BookDetailRes book) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storage.updateBook(book);
    return true;
  }

  Future<bool> deleteBook(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storage.deleteBook(bookId);
    return true;
  }
}
