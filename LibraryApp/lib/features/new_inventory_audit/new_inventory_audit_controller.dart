import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/inventory_audit_detail_res.dart';
import 'new_inventory_audit_provider.dart';

class AuditMemberEntry {
  final TextEditingController nameController;
  final TextEditingController roleController;

  AuditMemberEntry({String name = "", String role = ""})
      : nameController = TextEditingController(text: name),
        roleController = TextEditingController(text: role);
}

class AuditDetailEntry {
  BookDetailRes? selectedBook;
  final TextEditingController quantityController;
  int conditionType = 1; // 1: Còn sử dụng, 2: Rách nát, 3: Mất

  AuditDetailEntry({this.selectedBook})
      : quantityController = TextEditingController(text: "1");
}

class NewInventoryAuditController extends GetxController {
  final NewInventoryAuditProvider provider;

  NewInventoryAuditController(this.provider);

  final auditId = "".obs;
  final books = <BookDetailRes>[].obs;
  final auditDate = "".obs;
  final status = 1.obs;
  final notes = "".obs;

  final auditBoard = <AuditMemberEntry>[
    AuditMemberEntry(role: "Trưởng ban"),
    AuditMemberEntry(role: "Ủy viên"),
  ].obs;

  final auditDetails = <AuditDetailEntry>[AuditDetailEntry()].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadInitData());
  }

  void loadInitData() async {
    try {
      LoadingOverlay.show();
      auditId.value = await provider.generateAuditId();
      books.value = await provider.getBooks();
    } catch (e) {
      AppToast.show("Lỗi tải dữ liệu");
    } finally {
      LoadingOverlay.hide();
    }
  }

  void addAuditMember() {
    auditBoard.add(AuditMemberEntry());
  }

  void removeAuditMember(int index) {
    if (auditBoard.length > 1) auditBoard.removeAt(index);
  }

  void addAuditDetail() {
    if (auditDetails.any((e) => e.selectedBook == null)) {
      AppToast.show("Vui lòng chọn sách cho các dòng hiện tại");
      return;
    }
    auditDetails.add(AuditDetailEntry());
  }

  void removeAuditDetail(int index) {
    if (auditDetails.length > 1) auditDetails.removeAt(index);
  }

  void onBookSelected(int index, BookDetailRes? book) {
    auditDetails[index].selectedBook = book;
    auditDetails.refresh();
  }

  Future<void> submit() async {
    if (auditDate.value.isEmpty) return _warn("Vui lòng chọn ngày kiểm kê");
    if (auditBoard.any((m) => m.nameController.text.trim().isEmpty)) return _warn("Vui lòng nhập đủ tên ban kiểm kê");
    if (auditDetails.every((e) => e.selectedBook == null)) return _warn("Vui lòng chọn ít nhất một sách");

    try {
      LoadingOverlay.show();
      int totalQty = 0;
      final details = auditDetails.where((e) => e.selectedBook != null).map((e) {
        final qty = int.tryParse(e.quantityController.text) ?? 1;
        totalQty += qty;
        return AuditDetail(bookId: e.selectedBook!.bookId, quantity: qty, conditionType: e.conditionType);
      }).toList();

      final board = auditBoard.map((m) => AuditBoardMember(
        fullName: m.nameController.text.trim(),
        role: m.roleController.text.trim().isNotEmpty ? m.roleController.text.trim() : "Thành viên",
      )).toList();

      final audit = InventoryAuditDetailRes(
        auditId: auditId.value,
        auditDate: auditDate.value,
        auditBoard: board,
        status: status.value,
        totalAuditedQuantity: totalQty,
        notes: notes.value,
        auditDetails: details,
      );
      await provider.addAudit(audit);
      LoadingOverlay.hide();
      AppToast.show("Thêm phiếu kiểm kê thành công");
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.back(result: true);
    } catch (e) {
      LoadingOverlay.hide();
      AppToast.show("Lỗi thêm phiếu kiểm kê");
    }
  }

  void _warn(String msg) => AppToast.show(msg);

  @override
  void onClose() {
    for (final e in auditBoard) {
      e.nameController.dispose();
      e.roleController.dispose();
    }
    for (final e in auditDetails) {
      e.quantityController.dispose();
    }
    super.onClose();
  }
}
