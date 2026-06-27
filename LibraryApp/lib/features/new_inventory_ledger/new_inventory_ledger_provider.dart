import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';

class NewInventoryLedgerProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // API #21: generateLedgerId | GET /api/stocktransactions/generate-id?type=
  Future<String> generateLedgerId(int ledgerType) async {
    final response = await _client.dio.get(
      '/stocktransactions/generate-id',
      queryParameters: {'type': ledgerType},
    );
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

  // API #24: addLedger | POST /api/stocktransactions/import (type=1) hoặc /export (type=2)
  Future<bool> addLedger(InventoryLedgerDetailRes ledger) async {
    final endpoint = ledger.ledgerType == 1
        ? '/stocktransactions/import'
        : '/stocktransactions/export';
    final response = await _client.dio.post(endpoint, data: ledger.toJson());
    return ApiClient.asSuccess(response.data);
  }
}
