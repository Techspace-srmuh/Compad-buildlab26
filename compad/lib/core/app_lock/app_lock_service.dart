import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLockService {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;

  static const String _keyPin = 'compad_app_lock_pin';
  static const String _keyBiometricsEnabled = 'compad_biometrics_enabled';
  static const String _keyLockEnabled = 'compad_lock_enabled';

  bool _isUnlocked = false;

  AppLockService({
    LocalAuthentication? localAuth,
    FlutterSecureStorage? secureStorage,
  })  : _localAuth = localAuth ?? LocalAuthentication(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  bool get isUnlocked => _isUnlocked;

  void lock() {
    _isUnlocked = false;
  }

  Future<bool> setBiometricsEnabled(bool enabled) async {
    try {
      await _secureStorage.write(key: _keyBiometricsEnabled, value: enabled.toString());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isBiometricsEnabled() async {
    try {
      final val = await _secureStorage.read(key: _keyBiometricsEnabled);
      return val == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<bool> isLockEnabled() async {
    try {
      final val = await _secureStorage.read(key: _keyLockEnabled);
      return val == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<bool> setPin(String pin) async {
    try {
      await _secureStorage.write(key: _keyPin, value: pin);
      await _secureStorage.write(key: _keyLockEnabled, value: 'true');
      _isUnlocked = true;
      return true;
    } catch (e) {
      debugPrint('[AppLock] Set PIN failed: $e');
      return false;
    }
  }

  Future<bool> verifyPin(String enteredPin) async {
    try {
      final storedPin = await _secureStorage.read(key: _keyPin);
      if (storedPin == enteredPin) {
        _isUnlocked = true;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[AppLock] Verify PIN failed: $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      if (!canCheck && !isSupported) return false;

      final success = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to unlock Compad',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (success) {
        _isUnlocked = true;
      }
      return success;
    } catch (e) {
      debugPrint('[AppLock] Biometric auth error: $e');
      return false;
    }
  }

  /// Emergency screens (First Aid, Police, Medical) bypass app lock
  static bool isExemptRoute(String route) {
    final lower = route.toLowerCase();
    return lower.contains('emergency') || lower.contains('first_aid') || lower.contains('hotlines');
  }
}
