class StudyGoal {
  final String id;
  final String subject;
  final String title;
  final DateTime deadline;
  final int estimatedHoursNeeded;

  const StudyGoal({
    required this.id,
    required this.subject,
    required this.title,
    required this.deadline,
    required this.estimatedHoursNeeded,
  });
}

class DailyStudySession {
  final DateTime date;
  final String subject;
  final String topic;
  final int allocatedMinutes;

  const DailyStudySession({
    required this.date,
    required this.subject,
    required this.topic,
    required this.allocatedMinutes,
  });
}

class StudyPlanner {
  /// Automatically distributes study goals into balanced daily sessions
  static List<DailyStudySession> generateRevisionPlan({
    required List<StudyGoal> goals,
    required DateTime startDate,
    int maxDailyStudyMinutes = 240, // 4 hours max per day
  }) {
    if (goals.isEmpty) return [];

    final sessions = <DailyStudySession>[];

    // Sort goals by urgency (closest deadline first)
    final sortedGoals = List<StudyGoal>.from(goals)
      ..sort((a, b) => a.deadline.compareTo(b.deadline));

    for (final goal in sortedGoals) {
      final daysAvailable = goal.deadline.difference(startDate).inDays;
      final effectiveDays = daysAvailable > 0 ? daysAvailable : 1;

      // Calculate minutes per day needed for this goal
      final totalMinutesNeeded = goal.estimatedHoursNeeded * 60;
      final minutesPerDay = (totalMinutesNeeded / effectiveDays).ceil();
      final boundedMinutes = minutesPerDay.clamp(30, 90); // 30m to 90m blocks

      for (int i = 0; i < effectiveDays; i++) {
        final sessionDate = startDate.add(Duration(days: i));
        sessions.add(
          DailyStudySession(
            date: DateTime(sessionDate.year, sessionDate.month, sessionDate.day),
            subject: goal.subject,
            topic: '${goal.title} (Part ${i + 1}/$effectiveDays)',
            allocatedMinutes: boundedMinutes,
          ),
        );
      }
    }

    // Sort sessions by date
    sessions.sort((a, b) => a.date.compareTo(b.date));
    return sessions;
  }
}
