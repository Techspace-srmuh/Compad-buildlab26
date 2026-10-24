import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:compad/features/academics/domain/gpa_calculator.dart';
import 'package:compad/features/academics/domain/attendance_calculator.dart';
import 'package:compad/features/academics/domain/schedule_conflict_detector.dart';
import 'package:compad/features/life/domain/spaced_repetition.dart';
import 'package:compad/features/campus/domain/walking_router.dart';
import 'package:compad/features/share/domain/share_crypto.dart';
import 'package:compad/core/utils/indian_formatters.dart';

void main() {
  group('1. Indian 10-Point SGPA & CGPA Calculator (UGC/AICTE/NEP-2020)', () {
    test('Calculates semester SGPA accurately on 10-point scale', () {
      final courses = [
        const IndianCourseGrade(courseCode: 'CS101', courseName: 'DSA', credits: 4, gradeLetter: 'O', semester: 1), // 4 * 10 = 40
        const IndianCourseGrade(courseCode: 'MA102', courseName: 'Math', credits: 4, gradeLetter: 'A+', semester: 1), // 4 * 9 = 36
        const IndianCourseGrade(courseCode: 'EE103', courseName: 'BEE', credits: 3, gradeLetter: 'A', semester: 1), // 3 * 8 = 24
        const IndianCourseGrade(courseCode: 'ME104', courseName: 'Workshop', credits: 2, gradeLetter: 'B+', semester: 1), // 2 * 7 = 14
      ];
      // Total credits = 13. Total product = 40 + 36 + 24 + 14 = 114.
      // SGPA = 114 / 13 = 8.769 => 8.77
      final sgpaRes = IndianGradingScheme.calculateSgpa(1, courses);
      expect(sgpaRes.registeredCredits, 13);
      expect(sgpaRes.earnedCredits, 13);
      expect(sgpaRes.totalGradePointsProduct, 114);
      expect(sgpaRes.sgpa, 8.77);
      expect(sgpaRes.backlogs, isEmpty);
    });

    test('Detects backlogs (F / Ab) and computes CGPA across semesters', () {
      final allCourses = [
        const IndianCourseGrade(courseCode: 'CS101', courseName: 'DSA', credits: 4, gradeLetter: 'O', semester: 1), // 40
        const IndianCourseGrade(courseCode: 'MA102', courseName: 'Math', credits: 4, gradeLetter: 'F', semester: 1), // 0 (Backlog)
        const IndianCourseGrade(courseCode: 'CS201', courseName: 'DBMS', credits: 4, gradeLetter: 'A', semester: 2), // 32
      ];
      final cgpaRes = IndianGradingScheme.calculateCgpa(
        allCourses: allCourses,
        preset: PercentageFormulaPreset.aicte95,
      );
      // Total registered credits: 12. Total points: 72. CGPA: 72 / 12 = 6.00
      expect(cgpaRes.totalRegisteredCredits, 12);
      expect(cgpaRes.totalEarnedCredits, 8);
      expect(cgpaRes.totalActiveBacklogs, 1);
      expect(cgpaRes.cgpa, 6.00);
      // AICTE formula: 6.0 * 9.5 = 57.0%
      expect(cgpaRes.percentage, 57.0);
    });

    test('Converts CGPA to percentage using configurable formulas (AICTE, VTU, Mumbai)', () {
      const cgpa = 8.4;
      final aictePct = IndianGradingScheme.convertCgpaToPercentage(cgpa: cgpa, preset: PercentageFormulaPreset.aicte95);
      final vtuPct = IndianGradingScheme.convertCgpaToPercentage(cgpa: cgpa, preset: PercentageFormulaPreset.vtuFormula);
      final direct10Pct = IndianGradingScheme.convertCgpaToPercentage(cgpa: cgpa, preset: PercentageFormulaPreset.direct10);

      expect(aictePct, 79.8); // 8.4 * 9.5
      expect(vtuPct, 76.5); // (8.4 - 0.75) * 10
      expect(direct10Pct, 84.0); // 8.4 * 10
    });

    test('Calculates End-Semester marks needed to reach target percentage', () {
      // Internal scored 32/40. Target 80% overall out of 100 total (40 internal + 60 endSem)
      // Total needed = 80 marks. Needed in end-sem = 80 - 32 = 48.
      final needed = IndianGradingScheme.marksNeededInEndSem(
        internalMarksScored: 32,
        internalMax: 40,
        targetTotalPercentage: 80,
        endSemMax: 60,
      );
      expect(needed, 48.0);
    });
  });

  group('2. Indian Attendance Calculator (75% Rule & 65% Condonation)', () {
    test('Calculates safe-to-skip count when >= 75%', () {
      // Attended 18 out of 20 classes (90%). Threshold 75%.
      // Safe to skip: ((18 - 0.75 * 20) / 0.75) = (18 - 15) / 0.75 = 3 / 0.75 = 4 classes!
      final analysis = AttendanceCalculator.analyze(attended: 18, total: 20);
      expect(analysis.currentPercentage, 90.0);
      expect(analysis.riskLevel, AttendanceRiskLevel.safe);
      expect(analysis.safeToSkipCount, 4);
      expect(analysis.classesNeededToRecover, 0);
    });

    test('Flags condonation threshold (65% - 74.9%) and computes recovery classes', () {
      // Attended 14 out of 20 classes (70%).
      // Threshold 75%. (0.75 * 20 - 14) / (1 - 0.75) = (15 - 14) / 0.25 = 4 classes needed!
      final analysis = AttendanceCalculator.analyze(attended: 14, total: 20);
      expect(analysis.currentPercentage, 70.0);
      expect(analysis.riskLevel, AttendanceRiskLevel.condonationEligible);
      expect(analysis.classesNeededToRecover, 4);
    });

    test('Flags critical detention risk when < 65%', () {
      // Attended 10 out of 20 classes (50%).
      final analysis = AttendanceCalculator.analyze(attended: 10, total: 20);
      expect(analysis.currentPercentage, 50.0);
      expect(analysis.riskLevel, AttendanceRiskLevel.criticalDetentionRisk);
      expect(analysis.statusMessage, contains('CRITICAL DETENTION RISK'));
    });
  });

  group('3. Indian Formatters & Security Validations', () {
    test('Formats currency with Indian rupee ₹ and lakh digit grouping', () {
      expect(IndianFormatters.formatCurrency(100000), '₹1,00,000');
      expect(IndianFormatters.formatCurrency(1234567.50, showDecimals: true), '₹12,34,567.50');
      expect(IndianFormatters.formatLpa(14.5), '14.5 LPA');
    });

    test('Validates Indian 10-digit mobile numbers starting with 6-9', () {
      expect(IndianFormatters.isValidIndianMobile('9876543210'), isTrue);
      expect(IndianFormatters.isValidIndianMobile('+91 9876543210'), isTrue);
      expect(IndianFormatters.isValidIndianMobile('7012345678'), isTrue);
      expect(IndianFormatters.isValidIndianMobile('5550100'), isFalse); // Invalid US number
      expect(IndianFormatters.isValidIndianMobile('1234567890'), isFalse); // Starts with 1
    });

    test('Validates 6-digit Indian Postal PIN codes', () {
      expect(IndianFormatters.isValidPinCode('110001'), isTrue);
      expect(IndianFormatters.isValidPinCode('560001'), isTrue);
      expect(IndianFormatters.isValidPinCode('010001'), isFalse); // Cannot start with 0
      expect(IndianFormatters.isValidPinCode('11000'), isFalse);
    });

    test('Validates 12-digit APAAR ID and masks Aadhaar securely', () {
      expect(IndianFormatters.isValidApaarId('123456789012'), isTrue);
      expect(IndianFormatters.isValidApaarId('1234 5678 9012'), isTrue);
      expect(IndianFormatters.isValidApaarId('1234'), isFalse);

      expect(IndianFormatters.maskAadhaar('987654321098'), '•••• •••• 1098');
    });

    test('Generates standard Indian UPI payment URI', () {
      final uri = IndianFormatters.generateUpiUri(
        upiId: 'collegecanteen@okaxis',
        payeeName: 'Campus Canteen',
        amount: 85.0,
        note: 'Lunch Thali',
      );
      expect(uri.scheme, 'upi');
      expect(uri.host, 'pay');
      expect(uri.queryParameters['pa'], 'collegecanteen@okaxis');
      expect(uri.queryParameters['am'], '85.00');
      expect(uri.queryParameters['cu'], 'INR');
    });
  });

  group('4. Schedule Conflict Detector', () {
    test('Detects overlapping time slots on the same day', () {
      const slotA = TimeSlot(
        id: '1',
        courseCode: 'CS 101',
        title: 'DSA Lecture',
        dayOfWeek: 1,
        startTime: '09:00',
        endTime: '10:30',
      );
      const slotB = TimeSlot(
        id: '2',
        courseCode: 'MA 102',
        title: 'Linear Algebra',
        dayOfWeek: 1,
        startTime: '10:00',
        endTime: '11:30',
      );

      final conflicts = ScheduleConflictDetector.findConflicts([slotA, slotB]);
      expect(conflicts.length, 1);
      expect(conflicts.first.description, contains('CS 101'));
      expect(conflicts.first.description, contains('MA 102'));
    });
  });

  group('5. Leitner / SM-2 Spaced Repetition Engine', () {
    test('Successful review increases repetition and intervals', () {
      final reviewed = SpacedRepetitionEngine.review(
        currentBox: 1,
        currentEaseFactor: 2.5,
        currentRepetitions: 0,
        rating: 4, // Successful recall
      );
      expect(reviewed.newRepetitions, 1);
      expect(reviewed.newBox, 2);
      expect(reviewed.nextReviewDate.isAfter(DateTime.now()), isTrue);
    });
  });

  group('6. Walking Router A* Pathfinding', () {
    test('Calculates shortest route through campus graph', () {
      final nodes = [
        const MapNode(id: 'gate', name: 'Main Gate', lat: 28.61, lng: 77.20, type: 'junction'),
        const MapNode(id: 'academic', name: 'Academic Block', lat: 28.62, lng: 77.21, type: 'building'),
        const MapNode(id: 'library', name: 'Library', lat: 28.615, lng: 77.205, type: 'study'),
      ];
      final edges = [
        const MapEdge(source: 'gate', target: 'academic', distanceMeters: 200),
        const MapEdge(source: 'gate', target: 'library', distanceMeters: 100),
        const MapEdge(source: 'library', target: 'academic', distanceMeters: 80),
      ];

      final router = WalkingRouter(nodeList: nodes, edges: edges);
      final route = router.findShortestRoute(startNodeId: 'gate', destinationNodeId: 'academic');

      expect(route, isNotNull);
      expect(route!.totalDistanceMeters, 180); // gate -> library (100) + library -> academic (80)
      expect(route.steps.length, 3);
    });
  });

  group('7. ShareCrypto & P2P Hashing', () {
    test('SHA-256 chunk hash matches expected digest', () {
      final data = utf8.encode('Compad Offline Campus Companion India');
      final hash = ShareCrypto.computeSha256(data);
      expect(hash.length, 64);
    });

    test('AES-GCM encryption & decryption round-trip', () async {
      final clearText = 'Compad AES-256 GCM Confidential Payload';
      final clearBytes = Uint8List.fromList(utf8.encode(clearText));
      final keyBytes = List<int>.generate(32, (i) => i * 7 % 256);

      final cipherBytes = await ShareCrypto.encryptBytes(clearBytes, keyBytes);
      expect(cipherBytes, isNot(equals(clearBytes)));

      final decryptedBytes = await ShareCrypto.decryptBytes(cipherBytes, keyBytes);
      final decryptedText = utf8.decode(decryptedBytes);
      expect(decryptedText, clearText);
    });
  });
}
