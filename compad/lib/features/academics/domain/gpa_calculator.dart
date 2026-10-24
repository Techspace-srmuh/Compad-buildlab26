/// Indian Higher Education Grading System (UGC / AICTE / NEP-2020)
/// Supports 10-point SGPA/CGPA, Backlog detection, CBCS credit categorisation,
/// and configurable percentage conversion formulas.
library;

enum CbcsCreditCategory {
  core, // Discipline Specific Core
  elective, // Discipline Specific Elective
  openElective, // Generic / Open Elective
  skillEnhancement, // SEC
  abilityEnhancement, // AEC
  valueAdded, // VAC
  internshipProject, // Summer Internship / Major Project
}

enum PercentageFormulaPreset {
  aicte95, // CGPA * 9.5 (AICTE, CBSE standard)
  direct10, // CGPA * 10.0
  vtuFormula, // (CGPA - 0.75) * 10
  mumbaiFormula, // (CGPA - 0.5) * 10
  custom,
}

class IndianCourseGrade {
  final String courseCode;
  final String courseName;
  final int credits;
  final String gradeLetter; // O, A+, A, B+, B, C, P, F, Ab
  final int semester;
  final CbcsCreditCategory category;
  final bool isBacklog;

  const IndianCourseGrade({
    required this.courseCode,
    required this.courseName,
    required this.credits,
    required this.gradeLetter,
    required this.semester,
    this.category = CbcsCreditCategory.core,
    this.isBacklog = false,
  });

  int get gradePoints => IndianGradingScheme.defaultLetterToPoints[gradeLetter.toUpperCase()] ?? 0;
  bool get isPassed => gradePoints >= 4; // Passing threshold is 'P' (4 points)
}

class SgpaResult {
  final int semester;
  final double sgpa;
  final int registeredCredits;
  final int earnedCredits;
  final int totalGradePointsProduct;
  final List<IndianCourseGrade> backlogs;

  const SgpaResult({
    required this.semester,
    required this.sgpa,
    required this.registeredCredits,
    required this.earnedCredits,
    required this.totalGradePointsProduct,
    required this.backlogs,
  });
}

class CgpaResult {
  final double cgpa;
  final int totalRegisteredCredits;
  final int totalEarnedCredits;
  final double percentage;
  final String division;
  final int totalActiveBacklogs;
  final Map<int, SgpaResult> semesterSgpas;

  const CgpaResult({
    required this.cgpa,
    required this.totalRegisteredCredits,
    required this.totalEarnedCredits,
    required this.percentage,
    required this.division,
    required this.totalActiveBacklogs,
    required this.semesterSgpas,
  });
}

class IndianGradingScheme {
  // UGC 10-Point Scale Standard
  static const Map<String, int> defaultLetterToPoints = {
    'O': 10, // Outstanding
    'A+': 9, // Excellent
    'A': 8, // Very Good
    'B+': 7, // Good
    'B': 6, // Above Average
    'C': 5, // Average
    'P': 4, // Pass
    'F': 0, // Fail
    'AB': 0, // Absent
  };

  /// Calculates SGPA for a single semester:
  /// SGPA = Σ(Credit_i × GradePoint_i) / Σ(Credit_i)
  static SgpaResult calculateSgpa(int semester, List<IndianCourseGrade> courses) {
    if (courses.isEmpty) {
      return SgpaResult(
        semester: semester,
        sgpa: 0.0,
        registeredCredits: 0,
        earnedCredits: 0,
        totalGradePointsProduct: 0,
        backlogs: const [],
      );
    }

    int registeredCredits = 0;
    int earnedCredits = 0;
    int weightedSum = 0;
    final backlogs = <IndianCourseGrade>[];

    for (final c in courses) {
      registeredCredits += c.credits;
      final pts = c.gradePoints;
      weightedSum += (c.credits * pts);

      if (c.isPassed) {
        earnedCredits += c.credits;
      } else {
        backlogs.add(c);
      }
    }

    final sgpa = registeredCredits > 0 ? weightedSum / registeredCredits : 0.0;
    final rounded = double.parse(sgpa.toStringAsFixed(2));

    return SgpaResult(
      semester: semester,
      sgpa: rounded,
      registeredCredits: registeredCredits,
      earnedCredits: earnedCredits,
      totalGradePointsProduct: weightedSum,
      backlogs: backlogs,
    );
  }

