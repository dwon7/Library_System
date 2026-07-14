
import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/models/ressponses/book_detail_res.dart';
import '../../mock_data/storage_service.dart';

class QrScannerProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // API: GET /api/inventorychecks/{auditId}/progress
  // Output: [scannedCount, totalCount]
  Future<List<int>> getAuditStats(String auditId) async {
    final response = await _client.dio.get('/inventorychecks/$auditId/progress');
    final data = response.data;
    if (data is List && data.length >= 2) {
      return [data[0] as int, data[1] as int];
    }
    return [0, 0];
  }

  // API: POST /api/inventorychecks/{auditId}/scan
  // Input: auditId, qrValue (ma_sach của sách)
  // Output: 1 (thành công), 2 (thất bại/không tìm thấy)
  Future<int> scanQR(String auditId, String qrValue) async {
    final response = await _client.dio.post(
      '/inventorychecks/$auditId/scan',
      data: {'qrValue': qrValue},
    );
    return ApiClient.asInt(response.data);
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

  // API: PUT /api/inventorychecks/{auditId}/books/{bookId}/condition
  // Input: auditId, bookId (ObjectId), state (conditionType: 1/2/3/4)
  // Output: true nếu thành công
  Future<bool> updateBookStatus(String auditId, String bookId, int state) async {
    final response = await _client.dio.put(
      '/inventorychecks/$auditId/books/$bookId/condition',
      data: {'conditionType': state},
    );
    return ApiClient.asSuccess(response.data);
  }
}
