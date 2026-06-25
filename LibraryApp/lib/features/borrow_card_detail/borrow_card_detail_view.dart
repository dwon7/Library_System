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
          _buildRow("Ngày mượn", card.borrowDate),
          _buildDivider(),
          _buildRow("Ngày hẹn trả", card.dueDate),
          _buildDivider(),

          if (card.borrowDetails != null && card.borrowDetails!.isNotEmpty) ...[
            _buildSectionTitle("Danh sách sách mượn"),
            ...card.borrowDetails!.map((d) => _buildBorrowDetail(d)),
          ],
        ],
      ),
    );
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
          _buildRow("Mã sách", detail.bookId),
          const SizedBox(height: 4),
          _buildRow("Tên sách", detail.bookName),
          const SizedBox(height: 4),
          _buildRow("Giá", detail.bookPrice != null ? "${detail.bookPrice!} đ" : null),
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
