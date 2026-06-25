import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../models/ressponses/inventory_ledger_detail_res.dart';
import '../../models/enum/ledger_type.dart';
import 'inventory_ledger_detail_controller.dart';

class InventoryLedgerDetailView extends GetView<InventoryLedgerDetailController> {
  const InventoryLedgerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Chi tiết phiếu kho"),
      body: Obx(() {
        final l = controller.ledger.value;
        if (l == null) return const SizedBox.shrink();
        return _buildContent(l);
      }),
    );
  }

  Widget _buildContent(InventoryLedgerDetailRes l) {
    final type = LedgerType.fromValue(l.ledgerType);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: type.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: type.color.withOpacity(0.4)),
              ),
              child: Text(type.label, style: TextStyle(color: type.color, fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 20),
          _buildRow("Mã phiếu", l.ledgerId),
          _buildDivider(),
          _buildRow("Ngày giao dịch", l.transactionDate),
          _buildDivider(),
          _buildRow("Nhân viên", l.staffInCharge),
          _buildDivider(),
          _buildRow("Đối tác", l.partner?.partnerName),
          _buildDivider(),
          _buildRow("Mã số thuế/MSSV", l.partner?.taxOrStudentId),
          _buildDivider(),
          _buildRow("Tổng tiền", l.grandTotal != null ? "${l.grandTotal} đ" : null),
          _buildDivider(),
          _buildRow("Ghi chú", l.notes),

          if (l.ledgerDetails != null && l.ledgerDetails!.isNotEmpty) ...[
            _buildSectionTitle("Chi tiết phiếu"),
            ...l.ledgerDetails!.map((d) => _buildLedgerDetail(d)),
          ],
        ],
      ),
    );
  }

  Widget _buildLedgerDetail(LedgerDetail d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow("Mã sách", d.bookId),
          const SizedBox(height: 4),
          _buildRow("Đơn giá", d.unitPrice?.toString()),
          const SizedBox(height: 4),
          _buildRow("Số lượng", d.quantity?.toString()),
          const SizedBox(height: 4),
          _buildRow("Thành tiền", d.totalAmount?.toString()),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value ?? "—", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDivider() => const Divider(height: 1);
}
