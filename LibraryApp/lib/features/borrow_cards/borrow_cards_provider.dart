import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

import '../../mock_data/storage_service.dart';
import '../../models/ressponses/book_detail_res.dart';
import '../../models/ressponses/borrow_card_detail_res.dart';
import '../../models/ressponses/category_detail_res.dart';
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

  // TODO:MOCK getMonthlyTrendByStatus | Input: int status (0=tất cả, 1=hoàn thành, 2=đang mượn, 3=quá hạn), int year | Output: List<MonthlyBorrowCount> (đủ 12 tháng, count=0 nếu không có) | GET /api/borrow/monthly-trend?status=&year=
  Future<List<MonthlyBorrowCount>> getMonthlyTrendByStatus(
    int status,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final counts = <int, int>{};
    for (final c in _storageService.borrowCards) {
      if (status != 0 && c.status != status) continue;
      final d = DateTime.tryParse(c.borrowDate ?? '');
      if (d == null || d.year != year) continue;
      counts[d.month] = (counts[d.month] ?? 0) + 1;
    }
    return List.generate(
      12,
      (i) => MonthlyBorrowCount(month: i + 1, count: counts[i + 1] ?? 0),
    );
  }

  // TODO:MOCK getCategoryRatioByStatus | Input: int status, int month, int year | Output: List<CategoryRatio> (tỷ lệ thể loại sách trong các phiếu mượn) | GET /api/borrow/category-ratio?status=&month=&year=
  Future<List<CategoryRatio>> getCategoryRatioByStatus(
    int status,
    int month,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final categoryCount = <String, int>{};
    int total = 0;
    for (final c in _storageService.borrowCards) {
      if (status != 0 && c.status != status) continue;
      final d = DateTime.tryParse(c.borrowDate ?? '');
      if (d == null || d.month != month || d.year != year) continue;
      for (final detail in c.borrowDetails ?? const <BorrowDetail>[]) {
        final book = _storageService.books.firstWhere(
          (b) => b.bookId == detail.bookId,
          orElse: () => BookDetailRes(),
        );
        final catId = book.categoryId;
        if (catId == null) continue;
        final qty = detail.quantity ?? 1;
        categoryCount[catId] = (categoryCount[catId] ?? 0) + qty;
        total += qty;
      }
    }
    if (total == 0) return [];
    return categoryCount.entries.map((e) {
      final category = _storageService.categories.firstWhere(
        (c) => c.categoryId == e.key,
        orElse: () => CategoryDetailRes(categoryName: e.key),
      );
      return CategoryRatio(
        categoryName: category.categoryName ?? e.key,
        count: e.value,
        percentage: double.parse((e.value / total * 100).toStringAsFixed(1)),
      );
    }).toList();
  }

  // TODO:MOCK getTopBorrowersByStatus | Input: int status, int month, int year | Output: List<BorrowerStat> (sắp xếp giảm dần theo số lượt, tối đa 5) | GET /api/borrow/top-borrowers?status=&month=&year=
  Future<List<BorrowerStat>> getTopBorrowersByStatus(
    int status,
    int month,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final userCount = <String, int>{};
    for (final c in _storageService.borrowCards) {
      if (status != 0 && c.status != status) continue;
      final d = DateTime.tryParse(c.borrowDate ?? '');
      if (d == null || d.month != month || d.year != year) continue;
      final uid = c.userId;
      if (uid == null || uid.isEmpty) continue;
      userCount[uid] = (userCount[uid] ?? 0) + 1;
    }
    final list = userCount.entries.map((e) {
      final user = _storageService.users.firstWhere(
        (u) => u.userId == e.key,
        orElse: () => UserDetailRes(fullName: e.key),
      );
      return BorrowerStat(userName: user.fullName ?? e.key, count: e.value);
    }).toList();
    list.sort((a, b) => b.count.compareTo(a.count));
    return list.take(5).toList();
  }
}
