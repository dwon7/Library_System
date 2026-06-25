import 'package:flutter/material.dart';
import '../../../models/ressponses/book_detail_res.dart';

class DropdownBookItem extends StatelessWidget {
  final BookDetailRes book;
  final bool isSelected;

  const DropdownBookItem({
    super.key,
    required this.book,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: isSelected ? Colors.grey.shade100 : null,
      child: Row(
        children: [
          Expanded(
            child: Text(
              book.title ?? "",
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${_formatPrice(book.physicalInfo?.totalQuantity != null ? (book.physicalInfo!.totalQuantity! * 50000).toString() : "0")} đ",
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Dùng số lượng để fake giá: 1 cuốn = 50,000đ
  String _formatPrice(String price) {
    final n = int.tryParse(price) ?? 0;
    return n.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
  }
}
