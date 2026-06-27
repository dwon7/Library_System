import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';
import 'book_edit_provider.dart';

class BookEditController extends GetxController {
  final BookEditProvider provider;
  final String bookId;

  BookEditController(this.provider, {required this.bookId});

  final book = Rxn<BookDetailRes>();
  final categories = <CategoryDetailRes>[].obs;
  final authors = <Author>[].obs;

  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final quantityController = TextEditingController();
  final fileFormatController = TextEditingController();
  final fileSizeController = TextEditingController();
  final downloadCountController = TextEditingController();

  final selectedCategoryId = Rxn<String>();
  final selectedStatus = Rxn<String>();
  final selectedAuthorFullName = Rxn<String>();

  final statusOptions = ['available', 'borrowed', 'maintenance'];

  @override
  void onInit() {
    super.onInit();
    categories.assignAll(provider.getCategories());
    authors.assignAll(provider.getAuthors());
    WidgetsBinding.instance.addPostFrameCallback((_) => loadBook());
  }

  void loadBook() async {
    try {
      LoadingOverlay.show();
      final result = await provider.getBookById(bookId);
      if (result != null) {
        book.value = result;
        _populateForm(result);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  void _populateForm(BookDetailRes b) {
    priceController.text = b.price?.toString() ?? '';
    locationController.text = b.physicalInfo?.warehouseLocation ?? '';
    quantityController.text = b.physicalInfo?.totalQuantity?.toString() ?? '';
    selectedCategoryId.value = b.categoryId;
    selectedStatus.value = b.status ?? 'available';
    if (b.authors != null && b.authors!.isNotEmpty) {
      selectedAuthorFullName.value = b.authors!.first.fullName;
    }
    if (b.digitalInfo != null) {
      fileFormatController.text = b.digitalInfo!.fileFormat ?? '';
      fileSizeController.text = b.digitalInfo!.fileSizeMb ?? '';
      downloadCountController.text = b.digitalInfo!.downloadCount?.toString() ?? '';
    }
  }

  void save() async {
    final current = book.value;
    if (current == null) return;

    current.price = double.tryParse(priceController.text);
    current.status = selectedStatus.value;
    current.categoryId = selectedCategoryId.value;
    current.authors = [
      Author(
        fullName: selectedAuthorFullName.value,
        degree: current.authors?.isNotEmpty == true ? current.authors!.first.degree : null,
      ),
    ];

    current.physicalInfo ??= PhysicalInfo();
    current.physicalInfo!.warehouseLocation = locationController.text;
    current.physicalInfo!.totalQuantity = int.tryParse(quantityController.text);

    if (current.documentType == 'Digital') {
      current.digitalInfo ??= DigitalInfo();
      current.digitalInfo!.fileFormat = fileFormatController.text;
      current.digitalInfo!.fileSizeMb = fileSizeController.text;
      current.digitalInfo!.downloadCount = int.tryParse(downloadCountController.text);
    }

    try {
      LoadingOverlay.show();
      final ok = await provider.updateBook(current);
      if (ok) {
        LoadingOverlay.hide();
        Get.back();
        Get.snackbar("Thành công", "Đã cập nhật sách");
      } else {
        Get.snackbar("Lỗi", "Cập nhật thất bại");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Cập nhật thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  void delete(BuildContext context) async {
    try {
      LoadingOverlay.show();
      final ok = await provider.deleteBook(bookId);
      if (ok) {
        LoadingOverlay.hide();
        Get.until((route) => route.isFirst);
        Get.snackbar("Thành công", "Đã xoá sách");
      } else {
        Get.snackbar("Lỗi", "Xoá thất bại");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Xoá thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  @override
  void onClose() {
    priceController.dispose();
    locationController.dispose();
    quantityController.dispose();
    fileFormatController.dispose();
    fileSizeController.dispose();
    downloadCountController.dispose();
    super.onClose();
  }
}
