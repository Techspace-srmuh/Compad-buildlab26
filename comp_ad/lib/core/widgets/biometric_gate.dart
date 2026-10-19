import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/secure_key_storage.dart';
import '../profile/controllers/profile_controller.dart';
import '../theme/spatial_colors.dart';
import 'spatial_glass.dart';

class BiometricGate extends ConsumerStatefulWidget {
  final Widget child;
  final bool initiallyLocked;

  const BiometricGate({
    super.key,
    required this.child,
    this.initiallyLocked = false,
  });

  @override
  ConsumerState<BiometricGate> createState() => BiometricGateState();
}

class BiometricGateState extends ConsumerState<BiometricGate> with WidgetsBindingObserver {
  final LocalAuthentication _localAuth = LocalAuthentication();
  late bool _isLocked;
  bool _isAuthenticating = false;
  String _authMessage = 'Authenticate with fingerprint or PIN to unlock CompAd';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isLocked = widget.initiallyLocked;
    // Cold start lock check
    _checkLockState();
  }

  Future<void> _checkLockState() async {
    final isEnabled = await SecureKeyStorage.isBiometricEnabled();
    if (isEnabled) {
      if (mounted) {
        setState(() {
          _isLocked = true;
        });
        // Delay slightly for Android native activity and window focus to attach cleanly
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted && _isLocked) {
            _triggerBiometricCheck();
          }
        });
      }
    } else {
      if (_isLocked && mounted) {
        setState(() {
          _isLocked = false;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final isEnabled = await SecureKeyStorage.isBiometricEnabled() ||
        ref.read(profileControllerProvider).profile.isBiometricEnabled;

    if (!isEnabled) {
      if (_isLocked && mounted) setState(() => _isLocked = false);
      return;
    }

    if (state == AppLifecycleState.paused) {
      // Lock as soon as user minimizes or switches away
      if (mounted) {
        setState(() {
          _isLocked = true;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      // Wait for window focus to return cleanly
      await Future.delayed(const Duration(milliseconds: 250));
      if (mounted && _isLocked) {
        _triggerBiometricCheck();
      }
    }
  }

  Future<void> _triggerBiometricCheck() async {
    final isEnabled = await SecureKeyStorage.isBiometricEnabled() ||
        ref.read(profileControllerProvider).profile.isBiometricEnabled;

    if (!isEnabled) {
      if (mounted) setState(() => _isLocked = false);
      return;
    }

    if (_isAuthenticating) return;

    if (mounted) {
      setState(() {
        _isAuthenticating = true;
        _isLocked = true;
      });
    }

    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();

      if (!canCheck && !isSupported) {
        // If device has neither biometric hardware nor credentials configured
        if (mounted) {
          setState(() {
            _isLocked = false;
          });
        }
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'CompAd Secure Access: Touch fingerprint sensor or enter PIN',
        options: const AuthenticationOptions(
          biometricOnly: false, // Fallback to PIN/Pattern if fingerprint isn't matched
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (mounted) {
        setState(() {
          _isLocked = !didAuthenticate;
          if (!didAuthenticate) {
            _authMessage = 'Authentication required to access offline vault.';
          }
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _isLocked = true;
          _authMessage = 'Sensor error: ${e.message ?? "Tap Unlock Device."}';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLocked = true;
          _authMessage = 'Tap Unlock Device to verify identity.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void unlockManually() {
    setState(() {
      _isLocked = false;
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isLocked)
          Positioned.fill(
            child: Material(
              color: SpatialColors.canvas,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpatialGlass(
                        radius: 28,
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          children: [
                            Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: SpatialColors.accentCyan.withValues(alpha: 0.4),
                                    blurRadius: 28,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.asset(
                                      'assets/icons/app_logo.png',
                                      width: 92,
                                      height: 92,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: SpatialColors.surfaceContainerLowest,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: SpatialColors.accentCyan.withValues(alpha: 0.6),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: const Icon(
                                        LucideIcons.fingerprint,
                                        size: 14,
                                        color: SpatialColors.accentCyan,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'CompAd Locked',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _authMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: SpatialColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SpatialColors.accentCyan,
                                foregroundColor: SpatialColors.canvas,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _triggerBiometricCheck,
                              icon: const Icon(LucideIcons.fingerprint, size: 18),
                              label: const Text(
                                'Unlock Device',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
