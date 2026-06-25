import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';

class BorrowCardsProvider {
  final StorageService _storageService = Get.find<StorageService>();

  String get _today {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<int> getDueTodayCount() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _storageService.borrowCards.where((c) => c.dueDate == _today).length;
  }

  Future<int> getCountByStatus(int status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (status == 0) return _storageService.borrowCards.length;
    return _storageService.borrowCards.where((c) => c.status == status).length;
  }

  Future<List<BorrowCardDetailRes>> getCardsByStatus(int status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final cards = status == 0
        ? _storageService.borrowCards.toList()
        : _storageService.borrowCards.where((c) => c.status == status).toList();
    cards.sort((a, b) => (b.borrowDate ?? "").compareTo(a.borrowDate ?? ""));
    return cards.take(4).toList();
  }
}
