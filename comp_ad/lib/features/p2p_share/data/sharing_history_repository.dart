import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/sharing_history_model.dart';

class SharingHistoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<SharingHistoryModel>> getHistory() async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'sharing_history',
      orderBy: 'timestamp DESC',
    );
    return results.map((m) => SharingHistoryModel.fromMap(m)).toList();
  }

  Future<void> addHistoryItem(SharingHistoryModel item) async {
    final db = await _dbHelper.database;
    await db.insert(
      'sharing_history',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteHistoryItem(String id) async {
    final db = await _dbHelper.database;
    await db.delete('sharing_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllHistory() async {
    final db = await _dbHelper.database;
    await db.delete('sharing_history');
  }
}
