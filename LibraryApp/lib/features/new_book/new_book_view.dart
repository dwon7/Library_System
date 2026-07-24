import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import 'new_book_controller.dart';

class NewBookView extends GetView<NewBookController> {
  const NewBookView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const AppHeader(title: "Thêm sách mới"),
        body: Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Thông tin chung"),
              TextFormField(
                enabled: false,
                decoration: const InputDecoration(labelText: "Mã sách", border: OutlineInputBorder()),
                controller: TextEditingController(text: controller.bookId.value),
              ),
              const SizedBox(height: 12),
              _buildTextField("Tiêu đề", controller.titleController, hint: "Nhập tiêu đề sách"),
              const SizedBox(height: 12),
              _buildTextField("Giá", controller.priceController, hint: "Nhập giá sách", keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildDropdown<String>(
                label: "Thể loại",
                value: controller.selectedCategoryId.value,
                items: controller.categories
                    .map((c) => DropdownMenuItem<String>(value: c.categoryId, child: Text(c.categoryName ?? '')))
                    .toList(),
                onChanged: (v) => controller.selectedCategoryId.value = v,
              ),
              const SizedBox(height: 12),
              _buildTextField("Tác giả", controller.authorController, hint: "Nhập tên tác giả"),
              const SizedBox(height: 12),
              _buildTextField("Năm xuất bản", controller.publicationYearController, hint: "VD: 2024", keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField("Nhà xuất bản", controller.publisherController, hint: "Nhập nhà xuất bản"),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _buildTypeOption("Physical", "Sách giấy")),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTypeOption("Digital", "Sách điện tử")),
                ],
              ),

              if (controller.documentType.value == 'Physical') ...[
                _buildSectionTitle("Thông tin kho"),
                _buildTextField("Vị trí kho", controller.locationController, hint: "Nhập vị trí kho"),
                const SizedBox(height: 12),
                _buildTextField("Số lượng", controller.quantityController, hint: "Nhập số lượng", keyboardType: TextInputType.number),
              ] else ...[
                _buildSectionTitle("Thông tin học liệu số"),
                _buildTextField("Định dạng", controller.fileFormatController, hint: "PDF, EPUB..."),
                const SizedBox(height: 12),
                _buildTextField("Dung lượng (MB)", controller.fileSizeController, hint: "VD: 15.2"),
              ],
              const SizedBox(height: 80),
            ],
          ),
        )),
        bottomNavigationBar: _buildSubmitButton(context),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
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
        child: const Text("Thêm sách", style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildTypeOption(String type, String label) {
    final selected = controller.documentType.value == type;
    return GestureDetector(
      onTap: () => controller.onDocumentTypeChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.black87 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(String label, TextEditingController? controller, {String? hint, TextInputType? keyboardType}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              hintText: hint,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({required String label, required T? value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                isDense: true,
                hint: const Text("Chọn thể loại", style: TextStyle(fontSize: 14, color: Colors.grey)),
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
