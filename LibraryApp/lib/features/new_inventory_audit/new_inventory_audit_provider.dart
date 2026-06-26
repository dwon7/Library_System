import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/inventory_audit_detail_res.dart';
import '../../models/ressponses/book_detail_res.dart';

class NewInventoryAuditProvider {
  final StorageService _storageService = Get.find<StorageService>();

  // TODO: generateAuditId | Input: — | Output: String | Sinh mã phiếu kiểm kê tự động KK-XXX
  Future<String> generateAuditId() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_storageService.inventoryAudits.isEmpty) return "KK-001";
    final list = _storageService.inventoryAudits.toList();
    list.sort((a, b) => (b.auditId ?? "").compareTo(a.auditId ?? ""));
    final lastId = list.first.auditId ?? "KK-000";
    final num = int.parse(lastId.substring(3)) + 1;
    return "KK-${num.toString().padLeft(3, '0')}";
  }

  // TODO: getBooks | Input: — | Output: List<BookDetailRes> | Lấy toàn bộ danh sách sách
  Future<List<BookDetailRes>> getBooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _storageService.books.toList();
  }

  // TODO: addAudit | Input: InventoryAuditDetailRes audit | Output: bool | Thêm phiếu kiểm kê mới
  Future<bool> addAudit(InventoryAuditDetailRes audit) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storageService.addAudit(audit);
    return true;
  }
}
