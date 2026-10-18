import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/calendar_activity_model.dart';

class CalendarActivityRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<CalendarActivityModel>> getActivitiesForMonth(int year, int month) async {
    final db = await _dbHelper.database;
    final monthStr = month.toString().padLeft(2, '0');
    final prefix = '$year-$monthStr%';

    final results = await db.query(
      'calendar_activities',
      where: 'date LIKE ?',
      whereArgs: [prefix],
      orderBy: 'date ASC, time ASC',
    );
    return results.map((m) => CalendarActivityModel.fromMap(m)).toList();
  }

  Future<List<CalendarActivityModel>> getActivitiesForDate(String dateStr) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'calendar_activities',
      where: 'date = ?',
      whereArgs: [dateStr],
      orderBy: 'time ASC',
    );
    return results.map((m) => CalendarActivityModel.fromMap(m)).toList();
  }

  Future<void> addActivity(CalendarActivityModel activity) async {
    final db = await _dbHelper.database;
    await db.insert(
      'calendar_activities',
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> toggleCompleted(String id, bool completed) async {
    final db = await _dbHelper.database;
    await db.update(
      'calendar_activities',
      {'is_completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteActivity(String id) async {
    final db = await _dbHelper.database;
    await db.delete('calendar_activities', where: 'id = ?', whereArgs: [id]);
  }
}
