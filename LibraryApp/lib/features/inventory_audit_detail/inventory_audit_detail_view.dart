import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/models/ressponses/inventory_audit_detail_res.dart';
import 'inventory_audit_detail_controller.dart';

class InventoryAuditDetailView
    extends GetView<InventoryAuditDetailController> {
  const InventoryAuditDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chi tiết kiểm kê"),
        actions: [
          Obx(() {
            if (!controller.isCompleted) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPieChart(),
            const SizedBox(height: 24),
            if (controller.isCompleted) ...[
              ...controller.inventoriedBooks.map((book) => _buildBookItem(book)),
            ] else ...[
              _buildBookSection("Chưa kiểm kê", controller.uninventoriedBooks, controller.uninventoriedBooks),
              const SizedBox(height: 16),
              _buildBookSection("Đã kiểm kê", controller.inventoriedBooks, controller.inventoriedBooks),
            ],
          ],
        )),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Cảnh báo'),
          ],
        ),
        content: const Text('Bạn có chắc chắn muốn xoá phiếu kiểm kê này không?'),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[400]!),
            ),
            onPressed: () => Get.back(),
            child: const Text('Không'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () {
              Get.back();
              controller.deleteAudit();
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Obx(() {
      final scanned = controller.scannedCount.value;
      final total = controller.totalCount.value;
      final unscanned = total - scanned;

      return Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  if (scanned > 0)
                    PieChartSectionData(
                      value: scanned.toDouble(),
                      color: Colors.green,
                      title: '$scanned',
                      radius: 60,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  if (unscanned > 0)
                    PieChartSectionData(
                      value: unscanned.toDouble(),
                      color: Colors.red.shade300,
                      title: '$unscanned',
                      radius: 60,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem("Đã kiểm kê", Colors.green, scanned),
              const SizedBox(width: 24),
              _legendItem("Chưa kiểm kê", Colors.red.shade300, unscanned),
            ],
          ),
        ],
      );
    });
  }

  Widget _legendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text("$label: $count",
            style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildBookSection(
    String title,
    RxList<AuditDetail> books,
    RxList<AuditDetail> allBooks,
  ) {
    return Obx(() {
      if (books.isEmpty) return const SizedBox.shrink();
      final displayBooks =
          allBooks.length > 5 ? allBooks.sublist(0, 5) : allBooks;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...displayBooks.map((book) => _buildBookItem(book)),
          if (allBooks.length > 5)
            GestureDetector(
              onTap: () => AppToast.show("Tính năng đang phát triển"),
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

  Widget _buildBookItem(AuditDetail book) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.bookId ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text("SL: ${book.quantity ?? 0}",
                    style:
                        const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          Text(_conditionLabel(book.conditionType),
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  String _conditionLabel(int? conditionType) {
    switch (conditionType) {
      case 1: return "Còn sử dụng";
      case 2: return "Rách nát";
      case 3: return "Mất";
      case 4: return "Chưa kiểm kê";
      default: return "";
    }
  }
}
