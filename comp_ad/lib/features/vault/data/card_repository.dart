import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/card_model.dart';

class CardRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<CardModel>> getCards() async {
    final db = await _dbHelper.database;
    final results = await db.query('custom_cards', orderBy: 'title ASC');
    return results.map((m) => CardModel.fromMap(m)).toList();
  }

  Future<CardModel?> getCardById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'custom_cards',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return CardModel.fromMap(results.first);
  }

  Future<void> saveCard(CardModel card) async {
    final db = await _dbHelper.database;
    await db.insert(
      'custom_cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCard(String id) async {
    final db = await _dbHelper.database;
    await db.delete('custom_cards', where: 'id = ?', whereArgs: [id]);
  }
}
