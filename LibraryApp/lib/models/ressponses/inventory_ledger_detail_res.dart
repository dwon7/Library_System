

// lib/data/models/inventory_ledger_model.dart

class InventoryLedgerDetailRes {
  String? ledgerId;
  int? ledgerType; // 1: Nhập kho, 2: Xuất kho
  String? transactionDate;
  String? staffInCharge;
  Partner? partner;
  List<LedgerDetail>? ledgerDetails;
  int? grandTotal;
  String? notes;

  InventoryLedgerDetailRes({
    this.ledgerId,
    this.ledgerType,
    this.transactionDate,
    this.staffInCharge,
    this.partner,
    this.ledgerDetails,
    this.grandTotal,
    this.notes,
  });

  factory InventoryLedgerDetailRes.fromJson(Map<String, dynamic> json) => InventoryLedgerDetailRes(
    ledgerId: json['ledgerId'],
    ledgerType: json['ledgerType'],
    transactionDate: json['transactionDate'],
    staffInCharge: json['staffInCharge'],
    partner: json['partner'] != null ? Partner.fromJson(json['partner']) : null,
    ledgerDetails: json['ledgerDetails'] != null
        ? List<LedgerDetail>.from(json['ledgerDetails'].map((x) => LedgerDetail.fromJson(x)))
        : null,
    grandTotal: (json['grandTotal'] as num?)?.toInt(),
    notes: json['notes'],
  );

  Map<String, dynamic> toJson() => {
    'ledgerId': ledgerId,
    'ledgerType': ledgerType,
    'transactionDate': transactionDate,
    'staffInCharge': staffInCharge,
    if (partner != null) 'partner': partner!.toJson(),
    'ledgerDetails': ledgerDetails?.map((x) => x.toJson()).toList(),
    'grandTotal': grandTotal,
    'notes': notes,
  };
}

class Partner {
  String? partnerName;
  String? taxOrStudentId;

  Partner({this.partnerName, this.taxOrStudentId});

  factory Partner.fromJson(Map<String, dynamic> json) => Partner(
    partnerName: json['partnerName'],
    taxOrStudentId: json['taxOrStudentId'],
  );

  Map<String, dynamic> toJson() => {
    'partnerName': partnerName,
    'taxOrStudentId': taxOrStudentId,
  };
}

class LedgerDetail {
  String? bookId; // Link ID cuốn sách
  int? quantity;
  int? unitPrice;
  int? totalAmount;

  LedgerDetail({this.bookId, this.quantity, this.unitPrice, this.totalAmount});

  factory LedgerDetail.fromJson(Map<String, dynamic> json) => LedgerDetail(
    bookId: json['bookId']?.toString(),
    quantity: json['quantity'],
    unitPrice: json['unitPrice'],
    totalAmount: json['totalAmount'],
  );

  Map<String, dynamic> toJson() => {
    'bookId': bookId,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalAmount': totalAmount,
  };
}