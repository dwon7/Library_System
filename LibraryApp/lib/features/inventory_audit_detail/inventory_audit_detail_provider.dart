import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/models/ressponses/book_detail_res.dart';
import 'package:library_app/models/ressponses/inventory_audit_detail_res.dart';

class InventoryAuditDetailProvider {
  final ApiClient _client = Get.find<ApiClient>();

  // API: GET /api/books/search?page=1&pageSize=100
  Future<List<BookDetailRes>> getBooks() async {
    final response = await _client.dio.get('/books/search', queryParameters: {
      'page': 1,
      'pageSize': 100,
    });
    final data = ApiClient.asList(response.data);
    return data.map((e) => BookDetailRes.fromJson(e)).toList();
  }

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

  // API: GET /api/inventorychecks/{auditId}/books?status={status}
  // status: 1 = đã kiểm kê, 2 = chưa kiểm kê
  // Output: List<AuditDetail>
  Future<List<AuditDetail>> getBooksByStatus(String auditId, int status) async {
    final response = await _client.dio.get(
      '/inventorychecks/$auditId/books',
      queryParameters: {'status': status},
    );
    final data = ApiClient.asList(response.data);
    return data.map((e) => AuditDetail.fromJson(e)).toList();
  }

  // API: DELETE /api/inventorychecks/{auditId}
  // Output: true nếu xoá thành công
  Future<bool> deleteAudit(String auditId) async {
    final response = await _client.dio.delete('/inventorychecks/$auditId');
    return ApiClient.asSuccess(response.data);
  }
}
