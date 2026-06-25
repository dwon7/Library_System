
import '../ressponses/borrow_card_detail_res.dart'; // Import lớp BorrowCardModel đã tạo trước đó

class BorrowCardEntity {
  final String? cardId;
  final String? userId;
  final String? borrowDate;
  final String? dueDate;
  final int? status;
  final int totalQuantity; // Tổng số lượng sách trong phiếu mượn

  BorrowCardEntity({
    this.cardId,
    this.userId,
    this.borrowDate,
    this.dueDate,
    this.status,
    required this.totalQuantity,
  });

  /// Hàm Factory Mapper: Chuyển đổi từ BorrowCardModel sang BorrowCardEntity
  factory BorrowCardEntity.fromModel(BorrowCardDetailRes model) {
    // Tính tổng số lượng từ danh sách các chi tiết mượn (borrowDetails)
    int calculatedTotal = 0;
    if (model.borrowDetails != null) {
      for (var detail in model.borrowDetails!) {
        calculatedTotal += detail.quantity ?? 0;
      }
    }

    return BorrowCardEntity(
      cardId: model.cardId,
      userId: model.userId,
      borrowDate: model.borrowDate,
      dueDate: model.dueDate,
      status: model.status,
      totalQuantity: calculatedTotal, // Gán giá trị tổng đã tính toán
    );
  }

  /// Hàm chuyển đổi ngược lại Map nếu cần xử lý cục bộ
  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'userId': userId,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'status': status,
      'totalQuantity': totalQuantity,
    };
  }
}