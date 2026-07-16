import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/features/inventory_audit_detail/inventory_audit_detail_provider.dart';
import 'package:library_app/models/ressponses/book_detail_res.dart';
import 'package:library_app/models/ressponses/inventory_audit_detail_res.dart';

class InventoryAuditDetailController extends GetxController {
  final InventoryAuditDetailProvider provider;
  final String auditId;

  InventoryAuditDetailController(this.provider, {required this.auditId});

  final scannedCount = 0.obs;
  final totalCount = 0.obs;
  final inventoriedBooks = <AuditDetail>[].obs;
  final uninventoriedBooks = <AuditDetail>[].obs;
  final books = <BookDetailRes>[].obs;

  bool get isCompleted => totalCount.value > 0 && scannedCount.value >= totalCount.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    try {
      books.value = await provider.getBooks();

      final stats = await provider.getAuditStats(auditId);
      scannedCount.value = stats[0];
      totalCount.value = stats[1];

      final inventoried = await provider.getBooksByStatus(auditId, 1);
      inventoriedBooks.value = inventoried;

      final uninventoried = await provider.getBooksByStatus(auditId, 2);
      uninventoriedBooks.value = uninventoried;
    } catch (_) {}
  }

  Future<void> deleteAudit() async {
    try {
      final success = await provider.deleteAudit(auditId);
      if (success) {
        AppToast.show("Xoá thành công");
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back();
      } else {
        AppToast.show("Xoá thất bại");
      }
    } catch (_) {
      AppToast.show("Xoá thất bại");
    }
  }
}
