import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';

class BorrowCardsProvider {
  final StorageService _storageService = Get.find<StorageService>();

  String get _today {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  // TODO: getDueTodayCount | Input: — | Output: int | Đếm số phiếu mượn đến hạn hôm nay
  Future<int> getDueTodayCount() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _storageService.borrowCards.where((c) => c.dueDate == _today).length;
  }

  // TODO: getCountByStatus | Input: int status | Output: int | Đếm số item theo trạng thái (BorrowCard: 0=all,1=done,2=borrowing,3=overdue)
  Future<int> getCountByStatus(int status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (status == 0) return _storageService.borrowCards.length;
    return _storageService.borrowCards.where((c) => c.status == status).length;
  }

  // TODO: getCardsByStatus | Input: int status | Output: List<BorrowCardDetailRes> | Lấy tối đa 4 phiếu mượn theo status, sắp xếp borrowDate giảm
  Future<List<BorrowCardDetailRes>> getCardsByStatus(int status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final cards = status == 0
        ? _storageService.borrowCards.toList()
        : _storageService.borrowCards.where((c) => c.status == status).toList();
    cards.sort((a, b) => (b.borrowDate ?? "").compareTo(a.borrowDate ?? ""));
    return cards.take(4).toList();
  }
}
