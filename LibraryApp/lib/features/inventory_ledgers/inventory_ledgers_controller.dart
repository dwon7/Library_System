import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/entities/inventory_ledger_detail_entity.dart';
import 'inventory_ledgers_provider.dart';

class InventoryLedgersController extends GetxController {
  final InventoryLedgersProvider provider;

  InventoryLedgersController(this.provider);

  final importCount = 0.obs;
  final exportCount = 0.obs;
  final importLedgers = <InventoryLedgerDetailEntity>[].obs;
  final exportLedgers = <InventoryLedgerDetailEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() async {
    try {
      LoadingOverlay.show();
      await Future.wait([_loadImport(), _loadExport()]);
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> _loadImport() async {
    importCount.value = await provider.getCountByType(1);
    final list = await provider.getLedgersByType(1);
    importLedgers.value = list.map((e) => InventoryLedgerDetailEntity.fromModel(e)).toList();
  }

  Future<void> _loadExport() async {
    exportCount.value = await provider.getCountByType(2);
    final list = await provider.getLedgersByType(2);
    exportLedgers.value = list.map((e) => InventoryLedgerDetailEntity.fromModel(e)).toList();
  }
}
