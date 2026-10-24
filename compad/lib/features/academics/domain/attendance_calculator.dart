/// Indian Attendance Calculator with 75% Mandatory Attendance Rule,
/// 65% Medical/On-Duty (OD) Condonation Rule, Safe-to-Skip, and Recovery Math.
library;

enum AttendanceRiskLevel {
  safe, // >= 75%
  condonationEligible, // 65.0% - 74.99% (Requires Medical/OD certificate & Dean approval)
  criticalDetentionRisk, // < 65% (Risk of semester detention/debarred from end-sem exam)
}

class AttendanceAnalysis {
  final int attended;
  final int total;
  final int onDutyLeave;
  final double currentPercentage;
  final double requiredThreshold;
  final double condonationThreshold;
  final int safeToSkipCount;
  final int classesNeededToRecover;
  final AttendanceRiskLevel riskLevel;
  final String statusMessage;

  const AttendanceAnalysis({
    required this.attended,
    required this.total,
    required this.onDutyLeave,
    required this.currentPercentage,
    required this.requiredThreshold,
    required this.condonationThreshold,
    required this.safeToSkipCount,
    required this.classesNeededToRecover,
    required this.riskLevel,
    required this.statusMessage,
  });
}

class AttendanceCalculator {
  /// Analyzes student attendance with customizable rules
  static AttendanceAnalysis analyze({
    required int attended,
    required int total,
    int onDutyLeave = 0,
    double threshold = 75.0,
    double condonationThreshold = 65.0,
  }) {
    if (total <= 0) {
      return AttendanceAnalysis(
        attended: 0,
        total: 0,
        onDutyLeave: onDutyLeave,
        currentPercentage: 100.0,
        requiredThreshold: threshold,
        condonationThreshold: condonationThreshold,
        safeToSkipCount: 0,
        classesNeededToRecover: 0,
        riskLevel: AttendanceRiskLevel.safe,
        statusMessage: 'No classes conducted yet.',
      );
    }

    final effectiveAttended = attended + onDutyLeave;
    final pct = (effectiveAttended / total) * 100.0;
    final roundedPct = double.parse(pct.toStringAsFixed(1));

    int safeToSkip = 0;
    int neededToRecover = 0;
    AttendanceRiskLevel risk;
    String message;

    if (roundedPct >= threshold) {
      risk = AttendanceRiskLevel.safe;
      // Formula: floor((effectiveAttended - threshold * total) / threshold)
      final p = threshold / 100.0;
      final skipCalc = ((effectiveAttended - (p * total)) / p).floor();
      safeToSkip = skipCalc > 0 ? skipCalc : 0;
      message = safeToSkip > 0
          ? 'Safe to skip $safeToSkip upcoming classes without falling below $threshold%.'
          : 'Attendance on track at $roundedPct%. Do not skip classes.';
    } else if (roundedPct >= condonationThreshold) {
      risk = AttendanceRiskLevel.condonationEligible;
      // Classes to attend consecutively to reach threshold:
      // (effectiveAttended + X) / (total + X) >= p
      final p = threshold / 100.0;
      final neededCalc = (((p * total) - effectiveAttended) / (1.0 - p)).ceil();
      neededToRecover = neededCalc > 0 ? neededCalc : 1;
      message =
          'Below $threshold% ($roundedPct%). Attend next $neededToRecover consecutive classes to recover, or submit OD/medical leave for condonation.';
    } else {
      risk = AttendanceRiskLevel.criticalDetentionRisk;
      final p = threshold / 100.0;
      final neededCalc = (((p * total) - effectiveAttended) / (1.0 - p)).ceil();
      neededToRecover = neededCalc > 0 ? neededCalc : 1;
      message =
          'CRITICAL DETENTION RISK: $roundedPct% is below $condonationThreshold%. Must attend $neededToRecover classes and meet Dean/Proctor.';
    }

    return AttendanceAnalysis(
      attended: attended,
      total: total,
      onDutyLeave: onDutyLeave,
      currentPercentage: roundedPct,
      requiredThreshold: threshold,
      condonationThreshold: condonationThreshold,
      safeToSkipCount: safeToSkip,
      classesNeededToRecover: neededToRecover,
      riskLevel: risk,
      statusMessage: message,
    );
  }
}
