import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/inventory_audit_detail_res.dart';

class InventoryAuditsProvider {
  final ApiClient _client = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

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

  // TODO:MOCK getMonthlyAuditTrend | Input: int status (0=tất cả, 1=đã hoàn thành, 2=chưa hoàn thành), int year | Output: List<MonthlyBorrowCount> (đủ 12 tháng, count=0 nếu không có) | GET /api/inventorychecks/monthly-trend?status=&year=
  Future<List<MonthlyBorrowCount>> getMonthlyAuditTrend(
    int status,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final counts = <int, int>{};
    for (final a in _storageService.inventoryAudits) {
      if (status != 0 && a.status != status) continue;
      final d = DateTime.tryParse(a.auditDate ?? '');
      if (d == null || d.year != year) continue;
      counts[d.month] = (counts[d.month] ?? 0) + 1;
    }
    return List.generate(
      12,
      (i) => MonthlyBorrowCount(month: i + 1, count: counts[i + 1] ?? 0),
    );
  }

  // TODO:MOCK getConditionRatioByStatus | Input: int status, int month, int year | Output: List<CategoryRatio> (tỷ lệ tình trạng sách: Còn SD/Rách nát/Mất/Chưa kiểm kê) | GET /api/inventorychecks/condition-ratio?status=&month=&year=
  Future<List<CategoryRatio>> getConditionRatioByStatus(
    int status,
    int month,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    const labels = {
      1: 'Còn sử dụng',
      2: 'Rách nát',
      3: 'Mất',
      4: 'Chưa kiểm kê',
    };
    final conditionCount = <int, int>{};
    int total = 0;
    for (final a in _storageService.inventoryAudits) {
      if (status != 0 && a.status != status) continue;
      final d = DateTime.tryParse(a.auditDate ?? '');
      if (d == null || d.month != month || d.year != year) continue;
      for (final detail in a.auditDetails ?? const <AuditDetail>[]) {
        final type = detail.conditionType ?? 4;
        final qty = detail.quantity ?? 1;
        conditionCount[type] = (conditionCount[type] ?? 0) + qty;
        total += qty;
      }
    }
    if (total == 0) return [];
    return conditionCount.entries.map((e) {
      return CategoryRatio(
        categoryName: labels[e.key] ?? 'Khác',
        count: e.value,
        percentage: double.parse((e.value / total * 100).toStringAsFixed(1)),
      );
    }).toList();
  }

  // TODO:MOCK getTopAuditChiefsByStatus | Input: int status, int month, int year | Output: List<BorrowerStat> (top trưởng ban phụ trách nhiều đợt kiểm kê nhất, tối đa 5) | GET /api/inventorychecks/top-chiefs?status=&month=&year=
  Future<List<BorrowerStat>> getTopAuditChiefsByStatus(
    int status,
    int month,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final chiefCount = <String, int>{};
    for (final a in _storageService.inventoryAudits) {
      if (status != 0 && a.status != status) continue;
      final d = DateTime.tryParse(a.auditDate ?? '');
      if (d == null || d.month != month || d.year != year) continue;
      final chief = a.auditBoard?.firstWhere(
        (m) => m.role == "Trưởng ban",
        orElse: () => AuditBoardMember(fullName: ''),
      );
      final name = chief?.fullName;
      if (name == null || name.isEmpty) continue;
      chiefCount[name] = (chiefCount[name] ?? 0) + 1;
    }
    final list = chiefCount.entries
        .map((e) => BorrowerStat(userName: e.key, count: e.value))
        .toList();
    list.sort((a, b) => b.count.compareTo(a.count));
    return list.take(5).toList();
  }
}
