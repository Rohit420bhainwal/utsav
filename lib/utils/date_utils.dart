import 'package:intl/intl.dart';

class DateUtilsHelper {
/*  /// 🔹 Format: 17 Apr 2026
  static String formatDate(dynamic date) {
    if (date == null) return "-";

    try {
      final parsed = DateTime.parse(date.toString());
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return "-";
    }
  }*/

  static String formatDate(dynamic date) {
    if (date == null) return "-";

    try {
      final parsed = DateTime.parse(date.toString());
      return DateFormat('MMM dd, yyyy').format(parsed);
    } catch (e) {
      return "-";
    }
  }

  /// 🔹 Format: 17 Apr
  static String formatShortDate(dynamic date) {
    if (date == null) return "-";

    try {
      final parsed = DateTime.parse(date.toString());
      return DateFormat('dd MMM').format(parsed);
    } catch (e) {
      return "-";
    }
  }

  /// 🔹 Format: Friday, 17 Apr 2026
  static String formatFullDate(dynamic date) {
    if (date == null) return "-";

    try {
      final parsed = DateTime.parse(date.toString());
      return DateFormat('EEEE, dd MMM yyyy').format(parsed);
    } catch (e) {
      return "-";
    }
  }

  /// 🔹 Format: 17 Apr 2026, 10:30 AM
  static String formatDateTime(dynamic date) {
    if (date == null) return "-";

    try {
      final parsed = DateTime.parse(date.toString());
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsed);
    } catch (e) {
      return "-";
    }
  }

  /// 🔹 Format: Time only → 10:30 AM
  static String formatTime(dynamic date) {
    if (date == null) return "-";

    try {
      final parsed = DateTime.parse(date.toString());
      return DateFormat('hh:mm a').format(parsed);
    } catch (e) {
      return "-";
    }
  }

  /// 🔹 Relative: Today / Yesterday / 2 days ago
  static String formatRelative(dynamic date) {
    if (date == null) return "-";

    try {
      final parsed = DateTime.parse(date.toString());
      final now = DateTime.now();
      final diff = now.difference(parsed).inDays;

      if (diff == 0) return "Today";
      if (diff == 1) return "Yesterday";
      if (diff < 7) return "$diff days ago";

      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return "-";
    }
  }
}