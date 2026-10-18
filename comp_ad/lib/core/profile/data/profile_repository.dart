import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../database/database_helper.dart';
import '../models/student_profile_model.dart';

class ProfileRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  static const String _prefName = 'sp_student_name';
  static const String _prefCollege = 'sp_student_college';
  static const String _prefRoll = 'sp_student_roll';
  static const String _prefYear = 'sp_student_year';
  static const String _prefDept = 'sp_student_dept';
  static const String _prefAnon = 'sp_student_anonymous';
  static const String _prefBio = 'compad_biometric_enabled';
  static const String _prefCompleted = 'sp_student_setup_completed';

  Future<StudentProfileModel> getProfile() async {
    // 1. Try reading from SQLite
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        'student_profile',
        where: 'id = ?',
        whereArgs: ['primary'],
        limit: 1,
      );

      if (results.isNotEmpty) {
        final profile = StudentProfileModel.fromMap(results.first);
        if (profile.isSetupCompleted || profile.name.isNotEmpty) {
          _saveToPrefs(profile);
          return profile;
        }
      }
    } catch (_) {}

    // 2. Check SharedPreferences fallback
    final prefProfile = await _loadFromPrefs();
    if (prefProfile != null) {
      try {
        final db = await _dbHelper.database;
        await db.insert(
          'student_profile',
          prefProfile.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (_) {}
      return prefProfile;
    }

    // 3. Brand new install default
    const defaultProfile = StudentProfileModel(
      id: 'primary',
      name: '',
      collegeName: '',
      rollNo: '',
      year: '1st Year',
      department: '',
      isAnonymous: false,
      isBiometricEnabled: false,
      isSetupCompleted: false,
    );
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'student_profile',
        defaultProfile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {}
    return defaultProfile;
  }

  Future<void> saveProfile(StudentProfileModel profile) async {
    // Always persist to SharedPreferences first for zero-loss durability
    await _saveToPrefs(profile);

    try {
      final db = await _dbHelper.database;
      await db.insert(
        'student_profile',
        profile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {}
  }

  Future<void> updateBiometricPreference(bool isEnabled) async {
    final profile = await getProfile();
    final updated = profile.copyWith(isBiometricEnabled: isEnabled);
    await saveProfile(updated);
  }

  Future<void> updateAnonymousPreference(bool isAnonymous) async {
    final profile = await getProfile();
    final updated = profile.copyWith(isAnonymous: isAnonymous);
    await saveProfile(updated);
  }

  Future<void> _saveToPrefs(StudentProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefName, profile.name);
      await prefs.setString(_prefCollege, profile.collegeName);
      await prefs.setString(_prefRoll, profile.rollNo);
      await prefs.setString(_prefYear, profile.year);
      await prefs.setString(_prefDept, profile.department);
      await prefs.setBool(_prefAnon, profile.isAnonymous);
      await prefs.setBool(_prefBio, profile.isBiometricEnabled);
      await prefs.setBool(_prefCompleted, profile.isSetupCompleted);
    } catch (_) {}
  }

  Future<StudentProfileModel?> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(_prefCompleted) ?? false;
      final name = prefs.getString(_prefName) ?? '';

      if (isCompleted || name.isNotEmpty) {
        return StudentProfileModel(
          id: 'primary',
          name: name,
          collegeName: prefs.getString(_prefCollege) ?? '',
          rollNo: prefs.getString(_prefRoll) ?? '',
          year: prefs.getString(_prefYear) ?? '1st Year',
          department: prefs.getString(_prefDept) ?? '',
          isAnonymous: prefs.getBool(_prefAnon) ?? false,
          isBiometricEnabled: prefs.getBool(_prefBio) ?? false,
          isSetupCompleted: isCompleted,
        );
      }
    } catch (_) {}
    return null;
  }
}
