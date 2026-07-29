import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';
import '../../models/ressponses/user_detail_res.dart';

class BorrowCardsProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  // Tải và cache users để _mapCards trong controller dùng được
  Future<void> getAndCacheUsers() async {
    try {
      final response = await _client.dio.get('/users');
      final data = ApiClient.asList(response.data);
      final users = data.map((e) => UserDetailRes.fromJson(e)).toList();
      _storageService.users.assignAll(users);
    } catch (_) {}
  }

  // API #8: getDueTodayCount | GET /api/borrow/due-today
  Future<int> getDueTodayCount() async {
    final response = await _client.dio.get('/borrow/due-today');
    return ApiClient.asInt(response.data);
  }

  // API #9a: getCountByStatus (BC) | GET /api/borrow/count?status=
  Future<int> getCountByStatus(int status) async {
    final response = await _client.dio.get(
      '/borrow/count',
      queryParameters: {'status': status},
    );
    return ApiClient.asInt(response.data);
  }

  // API #10: getCardsByStatus | GET /api/borrow/list?status=
  Future<List<BorrowCardDetailRes>> getCardsByStatus(int status) async {
    final response = await _client.dio.get(
      '/borrow/list',
      queryParameters: {'status': status},
    );
    final data = ApiClient.asList(response.data);
    return data.map((e) => BorrowCardDetailRes.fromJson(e)).toList();
  }

  // getMonthlyTrendByStatus | GET /api/borrow/monthly-trend?status=&year=
  Future<List<MonthlyBorrowCount>> getMonthlyTrendByStatus(
    int status,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/borrow/monthly-trend',
      queryParameters: {'status': status, 'year': year},
    );
    final data = ApiClient.asList(response.data);
    final result = data
        .map((e) => MonthlyBorrowCount(
              month: e['month'] as int,
              count: e['count'] as int,
            ))
        .toList();
    final monthMap = {for (final m in result) m.month: m.count};
    return List.generate(
      12,
      (i) => MonthlyBorrowCount(month: i + 1, count: monthMap[i + 1] ?? 0),
    );
  }

  // getCategoryRatioByStatus | GET /api/borrow/category-ratio?status=&month=&year=
  Future<List<CategoryRatio>> getCategoryRatioByStatus(
    int status,
    int month,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/borrow/category-ratio',
      queryParameters: {'status': status, 'month': month, 'year': year},
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

  // getTopBorrowersByStatus | GET /api/borrow/top-borrowers?status=&month=&year=
  Future<List<BorrowerStat>> getTopBorrowersByStatus(
    int status,
    int month,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/borrow/top-borrowers',
      queryParameters: {'status': status, 'month': month, 'year': year},
    );
    final data = ApiClient.asList(response.data);
    return data
        .map((e) => BorrowerStat(
              userName: (e['userName'] as String?) ?? '',
              count: (e['count'] as num?)?.toInt() ?? 0,
            ))
        .toList();
  }
}
