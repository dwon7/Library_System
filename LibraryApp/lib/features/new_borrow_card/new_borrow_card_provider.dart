import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';
import '../../models/ressponses/user_detail_res.dart';

class NewBorrowCardProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // API #19: generateCardId | GET /api/borrow/generate-id
  Future<String> generateCardId() async {
    final response = await _client.dio.get('/borrow/generate-id');
    return ApiClient.asString(response.data);
  }

  // API #1: getBooks | GET /api/books/search?page=1&pageSize=100
  Future<List<BookDetailRes>> getBooks() async {
    final response = await _client.dio.get('/books/search', queryParameters: {
      'page': 1,
      'pageSize': 100,
    });
    final data = ApiClient.asList(response.data);
    final books = data.map((e) => BookDetailRes.fromJson(e)).toList();
    _storageService.books.assignAll(books);
    return books;
  }

  // API #2: getUsers | GET /api/users
  Future<List<UserDetailRes>> getUsers() async {
    final response = await _client.dio.get('/users');
    final data = ApiClient.asList(response.data);
    final users = data.map((e) => UserDetailRes.fromJson(e)).toList();
    _storageService.users.assignAll(users);
    return users;
  }

  // API #22: addBorrowCard | POST /api/borrow
  Future<bool> addBorrowCard(BorrowCardDetailRes card) async {
    final response = await _client.dio.post('/borrow', data: card.toJson());
    return ApiClient.asSuccess(response.data);
  }
}
