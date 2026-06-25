import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/inventory_audit_detail_res.dart';

class InventoryAuditsProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<int> getCountByStatus(int status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storageService.inventoryAudits.where((a) => a.status == status).length;
  }

  Future<List<InventoryAuditDetailRes>> getAuditsByStatus(int status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final list = _storageService.inventoryAudits
        .where((a) => a.status == status)
        .toList();
    list.sort((a, b) => (b.auditDate ?? "").compareTo(a.auditDate ?? ""));
    return list.take(4).toList();
  }
}
