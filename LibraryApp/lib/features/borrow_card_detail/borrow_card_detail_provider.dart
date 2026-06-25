import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';

class BorrowCardDetailProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<BorrowCardDetailRes?> getBorrowCardById(String cardId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _storageService.borrowCards.firstWhere(
        (c) => c.cardId == cardId,
      );
    } catch (_) {
      return null;
    }
  }

  String getUserName(String userId) {
    try {
      final user = _storageService.users.firstWhere((u) => u.userId == userId);
      return user.fullName ?? "";
    } catch (_) {
      return "";
    }
  }
}
