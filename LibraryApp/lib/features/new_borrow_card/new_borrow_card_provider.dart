import 'package:get/get.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';
import '../../models/ressponses/user_detail_res.dart';

class NewBorrowCardProvider {
  final StorageService _storageService = Get.find<StorageService>();

  // TODO: generateCardId | Input: — | Output: String | Sinh mã phiếu mượn tự động PM-XXX
  Future<String> generateCardId() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_storageService.borrowCards.isEmpty) return "PM-001";
    final cards = _storageService.borrowCards;
    cards.sort((a, b) => (b.cardId ?? "").compareTo(a.cardId ?? ""));
    final lastId = cards.first.cardId ?? "PM-000";
    final num = int.parse(lastId.substring(3)) + 1;
    return "PM-${num.toString().padLeft(3, '0')}";
  }

  // TODO: getBooks | Input: — | Output: List<BookDetailRes> | Lấy toàn bộ danh sách sách
  Future<List<BookDetailRes>> getBooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _storageService.books.toList();
  }

  // TODO: getUsers | Input: — | Output: List<UserDetailRes> | Lấy toàn bộ danh sách độc giả
  Future<List<UserDetailRes>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _storageService.users.toList();
  }

  // TODO: addBorrowCard | Input: BorrowCardDetailRes card | Output: bool | Thêm phiếu mượn mới
  Future<bool> addBorrowCard(BorrowCardDetailRes card) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storageService.addBorrowCard(card);
    return true;
  }
}
