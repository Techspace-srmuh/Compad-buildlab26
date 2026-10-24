import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:compad/shared/widgets/compad_logo.dart';
import 'package:compad/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Brand Assets and Icon Verification', () {
    test('CI Check: icon_full.png must exist and have no alpha channel', () {
      final file = File('assets/branding/icon_full.png');
      expect(file.existsSync(), isTrue, reason: 'icon_full.png must exist in assets/branding');

      final bytes = file.readAsBytesSync();
      expect(bytes.length, greaterThan(100), reason: 'Icon file cannot be empty');

      // PNG format check: bytes 0..7 must match standard PNG header
      expect(bytes[0], 0x89);
      expect(bytes[1], 0x50); // P
      expect(bytes[2], 0x4E); // N
      expect(bytes[3], 0x47); // G

      // In PNG IHDR chunk (starts at byte 12), color type is at byte offset 25
      // Color type 2 = Truecolor (RGB, no alpha channel)
      // Color type 6 = Truecolor with alpha (RGBA - prohibited for App Store)
      final colorType = bytes[25];
      expect(
        colorType,
        equals(2),
        reason: 'icon_full.png must have PNG color type 2 (RGB, strictly NO alpha channel), but got type $colorType',
      );
    });

    testWidgets('CompadLogo renders cleanly with branding style', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CompadTheme.light(),
          home: const Scaffold(
            body: Center(
              child: CompadLogo(
                size: 64,
                showText: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CompadLogo), findsOneWidget);
      expect(find.text('Compad'), findsOneWidget);
    });

    testWidgets('CompadLogo renders in standalone icon mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CompadTheme.dark(),
          home: const Scaffold(
            body: Center(
              child: CompadLogo(
                size: 48,
                showText: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CompadLogo), findsOneWidget);
      expect(find.text('Compad'), findsNothing);
    });
  });
}
