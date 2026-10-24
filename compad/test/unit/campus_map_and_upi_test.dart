import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:compad/core/database/app_database.dart';
import 'package:compad/core/upi/campus_upi_service.dart';
import 'package:compad/features/campus/domain/offline_map_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Offline Campus Map Service Tests', () {
    test('Official campus catalog has valid Indian university campuses', () {
      final catalog = OfflineCampusMapService.officialCampuses;
      expect(catalog.isNotEmpty, isTrue);
      expect(catalog.length, greaterThanOrEqualTo(5));

      final iitb = catalog.firstWhere((c) => c.id == 'iit_bombay');
      expect(iitb.name, contains('IIT Bombay'));
      expect(iitb.city, 'Mumbai');
      expect(iitb.state, 'Maharashtra');
      expect(iitb.centerLat, closeTo(19.1334, 0.01));
      expect(iitb.centerLng, closeTo(72.9133, 0.01));
      expect(iitb.defaultNodes.isNotEmpty, isTrue);
    });

    test('Campus map download stream yields progress and saves valid package', () async {
      final tempDir = await Directory.systemTemp.createTemp('compad_unit_map_');
      final service = OfflineCampusMapService(customBaseDirectory: () async => tempDir);
      final iitb = OfflineCampusMapService.officialCampuses.firstWhere((c) => c.id == 'iit_bombay');

      try {
        final progressEvents = <double>[];
        await for (final progress in service.downloadCampusMap(iitb)) {
          progressEvents.add(progress);
        }

        expect(progressEvents.isNotEmpty, isTrue);
        expect(progressEvents.last, 1.0);

        // Verify that map is now downloaded and verified
        final isDownloaded = await service.isMapDownloaded('iit_bombay');
        expect(isDownloaded, isTrue);

        final isIntact = await service.verifyMapIntegrity('iit_bombay');
        expect(isIntact, isTrue);

        // Load nodes from offline storage
        final nodes = await service.loadCampusNodes('iit_bombay');
        expect(nodes.isNotEmpty, isTrue);
        expect(nodes.any((n) => n.name.contains('Administrative Building')), isTrue);
        expect(nodes.any((n) => n.type == 'amenity' || n.type == 'study'), isTrue);
      } finally {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      }
    });

    test('Throws MapCorruptedException when loading non-existent map', () async {
      final tempDir = await Directory.systemTemp.createTemp('compad_unit_corrupt_');
      final service = OfflineCampusMapService(customBaseDirectory: () async => tempDir);
      try {
        await expectLater(
          () => service.loadCampusNodes('non_existent_campus'),
          throwsA(isA<MapCorruptedException>()),
        );
      } finally {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      }
    });
  });

  group('Campus UPI Payment Service Tests', () {
    test('Validates Indian UPI IDs correctly', () {
      expect(CampusUpiService.isValidUpiId('alex@oksbi'), isTrue);
      expect(CampusUpiService.isValidUpiId('canteen.bits@upi'), isTrue);
      expect(CampusUpiService.isValidUpiId('9876543210@paytm'), isTrue);
      expect(CampusUpiService.isValidUpiId('student_council@icici'), isTrue);

      // Invalid
      expect(CampusUpiService.isValidUpiId('invalid-vpa'), isFalse);
      expect(CampusUpiService.isValidUpiId('@paytm'), isFalse);
      expect(CampusUpiService.isValidUpiId('user@'), isFalse);
      expect(CampusUpiService.isValidUpiId('user name@sbi'), isFalse);
      expect(CampusUpiService.isValidUpiId(''), isFalse);
    });

    test('Constructs valid NPCI UPI payment URI with parameters', () {
      final uri = CampusUpiService.buildUpiUri(
        upiId: 'canteen@oksbi',
        payeeName: 'Hostel 12 Canteen',
        amount: 85.50,
        note: 'Lunch Thali',
      );

      expect(uri.scheme, 'upi');
      expect(uri.host, 'pay');
      expect(uri.queryParameters['pa'], 'canteen@oksbi');
      expect(uri.queryParameters['pn'], 'Hostel 12 Canteen');
      expect(uri.queryParameters['am'], '85.50');
      expect(uri.queryParameters['tn'], 'Lunch Thali');
      expect(uri.queryParameters['cu'], 'INR');
    });
  });

  group('Database Student Profile Extended Columns Test', () {
    test('StudentProfileTable stores UPI ID, campus details, and preferences permanently', () async {
      final db = AppDatabase(NativeDatabase.memory());

      try {
        await db.into(db.studentProfileTable).insert(
              StudentProfileTableCompanion.insert(
                id: 'profile_test',
                fullName: const drift.Value('Kavya Raman'),
                enrollmentNumber: const drift.Value('2024CS088'),
                branch: const drift.Value('Computer Science'),
                upiId: const drift.Value('kavya@okhdfcbank'),
                selectedCampusId: const drift.Value('bits_pilani'),
                selectedCampusName: const drift.Value('BITS Pilani - Pilani Campus'),
                preferredLanguage: const drift.Value('en'),
                notificationsEnabled: const drift.Value(true),
                tutorialCompleted: const drift.Value(true),
                updatedAt: DateTime.now(),
              ),
            );

        final profile = await (db.select(db.studentProfileTable)
              ..where((t) => t.id.equals('profile_test')))
            .getSingle();

        expect(profile.fullName, 'Kavya Raman');
        expect(profile.enrollmentNumber, '2024CS088');
        expect(profile.upiId, 'kavya@okhdfcbank');
        expect(profile.selectedCampusId, 'bits_pilani');
        expect(profile.selectedCampusName, 'BITS Pilani - Pilani Campus');
        expect(profile.preferredLanguage, 'en');
        expect(profile.notificationsEnabled, isTrue);
        expect(profile.tutorialCompleted, isTrue);
      } finally {
        await db.close();
      }
    });
  });
}
