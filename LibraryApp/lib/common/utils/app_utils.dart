class AppUtils {
  /// Parse ISO8601 datetime từ API (e.g. "2024-01-15T00:00:00Z") → "15/01/2024"
  static String formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final local = dt.toLocal();
    return "${local.day.toString().padLeft(2, '0')}/"
        "${local.month.toString().padLeft(2, '0')}/"
        "${local.year}";
  }

  /// Format số tiền, tách "." mỗi 3 chữ số (e.g. 1500000 → "1.500.000")
  static String formatMoney(num? value) {
    if (value == null) return '—';
    final isNegative = value < 0;
    final intStr = value.abs().truncate().toString();
    final grouped = intStr.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
    return isNegative ? '-$grouped' : grouped;
  }
}
