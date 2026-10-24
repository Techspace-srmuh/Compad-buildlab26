import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/database/app_database.dart';

class CampackManifest {
  final String senderName;
  final String version;
  final DateTime createdAt;
  final String checksumSha256;
  final int notesCount;
  final int attendanceCount;
  final int timetableCount;
  final int pyqsCount;
  final bool includesMap;
  final String? campusId;

  const CampackManifest({
    required this.senderName,
    required this.version,
    required this.createdAt,
    required this.checksumSha256,
    required this.notesCount,
    required this.attendanceCount,
    required this.timetableCount,
    required this.pyqsCount,
    required this.includesMap,
    this.campusId,
  });

  Map<String, dynamic> toJson() => {
        'senderName': senderName,
        'version': version,
        'createdAt': createdAt.toIso8601String(),
        'checksumSha256': checksumSha256,
        'notesCount': notesCount,
        'attendanceCount': attendanceCount,
        'timetableCount': timetableCount,
        'pyqsCount': pyqsCount,
        'includesMap': includesMap,
        'campusId': campusId,
      };

  factory CampackManifest.fromJson(Map<String, dynamic> json) => CampackManifest(
        senderName: json['senderName'] as String? ?? 'Peer Student',
        version: json['version'] as String? ?? '1.0',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        checksumSha256: json['checksumSha256'] as String? ?? '',
        notesCount: json['notesCount'] as int? ?? 0,
        attendanceCount: json['attendanceCount'] as int? ?? 0,
        timetableCount: json['timetableCount'] as int? ?? 0,
        pyqsCount: json['pyqsCount'] as int? ?? 0,
        includesMap: json['includesMap'] as bool? ?? false,
        campusId: json['campusId'] as String?,
      );
}

class CampackPackage {
  final CampackManifest manifest;
  final Map<String, dynamic> payload;
  final List<int> rawCompressedBytes;

  CampackPackage({
    required this.manifest,
    required this.payload,
    required this.rawCompressedBytes,
  });
}

class MergeResult {
  final int notesAdded;
  final int notesSkipped;
  final int attendanceAdded;
  final int attendanceSkipped;
  final int timetableAdded;
  final int timetableSkipped;

  const MergeResult({
    this.notesAdded = 0,
    this.notesSkipped = 0,
    this.attendanceAdded = 0,
    this.attendanceSkipped = 0,
    this.timetableAdded = 0,
    this.timetableSkipped = 0,
  });

  String get summary =>
      'Imported: $notesAdded notes, $attendanceAdded attendance, $timetableAdded classes ($notesSkipped notes already existed).';
}

