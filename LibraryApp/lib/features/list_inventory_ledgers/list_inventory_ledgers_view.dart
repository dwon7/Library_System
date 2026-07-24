import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';
import 'package:library_app/common/widgets/empty_state.dart';
import 'package:library_app/common/widgets/search_text_field.dart';
import 'package:library_app/features/dashboard/components/chart_borrow_count.dart';
import 'package:library_app/features/dashboard/components/chart_category_ratio.dart';
import 'package:library_app/features/dashboard/components/chart_top_borrowers.dart';
import 'package:library_app/features/dashboard/components/chart_wrapper.dart';

import '../inventory_ledgers/components/inventory_ledger_item.dart';
import 'list_inventory_ledgers_controller.dart';

class ListInventoryLedgersView extends GetView<ListInventoryLedgersController> {
  const ListInventoryLedgersView({super.key});

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
          SizedBox(height: 310, child: _buildPartnerChart()),
          const SizedBox(height: 24),
          SizedBox(height: 310, child: _buildTopPartnersChart()),
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
        title: 'Số phiếu theo tháng',
      );
    });
  }

  Widget _buildPartnerChart() {
    return Obx(() {
      return ChartWrapper(
        chart: CategoryRatioChart(data: controller.partnerRatioData),
        selectedMonth: controller.partnerMonth.value,
        selectedYear: controller.partnerYear.value,
        onMonthChanged: (m) {
          controller.partnerMonth.value = m;
          controller.loadPartnerRatio();
        },
        onYearChanged: (y) {
          controller.partnerYear.value = y;
          controller.loadPartnerRatio();
        },
        title: 'Tỷ lệ giá trị theo đối tác',
      );
    });
  }

  Widget _buildTopPartnersChart() {
    return Obx(() {
      return ChartWrapper(
        chart: TopBorrowersChart(data: controller.topPartnersData),
        selectedMonth: controller.topPartnersMonth.value,
        selectedYear: controller.topPartnersYear.value,
        onMonthChanged: (m) {
          controller.topPartnersMonth.value = m;
          controller.loadTopPartners();
        },
        onYearChanged: (y) {
          controller.topPartnersYear.value = y;
          controller.loadTopPartners();
        },
        title: 'Top đối tác giao dịch nhiều nhất',
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
              hintText: "Tìm phiếu kho",
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
      final ledgers = controller.filteredLedgers;
      if (ledgers.isEmpty) {
        return const EmptyState(message: "Không có phiếu kho nào");
      }
      return RefreshIndicator(
        onRefresh: () => controller.loadData(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          itemCount: ledgers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              InventoryLedgerItem(item: ledgers[index]),
        ),
      );
    });
  }
}
