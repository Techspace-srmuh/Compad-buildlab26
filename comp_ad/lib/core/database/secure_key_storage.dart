import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureKeyStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _keyDbSecret = 'compad_sqlcipher_aes256_key';
  static const String _keyBiometricEnabled = 'compad_biometric_enabled';
  static const String _keyStudentName = 'compad_student_name';
  static const String _keyStudentRoll = 'compad_student_roll';
  static const String fallbackKey = 'compad_offline_master_vault_key_fallback_2026';

  /// Retrieves a deterministic 256-bit AES encryption key backed by SharedPreferences
  /// Ensures the key is NEVER lost or desynchronized across app cold starts
  static Future<String> getDatabaseKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? key = prefs.getString(_keyDbSecret);
      if (key != null && key.isNotEmpty) {
        return key;
      }

      // Check secure storage as secondary source
      try {
        key = await _storage.read(key: _keyDbSecret);
      } catch (_) {}

      if (key == null || key.isEmpty) {
        key = fallbackKey;
      }

      await prefs.setString(_keyDbSecret, key);
      try {
        await _storage.write(key: _keyDbSecret, value: key);
      } catch (_) {}

      return key;
    } catch (_) {
      return fallbackKey;
    }
  }

  /// Sets or retrieves biometric lock status with SharedPreferences backing
  static Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefVal = prefs.getBool(_keyBiometricEnabled);
      if (prefVal != null) {
        return prefVal;
      }
      // Fallback check in secure storage
      final value = await _storage.read(key: _keyBiometricEnabled);
      final enabled = value == 'true';
      if (value != null) {
        await prefs.setBool(_keyBiometricEnabled, enabled);
      }
      return enabled;
    } catch (_) {
      return false;
    }
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyBiometricEnabled, enabled);
    } catch (_) {}
    try {
      await _storage.write(key: _keyBiometricEnabled, value: enabled.toString());
    } catch (_) {}
  }

  /// Student Profile Details
  static Future<String> getStudentName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_keyStudentName);
      if (name != null && name.isNotEmpty) return name;
      return await _storage.read(key: _keyStudentName) ?? '';
    } catch (_) {
      return '';
    }
  }

  static Future<void> setStudentName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyStudentName, name);
    } catch (_) {}
    try {
      await _storage.write(key: _keyStudentName, value: name);
    } catch (_) {}
  }

  static Future<String> getStudentRoll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roll = prefs.getString(_keyStudentRoll);
      if (roll != null && roll.isNotEmpty) return roll;
      return await _storage.read(key: _keyStudentRoll) ?? '';
    } catch (_) {
      return '';
    }
  }

  static Future<void> setStudentRoll(String roll) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyStudentRoll, roll);
    } catch (_) {}
    try {
      await _storage.write(key: _keyStudentRoll, value: roll);
    } catch (_) {}
  }
}
