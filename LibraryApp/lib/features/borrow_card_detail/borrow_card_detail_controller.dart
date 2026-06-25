import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        userName.value = provider.getUserName(card.value!.userId ?? "");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }
}
