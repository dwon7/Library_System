class MonthlyBorrowCount {
  final int month;
  final int count;
  MonthlyBorrowCount({required this.month, required this.count});
}

class CategoryRatio {
  final String categoryName;
  final int count;
  final double percentage;
  CategoryRatio({required this.categoryName, required this.count, required this.percentage});
}

class BorrowStatusRatio {
  final int completed;
  final int borrowing;
  final int overdue;
  final int total;
  BorrowStatusRatio({required this.completed, required this.borrowing, required this.overdue})
    : total = completed + borrowing + overdue;
}

class BorrowerStat {
  final String userName;
  final int count;
  BorrowerStat({required this.userName, required this.count});
}
