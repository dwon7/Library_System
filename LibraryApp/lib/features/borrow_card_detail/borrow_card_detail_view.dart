import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../models/ressponses/borrow_card_detail_res.dart';
import '../../models/enum/borrow_card_status.dart';
import 'borrow_card_detail_controller.dart';

class BorrowCardDetailView extends GetView<BorrowCardDetailController> {
  const BorrowCardDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Chi tiết phiếu mượn"),
      body: Obx(() {
        final card = controller.card.value;
        if (card == null) return const SizedBox.shrink();
        return _buildContent(card);
      }),
      floatingActionButton: Obx(() {
        final status = controller.card.value?.status;
        // Chỉ hiển thị nút Trả sách khi đang mượn (2) hoặc quá hạn (3)
        if (status == 2 || status == 3) {
          return FloatingActionButton.extended(
            heroTag: 'fab-return-book',
            onPressed: () => _confirmReturn(context),
            icon: const Icon(Icons.assignment_return_outlined),
            label: const Text("Trả sách"),
            backgroundColor: Colors.green,
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  void _confirmReturn(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận trả sách"),
        content: const Text("Xác nhận độc giả đã trả toàn bộ sách trong phiếu này?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Huỷ")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Get.back();
              controller.returnBook();
            },
            child: const Text("Xác nhận", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BorrowCardDetailRes card) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBadge(card.status),
          const SizedBox(height: 20),
          _buildRow("Mã phiếu", card.cardId),
          _buildDivider(),
          _buildRow("Mã độc giả", card.userId),
          _buildDivider(),
          _buildRow("Tên độc giả", controller.userName.value),
          _buildDivider(),
          _buildRow("Ngày mượn", _formatDate(card.borrowDate)),
          _buildDivider(),
          _buildRow("Ngày hẹn trả", _formatDate(card.dueDate)),
          _buildDivider(),

          if (card.borrowDetails != null && card.borrowDetails!.isNotEmpty) ...[
            _buildSectionTitle("Danh sách sách mượn"),
            ...card.borrowDetails!.map((d) => _buildBorrowDetail(d)),
          ],
          const SizedBox(height: 80), // space for FAB
        ],
      ),
    );
  }

  /// Parse ISO8601 datetime từ API → dd/MM/yyyy
  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final local = dt.toLocal();
    return "${local.day.toString().padLeft(2, '0')}/"
        "${local.month.toString().padLeft(2, '0')}/"
        "${local.year}";
  }

  Widget _buildStatusBadge(int? status) {
    final s = BorrowCardStatus.fromValue(status);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: s.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: s.color.withOpacity(0.4)),
        ),
        child: Text(s.label, style: TextStyle(color: s.color, fontWeight: FontWeight.w600, fontSize: 15)),
      ),
    );
  }

  Widget _buildBorrowDetail(BorrowDetail detail) {
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
          _buildRow("Tên sách", detail.bookName),
          const SizedBox(height: 4),
          _buildRow("Số lượng", detail.quantity?.toString()),
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
            width: 130,
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
