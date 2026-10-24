import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_lock/app_lock_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/compad_logo.dart';
import '../../campus/data/indian_emergency_directory.dart';

final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService();
});

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String _enteredPin = '';
  String _errorMessage = '';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final lockService = ref.read(appLockServiceProvider);
    final bioEnabled = await lockService.isBiometricsEnabled();
    if (bioEnabled) {
      _triggerBiometrics();
    }
  }

  Future<void> _triggerBiometrics() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);
    final lockService = ref.read(appLockServiceProvider);
    final success = await lockService.authenticateWithBiometrics();
    setState(() => _isAuthenticating = false);

    if (success && mounted) {
      context.go('/home');
    }
  }

  void _onDigitPressed(String digit) {
    if (_enteredPin.length >= 6) return;
    setState(() {
      _enteredPin += digit;
      _errorMessage = '';
    });

    if (_enteredPin.length == 4 || _enteredPin.length == 6) {
      _verifyPin();
    }
  }

  void _onDeletePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = '';
      });
    }
  }

  Future<void> _verifyPin() async {
    final lockService = ref.read(appLockServiceProvider);
    final valid = await lockService.verifyPin(_enteredPin);
    if (valid) {
      if (mounted) context.go('/home');
    } else {
      if (_enteredPin.length >= 4) {
        setState(() {
          _errorMessage = 'Incorrect PIN. Please try again.';
          _enteredPin = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F131D) : const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Emergency SOS shortcut (Exempt from App Lock)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CompadLogo(size: 28, showText: true),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CompadColors.urgentRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: const Icon(Icons.sos_rounded, size: 18),
                    label: const Text('SOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: () {
                      IndianEmergencyDirectory.callNumber(IndianEmergencyDirectory.nationalEmergency112);
                    },
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),

            // Lock Icon & Header
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: compadColors.academicsTint.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_rounded, size: 32, color: compadColors.academicsTint),
            ),
            const SizedBox(height: 16),
            const Text(
              'Compad Security Shield',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            const SizedBox(height: 6),
            Text(
              'Enter your 4-digit or 6-digit campus PIN',
              style: TextStyle(fontSize: 13, color: compadColors.subtext),
            ),
            const SizedBox(height: 24),

            // PIN Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? compadColors.academicsTint : compadColors.chipBackground,
                    border: Border.all(
                      color: isFilled ? compadColors.academicsTint : compadColors.subtext.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),

            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage,
                style: const TextStyle(color: CompadColors.urgentRed, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],

            const Spacer(flex: 2),

            // Numeric Keypad (3x4 Grid)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3'], compadColors),
                  const SizedBox(height: 16),
                  _buildKeypadRow(['4', '5', '6'], compadColors),
                  const SizedBox(height: 16),
                  _buildKeypadRow(['7', '8', '9'], compadColors),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Biometric Button
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: IconButton(
                          icon: Icon(Icons.fingerprint_rounded, size: 36, color: compadColors.academicsTint),
                          onPressed: _triggerBiometrics,
                          tooltip: 'Unlock with fingerprint',
                        ),
                      ),
                      _buildKeypadButton('0', compadColors),
                      // Backspace Button
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: IconButton(
                          icon: Icon(Icons.backspace_outlined, size: 26, color: compadColors.subtext),
                          onPressed: _onDeletePressed,
                          tooltip: 'Delete last digit',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),

            // Emergency Contacts Link (Exempt from App Lock)
            TextButton(
              onPressed: () => context.push('/campus/emergency'),
              child: const Text('Campus Emergency Directory & First Aid', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> digits, CompadThemeColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: digits.map((d) => _buildKeypadButton(d, colors)).toList(),
    );
  }

  Widget _buildKeypadButton(String digit, CompadThemeColors colors) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _onDigitPressed(digit),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
