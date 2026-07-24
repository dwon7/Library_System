import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';

class InventoryLedgersProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

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

  // TODO:MOCK getMonthlyLedgerTrend | Input: int type (0=tất cả, 1=nhập kho, 2=xuất kho), int year | Output: List<MonthlyBorrowCount> (đủ 12 tháng, count=0 nếu không có) | GET /api/stocktransactions/monthly-trend?type=&year=
  Future<List<MonthlyBorrowCount>> getMonthlyLedgerTrend(
    int type,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final counts = <int, int>{};
    for (final l in _storageService.inventoryLedgers) {
      if (type != 0 && l.ledgerType != type) continue;
      final d = DateTime.tryParse(l.transactionDate ?? '');
      if (d == null || d.year != year) continue;
      counts[d.month] = (counts[d.month] ?? 0) + 1;
    }
    return List.generate(
      12,
      (i) => MonthlyBorrowCount(month: i + 1, count: counts[i + 1] ?? 0),
    );
  }

  // TODO:MOCK getPartnerValueRatioByType | Input: int type, int month, int year | Output: List<CategoryRatio> (tỷ lệ giá trị giao dịch theo đối tác) | GET /api/stocktransactions/partner-ratio?type=&month=&year=
  Future<List<CategoryRatio>> getPartnerValueRatioByType(
    int type,
    int month,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final partnerValue = <String, int>{};
    int total = 0;
    for (final l in _storageService.inventoryLedgers) {
      if (type != 0 && l.ledgerType != type) continue;
      final d = DateTime.tryParse(l.transactionDate ?? '');
      if (d == null || d.month != month || d.year != year) continue;
      final name = l.partner?.partnerName;
      if (name == null || name.isEmpty) continue;
      final value = l.grandTotal ?? 0;
      partnerValue[name] = (partnerValue[name] ?? 0) + value;
      total += value;
    }
    if (total == 0) return [];
    return partnerValue.entries.map((e) {
      return CategoryRatio(
        categoryName: e.key,
        count: e.value,
        percentage: double.parse((e.value / total * 100).toStringAsFixed(1)),
      );
    }).toList();
  }

  // TODO:MOCK getTopPartnersByType | Input: int type, int month, int year | Output: List<BorrowerStat> (top đối tác nhiều giao dịch nhất, tối đa 5) | GET /api/stocktransactions/top-partners?type=&month=&year=
  Future<List<BorrowerStat>> getTopPartnersByType(
    int type,
    int month,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final partnerCount = <String, int>{};
    for (final l in _storageService.inventoryLedgers) {
      if (type != 0 && l.ledgerType != type) continue;
      final d = DateTime.tryParse(l.transactionDate ?? '');
      if (d == null || d.month != month || d.year != year) continue;
      final name = l.partner?.partnerName;
      if (name == null || name.isEmpty) continue;
      partnerCount[name] = (partnerCount[name] ?? 0) + 1;
    }
    final list = partnerCount.entries
        .map((e) => BorrowerStat(userName: e.key, count: e.value))
        .toList();
    list.sort((a, b) => b.count.compareTo(a.count));
    return list.take(5).toList();
  }
}
