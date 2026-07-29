import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/user_detail_res.dart';
import 'new_borrow_card_controller.dart';
import '../borrow_cards/components/borrow_detail_widget.dart';

class NewBorrowCardView extends GetView<NewBorrowCardController> {
  const NewBorrowCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Tạo phiếu mượn"),
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
                    decoration: InputDecoration(
                      labelText: "Mã phiếu",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    controller: TextEditingController(text: controller.cardId.value),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<UserDetailRes>(
                    value: controller.selectedUser.value,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: "Độc giả",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    items: controller.users.map((u) => DropdownMenuItem(
                      value: u,
                      child: Text(
                        "${u.fullName ?? ""} (${u.userId ?? ""})",
                        overflow: TextOverflow.ellipsis,
                      ),
                    )).toList(),
                    onChanged: (val) => controller.selectedUser.value = val,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Ngày mượn",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(text: controller.borrowDate.value),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        controller.borrowDate.value =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Ngày hẹn trả",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(text: controller.dueDate.value),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        controller.dueDate.value =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Text("Danh sách sách mượn", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.black87, size: 28),
                        onPressed: () => controller.addBorrowDetail(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...controller.borrowDetails.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BorrowDetailWidget(
                      selectedBook: entry.value.selectedBook,
                      books: controller.books,
                      quantityController: entry.value.quantityController,
                      onBookChanged: (book) {
                        controller.onBookSelected(entry.key, book);
                      },
                      onDelete: controller.borrowDetails.length > 1
                          ? () => controller.removeBorrowDetail(entry.key)
                          : null,
                    ),
                  )),
                ],
              )),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 10 + MediaQuery.of(context).viewPadding.bottom, top: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => controller.submit(),
              child: const Text("Tạo phiếu mượn", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
