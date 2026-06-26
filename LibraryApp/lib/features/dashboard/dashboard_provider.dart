import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

class DashboardProvider {
  final ApiClient _client = Get.find<ApiClient>();

  // API #15: getBorrowCountByYear | GET /api/dashboard/borrow-by-year?year=
  Future<List<MonthlyBorrowCount>> getBorrowCountByYear(int year) async {
    final response = await _client.dio.get(
      '/dashboard/borrow-by-year',
      queryParameters: {'year': year},
    );
    final data = ApiClient.asList(response.data);
    final result = data
        .map((e) => MonthlyBorrowCount(
              month: e['month'] as int,
              count: e['count'] as int,
            ))
        .toList();
    // Đảm bảo đủ 12 tháng, tháng chưa có mượn thì count = 0
    final monthMap = {for (final m in result) m.month: m.count};
    return List.generate(
      12,
      (i) => MonthlyBorrowCount(month: i + 1, count: monthMap[i + 1] ?? 0),
    );
  }

  // API #16: getCategoryBorrowRatio | GET /api/dashboard/category-ratio?month=&year=
  Future<List<CategoryRatio>> getCategoryBorrowRatio(int month, int year) async {
    final response = await _client.dio.get(
      '/dashboard/category-ratio',
      queryParameters: {'month': month, 'year': year},
    );
    final data = ApiClient.asList(response.data);
    return data
        .map((e) => CategoryRatio(
              categoryName: (e['categoryName'] as String?) ?? '',
              count: (e['count'] as num?)?.toInt() ?? 0,
              percentage: (e['percentage'] as num?)?.toDouble() ?? 0.0,
            ))
        .toList();
  }

  // API #17: getBorrowStatusRatio | GET /api/dashboard/borrow-status?month=&year=
  Future<BorrowStatusRatio> getBorrowStatusRatio(int month, int year) async {
    final response = await _client.dio.get(
      '/dashboard/borrow-status',
      queryParameters: {'month': month, 'year': year},
    );
    final d = response.data as Map<String, dynamic>;
    // Hỗ trợ cả { completed, borrowing, overdue } và { done, notDone, total }
    final completed = (d['completed'] ?? d['done'] ?? 0) as int;
    final borrowing = (d['borrowing'] ?? 0) as int;
    final overdue = (d['overdue'] ?? 0) as int;
    return BorrowStatusRatio(
      completed: completed,
      borrowing: borrowing,
      overdue: overdue,
    );
  }

  // API #18: getTopBorrowers | GET /api/dashboard/top-borrowers?month=&year=
  Future<List<BorrowerStat>> getTopBorrowers(int month, int year) async {
    final response = await _client.dio.get(
      '/dashboard/top-borrowers',
      queryParameters: {'month': month, 'year': year},
    );
    final data = ApiClient.asList(response.data);
    return data
        .map((e) => BorrowerStat(
              userName: (e['fullName'] ?? e['userName'] ?? '') as String,
              count: (e['totalBorrows'] ?? e['count'] ?? 0) as int,
            ))
        .toList();
  }
}
