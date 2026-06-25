import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';
import 'new_inventory_ledger_provider.dart';

class LedgerDetailEntry {
  BookDetailRes? selectedBook;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;

  LedgerDetailEntry({this.selectedBook})
      : quantityController = TextEditingController(text: "1"),
        unitPriceController = TextEditingController(text: "0");
}

class NewInventoryLedgerController extends GetxController {
  final NewInventoryLedgerProvider provider;

  NewInventoryLedgerController(this.provider);

  final cardId = "".obs;
  final ledgerType = 1.obs;
  final books = <BookDetailRes>[].obs;

  final transactionDate = "".obs;
  final staffInCharge = "".obs;
  final partnerName = "".obs;
  final taxOrStudentId = "".obs;
  final notes = "".obs;

  final ledgerDetails = <LedgerDetailEntry>[LedgerDetailEntry()].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadInitData());
  }

  void loadInitData() async {
    try {
      LoadingOverlay.show();
      cardId.value = await provider.generateLedgerId(ledgerType.value);
      books.value = await provider.getBooks();
    } catch (e) {
      AppToast.show("Lỗi tải dữ liệu");
    } finally {
      LoadingOverlay.hide();
    }
  }

  void onLedgerTypeChanged(int type) {
    ledgerType.value = type;
    provider.generateLedgerId(type).then((id) => cardId.value = id);
  }

  void addLedgerDetail() {
    if (ledgerDetails.any((e) => e.selectedBook == null)) {
      AppToast.show("Vui lòng chọn sách cho các dòng hiện tại");
      return;
    }
    ledgerDetails.add(LedgerDetailEntry());
  }

  void removeLedgerDetail(int index) {
    if (ledgerDetails.length > 1) {
      ledgerDetails.removeAt(index);
    }
  }

  void onBookSelected(int index, BookDetailRes? book) {
    ledgerDetails[index].selectedBook = book;
    if (book != null) {
      final price = (book.physicalInfo?.totalQuantity ?? 0) * 50000;
      ledgerDetails[index].unitPriceController.text = price.toString();
    }
    ledgerDetails.refresh();
  }

  Future<void> submit() async {
    if (transactionDate.value.isEmpty) return _warn("Vui lòng chọn ngày giao dịch");
    if (staffInCharge.value.isEmpty) return _warn("Vui lòng nhập nhân viên");
    if (partnerName.value.isEmpty) return _warn("Vui lòng nhập đối tác");
    if (ledgerDetails.every((e) => e.selectedBook == null)) return _warn("Vui lòng chọn ít nhất một sách");

    try {
      LoadingOverlay.show();
      int grandTotal = 0;
      final details = ledgerDetails.where((e) => e.selectedBook != null).map((e) {
        final qty = int.tryParse(e.quantityController.text) ?? 1;
        final price = int.tryParse(e.unitPriceController.text) ?? 0;
        grandTotal += qty * price;
        return LedgerDetail(
          bookId: e.selectedBook!.bookId,
          quantity: qty,
          unitPrice: price,
          totalAmount: qty * price,
        );
      }).toList();

      final ledger = InventoryLedgerDetailRes(
        ledgerId: cardId.value,
        ledgerType: ledgerType.value,
        transactionDate: transactionDate.value,
        staffInCharge: staffInCharge.value,
        partner: Partner(partnerName: partnerName.value, taxOrStudentId: taxOrStudentId.value),
        grandTotal: grandTotal,
        notes: notes.value,
        ledgerDetails: details,
      );
      await provider.addLedger(ledger);
      LoadingOverlay.hide();
      AppToast.show("Thêm phiếu kho thành công");
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.back(result: true);
    } catch (e) {
      LoadingOverlay.hide();
      AppToast.show("Lỗi thêm phiếu kho");
    }
  }

  void _warn(String msg) => AppToast.show(msg);

  @override
  void onClose() {
    for (final e in ledgerDetails) {
      e.quantityController.dispose();
      e.unitPriceController.dispose();
    }
    super.onClose();
  }
}
