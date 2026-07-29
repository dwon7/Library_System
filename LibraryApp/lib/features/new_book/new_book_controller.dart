import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';
import 'new_book_provider.dart';

class NewBookController extends GetxController {
  final NewBookProvider provider;

  NewBookController(this.provider);

  final bookId = "".obs;
  final categories = <CategoryDetailRes>[].obs;
  final documentType = "Physical".obs;

  final selectedCategoryId = Rxn<String>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final authorController = TextEditingController();
  final publicationYearController = TextEditingController();
  final publisherController = TextEditingController();
  final locationController = TextEditingController();
  final quantityController = TextEditingController();
  final fileFormatController = TextEditingController();
  final fileSizeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    categories.assignAll(provider.getCategories());
    WidgetsBinding.instance.addPostFrameCallback((_) => loadBookId());
  }

  void loadBookId() async {
    try {
      LoadingOverlay.show();
      bookId.value = await provider.generateBookId();
    } catch (e) {
      AppToast.show("Lỗi tải dữ liệu");
    } finally {
      LoadingOverlay.hide();
    }
  }

  void onDocumentTypeChanged(String type) {
    documentType.value = type;
  }

  Future<void> submit() async {
    if (titleController.text.trim().isEmpty) {
      AppToast.show("Vui lòng nhập tiêu đề");
      return;
    }
    if (selectedCategoryId.value == null) {
      AppToast.show("Vui lòng chọn thể loại");
      return;
    }

    final book = BookDetailRes(
      bookId: bookId.value,
      bookCode: bookId.value,
      title: titleController.text.trim(),
      categoryId: selectedCategoryId.value,
      publicationYear: int.tryParse(publicationYearController.text),
      publisher: publisherController.text.trim(),
      authors: authorController.text.trim().isNotEmpty
          ? [Author(fullName: authorController.text.trim())]
          : null,
      documentType: documentType.value,
      price: double.tryParse(priceController.text),
      status: 'available',
      physicalInfo: documentType.value == 'Physical'
          ? PhysicalInfo(
              warehouseLocation: locationController.text.trim(),
              totalQuantity: int.tryParse(quantityController.text),
            )
          : null,
      digitalInfo: documentType.value == 'Digital'
          ? DigitalInfo(
              fileFormat: fileFormatController.text.trim(),
              fileSizeMb: fileSizeController.text.trim(),
              downloadCount: 0,
            )
          : null,
    );

    try {
      LoadingOverlay.show();
      final ok = await provider.addBook(book);
      LoadingOverlay.hide();
      if (ok) {
        AppToast.show("Thêm sách thành công");
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.back(result: true);
      } else {
        AppToast.show("Thêm sách thất bại");
      }
    } catch (e) {
      LoadingOverlay.hide();
      AppToast.show("Lỗi thêm sách");
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    authorController.dispose();
    publicationYearController.dispose();
    publisherController.dispose();
    locationController.dispose();
    quantityController.dispose();
    fileFormatController.dispose();
    fileSizeController.dispose();
    super.onClose();
  }
}
