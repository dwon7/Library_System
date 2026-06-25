import '../ressponses/inventory_ledger_detail_res.dart';

class InventoryLedgerDetailEntity {
  final String? ledgerId;
  final int ledgerType;
  final String? transactionDate;
  final String? staffInCharge;
  final String? partnerName;
  final int grandTotal;

  InventoryLedgerDetailEntity({
    this.ledgerId,
    required this.ledgerType,
    this.transactionDate,
    this.staffInCharge,
    this.partnerName,
    required this.grandTotal,
  });

  factory InventoryLedgerDetailEntity.fromModel(InventoryLedgerDetailRes model) {
    return InventoryLedgerDetailEntity(
      ledgerId: model.ledgerId,
      ledgerType: model.ledgerType ?? 1,
      transactionDate: model.transactionDate,
      staffInCharge: model.staffInCharge,
      partnerName: model.partner?.partnerName,
      grandTotal: model.grandTotal ?? 0,
    );
  }
}
