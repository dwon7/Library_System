import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/entities/inventory_audit_detail_entity.dart';
import 'inventory_audits_provider.dart';

class InventoryAuditsController extends GetxController {
  final InventoryAuditsProvider provider;

  InventoryAuditsController(this.provider);

  final completedCount = 0.obs;
  final incompleteCount = 0.obs;
  final completedAudits = <InventoryAuditDetailEntity>[].obs;
  final incompleteAudits = <InventoryAuditDetailEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() async {
    try {
      LoadingOverlay.show();
      await Future.wait([_loadCompleted(), _loadIncomplete()]);
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> _loadCompleted() async {
    completedCount.value = await provider.getCountByStatus(1);
    final list = await provider.getAuditsByStatus(1);
    completedAudits.value = list.map((e) => InventoryAuditDetailEntity.fromModel(e)).toList();
  }

  Future<void> _loadIncomplete() async {
    incompleteCount.value = await provider.getCountByStatus(2);
    final list = await provider.getAuditsByStatus(2);
    incompleteAudits.value = list.map((e) => InventoryAuditDetailEntity.fromModel(e)).toList();
  }
}
