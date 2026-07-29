import 'package:flutter/material.dart';
import '../../../common/utils/app_utils.dart';
import '../../../common/widgets/delete_icon.dart';
import '../../../models/ressponses/book_detail_res.dart';

class BorrowDetailWidget extends StatelessWidget {
  final TextEditingController quantityController;
  final BookDetailRes? selectedBook;
  final List<BookDetailRes> books;
  final Function(BookDetailRes?) onBookChanged;
  final VoidCallback? onDelete;

  const BorrowDetailWidget({
    super.key,
    required this.quantityController,
    required this.selectedBook,
    required this.books,
    required this.onBookChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // BookName dropdown
                    DropdownButtonFormField<BookDetailRes>(
                      value: selectedBook,
                      decoration: InputDecoration(
                        labelText: "Tên sách",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      items: books
                          .map(
                            (b) => DropdownMenuItem(
                              value: b,
                              child: Text(
                                b.title ?? "",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => onBookChanged(val),
                    ),
                    const SizedBox(height: 8),
                    // BookPrice (disabled)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        selectedBook != null
                            ? "${AppUtils.formatMoney(_calcPrice(selectedBook!))} đ"
                            : "—",
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedBook != null
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Quantity +/-
                    Row(
                      children: [
                        const Text("Số lượng", style: TextStyle(fontSize: 14)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 28,
                          ),
                          onPressed: () {
                            int current =
                                int.tryParse(quantityController.text) ?? 1;
                            if (current > 1) {
                              quantityController.text = (current - 1)
                                  .toString();
                            }
                          },
                        ),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            controller: quantityController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 28),
                          onPressed: () {
                            int current =
                                int.tryParse(quantityController.text) ?? 1;
                            quantityController.text = (current + 1).toString();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 25,
                child: onDelete != null
                    ? IconButton(
                        icon: const DeleteIcon(size: 20),
                        onPressed: onDelete,
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _calcPrice(BookDetailRes book) {
    int qty = book.physicalInfo?.totalQuantity ?? 0;
    return qty * 50000;
  }
}
