import 'package:library_app/features/dashboard/chart_models.dart';

class DashboardProvider {
  // TODO: getBorrowCountByYear | Input: int year | Output: List<MonthlyBorrowCount> | Đếm số phiếu mượn theo 12 tháng trong năm
  Future<List<MonthlyBorrowCount>> getBorrowCountByYear(int year) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      MonthlyBorrowCount(month: 1, count: 12),
      MonthlyBorrowCount(month: 2, count: 18),
      MonthlyBorrowCount(month: 3, count: 8),
      MonthlyBorrowCount(month: 4, count: 15),
      MonthlyBorrowCount(month: 5, count: 22),
      MonthlyBorrowCount(month: 6, count: 10),
      MonthlyBorrowCount(month: 7, count: 5),
      MonthlyBorrowCount(month: 8, count: 9),
      MonthlyBorrowCount(month: 9, count: 25),
      MonthlyBorrowCount(month: 10, count: 14),
      MonthlyBorrowCount(month: 11, count: 20),
      MonthlyBorrowCount(month: 12, count: 17),
    ];
  }

  // TODO: getCategoryBorrowRatio | Input: int month, int year | Output: List<CategoryRatio> | Tỉ lệ danh mục sách mượn trong tháng (mock)
  Future<List<CategoryRatio>> getCategoryBorrowRatio(int month, int year) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      CategoryRatio(categoryName: 'Công nghệ thông tin', count: 18, percentage: 40),
      CategoryRatio(categoryName: 'Kinh tế & Quản trị', count: 12, percentage: 27),
      CategoryRatio(categoryName: 'Văn học', count: 10, percentage: 22),
      CategoryRatio(categoryName: 'Ngoại ngữ', count: 5, percentage: 11),
    ];
  }

  // TODO: getBorrowStatusRatio | Input: int month, int year | Output: BorrowStatusRatio | Số phiếu theo 3 trạng thái: hoàn thành, đang mượn, quá hạn trong tháng
  Future<BorrowStatusRatio> getBorrowStatusRatio(int month, int year) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return BorrowStatusRatio(completed: 30, borrowing: 12, overdue: 8);
  }

  // TODO: getTopBorrowers | Input: int month, int year | Output: List<BorrowerStat> | Top 5 độc giả mượn nhiều nhất trong tháng
  Future<List<BorrowerStat>> getTopBorrowers(int month, int year) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      BorrowerStat(userName: 'Nguyễn Văn A', count: 15),
      BorrowerStat(userName: 'Trần Thị B', count: 12),
      BorrowerStat(userName: 'Lê Văn C', count: 9),
      BorrowerStat(userName: 'Phạm Thị D', count: 7),
      BorrowerStat(userName: 'Hoàng Văn E', count: 5),
    ];
  }
}
