import '../ressponses/inventory_audit_detail_res.dart'; // Import lớp InventoryAuditModel đã tạo trước đó

class InventoryAuditEntity {
  final String? auditId;
  final String? auditDate;
  final int? status;
  final int totalAuditedQuantity; // Đã cấu hình phẳng hóa và không cho phép null (mặc định bằng 0)

  InventoryAuditEntity({
    this.auditId,
    this.auditDate,
    this.status,
    required this.totalAuditedQuantity,
  });

  /// Hàm Factory Mapper: Chuyển đổi trực tiếp từ InventoryAuditModel sang InventoryAuditEntity
  factory InventoryAuditEntity.fromModel(InventoryAuditDetailRes model) {
    return InventoryAuditEntity(
      auditId: model.auditId,
      auditDate: model.auditDate,
      status: model.status,
      // Lấy trực tiếp từ trường totalAuditedQuantity của model, nếu null thì mặc định bằng 0
      totalAuditedQuantity: model.totalAuditedQuantity ?? 0,
    );
  }

  /// Hàm chuyển đổi ngược lại Map nếu cần xử lý cục bộ
  Map<String, dynamic> toMap() {
    return {
      'auditId': auditId,
      'auditDate': auditDate,
      'status': status,
      'totalAuditedQuantity': totalAuditedQuantity,
    };
  }
}