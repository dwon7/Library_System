import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../models/ressponses/book_detail_res.dart';
import 'book_detail_controller.dart';

class BookDetailView extends GetView<BookDetailController> {
  const BookDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: "Chi tiết sách",
        // icon: Icons.arrow_back,
        // onTap: () => Get.back(),
      ),
      body: Obx(() {
        final book = controller.book.value;
        if (book == null) {
          return const SizedBox.shrink();
        }
        return _buildContent(book);
      }),
    );
  }

  Widget _buildContent(BookDetailRes book) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/book.png',
                width: 160,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Mã sách
          _buildRow("Mã sách", book.bookId),
          _buildDivider(),
          // Tiêu đề
          _buildRow("Tiêu đề", book.title),
          _buildDivider(),
          // Năm xuất bản
          _buildRow("Năm xuất bản", book.publicationYear?.toString()),
          _buildDivider(),
          // Nhà xuất bản
          _buildRow("Nhà xuất bản", book.publisher),
          _buildDivider(),
          // Tác giả
          _buildAuthors(book.authors),
          _buildDivider(),
          // Loại tài liệu
          _buildRow("Loại tài liệu", book.documentType == "Physical" ? "Sách giấy" : "Sách điện tử"),
          _buildDivider(),

          // Physical info
          if (book.physicalInfo != null) ...[
            _buildSectionTitle("Thông tin kho"),
            _buildRow("Vị trí kho", book.physicalInfo!.warehouseLocation),
            _buildDivider(),
            _buildRow("Kệ", book.physicalInfo!.shelfId),
            _buildDivider(),
            _buildRow("Tổng số lượng", book.physicalInfo!.totalQuantity?.toString()),
            _buildDivider(),
          ],

          // Digital info
          if (book.digitalInfo != null) ...[
            _buildSectionTitle("Thông tin học liệu số"),
            _buildRow("Định dạng", book.digitalInfo!.fileFormat),
            _buildDivider(),
            _buildRow("Dung lượng", book.digitalInfo!.fileSizeMb),
            _buildDivider(),
            _buildRow("Lượt tải", book.digitalInfo!.downloadCount?.toString()),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "—",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthors(List<Author>? authors) {
    final text = authors != null && authors.isNotEmpty
        ? authors.map((a) => "${a.fullName ?? ""}${a.degree != null ? " (${a.degree})" : ""}").join(", ")
        : null;
    return _buildRow("Tác giả", text);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1);
}
