import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/utils/attendance_calculator.dart';
import '../models/attendance_log_model.dart';

class CourseAttendanceStat {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String colorHex;
  final int attended;
  final int held;
  final AttendanceResult result;

  CourseAttendanceStat({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.colorHex,
    required this.attended,
    required this.held,
    required this.result,
  });
}

class AttendanceRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<AttendanceLogModel>> getAllLogs() async {
    final db = await _dbHelper.database;
    final results = await db.query('attendance_logs', orderBy: 'timestamp DESC');
    return results.map((m) => AttendanceLogModel.fromMap(m)).toList();
  }

  Future<List<AttendanceLogModel>> getLogsForCourse(String courseId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'attendance_logs',
      where: 'course_id = ?',
      whereArgs: [courseId],
      orderBy: 'timestamp DESC',
    );
    return results.map((m) => AttendanceLogModel.fromMap(m)).toList();
  }

  Future<void> logAttendance({
    required String courseId,
    required String status,
    DateTime? timestamp,
  }) async {
    final db = await _dbHelper.database;
    final id = 'log_${DateTime.now().millisecondsSinceEpoch}';
    final log = AttendanceLogModel(
      id: id,
      courseId: courseId,
      timestamp: timestamp ?? DateTime.now(),
      status: status,
    );
    await db.insert(
      'attendance_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteLog(String id) async {
    final db = await _dbHelper.database;
    await db.delete('attendance_logs', where: 'id = ?', whereArgs: [id]);
  }

  /// Sets or updates the exact direct attendance baseline (attended / held) for a course
  Future<void> setDirectCourseAttendance({
    required String courseId,
    required int attended,
    required int held,
  }) async {
    final db = await _dbHelper.database;
    // Clear existing logs for this course to replace with exact student-entered counts
    await db.delete('attendance_logs', where: 'course_id = ?', whereArgs: [courseId]);

    final now = DateTime.now();
    for (int i = 0; i < attended; i++) {
      final dt = now.subtract(Duration(days: held - i));
      await db.insert(
        'attendance_logs',
        {
          'id': 'log_man_${courseId}_p_${DateTime.now().microsecondsSinceEpoch}_$i',
          'course_id': courseId,
          'timestamp': dt.toIso8601String(),
          'status': 'present',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    final absent = held - attended;
    for (int i = 0; i < absent; i++) {
      final dt = now.subtract(Duration(days: absent - i));
      await db.insert(
        'attendance_logs',
        {
          'id': 'log_man_${courseId}_a_${DateTime.now().microsecondsSinceEpoch}_$i',
          'course_id': courseId,
          'timestamp': dt.toIso8601String(),
          'status': 'absent',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getCourses() async {
    final db = await _dbHelper.database;
    return await db.query('courses', orderBy: 'name ASC');
  }

  /// Calculates per-course statistics
  Future<List<CourseAttendanceStat>> getPerCourseStats() async {
    final db = await _dbHelper.database;
    final courses = await db.query('courses', orderBy: 'name ASC');

    final List<CourseAttendanceStat> statsList = [];

    for (final c in courses) {
      final courseId = c['id'] as String;
      final logs = await getLogsForCourse(courseId);

      // Exclude canceled sessions from total held
      final validLogs = logs.where((l) => !l.isCanceled).toList();
      final held = validLogs.length;
      final attended = validLogs.where((l) => l.isPresent).length;

      final result = AttendanceCalculator.calculate(
        attended: attended,
        held: held,
      );

      statsList.add(
        CourseAttendanceStat(
          courseId: courseId,
          courseCode: (c['code'] as String?) ?? '',
          courseName: (c['name'] as String?) ?? '',
          colorHex: (c['color_hex'] as String?) ?? '6366F1',
          attended: attended,
          held: held,
          result: result,
        ),
      );
    }

    return statsList;
  }

  /// Calculates aggregate statistics across all courses
  Future<AttendanceResult> getAggregateStats() async {
    final db = await _dbHelper.database;
    final logs = await db.query(
      'attendance_logs',
      where: "status != 'canceled'",
    );

    int totalHeld = logs.length;
    int totalAttended = logs.where((l) => l['status'] == 'present').length;

    return AttendanceCalculator.calculate(
      attended: totalAttended,
      held: totalHeld,
    );
  }
}
