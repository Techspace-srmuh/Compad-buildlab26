import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:compad/core/database/app_database.dart';
import 'package:compad/features/share/domain/campack_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Campack Service & Offline Packaging Tests', () {
    late AppDatabase sourceDb;
    late AppDatabase targetDb;
    late Directory tempDir;

    setUp(() async {
      sourceDb = AppDatabase(NativeDatabase.memory());
      targetDb = AppDatabase(NativeDatabase.memory());
      tempDir = await Directory.systemTemp.createTemp('campack_unit_');

      // Seed source notes and attendance
      await sourceDb.into(sourceDb.notesTable).insert(
            NotesTableCompanion.insert(
              id: 'note-1',
              title: 'Operating Systems Summary',
              content: 'Deadlock conditions: Mutual exclusion, Hold and wait, No preemption, Circular wait.',
              updatedAt: DateTime.now(),
            ),
          );

      await sourceDb.into(sourceDb.coursesTable).insert(
            CoursesTableCompanion.insert(
              id: 'course-1',
              code: 'CS201',
              name: 'Data Structures',
              credits: 4,
              department: 'CSE',
              instructor: 'Prof. Sharma',
              color: '#3F3DDB',
              room: 'LH-101',
              syllabus: 'Arrays, Trees, Graphs',
            ),
          );

      await sourceDb.into(sourceDb.attendanceTable).insert(
            AttendanceTableCompanion.insert(
              id: 'att-1',
              courseId: 'course-1',
              date: DateTime.now(),
              status: 'PRESENT',
            ),
          );
    });

    tearDown(() async {
      await sourceDb.close();
      await targetDb.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('Packs database records into compressed .campack file with valid checksum', () async {
      final file = await CampackService.packData(
        db: sourceDb,
        senderName: 'Aarav Kumar',
        includeNotes: true,
        includeAttendance: true,
        includeTimetable: true,
        includePyqs: true,
        outputDirectory: tempDir,
      );

      expect(file.existsSync(), isTrue);
      expect(file.path.endsWith('.campack'), isTrue);

      final bytes = await file.readAsBytes();
      final package = CampackService.unpackBytes(bytes);

      expect(package.manifest.senderName, 'Aarav Kumar');
      expect(package.manifest.notesCount, 1);
      expect(package.manifest.attendanceCount, 1);
      expect(package.manifest.checksumSha256.isNotEmpty, isTrue);
      expect(package.payload.containsKey('notes'), isTrue);
      expect(package.payload.containsKey('attendance'), isTrue);
    });

    test('Merges incoming package into target DB and skips duplicate IDs', () async {
      // 1. Pack from source
      final file = await CampackService.packData(
        db: sourceDb,
        senderName: 'Priya Verma',
        includeNotes: true,
        includeAttendance: true,
        outputDirectory: tempDir,
      );

      final bytes = await file.readAsBytes();
      final package = CampackService.unpackBytes(bytes);

      // 2. Pre-seed target DB with the same note
      await targetDb.into(targetDb.notesTable).insert(
            NotesTableCompanion.insert(
              id: 'note-1',
              title: 'Operating Systems Summary (Existing)',
              content: 'Existing local content that must not be overwritten.',
              updatedAt: DateTime.now(),
            ),
          );

      // 3. Merge package into target
      final mergeResult = await CampackService.mergePackage(
        package: package,
        db: targetDb,
      );

      // Check duplicate skip behavior
      expect(mergeResult.notesSkipped, 1);
      expect(mergeResult.notesAdded, 0);
      expect(mergeResult.attendanceAdded, 1);

      // Verify existing note was preserved
      final preservedNote = await (targetDb.select(targetDb.notesTable)..where((t) => t.id.equals('note-1'))).getSingle();
      expect(preservedNote.title, 'Operating Systems Summary (Existing)');
    });
  });
}
