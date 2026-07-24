import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../models/entities/inventory_ledger_detail_entity.dart';
import '../inventory_ledgers/inventory_ledgers_provider.dart';

class ListInventoryLedgersController extends GetxController {
  final InventoryLedgersProvider provider;
  final int ledgerType;
  final String title;

  ListInventoryLedgersController(
    this.provider, {
    required this.ledgerType,
    required this.title,
  });

  final now = DateTime.now();

  // Tab "Danh sách"
  final ledgers = <InventoryLedgerDetailEntity>[].obs;
  final searchText = "".obs;

  // Tab "Thống kê"
  final monthlyTrendData = <MonthlyBorrowCount>[].obs;
  final trendYear = 0.obs;

  final partnerRatioData = <CategoryRatio>[].obs;
  final partnerMonth = 0.obs;
  final partnerYear = 0.obs;

  final topPartnersData = <BorrowerStat>[].obs;
  final topPartnersMonth = 0.obs;
  final topPartnersYear = 0.obs;

  List<InventoryLedgerDetailEntity> get filteredLedgers {
    final keyword = searchText.value.trim().toLowerCase();
    if (keyword.isEmpty) return ledgers;
    return ledgers.where((l) {
      return (l.ledgerId ?? '').toLowerCase().contains(keyword) ||
          (l.partnerName ?? '').toLowerCase().contains(keyword);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    trendYear.value = now.year;
    partnerMonth.value = now.month;
    partnerYear.value = now.year;
    topPartnersMonth.value = now.month;
    topPartnersYear.value = now.year;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
      refreshCharts();
    });
  }

  Future<void> loadData() async {
    try {
      LoadingOverlay.show();
      final list = await provider.getLedgersByType(ledgerType);
      ledgers.value = list
          .map((e) => InventoryLedgerDetailEntity.fromModel(e))
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
      loadPartnerRatio(),
      loadTopPartners(),
    ]);
  }

  Future<void> loadMonthlyTrend() async {
    try {
      monthlyTrendData.value = await provider.getMonthlyLedgerTrend(
        ledgerType,
        trendYear.value,
      );
    } catch (_) {
      monthlyTrendData.value = [];
    }
  }

  Future<void> loadPartnerRatio() async {
    try {
      partnerRatioData.value = await provider.getPartnerValueRatioByType(
        ledgerType,
        partnerMonth.value,
        partnerYear.value,
      );
    } catch (_) {
      partnerRatioData.value = [];
    }
  }

  Future<void> loadTopPartners() async {
    try {
      topPartnersData.value = await provider.getTopPartnersByType(
        ledgerType,
        topPartnersMonth.value,
        topPartnersYear.value,
      );
    } catch (_) {
      topPartnersData.value = [];
    }
  }
}
