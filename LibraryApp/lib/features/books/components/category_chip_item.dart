import 'package:flutter/material.dart';
import '../../../models/entities/category_entity.dart';

class CategoryChipItem extends StatelessWidget {
  final CategoryEntity item;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChipItem({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black87 : Colors.grey.shade400,
            width: 1,
          ),
        ),
        child: Text(
          item.categoryName ?? "",
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
