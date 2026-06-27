import 'package:flutter/material.dart';

enum LedgerType {
  importStock(1, "Thông tin phiếu nhập kho", Colors.blue),
  exportStock(2, "Thông tin phiếu xuất kho", Colors.deepOrange);

  final int value;
  final String label;
  final Color color;

  const LedgerType(this.value, this.label, this.color);

  static LedgerType fromValue(int? value) {
    return value == 2 ? LedgerType.exportStock : LedgerType.importStock;
  }
}
