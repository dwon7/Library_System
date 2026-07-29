import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/add_fab.dart';
import '../../common/widgets/app_header.dart';
import '../../models/entities/borrow_card_detail_entity.dart';
import '../../routes/app_pages.dart';
import 'borrow_cards_controller.dart';
import 'components/borrow_card_item.dart';

class BorrowCardsView extends GetView<BorrowCardsController> {
  const BorrowCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Phiếu mượn"),
      floatingActionButton: AddFab(
        heroTag: 'fab-borrow-cards',
        onPressed: () async {
          final result = await Get.toNamed(AppPages.newBorrowCard);
          if (result == true) controller.loadData();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusRow(),
              const SizedBox(height: 24),
              _buildSection(
                "Đang mượn",
                controller.borrowingCards,
                controller.borrowingCount,
                2,
              ),
              _buildSection(
                "Quá hạn",
                controller.overdueCards,
                controller.overdueCount,
                3,
              ),
              _buildSection(
                "Hoàn thành",
                controller.completedCards,
                controller.completedCount,
                1,
              ),
              _buildSection(
                "Tất cả phiếu mượn",
                controller.allCards,
                controller.allCount,
                0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildStatusCard(
              "Hoàn thành",
              controller.completedCount.value,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatusCard(
              "Đang mượn",
              controller.borrowingCount.value,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatusCard(
              "Quá hạn",
              controller.overdueCount.value,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    RxList<BorrowCardDetailEntity> cards,
    RxInt totalCount,
    int status,
  ) {
    return Obx(() {
      if (cards.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...cards
              .take(5)
              .map(
                (card) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BorrowCardItem(item: card),
                ),
              ),
          if (totalCount.value > 5)
            GestureDetector(
              onTap: () => Get.toNamed(
                AppPages.listBorrowCards,
                arguments: {'status': status, 'title': title},
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 16),
                child: Center(
                  child: Text(
                    "Xem thêm",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 16),
        ],
      );
    });
  }
}