class CampackService {
  /// Packs selected data categories into a compressed `.campack` file
  static Future<File> packData({
    required AppDatabase db,
    required String senderName,
    bool includeNotes = true,
    bool includeAttendance = true,
    bool includeTimetable = true,
    bool includePyqs = true,
    bool includeMap = false,
    String? campusId,
    Directory? outputDirectory,
  }) async {
    final payload = <String, dynamic>{
      'sender': senderName,
      'createdAt': DateTime.now().toIso8601String(),
    };

    int notesCount = 0;
    int attendanceCount = 0;
    int timetableCount = 0;
    int pyqsCount = 0;

    if (includeNotes) {
      final notes = await db.select(db.notesTable).get();
      notesCount = notes.length;
      payload['notes'] = notes
          .map((n) => {
                'id': n.id,
                'folder': n.folder,
                'title': n.title,
                'content': n.content,
                'tags': n.tags,
                'updatedAt': n.updatedAt.toIso8601String(),
                'isFavorite': n.isFavorite,
              })
          .toList();
    }

    if (includeAttendance) {
      final records = await db.select(db.attendanceTable).get();
      attendanceCount = records.length;
      payload['attendance'] = records
          .map((a) => {
                'id': a.id,
                'courseId': a.courseId,
                'date': a.date.toIso8601String(),
                'status': a.status,
              })
          .toList();
    }

    if (includeTimetable) {
      final classes = await db.select(db.timetableTable).get();
      final courses = await db.select(db.coursesTable).get();
      timetableCount = classes.length;
      payload['timetable'] = classes
          .map((t) => {
                'id': t.id,
                'courseId': t.courseId,
                'courseCode': t.courseCode,
                'title': t.title,
                'dayOfWeek': t.dayOfWeek,
                'startTime': t.startTime,
                'endTime': t.endTime,
                'room': t.room,
                'color': t.color,
                'type': t.type,
              })
          .toList();
      payload['courses'] = courses
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'code': c.code,
                'credits': c.credits,
                'department': c.department,
                'instructor': c.instructor,
                'color': c.color,
                'room': c.room,
                'syllabus': c.syllabus,
              })
          .toList();
    }

    if (includePyqs) {
      // Bundled mock PYQ papers/flashcards
      final flashcards = await db.select(db.flashcardsTable).get();
      pyqsCount = flashcards.length;
      payload['pyqs'] = flashcards
          .map((f) => {
                'id': f.id,
                'deckId': f.deckId,
                'question': f.question,
                'answer': f.answer,
              })
          .toList();
    }

    final rawJsonString = jsonEncode(payload);
    final rawBytes = utf8.encode(rawJsonString);
    final checksum = sha256.convert(rawBytes).toString();

    final manifest = CampackManifest(
      senderName: senderName,
      version: '1.0',
      createdAt: DateTime.now(),
      checksumSha256: checksum,
      notesCount: notesCount,
      attendanceCount: attendanceCount,
      timetableCount: timetableCount,
      pyqsCount: pyqsCount,
      includesMap: includeMap,
      campusId: campusId,
    );

    final finalContainer = {
      'manifest': manifest.toJson(),
      'payload': payload,
    };

    final containerJson = jsonEncode(finalContainer);
    final compressedBytes = gzip.encode(utf8.encode(containerJson));

    final dir = outputDirectory ?? await getTemporaryDirectory();
    final fileName = 'compad_share_${DateTime.now().millisecondsSinceEpoch}.campack';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(compressedBytes, flush: true);

    debugPrint('[CampackService] Created .campack package (${file.lengthSync()} bytes) with SHA-256 $checksum');
    return file;
  }

  /// Unpacks and validates a `.campack` compressed byte array
  static CampackPackage unpackBytes(List<int> compressedBytes) {
    List<int> decompressed;
    try {
      decompressed = gzip.decode(compressedBytes);
    } catch (e) {
      // Fallback: If not gzip compressed, attempt raw utf8
      decompressed = compressedBytes;
    }

    final decodedJson = utf8.decode(decompressed);
    final map = jsonDecode(decodedJson) as Map<String, dynamic>;

    final manifestMap = map['manifest'] as Map<String, dynamic>? ?? {};
    final manifest = CampackManifest.fromJson(manifestMap);
    final payload = map['payload'] as Map<String, dynamic>? ?? {};

    // Validate Checksum if provided
    final payloadString = jsonEncode(payload);
    final calculatedHash = sha256.convert(utf8.encode(payloadString)).toString();
    if (manifest.checksumSha256.isNotEmpty && manifest.checksumSha256 != calculatedHash) {
      debugPrint('[CampackService] Warning: Checksum mismatch or re-encoded payload.');
    }

    return CampackPackage(
      manifest: manifest,
      payload: payload,
      rawCompressedBytes: compressedBytes,
    );
  }

  /// Merges unpacked data safely without overwriting or duplicating existing records
  static Future<MergeResult> mergePackage({
    required CampackPackage package,
    required AppDatabase db,
  }) async {
    final payload = package.payload;
    int notesAdded = 0;
    int notesSkipped = 0;
    int attendanceAdded = 0;
    int attendanceSkipped = 0;
    int timetableAdded = 0;
    int timetableSkipped = 0;

    // 1. Merge Courses & Timetable
    if (payload.containsKey('courses')) {
      final coursesList = payload['courses'] as List<dynamic>? ?? [];
      for (final c in coursesList) {
        final existing = await (db.select(db.coursesTable)..where((t) => t.id.equals(c['id'] as String))).getSingleOrNull();
        if (existing == null) {
          await db.into(db.coursesTable).insert(
                CoursesTableCompanion.insert(
                  id: c['id'] as String,
                  name: c['name'] as String? ?? 'Imported Course',
                  code: c['code'] as String? ?? 'IMP101',
                  credits: c['credits'] as int? ?? 3,
                  department: c['department'] as String? ?? 'Academics',
                  instructor: c['instructor'] as String? ?? 'Faculty',
                  color: c['color'] as String? ?? '#3F3DDB',
                  room: c['room'] as String? ?? 'Hall A',
                  syllabus: c['syllabus'] as String? ?? '',
                ),
              );
        }
      }
    }

    if (payload.containsKey('timetable')) {
      final classes = payload['timetable'] as List<dynamic>? ?? [];
      for (final t in classes) {
        final existing = await (db.select(db.timetableTable)..where((entry) => entry.id.equals(t['id'] as String))).getSingleOrNull();
        if (existing == null) {
          await db.into(db.timetableTable).insert(
                TimetableTableCompanion.insert(
                  id: t['id'] as String,
                  courseId: t['courseId'] as String? ?? 'course_default',
                  courseCode: t['courseCode'] as String? ?? 'IMP101',
                  title: t['title'] as String? ?? 'Lecture',
                  dayOfWeek: t['dayOfWeek'] as int? ?? 1,
                  startTime: t['startTime'] as String? ?? '09:00',
                  endTime: t['endTime'] as String? ?? '10:00',
                  room: t['room'] as String? ?? 'Room 101',
                  color: t['color'] as String? ?? '#3F3DDB',
                  type: t['type'] as String? ?? 'Lecture',
                ),
              );
          timetableAdded++;
        } else {
          timetableSkipped++;
        }
      }
    }

    // 2. Merge Notes
    if (payload.containsKey('notes')) {
      final notes = payload['notes'] as List<dynamic>? ?? [];
      for (final n in notes) {
        final existing = await (db.select(db.notesTable)..where((entry) => entry.id.equals(n['id'] as String))).getSingleOrNull();
        if (existing == null) {
          await db.into(db.notesTable).insert(
                NotesTableCompanion.insert(
                  id: n['id'] as String,
                  folder: drift.Value(n['folder'] as String? ?? 'Shared with me'),
                  title: n['title'] as String? ?? 'Untitled Note',
                  content: n['content'] as String? ?? '',
                  tags: drift.Value(n['tags'] as String? ?? 'shared'),
                  updatedAt: DateTime.tryParse(n['updatedAt'] as String? ?? '') ?? DateTime.now(),
                  isFavorite: drift.Value(n['isFavorite'] as bool? ?? false),
                ),
              );
          notesAdded++;
        } else {
          notesSkipped++;
        }
      }
    }

    // 3. Merge Attendance
    if (payload.containsKey('attendance')) {
      final records = payload['attendance'] as List<dynamic>? ?? [];
      for (final a in records) {
        final existing = await (db.select(db.attendanceTable)..where((entry) => entry.id.equals(a['id'] as String))).getSingleOrNull();
        if (existing == null) {
          await db.into(db.attendanceTable).insert(
                AttendanceTableCompanion.insert(
                  id: a['id'] as String,
                  courseId: a['courseId'] as String,
                  date: DateTime.tryParse(a['date'] as String? ?? '') ?? DateTime.now(),
                  status: a['status'] as String? ?? 'PRESENT',
                ),
              );
          attendanceAdded++;
        } else {
          attendanceSkipped++;
        }
      }
    }

    // 4. Merge PYQs / Flashcards
    if (payload.containsKey('pyqs')) {
      final cards = payload['pyqs'] as List<dynamic>? ?? [];
      for (final f in cards) {
        final existing = await (db.select(db.flashcardsTable)..where((entry) => entry.id.equals(f['id'] as String))).getSingleOrNull();
        if (existing == null) {
          await db.into(db.flashcardsTable).insert(
                FlashcardsTableCompanion.insert(
                  id: f['id'] as String,
                  deckId: f['deckId'] as String? ?? 'PYQ',
                  question: f['question'] as String? ?? '',
                  answer: f['answer'] as String? ?? '',
                  nextReviewDate: DateTime.now().add(const Duration(days: 1)),
                ),
              );
        }
      }
    }

    return MergeResult(
      notesAdded: notesAdded,
      notesSkipped: notesSkipped,
      attendanceAdded: attendanceAdded,
      attendanceSkipped: attendanceSkipped,
      timetableAdded: timetableAdded,
      timetableSkipped: timetableSkipped,
    );
  }
}
