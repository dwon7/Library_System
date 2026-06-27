import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../models/ressponses/book_detail_res.dart';
import 'new_inventory_audit_controller.dart';

class NewInventoryAuditView extends GetView<NewInventoryAuditController> {
  const NewInventoryAuditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Tạo phiếu kiểm kê"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    enabled: false,
                    decoration: const InputDecoration(labelText: "Mã phiếu", border: OutlineInputBorder()),
                    controller: TextEditingController(text: controller.auditId.value),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Ngày kiểm kê", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                    controller: TextEditingController(text: controller.auditDate.value),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                      if (date != null) controller.auditDate.value = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    },
                  ),
                  const SizedBox(height: 12),
                  // Row(
                  //   children: [
                  //     const Text("Trạng thái", style: TextStyle(fontSize: 14)),
                  //     const Spacer(),
                  //     _buildStatusBtn(1, "Đã hoàn thành"),
                  //     const SizedBox(width: 8),
                  //     _buildStatusBtn(2, "Chưa hoàn thành"),
                  //   ],
                  // ),
                  // const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Ghi chú", border: OutlineInputBorder()),
                    onChanged: (v) => controller.notes.value = v,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  // Ban kiểm kê
                  Row(
                    children: [
                      const Text("Ban kiểm kê", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.person_add, size: 24), onPressed: () => controller.addAuditMember()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...controller.auditBoard.asMap().entries.map((e) => _buildMemberRow(e.key, e.value)),

                  const SizedBox(height: 20),
                  // Danh sách sách
                  Row(
                    children: [
                      const Text("Tổng số sách cần kiểm kê", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Obx(() => Text("${controller.books.value.length} sách")) // IconButton(icon: const Icon(Icons.add_circle, color: Colors.black87, size: 28), onPressed: () => controller.addAuditDetail()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // ...controller.auditDetails.asMap().entries.map((e) => _buildDetailBlock(e.key, e.value)),
                ],
              )),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 10 + MediaQuery.of(context).viewPadding.bottom, top: 16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))]),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () => controller.submit(),
              child: const Text("Tạo phiếu kiểm kê", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBtn(int value, String label) {
    return GestureDetector(
      onTap: () => controller.status.value = value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: controller.status.value == value ? Colors.black87 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label, style: TextStyle(color: controller.status.value == value ? Colors.white : Colors.black87, fontSize: 13)),
      ),
    );
  }

  Widget _buildMemberRow(int index, AuditMemberEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: entry.nameController,
              decoration: const InputDecoration(labelText: "Họ tên", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: entry.roleController,
              decoration: const InputDecoration(labelText: "Vai trò", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
            ),
          ),
          if (controller.auditBoard.length > 1)
            IconButton(icon: const Icon(Icons.close, size: 18, color: Colors.red), onPressed: () => controller.removeAuditMember(index)),
        ],
      ),
    );
  }

  Widget _buildDetailBlock(int index, AuditDetailEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          Row(
            children: [
              const Text("Số lượng", style: TextStyle(fontSize: 14)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.remove_circle_outline, size: 28), onPressed: () {
                int cur = int.tryParse(entry.quantityController.text) ?? 1;
                if (cur > 1) entry.quantityController.text = (cur - 1).toString();
              }),
              SizedBox(
                width: 50,
                child: TextFormField(
                  controller: entry.quantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                ),
              ),
              IconButton(icon: const Icon(Icons.add_circle_outline, size: 28), onPressed: () {
                int cur = int.tryParse(entry.quantityController.text) ?? 1;
                entry.quantityController.text = (cur + 1).toString();
              }),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("Tình trạng", style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              _buildCondBtn(index, entry, 1, "Còn SD"),
              _buildCondBtn(index, entry, 2, "Rách nát"),
              _buildCondBtn(index, entry, 3, "Mất"),
            ],
          ),
          if (controller.auditDetails.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red), onPressed: () => controller.removeAuditDetail(index)),
            ),
        ],
      ),
    );
  }

  Widget _buildCondBtn(int index, AuditDetailEntry entry, int value, String label) {
    return GestureDetector(
      onTap: () {
        entry.conditionType = value;
        controller.auditDetails.refresh();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: entry.conditionType == value ? Colors.black87 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: TextStyle(color: entry.conditionType == value ? Colors.white : Colors.black87, fontSize: 12)),
      ),
    );
  }
}