  /// Calculates cumulative CGPA across all recorded semesters
  static CgpaResult calculateCgpa({
    required List<IndianCourseGrade> allCourses,
    PercentageFormulaPreset preset = PercentageFormulaPreset.aicte95,
    double customMultiplier = 9.5,
  }) {
    if (allCourses.isEmpty) {
      return const CgpaResult(
        cgpa: 0.0,
        totalRegisteredCredits: 0,
        totalEarnedCredits: 0,
        percentage: 0.0,
        division: 'N/A',
        totalActiveBacklogs: 0,
        semesterSgpas: {},
      );
    }

    // Group courses by semester
    final semMap = <int, List<IndianCourseGrade>>{};
    for (final c in allCourses) {
      semMap.putIfAbsent(c.semester, () => []).add(c);
    }

    final sgpaResults = <int, SgpaResult>{};
    int totalRegistered = 0;
    int totalEarned = 0;
    int totalWeightedSum = 0;
    int activeBacklogs = 0;

    for (final entry in semMap.entries) {
      final sgpaRes = calculateSgpa(entry.key, entry.value);
      sgpaResults[entry.key] = sgpaRes;
      totalRegistered += sgpaRes.registeredCredits;
      totalEarned += sgpaRes.earnedCredits;
      totalWeightedSum += sgpaRes.totalGradePointsProduct;
      activeBacklogs += sgpaRes.backlogs.length;
    }

    final cgpa = totalRegistered > 0 ? totalWeightedSum / totalRegistered : 0.0;
    final roundedCgpa = double.parse(cgpa.toStringAsFixed(2));

    // Convert CGPA to percentage per chosen university formula
    final percentage = convertCgpaToPercentage(
      cgpa: roundedCgpa,
      preset: preset,
      customMultiplier: customMultiplier,
    );

    // Indian university division classification
    String division;
    if (roundedCgpa >= 7.5 && activeBacklogs == 0) {
      division = 'First Class with Distinction';
    } else if (roundedCgpa >= 6.5) {
      division = 'First Class';
    } else if (roundedCgpa >= 5.5) {
      division = 'Second Class';
    } else if (roundedCgpa >= 4.0) {
      division = 'Pass Class';
    } else {
      division = 'Fail';
    }

    return CgpaResult(
      cgpa: roundedCgpa,
      totalRegisteredCredits: totalRegistered,
      totalEarnedCredits: totalEarned,
      percentage: percentage,
      division: division,
      totalActiveBacklogs: activeBacklogs,
      semesterSgpas: sgpaResults,
    );
  }

  /// Converts 10-point CGPA to equivalent percentage
  static double convertCgpaToPercentage({
    required double cgpa,
    PercentageFormulaPreset preset = PercentageFormulaPreset.aicte95,
    double customMultiplier = 9.5,
  }) {
    double pct;
    switch (preset) {
      case PercentageFormulaPreset.aicte95:
        pct = cgpa * 9.5;
        break;
      case PercentageFormulaPreset.direct10:
        pct = cgpa * 10.0;
        break;
      case PercentageFormulaPreset.vtuFormula:
        pct = (cgpa - 0.75) * 10.0;
        break;
      case PercentageFormulaPreset.mumbaiFormula:
        pct = (cgpa - 0.5) * 10.0;
        break;
      case PercentageFormulaPreset.custom:
        pct = cgpa * customMultiplier;
        break;
    }
    if (pct < 0.0) pct = 0.0;
    if (pct > 100.0) pct = 100.0;
    return double.parse(pct.toStringAsFixed(1));
  }

  /// Prospective What-If: Required End-Semester mark calculation
  /// e.g. Internal weightage 40%, End-sem weightage 60%
  static double marksNeededInEndSem({
    required double internalMarksScored, // out of internalMax (e.g. 32/40)
    required double internalMax, // e.g. 40
    required double targetTotalPercentage, // e.g. 80% for 'A' grade
    required double endSemMax, // e.g. 60
  }) {
    final targetTotalMarks = (targetTotalPercentage / 100.0) * (internalMax + endSemMax);
    final needed = targetTotalMarks - internalMarksScored;
    if (needed <= 0) return 0.0;
    return double.parse(needed.toStringAsFixed(1));
  }

  /// What-If projection for prospective upcoming semester SGPA
  static double projectWhatIf({
    required double currentCgpa,
    required int currentCredits,
    required int upcomingCredits,
    required double targetUpcomingSgpa,
  }) {
    if (currentCredits + upcomingCredits <= 0) return 0.0;
    final currentPoints = currentCgpa * currentCredits;
    final upcomingPoints = targetUpcomingSgpa * upcomingCredits;
    final totalCredits = currentCredits + upcomingCredits;
    final projected = (currentPoints + upcomingPoints) / totalCredits;
    return double.parse(projected.toStringAsFixed(2));
  }
}
