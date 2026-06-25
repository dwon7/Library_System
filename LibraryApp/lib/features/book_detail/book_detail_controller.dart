import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/ressponses/book_detail_res.dart';
import 'book_detail_provider.dart';

class BookDetailController extends GetxController {
  final BookDetailProvider provider;
  final String bookId;

  BookDetailController(this.provider, {required this.bookId});

  final book = Rxn<BookDetailRes>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() async {
    try {
      LoadingOverlay.show();
      book.value = await provider.getBookById(bookId);
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }
}
