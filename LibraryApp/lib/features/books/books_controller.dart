import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';
import '../../models/entities/book_detail_entity.dart';
import '../../models/entities/category_entity.dart';
import 'books_provider.dart';

class BooksController extends GetxController {
  final BooksProvider provider;

  BooksController(this.provider);

  final books = <BookDetailEntity>[].obs;
  final categories = <CategoryEntity>[].obs;
  final selectedCategory = CategoryEntity(
    categoryId: "-1",
    categoryName: "Tất cả",
  ).obs;
  final searchText = "".obs;
  final isSearching = false.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() async {
    try {
      LoadingOverlay.show();
      if (kDebugMode) debugPrint('[BooksController] loadData: bắt đầu getCategories()');
      categories.value = await provider.getCategories();
      if (kDebugMode) debugPrint('[BooksController] loadData: getCategories() xong, bắt đầu getBooksByCategoryId()');
      books.value = await provider.getBooksByCategoryId(
        selectedCategory.value.categoryId ?? "-1",
        searchText.value,
      );
      if (kDebugMode) debugPrint('[BooksController] loadData: getBooksByCategoryId() xong');
    } catch (e, st) {
      if (kDebugMode) debugPrint('[BooksController] loadData: LỖI $e\n$st');
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      if (kDebugMode) debugPrint('[BooksController] loadData: vào finally, gọi LoadingOverlay.hide()');
      LoadingOverlay.hide();
      if (kDebugMode) debugPrint('[BooksController] loadData: đã gọi xong LoadingOverlay.hide()');
    }
  }

  void updateSelectedCategory(CategoryEntity e) async {
    LoadingOverlay.show();
    selectedCategory.value = e;
    try {
      books.value = await provider.getBooksByCategoryId(
        e.categoryId ?? "-1",
        searchText.value,
      );
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      if (searchText.value.isNotEmpty) {
        searchText.value = "";
        _searchBooks();
      }
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchBooks();
    });
  }

  Future<void> _searchBooks() async {
    try {
      books.value = await provider.getBooksByCategoryId(
        selectedCategory.value.categoryId ?? "-1",
        searchText.value,
      );
    } catch (_) {}
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
