import 'package:library_app/models/ressponses/inventory_audit_detail_res.dart';

class InventoryAuditDetailProvider {
  // TODO: Gọi API lây thông kê kiêm kê
  // Input: auditId (String) - ID phiêu kiêm kê
  // Output: List<int> - [0] = scannedCount - Số lượng sách đã kiểm kê, [1] = totalCount - Tổng số sách cần kiểm kê
  Future<List<int>> getAuditStats(String auditId) async {
    throw UnimplementedError('getAuditStats not implemented yet');
  }

  // TODO: Gọi API lây danh sách sách theo trang thái
  // Input: auditId (String) - ID phiêu kiêm kê, status (int) - 1 (đã kiêm kê) / 2 (chua kiêm kê)
  // Output: List<AuditDetail>
  Future<List<AuditDetail>> getBooksByStatus(
      String auditId, int status) async {
    throw UnimplementedError('getBooksByStatus not implemented yet');
  }

  // TODO: Gọi API xoá phiếu kiểm kê
  // Input: auditId (String) - ID phiếu kiểm kê
  // Output: bool - true nếu xoá thành công
  Future<bool> deleteAudit(String auditId) async {
    throw UnimplementedError('deleteAudit not implemented yet');
  }
}
