import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../models/ressponses/book_detail_res.dart';

class BookDetailProvider {
  final ApiClient _client = Get.find<ApiClient>();

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
}
