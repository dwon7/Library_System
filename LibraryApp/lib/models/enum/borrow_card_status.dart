import 'package:flutter/material.dart';

enum BorrowCardStatus {
  completed(1, "Hoàn thành", Colors.green),
  borrowing(2, "Đang mượn", Colors.orange),
  overdue(3, "Quá hạn", Colors.red);

  final int value;
  final String label;
  final Color color;

  const BorrowCardStatus(this.value, this.label, this.color);

  static BorrowCardStatus fromValue(int? value) {
    switch (value) {
      case 1:
        return BorrowCardStatus.completed;
      case 3:
        return BorrowCardStatus.overdue;
      default:
        return BorrowCardStatus.borrowing;
    }
  }
}
