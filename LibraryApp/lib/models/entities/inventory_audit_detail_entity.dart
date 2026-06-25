import '../ressponses/inventory_audit_detail_res.dart';

class InventoryAuditDetailEntity {
  final String? auditId;
  final String? auditDate;
  final String? boardChief;
  final int status;
  final int totalAuditedQuantity;

  InventoryAuditDetailEntity({
    this.auditId,
    this.auditDate,
    this.boardChief,
    required this.status,
    required this.totalAuditedQuantity,
  });

  factory InventoryAuditDetailEntity.fromModel(InventoryAuditDetailRes model) {
    final chief = model.auditBoard?.firstWhere(
      (m) => m.role == "Trưởng ban",
      orElse: () => AuditBoardMember(fullName: "", role: ""),
    );
    return InventoryAuditDetailEntity(
      auditId: model.auditId,
      auditDate: model.auditDate,
      boardChief: chief?.fullName,
      status: model.status ?? 2,
      totalAuditedQuantity: model.totalAuditedQuantity ?? 0,
    );
  }
}
