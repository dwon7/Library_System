import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/loading_overlay.dart';

import '../../models/entities/borrow_card_detail_entity.dart';
import '../../mock_data/storage_service.dart';
import 'borrow_cards_provider.dart';

class BorrowCardsController extends GetxController {
  final BorrowCardsProvider provider;

  BorrowCardsController(this.provider);

  final dueTodayCount = 0.obs;
  final completedCount = 0.obs;
  final borrowingCount = 0.obs;
  final overdueCount = 0.obs;
  final allCount = 0.obs;

  final allCards = <BorrowCardDetailEntity>[].obs;
  final completedCards = <BorrowCardDetailEntity>[].obs;
  final borrowingCards = <BorrowCardDetailEntity>[].obs;
  final overdueCards = <BorrowCardDetailEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  void loadData() async {
    try {
      LoadingOverlay.show();
      await Future.wait([
        _loadDueToday(),
        _loadAll(),
        _loadCompleted(),
        _loadBorrowing(),
        _loadOverdue(),
      ]);
    } catch (e) {
      Get.snackbar("Lỗi", "Tải dữ liệu thất bại");
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> _loadDueToday() async {
    dueTodayCount.value = await provider.getDueTodayCount();
  }

  Future<void> _loadAll() async {
    allCount.value = await provider.getCountByStatus(0);
    final cards = await provider.getCardsByStatus(0);
    allCards.value = _mapCards(cards);
  }

  Future<void> _loadCompleted() async {
    completedCount.value = await provider.getCountByStatus(1);
    final cards = await provider.getCardsByStatus(1);
    completedCards.value = _mapCards(cards);
  }

  Future<void> _loadBorrowing() async {
    borrowingCount.value = await provider.getCountByStatus(2);
    final cards = await provider.getCardsByStatus(2);
    borrowingCards.value = _mapCards(cards);
  }

  Future<void> _loadOverdue() async {
    overdueCount.value = await provider.getCountByStatus(3);
    final cards = await provider.getCardsByStatus(3);
    overdueCards.value = _mapCards(cards);
  }

  List<BorrowCardDetailEntity> _mapCards(List<dynamic> cards) {
    final storageService = Get.find<StorageService>();
    return cards.map((c) {
      final user = storageService.users.firstWhere(
        (u) => u.userId == c.userId,
        orElse: () => storageService.users.first,
      );
      return BorrowCardDetailEntity.fromModel(c, userName: user.fullName);
    }).toList();
  }
}
