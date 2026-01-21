import 'package:intl/intl.dart';

class AppDateFormatter {
  /// 🔹 For API → yyyy-MM-dd
  static String toApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// 🔹 For UI → 20 Jan 2026
  static String toDisplay(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// 🔹 For UI with time → 20 Jan 2026 • 10:55 AM
  static String toDisplayWithTime(DateTime date) {
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  /// 🔹 From API string → display
  static String apiToDisplay(String date) {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return toDisplay(parsed);
  }
}
