import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/utils/app_utils.dart';
import '../../../models/entities/inventory_ledger_detail_entity.dart';
import '../../../models/enum/ledger_type.dart';
import '../../../routes/app_pages.dart';

class InventoryLedgerItem extends StatelessWidget {
  final InventoryLedgerDetailEntity item;

  const InventoryLedgerItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final type = LedgerType.fromValue(item.ledgerType);
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppPages.inventoryLedgerDetail, arguments: item.ledgerId);
      },
      child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: type.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: type.color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: type.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.ledgerType == 1 ? Icons.download : Icons.upload,
              color: type.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phiếu ${item.ledgerId ?? ""}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(item.partnerName ?? "", style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.transactionDate ?? "", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text("${AppUtils.formatMoney(item.grandTotal)} đ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: type.color)),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
