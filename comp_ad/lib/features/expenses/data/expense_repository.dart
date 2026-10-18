import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ExpenseModel>> getExpenses() async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );
    return results.map((m) => ExpenseModel.fromMap(m)).toList();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final db = await _dbHelper.database;
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteExpense(String id) async {
    final db = await _dbHelper.database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getMonthTotal(int year, int month) async {
    final db = await _dbHelper.database;
    final monthStr = month.toString().padLeft(2, '0');
    final start = '$year-$monthStr-01';
    final end = '$year-$monthStr-31T23:59:59';

    final result = await db.rawQuery('''
      SELECT SUM(amount) as total FROM expenses
      WHERE date >= ? AND date <= ?
    ''', [start, end]);

    final total = result.first['total'];
    return (total as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTodayTotal() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final result = await db.rawQuery('''
      SELECT SUM(amount) as total FROM expenses
      WHERE date LIKE ?
    ''', ['$todayStr%']);

    final total = result.first['total'];
    return (total as num?)?.toDouble() ?? 0.0;
  }

  Future<Map<String, double>> getCategoryBreakdown(int year, int month) async {
    final db = await _dbHelper.database;
    final monthStr = month.toString().padLeft(2, '0');
    final start = '$year-$monthStr-01';
    final end = '$year-$monthStr-31T23:59:59';

    final results = await db.rawQuery('''
      SELECT category, SUM(amount) as cat_total FROM expenses
      WHERE date >= ? AND date <= ?
      GROUP BY category
    ''', [start, end]);

    final Map<String, double> map = {};
    for (final row in results) {
      final cat = row['category'] as String? ?? 'Others';
      final sum = (row['cat_total'] as num?)?.toDouble() ?? 0.0;
      map[cat] = sum;
    }
    return map;
  }
}
