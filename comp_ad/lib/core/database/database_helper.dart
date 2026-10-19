import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'secure_key_storage.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('compad_encrypted.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    final password = await SecureKeyStorage.getDatabaseKey();

    try {
      return await _openDb(path, password);
    } catch (_) {
      // Safe fallback to prevent data loss
      try {
        return await _openDb(path, SecureKeyStorage.fallbackKey);
      } catch (_) {
        return await _openDb(path, '');
      }
    }
  }

  Future<Database> _openDb(String path, String password) async {
    return await openDatabase(
      path,
      password: password.isNotEmpty ? password : null,
      version: 3,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _ensureNewTables(db);
      },
      onOpen: (db) async {
        await _ensureNewTables(db);
      },
    );
  }

  static Future<void> _ensureNewTables(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS student_profile (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        college_name TEXT NOT NULL,
        roll_no TEXT NOT NULL,
        year TEXT NOT NULL,
        department TEXT NOT NULL,
        is_anonymous INTEGER NOT NULL DEFAULT 0,
        is_biometric_enabled INTEGER NOT NULL DEFAULT 0,
        is_setup_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sharing_history (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        payload_type TEXT NOT NULL,
        direction TEXT NOT NULL,
        transport TEXT NOT NULL,
        peer_info TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        item_count INTEGER NOT NULL,
        raw_json TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS expenses (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        payment_mode TEXT NOT NULL,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS calendar_activities (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT,
        category TEXT NOT NULL,
        color_hex TEXT NOT NULL,
        notes TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _createDB(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE courses (
          id TEXT PRIMARY KEY,
          code TEXT NOT NULL,
          name TEXT NOT NULL,
          instructor TEXT,
          color_hex TEXT NOT NULL,
          default_room TEXT
        )
      ''');

      await txn.execute('''
        CREATE TABLE timetable_slots (
          id TEXT PRIMARY KEY,
          course_id TEXT NOT NULL,
          day_of_week INTEGER NOT NULL,
          start_time TEXT NOT NULL,
          end_time TEXT NOT NULL,
          room TEXT NOT NULL,
          FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE
        )
      ''');

      await txn.execute('''
        CREATE TABLE attendance_logs (
          id TEXT PRIMARY KEY,
          course_id TEXT NOT NULL,
          timestamp TEXT NOT NULL,
          status TEXT NOT NULL,
          FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE
        )
      ''');

      await txn.execute('''
        CREATE TABLE notes (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      await txn.execute('''
        CREATE TABLE custom_cards (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          student_name TEXT NOT NULL,
          roll_number TEXT NOT NULL,
          barcode_value TEXT NOT NULL,
          barcode_format TEXT NOT NULL
        )
      ''');

      await _ensureNewTables(txn);

      // Seed Initial Setup (Clean, unconfigured profile for student to customize)
      await _seedData(txn);
    });
  }

  Future<void> _seedData(Transaction txn) async {
    // 100% Student-Managed: No dummy courses, slots, logs, or notes seeded.
    // Initialize blank student identity chip
    await txn.insert('student_profile', {
      'id': 'primary',
      'name': '',
      'college_name': '',
      'roll_no': '',
      'year': '1st Year',
      'department': '',
      'is_anonymous': 0,
      'is_biometric_enabled': 0,
      'is_setup_completed': 0,
    });
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
