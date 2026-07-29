import 'package:flutter/material.dart';

class ChartWrapper extends StatelessWidget {
  final Widget chart;
  final int selectedMonth;
  final int selectedYear;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onYearChanged;
  final bool showMonthDropdown;
  final String? title;

  const ChartWrapper({
    super.key,
    required this.chart,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onYearChanged,
    this.showMonthDropdown = true,
    this.title,
  });

  List<int> get _years =>
      List.generate(10, (i) => DateTime.now().year - i);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 4, bottom: 8, left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                // const SizedBox(width: 10),
                if (showMonthDropdown) ...[
                  _buildDropdown<int>(
                    value: selectedMonth,
                    items: List.generate(12, (i) => i + 1),
                    itemLabel: (m) => 'T$m',
                    onChanged: onMonthChanged,
                  ),
                  const SizedBox(width: 6),
                ],
                _buildDropdown<int>(
                  value: selectedYear,
                  items: _years,
                  itemLabel: (y) => y.toString(),
                  onChanged: onYearChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: chart,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
