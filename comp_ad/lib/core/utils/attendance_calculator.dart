import 'dart:math';

class AttendanceResult {
  final double percentage;
  final bool isSafe;
  final int safeBunks;
  final int classesToRecover;
  final int attended;
  final int held;

  const AttendanceResult({
    required this.percentage,
    required this.isSafe,
    required this.safeBunks,
    required this.classesToRecover,
    required this.attended,
    required this.held,
  });
}

class AttendanceCalculator {
  /// Computes official attendance status and headroom
  static AttendanceResult calculate({
    required int attended,
    required int held,
    double threshold = 0.75,
  }) {
    if (held <= 0) {
      return AttendanceResult(
        percentage: 100.0,
        isSafe: true,
        safeBunks: 0,
        classesToRecover: 0,
        attended: attended,
        held: held,
      );
    }

    final double percentage = (attended / held) * 100.0;
    final bool isSafe = percentage >= (threshold * 100.0);

    int safeBunks = 0;
    int classesToRecover = 0;

    if (isSafe) {
      // Safe bunks: floor((Attended - (Target * Held)) / Target)
      final bunkCalc = (attended - (threshold * held)) / threshold;
      safeBunks = max(0, bunkCalc.floor());
    } else {
      // Recovery Needed: ceil(((Target * Held) - Attended) / (1 - Target))
      final recCalc = ((threshold * held) - attended) / (1.0 - threshold);
      classesToRecover = max(0, recCalc.ceil());
    }

    return AttendanceResult(
      percentage: percentage,
      isSafe: isSafe,
      safeBunks: safeBunks,
      classesToRecover: classesToRecover,
      attended: attended,
      held: held,
    );
  }

  /// Simulates skipping [missedCount] future lectures
  static AttendanceResult simulateFutureMisses({
    required int baseAttended,
    required int baseHeld,
    required int missedCount,
    double threshold = 0.75,
  }) {
    final simulatedHeld = baseHeld + missedCount;
    final simulatedAttended = baseAttended; // Missed lectures increment held but not attended
    return calculate(
      attended: simulatedAttended,
      held: simulatedHeld,
      threshold: threshold,
    );
  }
}
