import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:compad/core/theme/app_theme.dart';
import 'package:compad/features/settings/presentation/settings_screen.dart';
import 'package:compad/features/campus/presentation/emergency_screen.dart';
import 'package:compad/core/database/app_database.dart';
import 'package:compad/main.dart';

double calculateLuminance(Color color) {
  double getComponent(int c) {
    final s = c / 255.0;
    return s <= 0.03928 ? s / 12.92 : pow((s + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = getComponent((color.r * 255.0).round().clamp(0, 255));
  final g = getComponent((color.g * 255.0).round().clamp(0, 255));
  final b = getComponent((color.b * 255.0).round().clamp(0, 255));
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double calculateContrastRatio(Color c1, Color c2) {
  final l1 = calculateLuminance(c1);
  final l2 = calculateLuminance(c2);
  final lighter = max(l1, l2);
  final darker = min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('1. WCAG 2.1 AA Contrast Ratio Verification', () {
    test('Light theme subtext meets minimum 4.5:1 ratio on card background', () {
      const colors = CompadThemeColors.light;
      final ratio = calculateContrastRatio(colors.subtext, colors.cardBackground);
      expect(ratio, greaterThanOrEqualTo(4.5), reason: 'Light subtext ratio must be >= 4.5:1');
    });

    test('Dark theme subtext meets minimum 4.5:1 ratio on dark card surface', () {
      const colors = CompadThemeColors.dark;
      final ratio = calculateContrastRatio(colors.subtext, colors.cardBackground);
      expect(ratio, greaterThanOrEqualTo(4.5), reason: 'Dark subtext ratio must be >= 4.5:1');
    });

    test('Dark text primary meets AAA standard (>7:1) on dark surface', () {
      const colors = CompadThemeColors.dark;
      final ratio = calculateContrastRatio(CompadColors.darkTextPrimary, colors.cardBackground);
      expect(ratio, greaterThan(7.0));
    });

    test('Amber banner warning text meets 4.5:1 contrast in both themes', () {
      final lightRatio = calculateContrastRatio(
        CompadThemeColors.light.bannerWarningText,
        CompadThemeColors.light.bannerWarningBg,
      );
      final darkRatio = calculateContrastRatio(
        CompadThemeColors.dark.bannerWarningText,
        CompadThemeColors.dark.bannerWarningBg,
      );
      expect(lightRatio, greaterThanOrEqualTo(4.5));
      expect(darkRatio, greaterThanOrEqualTo(4.5));
    });
  });

  group('2. Indic Script Matra Clearance & Line Height Test', () {
    test('Light theme text styles enforce line height >= 1.4', () {
      final theme = CompadTheme.light();
      expect(theme.textTheme.bodyLarge?.height, greaterThanOrEqualTo(1.4));
      expect(theme.textTheme.bodyMedium?.height, greaterThanOrEqualTo(1.4));
      expect(theme.textTheme.titleMedium?.height, greaterThanOrEqualTo(1.4));
      expect(theme.textTheme.headlineMedium?.height, greaterThanOrEqualTo(1.4));
    });

    test('Dark theme text styles enforce line height >= 1.4', () {
      final theme = CompadTheme.dark();
      expect(theme.textTheme.bodyLarge?.height, greaterThanOrEqualTo(1.4));
      expect(theme.textTheme.bodyMedium?.height, greaterThanOrEqualTo(1.4));
      expect(theme.textTheme.titleMedium?.height, greaterThanOrEqualTo(1.4));
    });
  });

  group('3. Screen Hardcoded Color Audit Verification', () {
    test('Ensures screens use ColorScheme or ThemeExtension tokens', () {
      final presentationDir = Directory('lib/features');
      final dartFiles = presentationDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.contains('presentation') && f.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        // Disallow raw Colors.grey without theme tokens
        expect(
          content.contains('color: Colors.grey'),
          isFalse,
          reason: 'File ${file.path} contains raw "color: Colors.grey". Use theme subtext token.',
        );
      }
    });
  });

  group('4. Key Screen Widget Rendering in Both Themes', () {
    testWidgets('EmergencyScreen renders cleanly in Light and Dark themes', (tester) async {
      // Light Mode
      await tester.pumpWidget(
        MaterialApp(
          theme: CompadTheme.light(),
          home: const EmergencyScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Emergency & Safety Hub'), findsOneWidget);
      expect(find.text('112'), findsOneWidget);
      expect(find.text('Tele-MANAS Mental Health Support'), findsOneWidget);

      // Dark Mode
      await tester.pumpWidget(
        MaterialApp(
          theme: CompadTheme.dark(),
          home: const EmergencyScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Emergency & Safety Hub'), findsOneWidget);
      expect(find.text('14416'), findsOneWidget);
    });

    testWidgets('SettingsScreen renders all sections cleanly in Light theme', (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            theme: CompadTheme.light(),
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings & Preferences'), findsOneWidget);
      expect(find.text('Appearance & Display'), findsOneWidget);
      expect(find.text('Region & Formats (India)'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Delete All My Data (Right to Erasure)'), 200);
      expect(find.text('Delete All My Data (Right to Erasure)'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
      await db.close();
    });
  });
}
