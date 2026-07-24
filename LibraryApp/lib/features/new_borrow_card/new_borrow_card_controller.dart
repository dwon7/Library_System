import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';
import '../../models/ressponses/user_detail_res.dart';
import 'new_borrow_card_provider.dart';

class BorrowDetailEntry {
  BookDetailRes? selectedBook;
  final TextEditingController quantityController;

  BorrowDetailEntry({this.selectedBook})
      : quantityController = TextEditingController(text: "1");
}

class NewBorrowCardController extends GetxController {
  final NewBorrowCardProvider provider;

  NewBorrowCardController(this.provider);

  final cardId = "".obs;
  final books = <BookDetailRes>[].obs;
  final users = <UserDetailRes>[].obs;

  final selectedUser = Rxn<UserDetailRes>();
  final borrowDate = "".obs;
  final dueDate = "".obs;
  final status = 2.obs;

  final borrowDetails = <BorrowDetailEntry>[
    BorrowDetailEntry(),
  ].obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadInitData());
  }

  void loadInitData() async {
    try {
      LoadingOverlay.show();
      cardId.value = await provider.generateCardId();
      books.value = await provider.getBooks();
      users.value = await provider.getUsers();
    } catch (e) {
      AppToast.show("Lỗi tải dữ liệu");
    } finally {
      LoadingOverlay.hide();
    }
  }

  void addBorrowDetail() {
    if (borrowDetails.any((e) => e.selectedBook == null)) {
      AppToast.show("Vui lòng chọn sách cho các block hiện tại");
      return;
    }
    borrowDetails.add(BorrowDetailEntry());
  }

  void removeBorrowDetail(int index) {
    if (borrowDetails.length > 1) {
      borrowDetails.removeAt(index);
    }
  }

  void onBookSelected(int index, BookDetailRes? book) {
    borrowDetails[index].selectedBook = book;
    borrowDetails.refresh();
  }

  Future<void> submit() async {
    if (selectedUser.value == null) {
      AppToast.show("Vui lòng chọn độc giả");
      return;
    }
    if (borrowDate.value.isEmpty) {
      AppToast.show("Vui lòng chọn ngày mượn");
      return;
    }
    if (dueDate.value.isEmpty) {
      AppToast.show("Vui lòng chọn ngày hẹn trả");
      return;
    }
    if (dueDate.value.compareTo(borrowDate.value) < 0) {
      AppToast.show("Ngày hẹn trả phải sau ngày mượn");
      return;
    }
    if (borrowDetails.every((e) => e.selectedBook == null)) {
      AppToast.show("Vui lòng chọn ít nhất một sách");
      return;
    }
    try {
      LoadingOverlay.show();
      final card = BorrowCardDetailRes(
        cardId: cardId.value,
        userId: selectedUser.value!.userId,
        userName: selectedUser.value!.fullName,
        borrowDate: borrowDate.value,
        dueDate: dueDate.value,
        status: status.value,
        borrowDetails: borrowDetails
            .where((e) => e.selectedBook != null)
            .map((e) => BorrowDetail(
              bookId: e.selectedBook!.bookId,
              bookName: e.selectedBook!.title,
              bookPrice: e.selectedBook != null
                  ? ((e.selectedBook!.physicalInfo?.totalQuantity ?? 0) * 50000).toDouble()
                  : 0,
              quantity: int.tryParse(e.quantityController.text) ?? 1,
            )).toList(),
      );
      await provider.addBorrowCard(card);
      LoadingOverlay.hide();
      AppToast.show("Thêm phiếu mượn thành công");
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.back(result: true);
    } catch (e) {
      LoadingOverlay.hide();
      AppToast.show("Lỗi thêm phiếu mượn");
    }
  }

  @override
  void onClose() {
    for (final entry in borrowDetails) {
      entry.quantityController.dispose();
    }
    super.onClose();
  }
}
