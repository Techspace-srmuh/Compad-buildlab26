import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:compad/core/theme/app_theme.dart';
import 'package:compad/core/database/app_database.dart';
import 'package:compad/main.dart';
import 'package:compad/features/home/presentation/home_dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('HomeDashboardScreen renders curriculum hero, hubs, attendance, and quick actions', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'student_name': 'Kavya', 'selected_campus_name': 'IIT Bombay'});
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          theme: CompadTheme.light(),
          home: const Scaffold(
            body: HomeDashboardScreen(),
          ),
        ),
      ),
    );
    await tester.pump();

    // Verify Attendance & Campus Hubs & Action Buttons
    expect(find.text('Attendance'), findsOneWidget);
    expect(find.text('Campus Hubs'), findsOneWidget);
    expect(find.text('App Tutorial'), findsOneWidget);
    expect(find.text('Campus UPI'), findsOneWidget);
    expect(find.text('Compad Share'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
