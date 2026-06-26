import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

class BorrowCountByYearChart extends StatelessWidget {
  final List<MonthlyBorrowCount> data;
  const BorrowCountByYearChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Không có dữ liệu', style: TextStyle(fontSize: 12, color: Colors.grey)));
    }
    final maxY = data.map((d) => d.count).reduce((a, b) => a > b ? a : b).toDouble();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY < 1 ? 10 : maxY * 1.2,
        barGroups: data.map((d) {
          return BarChartGroupData(
            x: d.month - 1,
            barRods: [
              BarChartRodData(
                toY: d.count.toDouble(),
                color: Colors.blue.shade400,
                width: 18,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Tháng', style: TextStyle(fontSize: 10)),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final months = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];
                final i = value.toInt();
                if (i >= 0 && i < 12) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(months[i], style: const TextStyle(fontSize: 9)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (value, meta) {
              if (value == value.roundToDouble()) {
                return Text(value.toInt().toString(), style: const TextStyle(fontSize: 9));
              }
              return const SizedBox.shrink();
            }),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY < 1 ? 2 : (maxY * 1.2 / 5).ceilToDouble().clamp(1, 100),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
