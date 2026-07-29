import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';

class NewBookProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  // API #3: getCategories | GET /api/categories (dùng cache nếu có)
  List<CategoryDetailRes> getCategories() => _storage.categories.toList();

  // generateBookId | GET /api/books/generate-id
  Future<String> generateBookId() async {
    final response = await _client.dio.get('/books/generate-id');
    return ApiClient.asString(response.data);
  }

  // addBook | POST /api/books
  Future<bool> addBook(BookDetailRes book) async {
    final response = await _client.dio.post('/books', data: book.toJson());
    return response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;
  }
}
