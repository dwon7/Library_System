import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../models/ressponses/inventory_audit_detail_res.dart';

class InventoryAuditsProvider {
  final ApiClient _client = Get.find<ApiClient>();

  // API #9b: getCountByStatus (IC) | GET /api/inventorychecks/count?status=
  Future<int> getCountByStatus(int status) async {
    final response = await _client.dio.get(
      '/inventorychecks/count',
      queryParameters: {'status': status},
    );
    return ApiClient.asInt(response.data);
  }

  // API #11: getAuditsByStatus | GET /api/inventorychecks/list?status=
  Future<List<InventoryAuditDetailRes>> getAuditsByStatus(int status) async {
    final response = await _client.dio.get(
      '/inventorychecks/list',
      queryParameters: {'status': status},
    );
    final data = ApiClient.asList(response.data);
    return data.map((e) => InventoryAuditDetailRes.fromJson(e)).toList();
  }

  // getMonthlyAuditTrend | GET /api/inventorychecks/monthly-trend?status=&year=
  Future<List<MonthlyBorrowCount>> getMonthlyAuditTrend(
    int status,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/inventorychecks/monthly-trend',
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

  // getConditionRatioByStatus | GET /api/inventorychecks/condition-ratio?status=&month=&year=
  Future<List<CategoryRatio>> getConditionRatioByStatus(
    int status,
    int month,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/inventorychecks/condition-ratio',
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

  // getTopAuditChiefsByStatus | GET /api/inventorychecks/top-chiefs?status=&month=&year=
  Future<List<BorrowerStat>> getTopAuditChiefsByStatus(
    int status,
    int month,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/inventorychecks/top-chiefs',
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
