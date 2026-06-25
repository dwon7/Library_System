import 'package:flutter/material.dart';
import '../../../models/entities/inventory_audit_detail_entity.dart';
import '../../../models/enum/audit_status.dart';

class InventoryAuditItem extends StatelessWidget {
  final InventoryAuditDetailEntity item;

  const InventoryAuditItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final status = AuditStatus.fromValue(item.status);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: status.color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.status == 1 ? Icons.check_circle_outline : Icons.pending_outlined,
              color: status.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phiếu ${item.auditId ?? ""}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(item.boardChief != null && item.boardChief!.isNotEmpty ? "Trưởng ban: ${item.boardChief}" : "", style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.auditDate ?? "", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text("SL: ${item.totalAuditedQuantity}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: status.color)),
            ],
          ),
        ],
      ),
    );
  }
}
