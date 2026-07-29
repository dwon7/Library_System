import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';
import 'package:library_app/features/inventory_ledgers/inventory_ledgers_controller.dart';

import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';
import 'inventory_ledger_detail_provider.dart';

class InventoryLedgerDetailController extends GetxController {
  final InventoryLedgerDetailProvider provider;
  final String ledgerId;

  InventoryLedgerDetailController(this.provider, {required this.ledgerId});

  final ledger = Rxn<InventoryLedgerDetailRes>();
  final bookIds = <String>[].obs;
  final bookDetails = Rxn<List<BookDetailRes>>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() async {
    try {
      LoadingOverlay.show();
      ledger.value = await provider.getLedgerById(ledgerId);
      List<String> bookDetailIds = ledger.value?.ledgerDetails?.map((e) => e.bookId ?? "").toList() ?? [];
      bookIds.value = bookDetailIds;

      bookDetails.value = await provider.getBooksByIds(bookIds.value);
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> deleteLedger() async {
    try {
      final success = await provider.deleteLedger(ledgerId);
      if (success) {
        AppToast.show("Xoá thành công");
        await Future.delayed(const Duration(milliseconds: 500));
        Get.until((route) => route.isFirst);
        if (Get.isRegistered<InventoryLedgersController>()) {
          Get.find<InventoryLedgersController>().loadData();
        }
      } else {
        AppToast.show("Xoá thất bại");
      }
    } catch (_) {
      AppToast.show("Xoá thất bại");
    }
  }
}
