import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_header.dart';
import '../../common/widgets/app_toast.dart';
import '../../models/entities/inventory_audit_detail_entity.dart';
import '../../models/enum/audit_status.dart';
import '../../routes/app_pages.dart';
import 'inventory_audits_controller.dart';
import 'components/inventory_audit_item.dart';

class InventoryAuditsView extends GetView<InventoryAuditsController> {
  const InventoryAuditsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Kiểm kê"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () async {
          final result = await Get.toNamed(AppPages.newInventoryAudit);
          if (result == true) controller.loadData();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusRow(),
              const SizedBox(height: 24),
              _buildSection("Đã hoàn thành", controller.completedAudits, controller.completedCount, 1),
              _buildSection("Chưa hoàn thành", controller.incompleteAudits, controller.incompleteCount, 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Obx(() => Row(
          children: [
            Expanded(child: _buildStatusCard("Đã hoàn thành", controller.completedCount.value, AuditStatus.completed.color)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatusCard("Chưa hoàn thành", controller.incompleteCount.value, AuditStatus.incomplete.color)),
          ],
        ));
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
          Text("$count", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, RxList<InventoryAuditDetailEntity> audits, RxInt totalCount, int status) {
    return Obx(() {
      if (audits.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...audits.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InventoryAuditItem(item: a),
              )),
          if (totalCount.value > 4)
            GestureDetector(
              onTap: () => AppToast.show("Tính năng đang phát triển"),
              child: const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 16),
                child: Center(
                  child: Text("Xem thêm", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, decoration: TextDecoration.underline, color: Colors.blueGrey)),
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
