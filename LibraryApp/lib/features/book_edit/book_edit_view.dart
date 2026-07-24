import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../models/ressponses/book_detail_res.dart';
import 'book_edit_controller.dart';

class BookEditView extends GetView<BookEditController> {
  const BookEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppHeader(title: "Chỉnh sửa sách"),
        body: Obx(() {
          final book = controller.book.value;
          if (book == null) return const SizedBox.shrink();
          return _buildForm(book);
        }),
        bottomNavigationBar: _buildBottomButtons(context),
      ),
    );
  }

  Widget _buildForm(BookDetailRes book) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            icon: Icons.menu_book_outlined,
            title: "Thông tin chung",
            children: [
              _buildTextField("Mã sách", book.bookId ?? '', enabled: false),
              _buildTextField("Tiêu đề", book.title ?? '', enabled: false),
              _buildEditField(
                "Giá",
                controller.priceController,
                hint: "Nhập giá sách",
              ),
              _buildDropdown<String>(
                label: "Thể loại",
                value: controller.selectedCategoryId.value,
                items: controller.categories
                    .map(
                      (c) => DropdownMenuItem<String>(
                        value: c.categoryId,
                        child: Text(c.categoryName ?? ''),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.selectedCategoryId.value = v,
              ),
              _buildDropdown<String>(
                label: "Tác giả",
                value: controller.selectedAuthorFullName.value,
                items: controller.authors
                    .map(
                      (a) => DropdownMenuItem<String>(
                        value: a.fullName,
                        child: Text(a.fullName ?? ''),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.selectedAuthorFullName.value = v,
              ),
              _buildDropdown<String>(
                label: "Trạng thái",
                value: controller.selectedStatus.value,
                items: controller.statusOptions
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(_statusLabel(s)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.selectedStatus.value = v,
              ),
              _buildTextField(
                "Năm xuất bản",
                book.publicationYear?.toString() ?? '',
                enabled: false,
              ),
              _buildTextField(
                "Nhà xuất bản",
                book.publisher ?? '',
                enabled: false,
              ),
              _buildTextField(
                "Loại tài liệu",
                book.documentType == "Physical" ? "Sách giấy" : "Sách điện tử",
                enabled: false,
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            icon: Icons.warehouse_outlined,
            title: "Thông tin kho",
            children: [
              _buildEditField(
                "Vị trí kho",
                controller.locationController,
                hint: "Nhập vị trí kho",
              ),
              _buildEditField(
                "Số lượng",
                controller.quantityController,
                hint: "Nhập số lượng",
                keyboardType: TextInputType.number,
                isLast: true,
              ),
            ],
          ),
          if (book.documentType == 'Digital') ...[
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.cloud_outlined,
              title: "Thông tin học liệu số",
              children: [
                _buildEditField(
                  "Định dạng",
                  controller.fileFormatController,
                  hint: "PDF, EPUB...",
                ),
                _buildEditField(
                  "Dung lượng (MB)",
                  controller.fileSizeController,
                  hint: "VD: 15.2",
                ),
                _buildEditField(
                  "Lượt tải",
                  controller.downloadCountController,
                  hint: "Nhập số lượt tải",
                  keyboardType: TextInputType.number,
                  isLast: true,
                ),
              ],
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
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
              onPressed: () => _confirmDelete(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Xoá",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
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
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Lưu",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Xác nhận xoá'),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xoá sách này? Hành động này không thể hoàn tác.',
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[400]!),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    ).then((value) {
      if (value == true && context.mounted) {
        controller.delete(context);
      }
    });
  }

  Widget _buildEditField(
    String label,
    TextEditingController? controller, {
    bool enabled = true,
    String? hint,
    TextInputType? keyboardType,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String value, {
    bool enabled = true,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
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
      case 'available':
        return 'Có sẵn';
      case 'borrowed':
        return 'Đang mượn';
      case 'maintenance':
        return 'Bảo trì';
      default:
        return s;
    }
  }
}
