import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/add_fab.dart';
import '../../common/widgets/app_header.dart';
import '../../common/widgets/wave_background.dart';
import '../../models/entities/inventory_ledger_detail_entity.dart';
import '../../models/enum/ledger_type.dart';
import '../../routes/app_pages.dart';
import 'inventory_ledgers_controller.dart';
import 'components/inventory_ledger_item.dart';

class InventoryLedgersView extends GetView<InventoryLedgersController> {
  const InventoryLedgersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Nhập xuất kho"),
      floatingActionButton: AddFab(
        heroTag: 'fab-inventory-ledgers',
        onPressed: () async {
          final result = await Get.toNamed(AppPages.newInventoryLedger);
          if (result == true) controller.loadData();
        },
      ),
      body: WaveBackground(
        child: RefreshIndicator(
          onRefresh: () async => controller.loadData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusRow(),
                const SizedBox(height: 24),
                _buildSection(
                  "Nhập kho",
                  controller.importLedgers,
                  controller.importCount,
                  1,
                ),
                _buildSection(
                  "Xuất kho",
                  controller.exportLedgers,
                  controller.exportCount,
                  2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildStatusCard(
              "Nhập kho",
              controller.importCount.value,
              LedgerType.importStock.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatusCard(
              "Xuất kho",
              controller.exportCount.value,
              LedgerType.exportStock.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    RxList<InventoryLedgerDetailEntity> ledgers,
    RxInt totalCount,
    int type,
  ) {
    return Obx(() {
      if (ledgers.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...ledgers
              .take(5)
              .map(
                (l) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InventoryLedgerItem(item: l),
                ),
              ),
          if (totalCount.value > 5)
            GestureDetector(
              onTap: () => Get.toNamed(
                AppPages.listInventoryLedgers,
                arguments: {'type': type, 'title': title},
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 16),
                child: Center(
                  child: Text(
                    "Xem thêm",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 16),
        ],
      );
    });
  }
}
