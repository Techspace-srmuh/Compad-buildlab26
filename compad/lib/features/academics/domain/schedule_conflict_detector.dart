class TimeSlot {
  final String id;
  final String courseCode;
  final String title;
  final int dayOfWeek; // 1 = Mon, 7 = Sun
  final String startTime; // '09:00'
  final String endTime; // '10:30'

  const TimeSlot({
    required this.id,
    required this.courseCode,
    required this.title,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  int get startMinutes => _parseMinutes(startTime);
  int get endMinutes => _parseMinutes(endTime);

  static int _parseMinutes(String timeStr) {
    final parts = timeStr.trim().split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return (h * 60) + m;
  }
}

class ScheduleConflict {
  final TimeSlot slotA;
  final TimeSlot slotB;
  final String description;

  const ScheduleConflict({
    required this.slotA,
    required this.slotB,
    required this.description,
  });
}

class ScheduleConflictDetector {
  /// Checks whether two time slots overlap on the same day
  static bool overlaps(TimeSlot a, TimeSlot b) {
    if (a.dayOfWeek != b.dayOfWeek) return false;
    // Overlap exists if startA < endB AND startB < endA
    return (a.startMinutes < b.endMinutes) && (b.startMinutes < a.endMinutes);
  }

  /// Detects all conflicting pairs in a timetable list
  static List<ScheduleConflict> findConflicts(List<TimeSlot> slots) {
    final conflicts = <ScheduleConflict>[];

    for (int i = 0; i < slots.length; i++) {
      for (int j = i + 1; j < slots.length; j++) {
        final slotA = slots[i];
        final slotB = slots[j];

        if (overlaps(slotA, slotB)) {
          conflicts.add(
            ScheduleConflict(
              slotA: slotA,
              slotB: slotB,
              description: '${slotA.courseCode} (${slotA.startTime}-${slotA.endTime}) overlaps with ${slotB.courseCode} (${slotB.startTime}-${slotB.endTime}) on day ${slotA.dayOfWeek}.',
            ),
          );
        }
      }
    }

    return conflicts;
  }
}
