import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';
import 'package:library_app/features/dashboard/components/chart_borrow_count.dart';
import 'package:library_app/features/dashboard/components/chart_category_ratio.dart';
import 'package:library_app/features/dashboard/components/chart_status_ratio.dart';
import 'package:library_app/features/dashboard/components/chart_top_borrowers.dart';
import 'package:library_app/features/dashboard/components/chart_wrapper.dart';
import 'package:library_app/features/dashboard/dashboard_controller.dart';
import 'package:library_app/features/login/login_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Tổng quan',
        icon: Icons.logout,
        onTap: () => LoginController.logout(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(height: 310, child: _buildChart1()),
          const SizedBox(height: 24),
          SizedBox(height: 310, child: _buildChart2()),
          const SizedBox(height: 24),
          SizedBox(height: 310, child: _buildChart3()),
          const SizedBox(height: 24),
          SizedBox(height: 310, child: _buildChart4()),
        ],
      ),
    );
  }

  Widget _buildChart1() {
    return Obx(() {
      return ChartWrapper(
        chart: BorrowCountByYearChart(data: controller.chart1Data.value),
        selectedMonth: 1,
        selectedYear: controller.chart1Year.value,
        onMonthChanged: (_) {},
        onYearChanged: (y) {
          controller.chart1Year.value = y;
          controller.loadChart1();
        },
        showMonthDropdown: false,
        title: 'Số lượt mượn theo năm',
      );
    });
  }

  Widget _buildChart2() {
    return Obx(() {
      return ChartWrapper(
        chart: CategoryRatioChart(data: controller.chart2Data.value),
        selectedMonth: controller.chart2Month.value,
        selectedYear: controller.chart2Year.value,
        onMonthChanged: (m) {
          controller.chart2Month.value = m;
          controller.loadChart2();
        },
        onYearChanged: (y) {
          controller.chart2Year.value = y;
          controller.loadChart2();
        },
        title: 'Tỷ lệ mượn theo thể loại',
      );
    });
  }

  Widget _buildChart3() {
    return Obx(() {
      final data = controller.chart3Data.value;
      return ChartWrapper(
        chart: data != null
            ? BorrowStatusRatioChart(data: data)
            : const SizedBox.shrink(),
        selectedMonth: controller.chart3Month.value,
        selectedYear: controller.chart3Year.value,
        onMonthChanged: (m) {
          controller.chart3Month.value = m;
          controller.loadChart3();
        },
        onYearChanged: (y) {
          controller.chart3Year.value = y;
          controller.loadChart3();
        },
        title: 'Tỷ lệ trạng thái mượn trả',
      );
    });
  }

  Widget _buildChart4() {
    return Obx(() {
      return ChartWrapper(
        chart: TopBorrowersChart(data: controller.chart4Data.value),
        selectedMonth: controller.chart4Month.value,
        selectedYear: controller.chart4Year.value,
        onMonthChanged: (m) {
          controller.chart4Month.value = m;
          controller.loadChart4();
        },
        onYearChanged: (y) {
          controller.chart4Year.value = y;
          controller.loadChart4();
        },
        title: 'Top người mượn nhiều nhất',
      );
    });
  }
}
