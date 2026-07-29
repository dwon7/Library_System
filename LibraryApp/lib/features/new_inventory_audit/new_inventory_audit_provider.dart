import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/inventory_audit_detail_res.dart';

class NewInventoryAuditProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // API #20: generateAuditId | GET /api/inventorychecks/generate-id
  Future<String> generateAuditId() async {
    final response = await _client.dio.get('/inventorychecks/generate-id');
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

  // API #23: addAudit | POST /api/inventorychecks → trả về auditId string (KK-XXX)
  Future<String> addAudit(InventoryAuditDetailRes audit) async {
    final response = await _client.dio.post('/inventorychecks', data: audit.toJson());
    return ApiClient.asString(response.data);
  }
}
