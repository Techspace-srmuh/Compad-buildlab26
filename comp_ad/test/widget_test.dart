import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:compad/main.dart';
import 'package:compad/core/utils/attendance_calculator.dart';

void main() {
  test('AttendanceCalculator computes correct metrics and safe bunks', () {
    // 40 attended out of 48 held
    // 40 / 48 = 83.33%
    // Safe bunks with 75% target: floor((40 - (0.75 * 48)) / 0.75) = floor((40 - 36) / 0.75) = floor(5.33) = 5
    final stats = AttendanceCalculator.calculate(attended: 40, held: 48);
    expect(stats.percentage, closeTo(83.33, 0.05));
    expect(stats.isSafe, true);
    expect(stats.safeBunks, 5);
    expect(stats.classesToRecover, 0);

    // Deficit case: 20 attended out of 30 held = 66.67%
    // Recovery needed: ceil(((0.75 * 30) - 20) / 0.25) = ceil((22.5 - 20) / 0.25) = ceil(2.5 / 0.25) = 10
    final deficit = AttendanceCalculator.calculate(attended: 20, held: 30);
    expect(deficit.percentage, closeTo(66.67, 0.05));
    expect(deficit.isSafe, false);
    expect(deficit.safeBunks, 0);
    expect(deficit.classesToRecover, 10);
  });

  testWidgets('CompAdApp initializes without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CompAdApp()));
    expect(find.byType(CompAdApp), findsOneWidget);
  });
}
