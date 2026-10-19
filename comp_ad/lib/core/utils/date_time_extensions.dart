import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Returns day name abbreviation (Mon, Tue, Wed, Thu, Fri, Sat, Sun)
  String get shortDayName => DateFormat('EEE').format(this);

  /// Returns full day name (Monday, Tuesday, etc.)
  String get fullDayName => DateFormat('EEEE').format(this);

  /// Returns day number formatted like "16"
  String get dayNumber => DateFormat('dd').format(this);

  /// Returns Month and Year formatted like "Oct 2024"
  String get monthYear => DateFormat('MMM yyyy').format(this);

  /// Returns 12-hour formatted time "09:30 AM"
  String get formattedTime => DateFormat('hh:mm a').format(this);

  /// Converts "HH:mm" 24-hr string to 12-hr display (e.g. "08:30" -> "08:30 AM")
  static String formatTimeString(String time24) {
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, hour, minute);
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return time24;
    }
  }

  /// Converts "HH:mm" string to total minutes from midnight
  static int timeToMinutes(String time24) {
    try {
      final parts = time24.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    } catch (_) {
      return 0;
    }
  }

  /// Calculates duration in minutes between start and end time
  static int durationMinutes(String start24, String end24) {
    final start = timeToMinutes(start24);
    final end = timeToMinutes(end24);
    return (end - start).clamp(0, 1440);
  }
}
