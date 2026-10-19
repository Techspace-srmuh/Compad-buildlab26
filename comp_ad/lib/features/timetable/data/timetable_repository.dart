import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/course_model.dart';
import '../models/timetable_slot_model.dart';

class TimetableRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<CourseModel>> getCourses() async {
    final db = await _dbHelper.database;
    final results = await db.query('courses', orderBy: 'name ASC');
    return results.map((m) => CourseModel.fromMap(m)).toList();
  }

  Future<CourseModel?> getCourseById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return CourseModel.fromMap(results.first);
  }

  Future<void> addCourse(CourseModel course) async {
    final db = await _dbHelper.database;
    await db.insert(
      'courses',
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCourse(String id) async {
    final db = await _dbHelper.database;
    await db.delete('timetable_slots', where: 'course_id = ?', whereArgs: [id]);
    await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TimetableSlotModel>> getSlotsForDay(int dayOfWeek) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT s.*, 
             c.code as c_code, c.name as c_name, c.instructor as c_instructor, 
             c.color_hex as c_color_hex, c.default_room as c_default_room
      FROM timetable_slots s
      INNER JOIN courses c ON s.course_id = c.id
      WHERE s.day_of_week = ?
      ORDER BY s.start_time ASC
    ''', [dayOfWeek]);

    return results.map((row) {
      final course = CourseModel(
        id: row['course_id'] as String,
        code: (row['c_code'] as String?) ?? '',
        name: (row['c_name'] as String?) ?? '',
        instructor: (row['c_instructor'] as String?) ?? '',
        colorHex: (row['c_color_hex'] as String?) ?? '6366F1',
        defaultRoom: (row['c_default_room'] as String?) ?? '',
      );
      return TimetableSlotModel.fromMap(row, course: course);
    }).toList();
  }

  Future<List<TimetableSlotModel>> getAllSlots() async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT s.*, 
             c.code as c_code, c.name as c_name, c.instructor as c_instructor, 
             c.color_hex as c_color_hex, c.default_room as c_default_room
      FROM timetable_slots s
      INNER JOIN courses c ON s.course_id = c.id
      ORDER BY s.day_of_week ASC, s.start_time ASC
    ''');

    return results.map((row) {
      final course = CourseModel(
        id: row['course_id'] as String,
        code: (row['c_code'] as String?) ?? '',
        name: (row['c_name'] as String?) ?? '',
        instructor: (row['c_instructor'] as String?) ?? '',
        colorHex: (row['c_color_hex'] as String?) ?? '6366F1',
        defaultRoom: (row['c_default_room'] as String?) ?? '',
      );
      return TimetableSlotModel.fromMap(row, course: course);
    }).toList();
  }

  Future<void> addSlot(TimetableSlotModel slot) async {
    final db = await _dbHelper.database;
    await db.insert(
      'timetable_slots',
      slot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSlot(String id) async {
    final db = await _dbHelper.database;
    await db.delete('timetable_slots', where: 'id = ?', whereArgs: [id]);
  }
}
