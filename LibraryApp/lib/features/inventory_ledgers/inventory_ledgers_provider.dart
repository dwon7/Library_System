import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';

class InventoryLedgersProvider {
  final StorageService _storageService = Get.find<StorageService>();

  // TODO: getCountByType | Input: int type | Output: int | Đếm số phiếu theo loại: 1=nhập kho, 2=xuất kho
  Future<int> getCountByType(int type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storageService.inventoryLedgers.where((l) => l.ledgerType == type).length;
  }

  // TODO: getLedgersByType | Input: int type | Output: List<InventoryLedgerDetailRes> | Lấy tối đa 4 phiếu theo loại, sắp xếp transactionDate giảm
  Future<List<InventoryLedgerDetailRes>> getLedgersByType(int type) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final list = _storageService.inventoryLedgers
        .where((l) => l.ledgerType == type)
        .toList();
    list.sort((a, b) => (b.transactionDate ?? "").compareTo(a.transactionDate ?? ""));
    return list.take(4).toList();
  }
}
