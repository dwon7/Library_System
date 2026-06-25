import 'package:flutter/material.dart';

enum AuditStatus {
  completed(1, "Đã hoàn thành", Colors.green),
  incomplete(2, "Chưa hoàn thành", Colors.red);

  final int value;
  final String label;
  final Color color;

  const AuditStatus(this.value, this.label, this.color);

  static AuditStatus fromValue(int? value) {
    return value == 2 ? AuditStatus.incomplete : AuditStatus.completed;
  }
}
