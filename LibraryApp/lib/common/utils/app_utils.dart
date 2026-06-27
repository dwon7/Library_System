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
}
