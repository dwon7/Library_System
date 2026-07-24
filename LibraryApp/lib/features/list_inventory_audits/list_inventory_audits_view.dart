import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';
import 'package:library_app/common/widgets/empty_state.dart';
import 'package:library_app/common/widgets/search_text_field.dart';
import 'package:library_app/features/dashboard/components/chart_borrow_count.dart';
import 'package:library_app/features/dashboard/components/chart_category_ratio.dart';
import 'package:library_app/features/dashboard/components/chart_top_borrowers.dart';
import 'package:library_app/features/dashboard/components/chart_wrapper.dart';

import '../inventory_audits/components/inventory_audit_item.dart';
import 'list_inventory_audits_controller.dart';

class ListInventoryAuditsView extends GetView<ListInventoryAuditsController> {
  const ListInventoryAuditsView({super.key});

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
          SizedBox(height: 310, child: _buildConditionChart()),
          const SizedBox(height: 24),
          SizedBox(height: 310, child: _buildTopChiefsChart()),
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
        title: 'Số đợt kiểm kê theo tháng',
      );
    });
  }

  Widget _buildConditionChart() {
    return Obx(() {
      return ChartWrapper(
        chart: CategoryRatioChart(data: controller.conditionRatioData),
        selectedMonth: controller.conditionMonth.value,
        selectedYear: controller.conditionYear.value,
        onMonthChanged: (m) {
          controller.conditionMonth.value = m;
          controller.loadConditionRatio();
        },
        onYearChanged: (y) {
          controller.conditionYear.value = y;
          controller.loadConditionRatio();
        },
        title: 'Tỷ lệ tình trạng sách',
      );
    });
  }

  Widget _buildTopChiefsChart() {
    return Obx(() {
      return ChartWrapper(
        chart: TopBorrowersChart(data: controller.topChiefsData),
        selectedMonth: controller.topChiefsMonth.value,
        selectedYear: controller.topChiefsYear.value,
        onMonthChanged: (m) {
          controller.topChiefsMonth.value = m;
          controller.loadTopChiefs();
        },
        onYearChanged: (y) {
          controller.topChiefsYear.value = y;
          controller.loadTopChiefs();
        },
        title: 'Top trưởng ban kiểm kê',
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
              hintText: "Tìm phiếu kiểm kê",
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
      final audits = controller.filteredAudits;
      if (audits.isEmpty) {
        return const EmptyState(message: "Không có phiếu kiểm kê nào");
      }
      return RefreshIndicator(
        onRefresh: () => controller.loadData(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          itemCount: audits.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              InventoryAuditItem(item: audits[index]),
        ),
      );
    });
  }
}
