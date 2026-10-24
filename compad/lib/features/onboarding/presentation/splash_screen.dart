import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/bootstrap/bootstrap_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/compad_logo.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    // Reactively route when status changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bootstrap.status == AppBootstrapStatus.needsOnboarding) {
        context.go('/setup');
      } else if (bootstrap.status == AppBootstrapStatus.locked) {
        context.go('/lock');
      } else if (bootstrap.status == AppBootstrapStatus.ready) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F131D) : const Color(0xFFFAF8FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CompadLogo(size: 72, showText: true),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: compadColors.campusTint.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: compadColors.campusTint.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: compadColors.campusTint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Campus Companion • Offline Ready',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: compadColors.campusTint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(compadColors.academicsTint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
