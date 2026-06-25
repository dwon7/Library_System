import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/entities/borrow_card_detail_entity.dart';
import '../../../models/enum/borrow_card_status.dart';
import '../../../routes/app_pages.dart';

class BorrowCardItem extends StatelessWidget {
  final BorrowCardDetailEntity item;

  const BorrowCardItem({super.key, required this.item});

  Color get _statusColor => BorrowCardStatus.fromValue(item.status).color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppPages.borrowCardDetail, arguments: item.cardId);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _statusColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phiếu ${item.cardId ?? ""}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(item.userName ?? "", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            Text(
              "Trả: ${item.dueDate ?? ""}",
              style: TextStyle(fontSize: 13, color: _statusColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
