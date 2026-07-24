import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/features/dashboard/chart_models.dart';
import 'package:library_app/features/dashboard/dashboard_provider.dart';

class DashboardController extends GetxController {
  final DashboardProvider provider;
  DashboardController(this.provider);

  final now = DateTime.now();

  final chart1Data = <MonthlyBorrowCount>[].obs;
  final chart2Data = <CategoryRatio>[].obs;
  final chart3Data = Rxn<BorrowStatusRatio>();
  final chart4Data = <BorrowerStat>[].obs;

  final chart1Year = 0.obs;
  final chart2Month = 0.obs;
  final chart2Year = 0.obs;
  final chart3Month = 0.obs;
  final chart3Year = 0.obs;
  final chart4Month = 0.obs;
  final chart4Year = 0.obs;

  @override
  void onInit() {
    super.onInit();
    chart1Year.value = now.year;
    chart2Month.value = now.month;
    chart2Year.value = now.year;
    chart3Month.value = now.month;
    chart3Year.value = now.year;
    chart4Month.value = now.month;
    chart4Year.value = now.year;
    WidgetsBinding.instance.addPostFrameCallback((_) => refreshAll());
  }

  Future<void> refreshAll() async {
    await Future.wait([
      loadChart1(),
      loadChart2(),
      loadChart3(),
      loadChart4(),
    ]);
  }

  Future<void> loadChart1() async {
    try {
      chart1Data.value = await provider.getBorrowCountByYear(chart1Year.value);
    } catch (_) {
      chart1Data.value = [];
    }
  }

  Future<void> loadChart2() async {
    try {
      chart2Data.value = await provider.getCategoryBorrowRatio(chart2Month.value, chart2Year.value);
    } catch (_) {
      chart2Data.value = [];
    }
  }

  Future<void> loadChart3() async {
    try {
      chart3Data.value = await provider.getBorrowStatusRatio(chart3Month.value, chart3Year.value);
    } catch (_) {
      chart3Data.value = null;
    }
  }

  Future<void> loadChart4() async {
    try {
      chart4Data.value = await provider.getTopBorrowers(chart4Month.value, chart4Year.value);
    } catch (_) {
      chart4Data.value = [];
    }
  }
}
