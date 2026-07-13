


import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/models/ressponses/book_detail_res.dart';
import '../../mock_data/storage_service.dart';

class QrScannerProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // TODO: Gọi API lấy thống kê kiểm kê
  // Input: auditId (String) - ID của phiếu kiểm kê
  // Output: List<int> - [0] = số lượng sách đã kiểm kê, [1] = tổng số sách cần kiểm kê
  Future<List<int>> getAuditStats(String auditId) async {
    throw UnimplementedError('getAuditStats not implemented yet');
  }

  // TODO: Gọi API quét mã QR
  // Input: qrValue (String) - giá trị mã QR quét được
  // Output: int - 1 (thành công), 2 (thất bại)
  Future<int> scanQR(String qrValue) async {
    throw UnimplementedError('scanQR not implemented yet');
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

  // TODO: Gọi API cập nhật trạng thái sách trong phiếu kiểm kê
  // Input: auditId (String) - ID phiếu kiểm kê, bookId (String) - ID sách, state (int) - trạng thái mới
  // Output: bool - true nếu thành công
  Future<bool> updateBookStatus(String auditId, String bookId, int state) async {
    throw UnimplementedError('updateBookStatus not implemented yet');
  }
}