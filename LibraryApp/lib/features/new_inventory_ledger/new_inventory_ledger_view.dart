import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../models/ressponses/book_detail_res.dart';
import 'new_inventory_ledger_controller.dart';

class NewInventoryLedgerView extends GetView<NewInventoryLedgerController> {
  const NewInventoryLedgerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Tạo phiếu kho"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Loại phiếu
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(1, "Nhập kho"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeOption(2, "Xuất kho"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Mã phiếu (disabled)
                  TextFormField(
                    enabled: false,
                    decoration: const InputDecoration(labelText: "Mã phiếu", border: OutlineInputBorder()),
                    controller: TextEditingController(text: controller.cardId.value),
                  ),
                  const SizedBox(height: 12),

                  // Ngày giao dịch
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Ngày giao dịch", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                    controller: TextEditingController(text: controller.transactionDate.value),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                      if (date != null) controller.transactionDate.value = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    },
                  ),
                  const SizedBox(height: 12),

                  // Nhân viên
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nhân viên phụ trách", border: OutlineInputBorder()),
                    onChanged: (v) => controller.staffInCharge.value = v,
                  ),
                  const SizedBox(height: 12),

                  // Đối tác
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Đối tác", border: OutlineInputBorder()),
                    onChanged: (v) => controller.partnerName.value = v,
                  ),
                  const SizedBox(height: 12),

                  // Mã số thuế / MSSV
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Mã số thuế / MSSV", border: OutlineInputBorder()),
                    onChanged: (v) => controller.taxOrStudentId.value = v,
                  ),
                  const SizedBox(height: 12),

                  // Ghi chú
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Ghi chú", border: OutlineInputBorder()),
                    onChanged: (v) => controller.notes.value = v,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  // Danh sách sách
                  Row(
                    children: [
                      const Text("Danh sách sách", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.black87, size: 28),
                        onPressed: () => controller.addLedgerDetail(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...controller.ledgerDetails.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildDetailBlock(entry.key, entry.value),
                  )),
                ],
              )),
            ),
          ),
          // Nút Tạo
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 10 + MediaQuery.of(context).viewPadding.bottom, top: 16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))]),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () => _showConfirmDialog(),
              child: const Text("Tạo phiếu kho", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    if (!controller.validate()) return;

    final rows = controller.ledgerDetails.where((e) => e.selectedBook != null).map((e) {
      final qty = int.tryParse(e.quantityController.text) ?? 0;
      final price = int.tryParse(e.unitPriceController.text) ?? 0;
      return (title: e.selectedBook!.title ?? "", qty: qty, amount: qty * price);
    }).toList();
    final grandTotal = rows.fold<int>(0, (sum, r) => sum + r.amount);

    Get.dialog(
      AlertDialog(
        title: const Text("Xác nhận tạo phiếu kho"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Đối tác: ${controller.partnerName.value}"),
              Text("Ngày lập: ${controller.transactionDate.value}"),
              const SizedBox(height: 12),
              const Text("Chi tiết phiếu", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text("${r.title} - SL: ${r.qty} - Thành tiền: ${r.amount}"),
              )),
              const Divider(),
              Text("Tổng tiền: $grandTotal", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text("Huỷ"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.submit();
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(int type, String label) {    return Obx(() => GestureDetector(
      onTap: () => controller.onLedgerTypeChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: controller.ledgerType.value == type ? Colors.black87 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: controller.ledgerType.value == type ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
        ),
      ),
    ));
  }

  Widget _buildDetailBlock(int index, LedgerDetailEntry entry) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          DropdownButtonFormField<BookDetailRes>(
            value: entry.selectedBook,
            decoration: const InputDecoration(labelText: "Tên sách", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
            items: controller.books.map((b) => DropdownMenuItem(value: b, child: Text(b.title ?? "", overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (val) => controller.onBookSelected(index, val),
          ),
          const SizedBox(height: 8),
          TextFormField(
            enabled: false,
            decoration: const InputDecoration(labelText: "Đơn giá", border: OutlineInputBorder()),
            controller: entry.unitPriceController,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("Số lượng", style: TextStyle(fontSize: 14)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 28),
                onPressed: () {
                  int cur = int.tryParse(entry.quantityController.text) ?? 1;
                  if (cur > 1) entry.quantityController.text = (cur - 1).toString();
                },
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  controller: entry.quantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 28),
                onPressed: () {
                  int cur = int.tryParse(entry.quantityController.text) ?? 1;
                  entry.quantityController.text = (cur + 1).toString();
                },
              ),
              if (controller.ledgerDetails.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 22, color: Colors.red),
                  onPressed: () => controller.removeLedgerDetail(index),
                ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: Listenable.merge([entry.quantityController, entry.unitPriceController]),
            builder: (_, __) {
              final qty = int.tryParse(entry.quantityController.text) ?? 0;
              final price = int.tryParse(entry.unitPriceController.text) ?? 0;
              return Row(
                children: [
                  const Text("Thành tiền", style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  Text("${qty * price}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
