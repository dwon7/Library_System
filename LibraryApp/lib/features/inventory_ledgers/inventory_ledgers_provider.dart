import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../models/ressponses/inventory_ledger_detail_res.dart';

class InventoryLedgersProvider {
  final ApiClient _client = Get.find<ApiClient>();

  // API #13: getCountByType | GET /api/stocktransactions/count?type=
  Future<int> getCountByType(int type) async {
    final response = await _client.dio.get(
      '/stocktransactions/count',
      queryParameters: {'type': type},
    );
    return ApiClient.asInt(response.data);
  }

  // API #14: getLedgersByType | GET /api/stocktransactions/list?type=
  Future<List<InventoryLedgerDetailRes>> getLedgersByType(int type) async {
    final response = await _client.dio.get(
      '/stocktransactions/list',
      queryParameters: {'type': type},
    );
    final data = ApiClient.asList(response.data);
    return data.map((e) => InventoryLedgerDetailRes.fromJson(e)).toList();
  }

  // getMonthlyLedgerTrend | GET /api/stocktransactions/monthly-trend?type=&year=
  Future<List<MonthlyBorrowCount>> getMonthlyLedgerTrend(
    int type,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/stocktransactions/monthly-trend',
      queryParameters: {'type': type, 'year': year},
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

  // getPartnerValueRatioByType | GET /api/stocktransactions/partner-ratio?type=&month=&year=
  Future<List<CategoryRatio>> getPartnerValueRatioByType(
    int type,
    int month,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/stocktransactions/partner-ratio',
      queryParameters: {'type': type, 'month': month, 'year': year},
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

  // getTopPartnersByType | GET /api/stocktransactions/top-partners?type=&month=&year=
  Future<List<BorrowerStat>> getTopPartnersByType(
    int type,
    int month,
    int year,
  ) async {
    final response = await _client.dio.get(
      '/stocktransactions/top-partners',
      queryParameters: {'type': type, 'month': month, 'year': year},
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
