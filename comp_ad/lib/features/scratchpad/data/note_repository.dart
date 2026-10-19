import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/note_model.dart';

class NoteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<NoteModel>> getNotes() async {
    final db = await _dbHelper.database;
    final results = await db.query('notes', orderBy: 'updated_at DESC');
    return results.map((m) => NoteModel.fromMap(m)).toList();
  }

  Future<NoteModel?> getNoteById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return NoteModel.fromMap(results.first);
  }

  Future<void> saveNote(NoteModel note) async {
    final db = await _dbHelper.database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await _dbHelper.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
