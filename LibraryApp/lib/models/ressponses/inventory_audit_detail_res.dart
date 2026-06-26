


// lib/data/models/inventory_audit_model.dart

class InventoryAuditDetailRes {
  String? auditId;
  String? auditDate;
  List<AuditBoardMember>? auditBoard;
  int? status; // 1: Đã hoàn thành, 2: Chưa hoàn thành
  List<AuditDetail>? auditDetails;
  int? totalAuditedQuantity;
  String? notes;

  InventoryAuditDetailRes({
    this.auditId,
    this.auditDate,
    this.auditBoard,
    this.status,
    this.auditDetails,
    this.totalAuditedQuantity,
    this.notes,
  });

  factory InventoryAuditDetailRes.fromJson(Map<String, dynamic> json) => InventoryAuditDetailRes(
    auditId: json['auditId'],
    auditDate: json['auditDate'],
    auditBoard: json['auditBoard'] != null
        ? List<AuditBoardMember>.from(json['auditBoard'].map((x) => AuditBoardMember.fromJson(x)))
        : null,
    status: json['status'],
    auditDetails: json['auditDetails'] != null
        ? List<AuditDetail>.from(json['auditDetails'].map((x) => AuditDetail.fromJson(x)))
        : null,
    totalAuditedQuantity: json['totalAuditedQuantity'],
    notes: json['notes'],
  );

  Map<String, dynamic> toJson() => {
    'auditId': auditId,
    'auditDate': auditDate,
    'auditBoard': auditBoard?.map((x) => x.toJson()).toList(),
    'status': status,
    'auditDetails': auditDetails?.map((x) => x.toJson()).toList(),
    'totalAuditedQuantity': totalAuditedQuantity,
    'notes': notes,
  };
}

class AuditBoardMember {
  String? fullName;
  String? role;

  AuditBoardMember({this.fullName, this.role});

  factory AuditBoardMember.fromJson(Map<String, dynamic> json) => AuditBoardMember(
    fullName: json['fullName'],
    role: json['role'],
  );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'role': role,
  };
}

class AuditDetail {
  String? bookId; // Link ID cuốn sách
  int? quantity;
  int? conditionType; // 1: Còn sử dụng, 2: Rách nát, 3: Mất

  AuditDetail({this.bookId, this.quantity, this.conditionType});

  factory AuditDetail.fromJson(Map<String, dynamic> json) => AuditDetail(
    bookId: json['bookId']?.toString(),
    quantity: json['quantity'],
    conditionType: json['conditionType'],
  );

  Map<String, dynamic> toJson() => {
    'bookId': bookId,
    'quantity': quantity,
    'conditionType': conditionType,
  };
}