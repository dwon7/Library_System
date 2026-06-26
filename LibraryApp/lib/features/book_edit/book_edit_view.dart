import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../models/ressponses/book_detail_res.dart';
import 'book_edit_controller.dart';

class BookEditView extends GetView<BookEditController> {
  const BookEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Chỉnh sửa sách"),
      body: Obx(() {
        final book = controller.book.value;
        if (book == null) return const SizedBox.shrink();
        return _buildForm(book);
      }),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildForm(BookDetailRes book) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Thông tin chung"),
          _buildTextField("Mã sách", book.bookId ?? '', enabled: false),
          _buildTextField("Tiêu đề", book.title ?? '', enabled: false),
          _buildEditField("Giá", controller.priceController, hint: "Nhập giá sách"),
          _buildDivider(),
          _buildDropdown<String>(
            label: "Thể loại",
            value: controller.selectedCategoryId.value,
            items: controller.categories
                .map((c) => DropdownMenuItem<String>(value: c.categoryId, child: Text(c.categoryName ?? '')))
                .toList(),
            onChanged: (v) => controller.selectedCategoryId.value = v,
          ),
          _buildDivider(),
          _buildDropdown<String>(
            label: "Tác giả",
            value: controller.selectedAuthorFullName.value,
            items: controller.authors
                .map((a) => DropdownMenuItem<String>(value: a.fullName, child: Text(a.fullName ?? '')))
                .toList(),
            onChanged: (v) => controller.selectedAuthorFullName.value = v,
          ),
          _buildDivider(),
          _buildDropdown<String>(
            label: "Trạng thái",
            value: controller.selectedStatus.value,
            items: controller.statusOptions
                .map((s) => DropdownMenuItem(value: s, child: Text(_statusLabel(s))))
                .toList(),
            onChanged: (v) => controller.selectedStatus.value = v,
          ),
          _buildDivider(),
          _buildTextField("Năm xuất bản", book.publicationYear?.toString() ?? '', enabled: false),
          _buildDivider(),
          _buildTextField("Nhà xuất bản", book.publisher ?? '', enabled: false),
          _buildDivider(),
          _buildTextField("Loại tài liệu",
              book.documentType == "Physical" ? "Sách giấy" : "Sách điện tử",
              enabled: false),

          _buildSectionTitle("Thông tin kho"),
          _buildEditField("Vị trí kho", controller.locationController, hint: "Nhập vị trí kho"),
          _buildDivider(),
          _buildEditField("Số lượng", controller.quantityController,
              hint: "Nhập số lượng", keyboardType: TextInputType.number),

          if (book.documentType == 'Digital') ...[
            _buildSectionTitle("Thông tin học liệu số"),
            _buildEditField("Định dạng", controller.fileFormatController, hint: "PDF, EPUB..."),
            _buildDivider(),
            _buildEditField("Dung lượng (MB)", controller.fileSizeController, hint: "VD: 15.2"),
            _buildDivider(),
            _buildEditField("Lượt tải", controller.downloadCountController,
                hint: "Nhập số lượt tải", keyboardType: TextInputType.number),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _confirmDelete(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Xoá", style: TextStyle(fontSize: 15)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => controller.save(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Lưu", style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: "Xác nhận xoá",
      middleText: "Bạn có chắc chắn muốn xoá sách này?",
      textConfirm: "Xoá",
      textCancel: "Huỷ",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.delete();
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEditField(String label, TextEditingController? controller, {bool enabled = true, String? hint, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
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
      ),
    );
  }

  Widget _buildTextField(String label, String value, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({required String label, required T? value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  items: items,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'available': return 'Có sẵn';
      case 'borrowed': return 'Đang mượn';
      case 'maintenance': return 'Bảo trì';
      default: return s;
    }
  }

  Widget _buildDivider() => const Divider(height: 1);
}
