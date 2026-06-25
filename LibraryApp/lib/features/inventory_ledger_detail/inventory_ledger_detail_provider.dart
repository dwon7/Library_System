import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';

class InventoryLedgerDetailProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<InventoryLedgerDetailRes?> getLedgerById(String ledgerId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _storageService.inventoryLedgers.firstWhere(
        (l) => l.ledgerId == ledgerId,
      );
    } catch (_) {
      return null;
    }
  }
}
