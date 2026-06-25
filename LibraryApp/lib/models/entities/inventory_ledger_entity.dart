

// lib/data/entities/inventory_ledger_entity.dart

import '../ressponses/inventory_ledger_detail_res.dart'; // Import lớp InventoryLedgerModel đã tạo trước đó

class InventoryLedgerEntity {
  final String? ledgerId;
  final int? ledgerType; // 1: Nhập kho, 2: Xuất kho
  final String? transactionDate;
  final String? staffInCharge;
  final String? partnerName; // Phẳng hóa từ object partner.partnerName
  final int grandTotal;      // Phẳng hóa và cấu hình mặc định bằng 0 nếu null

  InventoryLedgerEntity({
    this.ledgerId,
    this.ledgerType,
    this.transactionDate,
    this.staffInCharge,
    this.partnerName,
    required this.grandTotal,
  });

  /// Hàm Factory Mapper: Chuyển đổi trực tiếp từ InventoryLedgerModel sang InventoryLedgerEntity
  factory InventoryLedgerEntity.fromModel(InventoryLedgerDetailRes model) {
    return InventoryLedgerEntity(
      ledgerId: model.ledgerId,
      ledgerType: model.ledgerType,
      transactionDate: model.transactionDate,
      staffInCharge: model.staffInCharge,
      // Bóc tách an toàn thông tin tên đối tác/nhà cung cấp/độc giả đóng góp
      partnerName: model.partner?.partnerName,
      // Ép kiểu mặc định bằng 0 nếu tổng tiền bị trống
      grandTotal: model.grandTotal ?? 0,
    );
  }

  /// Hàm chuyển đổi ngược lại Map nếu cần xử lý cục bộ
  Map<String, dynamic> toMap() {
    return {
      'ledgerId': ledgerId,
      'ledgerType': ledgerType,
      'transactionDate': transactionDate,
      'staffInCharge': staffInCharge,
      'partnerName': partnerName,
      'grandTotal': grandTotal,
    };
  }
}