import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../mock_data/storage_service.dart';
import '../../models/entities/borrow_card_detail_entity.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';
import '../borrow_cards/borrow_cards_provider.dart';

class ListBorrowCardsController extends GetxController {
  final BorrowCardsProvider provider;
  final int status;
  final String title;

  ListBorrowCardsController(
    this.provider, {
    required this.status,
    required this.title,
  });

  final now = DateTime.now();

  // Tab "Danh sách"
  final cards = <BorrowCardDetailEntity>[].obs;
  final searchText = "".obs;

  // Tab "Thống kê"
  final monthlyTrendData = <MonthlyBorrowCount>[].obs;
  final trendYear = 0.obs;

  final categoryRatioData = <CategoryRatio>[].obs;
  final categoryMonth = 0.obs;
  final categoryYear = 0.obs;

  final topBorrowersData = <BorrowerStat>[].obs;
  final topBorrowersMonth = 0.obs;
  final topBorrowersYear = 0.obs;

  List<BorrowCardDetailEntity> get filteredCards {
    final keyword = searchText.value.trim().toLowerCase();
    if (keyword.isEmpty) return cards;
    return cards.where((c) {
      return (c.cardId ?? '').toLowerCase().contains(keyword) ||
          (c.userName ?? '').toLowerCase().contains(keyword);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    trendYear.value = now.year;
    categoryMonth.value = now.month;
    categoryYear.value = now.year;
    topBorrowersMonth.value = now.month;
    topBorrowersYear.value = now.year;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
      refreshCharts();
    });
  }

  Future<void> loadData() async {
    try {
      LoadingOverlay.show();
      await provider.getAndCacheUsers();
      final result = await provider.getCardsByStatus(status);
      cards.value = _mapCards(result);
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
      loadCategoryRatio(),
      loadTopBorrowers(),
    ]);
  }

  Future<void> loadMonthlyTrend() async {
    try {
      monthlyTrendData.value = await provider.getMonthlyTrendByStatus(
        status,
        trendYear.value,
      );
    } catch (_) {
      monthlyTrendData.value = [];
    }
  }

  Future<void> loadCategoryRatio() async {
    try {
      categoryRatioData.value = await provider.getCategoryRatioByStatus(
        status,
        categoryMonth.value,
        categoryYear.value,
      );
    } catch (_) {
      categoryRatioData.value = [];
    }
  }

  Future<void> loadTopBorrowers() async {
    try {
      topBorrowersData.value = await provider.getTopBorrowersByStatus(
        status,
        topBorrowersMonth.value,
        topBorrowersYear.value,
      );
    } catch (_) {
      topBorrowersData.value = [];
    }
  }

  List<BorrowCardDetailEntity> _mapCards(List<BorrowCardDetailRes> list) {
    final storageService = Get.find<StorageService>();
    return list.map((c) {
      String resolvedName = c.userName ?? '';
      if (resolvedName.isEmpty && storageService.users.isNotEmpty) {
        try {
          final user = storageService.users.firstWhere(
            (u) => u.userId == c.userId,
          );
          resolvedName = user.fullName ?? '';
        } catch (_) {}
      }
      return BorrowCardDetailEntity.fromModel(c, userName: resolvedName);
    }).toList();
  }
}
