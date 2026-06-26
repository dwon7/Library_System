import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../mock_data/storage_service.dart';
import '../../models/entities/book_detail_entity.dart';
import '../../models/entities/category_entity.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';

class BooksProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // API #3: getCategories | GET /api/categories
  Future<List<CategoryEntity>> getCategories() async {
    final response = await _client.dio.get('/categories');
    final data = ApiClient.asList(response.data);
    final cats = data.map((e) => CategoryDetailRes.fromJson(e)).toList();
    _storageService.categories.assignAll(cats);
    return cats.map((e) => CategoryEntity.fromModel(e)).toList();
  }

  // API #5: getBooksByCategoryId | GET /api/books/search?categoryId=&keyword=&page=1&pageSize=100
  // API #1: getBooks (categoryId="-1", textSearch="")
  Future<List<BookDetailEntity>> getBooksByCategoryId(
    String categoryId,
    String textSearch,
  ) async {
    final params = <String, dynamic>{
      'page': 1,
      'pageSize': 100,
    };
    if (categoryId != '-1') params['categoryId'] = categoryId;
    if (textSearch.trim().isNotEmpty) params['keyword'] = textSearch.trim();

    final response = await _client.dio.get('/books/search', queryParameters: params);
    final data = ApiClient.asList(response.data);
    final books = data.map((e) => BookDetailRes.fromJson(e)).toList();
    // Cập nhật cache để các provider khác dùng (lookup theo bookId)
    if (categoryId == '-1' && textSearch.isEmpty) {
      _storageService.books.assignAll(books);
    }
    return books.map((e) => BookDetailEntity.fromModel(e)).toList();
  }
}
