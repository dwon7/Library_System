import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/ressponses/borrow_card_detail_res.dart';
import 'borrow_card_detail_provider.dart';

class BorrowCardDetailController extends GetxController {
  final BorrowCardDetailProvider provider;
  final String cardId;

  BorrowCardDetailController(this.provider, {required this.cardId});

  final card = Rxn<BorrowCardDetailRes>();
  final userName = "".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() async {
    try {
      LoadingOverlay.show();
      card.value = await provider.getBorrowCardById(cardId);
      if (card.value != null) {
        userName.value = card.value!.userName?.isNotEmpty == true
            ? card.value!.userName!
            : provider.getUserName(card.value!.userId ?? "");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> returnBook() async {
    try {
      LoadingOverlay.show();
      final ok = await provider.returnBook(cardId);
      LoadingOverlay.hide();
      if (ok) {
        AppToast.show("Trả sách thành công");
        loadData();
      } else {
        AppToast.show("Trả sách thất bại");
      }
    } catch (_) {
      LoadingOverlay.hide();
      AppToast.show("Lỗi khi trả sách");
    }
  }
}
