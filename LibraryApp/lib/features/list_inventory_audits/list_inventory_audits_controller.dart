import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../models/entities/inventory_audit_detail_entity.dart';
import '../inventory_audits/inventory_audits_provider.dart';

class ListInventoryAuditsController extends GetxController {
  final InventoryAuditsProvider provider;
  final int status;
  final String title;

  ListInventoryAuditsController(
    this.provider, {
    required this.status,
    required this.title,
  });

  final now = DateTime.now();

  // Tab "Danh sách"
  final audits = <InventoryAuditDetailEntity>[].obs;
  final searchText = "".obs;

  // Tab "Thống kê"
  final monthlyTrendData = <MonthlyBorrowCount>[].obs;
  final trendYear = 0.obs;

  final conditionRatioData = <CategoryRatio>[].obs;
  final conditionMonth = 0.obs;
  final conditionYear = 0.obs;

  final topChiefsData = <BorrowerStat>[].obs;
  final topChiefsMonth = 0.obs;
  final topChiefsYear = 0.obs;

  List<InventoryAuditDetailEntity> get filteredAudits {
    final keyword = searchText.value.trim().toLowerCase();
    if (keyword.isEmpty) return audits;
    return audits.where((a) {
      return (a.auditId ?? '').toLowerCase().contains(keyword) ||
          (a.boardChief ?? '').toLowerCase().contains(keyword);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    trendYear.value = now.year;
    conditionMonth.value = now.month;
    conditionYear.value = now.year;
    topChiefsMonth.value = now.month;
    topChiefsYear.value = now.year;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
      refreshCharts();
    });
  }

  Future<void> loadData() async {
    try {
      LoadingOverlay.show();
      final list = await provider.getAuditsByStatus(status);
      audits.value = list
          .map((e) => InventoryAuditDetailEntity.fromModel(e))
          .toList();
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  void onSearchChanged(String value) {
    searchText.value = value;
  }

  Future<void> refreshCharts() async {
    await Future.wait([
      loadMonthlyTrend(),
      loadConditionRatio(),
      loadTopChiefs(),
    ]);
  }

  Future<void> loadMonthlyTrend() async {
    try {
      monthlyTrendData.value = await provider.getMonthlyAuditTrend(
        status,
        trendYear.value,
      );
    } catch (_) {
      monthlyTrendData.value = [];
    }
  }

  Future<void> loadConditionRatio() async {
    try {
      conditionRatioData.value = await provider.getConditionRatioByStatus(
        status,
        conditionMonth.value,
        conditionYear.value,
      );
    } catch (_) {
      conditionRatioData.value = [];
    }
  }

  Future<void> loadTopChiefs() async {
    try {
      topChiefsData.value = await provider.getTopAuditChiefsByStatus(
        status,
        topChiefsMonth.value,
        topChiefsYear.value,
      );
    } catch (_) {
      topChiefsData.value = [];
    }
  }
}
