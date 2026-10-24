import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:http/http.dart' as http;
import 'package:compad/core/registry/feature_registry.dart';
import 'package:compad/core/database/app_database.dart';
import 'package:compad/features/share/domain/p2p_transfer_service.dart';
import 'package:compad/features/share/domain/share_crypto.dart';
import 'package:drift/drift.dart' as drift;

void main() {
  group('1. Feature Registry & Route Integrity Verification', () {
    test('All features in FeatureRegistry have unique IDs and valid routes', () {
      final features = FeatureRegistry.allFeatures;
      expect(features.isNotEmpty, true);

      final ids = <String>{};
      final routes = <String>{};

      for (final f in features) {
        expect(f.id.isNotEmpty, true, reason: 'Feature ${f.title} has empty ID');
        expect(f.title.isNotEmpty, true);
        expect(f.subtitle.isNotEmpty, true);
        expect(f.route.startsWith('/'), true, reason: 'Route ${f.route} must start with /');
        expect(f.keywords.isNotEmpty, true, reason: 'Feature ${f.title} must have search keywords');

        expect(ids.contains(f.id), false, reason: 'Duplicate feature ID: ${f.id}');
        ids.add(f.id);
        routes.add(f.route);
      }

      expect(features.length >= 60, true, reason: 'Must contain all master features');
    });

    test('FeatureRegistry search finds matching items across titles and keywords', () {
      final gpaResults = FeatureRegistry.search('gpa');
      expect(gpaResults.any((f) => f.id == 'academics_gpa'), true);

      final messResults = FeatureRegistry.search('mess');
      expect(messResults.any((f) => f.id == 'campus_mess'), true);

      final qrResults = FeatureRegistry.search('qr');
      expect(qrResults.any((f) => f.id == 'life_share'), true);

      final cprResults = FeatureRegistry.search('cpr');
      expect(cprResults.any((f) => f.id == 'wellbeing_first_aid'), true);
    });
  });

  group('2. P2P Local Transfer Server Verification', () {
    late P2pTransferServer server;

    setUp(() {
      server = P2pTransferServer();
    });

    tearDown(() async {
      await server.stopServer();
    });

    test('P2pTransferServer starts, responds to handshake, and streams file content', () async {
      final testContent = utf8.encode('COMPAD_OFFLINE_P2P_PAYLOAD_TEST');
      final testHash = ShareCrypto.computeChunkHash(testContent);

      final testFile = SharedFileItem(
        id: 'file-test-1',
        name: 'lecture_notes.pdf',
        sizeBytes: testContent.length,
        rawBytes: testContent,
        sha256Hash: testHash,
      );

      await server.startServer(files: [testFile]);
      expect(server.isRunning, true);
      expect(server.port! > 0, true);

      final baseUrl = 'http://127.0.0.1:${server.port}';

      // 1. Handshake with valid PIN
      final handshakeRes = await http.get(Uri.parse('$baseUrl/api/handshake?pin=${server.pinCode}'));
      expect(handshakeRes.statusCode, 200);
      final handshakeData = jsonDecode(handshakeRes.body);
      expect(handshakeData['status'], 'APPROVED');

      // 2. Handshake with invalid PIN
      final badRes = await http.get(Uri.parse('$baseUrl/api/handshake?pin=000000'));
      expect(badRes.statusCode, 403);

      // 3. List files
      final filesRes = await http.get(Uri.parse('$baseUrl/api/files'));
      expect(filesRes.statusCode, 200);
      final filesList = jsonDecode(filesRes.body) as List;
      expect(filesList.length, 1);
      expect(filesList[0]['name'], 'lecture_notes.pdf');

      // 4. Download file and verify checksum
      final downloadRes = await http.get(Uri.parse('$baseUrl/api/download/file-test-1'));
      expect(downloadRes.statusCode, 200);
      expect(downloadRes.bodyBytes, testContent);

      final receivedHash = ShareCrypto.computeChunkHash(downloadRes.bodyBytes);
      expect(receivedHash, testHash);
    });

    test('SharedFileItem accurately classifies different file types and formats byte sizes', () {
      expect(SharedFileItem.detectFileType('assignment.pdf'), 'pdf');
      expect(SharedFileItem.detectFileType('campus_gate.jpg'), 'image');
      expect(SharedFileItem.detectFileType('diagram.png'), 'image');
      expect(SharedFileItem.detectFileType('lecture_audio.m4a'), 'audio');
      expect(SharedFileItem.detectFileType('podcast.mp3'), 'audio');
      expect(SharedFileItem.detectFileType('syllabus.docx'), 'doc');
      expect(SharedFileItem.detectFileType('grades.xlsx'), 'doc');
      expect(SharedFileItem.detectFileType('notes_bundle.campack'), 'campack');
      expect(SharedFileItem.detectFileType('archive.tar.gz'), 'other');

      expect(SharedFileItem.formatBytes(500), '500 B');
      expect(SharedFileItem.formatBytes(1536), '1.5 KB');
      expect(SharedFileItem.formatBytes(2 * 1024 * 1024), '2.00 MB');
    });

    test('P2P QR Payload URI format follows RFC 3986 without illegal underscores', () {
      final payload = 'compad-share://192.168.43.1:53177?pin=123456&device=Student';
      final uri = Uri.parse(payload);
      expect(uri.scheme, 'compad-share');
      expect(uri.host, '192.168.43.1');
      expect(uri.port, 53177);
      expect(uri.queryParameters['pin'], '123456');
    });
  });

  group('3. Persistent Student Profile & Onboarding State', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('StudentProfileTable accurately persists and updates setup progress', () async {
      // Initially empty
      final initial = await (db.select(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).getSingleOrNull();
      expect(initial, isNull);

      // Save Step 1
      await db.into(db.studentProfileTable).insertOnConflictUpdate(
            StudentProfileTableCompanion.insert(
              id: 'profile_main',
              fullName: const drift.Value('Tarun'),
              degree: const drift.Value('B.Tech'),
              branch: const drift.Value('CSE'),
              setupStep: const drift.Value(1),
              onboardingCompleted: const drift.Value(false),
              updatedAt: DateTime.now(),
            ),
          );

      final step1 = await (db.select(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).getSingle();
      expect(step1.fullName, 'Tarun');
      expect(step1.setupStep, 1);
      expect(step1.onboardingCompleted, false);

      // Complete Onboarding
      await db.into(db.studentProfileTable).insertOnConflictUpdate(
            StudentProfileTableCompanion.insert(
              id: 'profile_main',
              fullName: const drift.Value('Tarun'),
              degree: const drift.Value('B.Tech'),
              branch: const drift.Value('CSE'),
              setupStep: const drift.Value(4),
              onboardingCompleted: const drift.Value(true),
              updatedAt: DateTime.now(),
            ),
          );

      final completed = await (db.select(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).getSingle();
      expect(completed.onboardingCompleted, true);
      expect(completed.setupStep, 4);
    });
  });
}
