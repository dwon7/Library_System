import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';

class NewInventoryLedgerProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<String> generateLedgerId(int ledgerType) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final prefix = ledgerType == 1 ? "NK" : "XK";
    final sameType = _storageService.inventoryLedgers
        .where((l) => l.ledgerType == ledgerType)
        .toList();
    if (sameType.isEmpty) return "$prefix-001";
    sameType.sort((a, b) => (b.ledgerId ?? "").compareTo(a.ledgerId ?? ""));
    final lastId = sameType.first.ledgerId ?? "$prefix-000";
    final num = int.parse(lastId.substring(3)) + 1;
    return "$prefix-${num.toString().padLeft(3, '0')}";
  }

  Future<List<BookDetailRes>> getBooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _storageService.books.toList();
  }

  Future<bool> addLedger(InventoryLedgerDetailRes ledger) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storageService.addLedger(ledger);
    return true;
  }
}
