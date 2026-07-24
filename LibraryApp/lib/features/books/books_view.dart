import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/add_fab.dart';
import 'package:library_app/common/widgets/app_header.dart';
import 'package:library_app/common/widgets/empty_state.dart';
import 'package:library_app/common/widgets/search_text_field.dart';

import 'books_controller.dart';
import 'components/book_detail_item.dart';
import 'components/category_chip_item.dart';
import '../../models/entities/category_entity.dart';
import '../../routes/app_pages.dart';

class BooksView extends GetView<BooksController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Danh sách sách"),
      floatingActionButton: AddFab(
        heroTag: 'fab-books',
        onPressed: () async {
          final result = await Get.toNamed(AppPages.newBook);
          if (result == true) controller.loadData();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchTextField(
              controller: TextEditingController(text: controller.searchText.value),
              onChanged: (v) => controller.onSearchChanged(v),
            ),
          ),
          const SizedBox(height: 10),
          _buildCategoryList(),
          const SizedBox(height: 12),
          Expanded(child: _buildBookGrid()),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 40,
      child: Obx(() {
        final allCategory = CategoryEntity(
          categoryId: "-1",
          categoryName: "Tất cả",
        );
        final isAllSelected =
            controller.selectedCategory.value.categoryId == "-1";

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return CategoryChipItem(
                item: allCategory,
                isSelected: isAllSelected,
                onTap: () =>
                    controller.updateSelectedCategory(allCategory),
              );
            }
            final cat = controller.categories[index - 1];
            return CategoryChipItem(
              item: cat,
              isSelected:
                  controller.selectedCategory.value.categoryId ==
                      cat.categoryId,
              onTap: () => controller.updateSelectedCategory(cat),
            );
          },
        );
      }),
    );
  }

  Widget _buildBookGrid() {
    return Obx(() {
      final books = controller.books;

      if (books.isEmpty) {
        return const EmptyState(message: "Không có sách nào");
      }

      return RefreshIndicator(
        onRefresh: () async => controller.loadData(),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.55,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return BookDetailItem(item: books[index]);
          },
        ),
      );
    });
  }
}
