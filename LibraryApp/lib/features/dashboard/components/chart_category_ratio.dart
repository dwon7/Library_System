import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:library_app/features/dashboard/chart_models.dart';

class CategoryRatioChart extends StatelessWidget {
  final List<CategoryRatio> data;
  const CategoryRatioChart({super.key, required this.data});

  static const _colors = [
    Colors.blue, Colors.orange, Colors.green, Colors.red,
    Colors.purple, Colors.teal, Colors.pink, Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Không có dữ liệu', style: TextStyle(fontSize: 12, color: Colors.grey)));
    }
    return Row(
      children: [
        Expanded(
          flex: 3,
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
                    sections: List.generate(data.length, (i) {
                      return PieChartSectionData(
                        value: data[i].count.toDouble(),
                        color: _colors[i % _colors.length],
                        radius: 40,
                        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                      );
                    }),
                    sectionsSpace: 2,
                    centerSpaceRadius: 20,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(data.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: _colors[i % _colors.length],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data[i].categoryName,
                        style: const TextStyle(fontSize: 9),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${data[i].percentage}%',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
