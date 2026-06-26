import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

class BorrowStatusRatioChart extends StatelessWidget {
  final BorrowStatusRatio data;
  const BorrowStatusRatioChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.total == 0) {
      return const Center(child: Text('Không có dữ liệu', style: TextStyle(fontSize: 12, color: Colors.grey)));
    }

    final completedPct = (data.completed / data.total * 100).round();
    final borrowingPct = (data.borrowing / data.total * 100).round();
    final overduePct = 100 - completedPct - borrowingPct;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth < constraints.maxHeight
                  ? constraints.maxWidth
                  : constraints.maxHeight;
              return SizedBox(
                width: size,
                height: size,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: data.completed.toDouble(),
                        color: Colors.green.shade400,
                        title: '$completedPct%',
                        radius: 44,
                        titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      PieChartSectionData(
                        value: data.borrowing.toDouble(),
                        color: Colors.orange.shade400,
                        title: '$borrowingPct%',
                        radius: 44,
                        titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      PieChartSectionData(
                        value: data.overdue.toDouble(),
                        color: Colors.red.shade400,
                        title: '$overduePct%',
                        radius: 44,
                        titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ],
                    sectionsSpace: 3,
                    centerSpaceRadius: 28,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _legend('Hoàn thành', data.completed, Colors.green.shade400),
            const SizedBox(height: 6),
            _legend('Đang mượn', data.borrowing, Colors.orange.shade400),
            const SizedBox(height: 6),
            _legend('Quá hạn', data.overdue, Colors.red.shade400),
          ],
        ),
      ],
    );
  }

  Widget _legend(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text('$label: $count', style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
