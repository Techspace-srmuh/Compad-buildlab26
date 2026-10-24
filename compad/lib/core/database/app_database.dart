import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Outbox Sync Queue for offline-first architecture
class OutboxSyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()(); // 'task', 'note', 'rsvp', 'booking', 'expense'
  TextColumn get action => text()(); // 'CREATE', 'UPDATE', 'DELETE'
  TextColumn get payloadJson => text()();
  TextColumn get status => text().withDefault(const Constant('PENDING'))(); // 'PENDING', 'SYNCING', 'FAILED', 'SYNCED'
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 1. Courses Table
class CoursesTable extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  IntColumn get credits => integer()();
  TextColumn get department => text()();
  TextColumn get instructor => text()();
  TextColumn get color => text()();
  TextColumn get room => text()();
  TextColumn get syllabus => text()();
  DateTimeColumn get examDate => dateTime().nullable()();
  RealColumn get attendanceGoal => real().withDefault(const Constant(85.0))();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Timetable Entries
class TimetableTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get courseCode => text()();
  TextColumn get title => text()();
  IntColumn get dayOfWeek => integer()(); // 1=Mon, 7=Sun
  TextColumn get startTime => text()(); // '09:00'
  TextColumn get endTime => text()(); // '10:30'
  TextColumn get room => text()();
  TextColumn get color => text()();
  TextColumn get type => text()(); // 'Lecture', 'Lab', 'Seminar'

  @override
  Set<Column> get primaryKey => {id};
}

// 3. Assignments & Tasks
class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get priority => text().withDefault(const Constant('NORMAL'))(); // 'LOW', 'NORMAL', 'HIGH', 'URGENT'
  TextColumn get status => text().withDefault(const Constant('TODO'))(); // 'TODO', 'IN_PROGRESS', 'DONE'
  IntColumn get estimatedMinutes => integer().withDefault(const Constant(60))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Attendance Records
class AttendanceTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text()(); // 'PRESENT', 'ABSENT', 'CANCELLED', 'LATE'

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Grades / GPA Tracker
class GradesTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get courseCode => text()();
  IntColumn get semester => integer().withDefault(const Constant(1))();
  IntColumn get credits => integer()();
  RealColumn get gradePoints => real()(); // 4.0 scale (A=4.0, B=3.0, etc.)
  TextColumn get letterGrade => text()(); // 'A', 'A-', 'B+', etc.

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Offline Notebook
class NotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get folder => text().withDefault(const Constant('General'))();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get tags => text().withDefault(const Constant(''))(); // comma-separated
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// 7. Flashcards & Spaced Repetition (Leitner/SM-2)
class FlashcardsTable extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  IntColumn get box => integer().withDefault(const Constant(1))(); // Leitner Box 1..5
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextReviewDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 8. Daily Habits Tracker
class HabitsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get icon => text()();
  TextColumn get color => text()();
  IntColumn get targetDaysPerWeek => integer().withDefault(const Constant(7))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastCompletedDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 9. Budget & Expenses
class BudgetTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get category => text()(); // 'Dining', 'Books', 'Tuition', 'Leisure'
  DateTimeColumn get date => dateTime()();
  BoolColumn get isMealPlanSwipe => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// 10. Wellbeing: Mood Entries
class MoodTable extends Table {
  TextColumn get id => text()();
  IntColumn get score => integer()(); // 1 (Terrible) to 5 (Great)
  TextColumn get emotion => text()(); // 'Energetic', 'Stressed', 'Calm', etc.
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 11. Encrypted Vault & Health (stored encrypted with AES-GCM)
class EncryptedVaultTable extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()(); // 'counseling', 'health', 'certificate'
  TextColumn get encryptedPayload => text()(); // AES cipher
  TextColumn get iv => text()(); // Initialization vector
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 12. Student Profile & Setup State
class StudentProfileTable extends Table {
  TextColumn get id => text()(); // 'profile_main'
  TextColumn get fullName => text().withDefault(const Constant(''))();
  TextColumn get photoPath => text().nullable()();
  TextColumn get degree => text().withDefault(const Constant('B.Tech'))();
  TextColumn get branch => text().withDefault(const Constant('Computer Science & Engineering'))();
  IntColumn get year => integer().withDefault(const Constant(1))();
  IntColumn get semester => integer().withDefault(const Constant(1))();
  TextColumn get college => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get state => text().withDefault(const Constant(''))();
  TextColumn get enrollmentNumber => text().withDefault(const Constant(''))();
  TextColumn get apaarId => text().nullable()();
  DateTimeColumn get semesterStartDate => dateTime().nullable()();
  DateTimeColumn get semesterEndDate => dateTime().nullable()();
  TextColumn get gradingScheme => text().withDefault(const Constant('10_point_ugc'))();
  RealColumn get targetCgpa => real().withDefault(const Constant(8.5))();
  RealColumn get attendanceRuleThreshold => real().withDefault(const Constant(75.0))();
  TextColumn get emergencyContactName => text().nullable()();
  TextColumn get emergencyContactPhone => text().nullable()();
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get setupStep => integer().withDefault(const Constant(0))();
  BoolColumn get isAppLockEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get pinCodeHash => text().nullable()();
  BoolColumn get useBiometrics => boolean().withDefault(const Constant(false))();
  TextColumn get upiId => text().withDefault(const Constant(''))();
  TextColumn get selectedCampusId => text().withDefault(const Constant(''))();
  TextColumn get selectedCampusName => text().withDefault(const Constant(''))();
  TextColumn get preferredLanguage => text().withDefault(const Constant('en'))();
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get tutorialCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get mapFilePath => text().nullable()();
  TextColumn get mapVersion => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 13. Past Papers & Exam Archive
class PastPapersTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseCode => text()();
  TextColumn get courseName => text()();
  IntColumn get year => integer()();
  TextColumn get examType => text()(); // 'End-Sem', 'Mid-Sem', 'Internal'
  TextColumn get fileUrl => text().nullable()();
  IntColumn get semester => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// 14. Study Planner & Revision
class StudyPlansTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get courseCode => text().nullable()();
  DateTimeColumn get targetDate => dateTime()();
  RealColumn get totalHours => real()();
  RealColumn get completedHours => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();

