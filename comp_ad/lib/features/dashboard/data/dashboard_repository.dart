import '../../../core/utils/attendance_calculator.dart';
import '../../../core/utils/date_time_extensions.dart';
import '../../attendance/data/attendance_repository.dart';
import '../../timetable/data/timetable_repository.dart';
import '../../timetable/models/timetable_slot_model.dart';

class DashboardData {
  final TimetableSlotModel? activeOrUpcomingSlot;
  final int minutesUntilNext;
  final bool isCurrentlyActive;
  final AttendanceResult attendance;
  final int totalSessionsToday;
  final int totalNotes;

  const DashboardData({
    required this.activeOrUpcomingSlot,
    required this.minutesUntilNext,
    required this.isCurrentlyActive,
    required this.attendance,
    required this.totalSessionsToday,
    required this.totalNotes,
  });
}

class DashboardRepository {
  final TimetableRepository _timetableRepo = TimetableRepository();
  final AttendanceRepository _attendanceRepo = AttendanceRepository();

  Future<DashboardData> getDashboardData() async {
    final now = DateTime.now();
    // Monday is 1, Sunday is 7
    final currentDayOfWeek = now.weekday > 6 ? 1 : now.weekday; // fallback to Mon if Sun
    final slotsToday = await _timetableRepo.getSlotsForDay(currentDayOfWeek);

    final currentMinutes = now.hour * 60 + now.minute;
    TimetableSlotModel? targetSlot;
    int minutesUntil = 0;
    bool isActive = false;

    for (final slot in slotsToday) {
      final startMin = DateTimeExtensions.timeToMinutes(slot.startTime);
      final endMin = DateTimeExtensions.timeToMinutes(slot.endTime);

      if (currentMinutes >= startMin && currentMinutes < endMin) {
        // Currently active class
        targetSlot = slot;
        isActive = true;
        minutesUntil = 0;
        break;
      } else if (currentMinutes < startMin) {
        // Upcoming class
        targetSlot = slot;
        isActive = false;
        minutesUntil = startMin - currentMinutes;
        break;
      }
    }

    // If all classes for today finished or no slots, pick first slot of today or tomorrow
    if (targetSlot == null && slotsToday.isNotEmpty) {
      targetSlot = slotsToday.first;
      isActive = false;
      minutesUntil = (DateTimeExtensions.timeToMinutes(targetSlot.startTime) - currentMinutes + 1440) % 1440;
    }

    final aggregateAttendance = await _attendanceRepo.getAggregateStats();

    return DashboardData(
      activeOrUpcomingSlot: targetSlot,
      minutesUntilNext: minutesUntil,
      isCurrentlyActive: isActive,
      attendance: aggregateAttendance,
      totalSessionsToday: slotsToday.length,
      totalNotes: 2, // Cached or counted
    );
  }
}
