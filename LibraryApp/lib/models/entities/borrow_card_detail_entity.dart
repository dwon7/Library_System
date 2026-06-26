import '../../common/utils/app_utils.dart';
import '../ressponses/borrow_card_detail_res.dart';

class BorrowCardDetailEntity {
  final String? cardId;
  final String? userId;
  final String? userName;
  final String? borrowDate;
  final String? dueDate;
  final int status; // 1: hoàn thành, 2: đang mượn, 3: quá hạn

  BorrowCardDetailEntity({
    this.cardId,
    this.userId,
    this.userName,
    this.borrowDate,
    this.dueDate,
    required this.status,
  });

  factory BorrowCardDetailEntity.fromModel(BorrowCardDetailRes model, {String? userName}) {
    return BorrowCardDetailEntity(
      cardId: model.cardId,
      userId: model.userId,
      userName: userName,
      borrowDate: AppUtils.formatDate(model.borrowDate),
      dueDate: AppUtils.formatDate(model.dueDate),
      status: model.status ?? 2,
    );
  }
}