  @override
  Set<Column> get primaryKey => {id};
}

// 15. Group Projects Hub
class GroupProjectsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get courseCode => text().nullable()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get teamMembers => text().withDefault(const Constant(''))();
  DateTimeColumn get dueDate => dateTime()();
  RealColumn get progress => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

// 16. Office Hours Booking
class OfficeHoursTable extends Table {
  TextColumn get id => text()();
  TextColumn get facultyName => text()();
  TextColumn get department => text()();
  TextColumn get courseCode => text().nullable()();
  IntColumn get dayOfWeek => integer()();
  TextColumn get timeSlot => text()();
  TextColumn get location => text()();
  TextColumn get bookingStatus => text().withDefault(const Constant('AVAILABLE'))();

  @override
  Set<Column> get primaryKey => {id};
}

// 17. Personal Health Tracker
class HealthRecordsTable extends Table {
  TextColumn get id => text()();
  TextColumn get bloodGroup => text()();
  TextColumn get allergies => text().withDefault(const Constant(''))();
  TextColumn get medications => text().withDefault(const Constant(''))();
  TextColumn get emergencyInstructions => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 18. Sleep & Wellness Log
class SleepLogsTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get bedTime => text()();
  TextColumn get wakeTime => text()();
  IntColumn get durationMinutes => integer()();
  IntColumn get qualityRating => integer().withDefault(const Constant(4))();

  @override
  Set<Column> get primaryKey => {id};
}

// 19. Nutrition Tracker
class NutritionLogsTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get mealType => text()(); // 'Breakfast', 'Lunch', 'Snacks', 'Dinner'
  TextColumn get foodItems => text()();
  IntColumn get calories => integer().withDefault(const Constant(0))();
  BoolColumn get isVeg => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// 20. Compad Share Transfer History
class ShareHistoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get fileName => text()();
  IntColumn get fileSize => integer()();
  TextColumn get direction => text()(); // 'SENT', 'RECEIVED'
  TextColumn get peerName => text()();
  DateTimeColumn get transferDate => dateTime()();
  TextColumn get sha256Hash => text()();
  TextColumn get status => text()(); // 'SUCCESS', 'FAILED', 'CANCELLED'

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  OutboxSyncQueue,
  CoursesTable,
  TimetableTable,
  TasksTable,
  AttendanceTable,
  GradesTable,
  NotesTable,
  FlashcardsTable,
  HabitsTable,
  BudgetTable,
  MoodTable,
  EncryptedVaultTable,
  StudentProfileTable,
  PastPapersTable,
  StudyPlansTable,
  GroupProjectsTable,
  OfficeHoursTable,
  HealthRecordsTable,
  SleepLogsTable,
  NutritionLogsTable,
  ShareHistoryTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(studentProfileTable);
            await m.createTable(pastPapersTable);
            await m.createTable(studyPlansTable);
            await m.createTable(groupProjectsTable);
            await m.createTable(officeHoursTable);
            await m.createTable(healthRecordsTable);
            await m.createTable(sleepLogsTable);
            await m.createTable(nutritionLogsTable);
            await m.createTable(shareHistoryTable);
          }
          if (from < 3) {
            try {
              await m.addColumn(studentProfileTable, studentProfileTable.upiId);
              await m.addColumn(studentProfileTable, studentProfileTable.selectedCampusId);
              await m.addColumn(studentProfileTable, studentProfileTable.selectedCampusName);
              await m.addColumn(studentProfileTable, studentProfileTable.preferredLanguage);
              await m.addColumn(studentProfileTable, studentProfileTable.notificationsEnabled);
              await m.addColumn(studentProfileTable, studentProfileTable.tutorialCompleted);
              await m.addColumn(studentProfileTable, studentProfileTable.mapFilePath);
              await m.addColumn(studentProfileTable, studentProfileTable.mapVersion);
            } catch (_) {}
          }
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'compad.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
