import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';
import 'package:library_app/common/widgets/empty_state.dart';
import 'package:library_app/common/widgets/search_text_field.dart';
import 'package:library_app/features/dashboard/components/chart_borrow_count.dart';
import 'package:library_app/features/dashboard/components/chart_category_ratio.dart';
import 'package:library_app/features/dashboard/components/chart_top_borrowers.dart';
import 'package:library_app/features/dashboard/components/chart_wrapper.dart';

import '../borrow_cards/components/borrow_card_item.dart';
import 'list_borrow_cards_controller.dart';

class ListBorrowCardsView extends GetView<ListBorrowCardsController> {
  const ListBorrowCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppHeader(
          title: controller.title,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Thống kê"),
              Tab(text: "Danh sách"),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildStatisticsTab(), _buildListTab(context)],
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return RefreshIndicator(
      onRefresh: () => controller.refreshCharts(),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(height: 310, child: _buildTrendChart()),
          const SizedBox(height: 24),
          SizedBox(height: 310, child: _buildCategoryChart()),
          const SizedBox(height: 24),
          SizedBox(height: 310, child: _buildTopBorrowersChart()),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    return Obx(() {
      return ChartWrapper(
        chart: BorrowCountByYearChart(data: controller.monthlyTrendData),
        selectedMonth: 1,
        selectedYear: controller.trendYear.value,
        onMonthChanged: (_) {},
        onYearChanged: (y) {
          controller.trendYear.value = y;
          controller.loadMonthlyTrend();
        },
        showMonthDropdown: false,
        title: 'Số lượt mượn theo tháng',
      );
    });
  }

  Widget _buildCategoryChart() {
    return Obx(() {
      return ChartWrapper(
        chart: CategoryRatioChart(data: controller.categoryRatioData),
        selectedMonth: controller.categoryMonth.value,
        selectedYear: controller.categoryYear.value,
        onMonthChanged: (m) {
          controller.categoryMonth.value = m;
          controller.loadCategoryRatio();
        },
        onYearChanged: (y) {
          controller.categoryYear.value = y;
          controller.loadCategoryRatio();
        },
        title: 'Tỷ lệ mượn theo thể loại',
      );
    });
  }

  Widget _buildTopBorrowersChart() {
    return Obx(() {
      return ChartWrapper(
        chart: TopBorrowersChart(data: controller.topBorrowersData),
        selectedMonth: controller.topBorrowersMonth.value,
        selectedYear: controller.topBorrowersYear.value,
        onMonthChanged: (m) {
          controller.topBorrowersMonth.value = m;
          controller.loadTopBorrowers();
        },
        onYearChanged: (y) {
          controller.topBorrowersYear.value = y;
          controller.loadTopBorrowers();
        },
        title: 'Top người mượn nhiều nhất',
      );
    });
  }

  Widget _buildListTab(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SearchTextField(
              controller: TextEditingController(
                text: controller.searchText.value,
              ),
              hintText: "Tìm phiếu mượn",
              onChanged: (v) => controller.onSearchChanged(v),
            ),
          ),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
      final cards = controller.filteredCards;
      if (cards.isEmpty) {
        return const EmptyState(message: "Không có phiếu mượn nào");
      }
      return RefreshIndicator(
        onRefresh: () => controller.loadData(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          itemCount: cards.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => BorrowCardItem(item: cards[index]),
        ),
      );
    });
  }
}
