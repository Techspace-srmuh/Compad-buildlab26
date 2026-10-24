import 'package:drift/drift.dart';
import '../database/app_database.dart';

class SeedDataLoader {
  final AppDatabase db;

  SeedDataLoader(this.db);

  /// Loads optional demo dataset labeled strictly as 'Example University'
  Future<void> loadSeedDataIfEmpty() async {
    final existingCourses = await db.select(db.coursesTable).get();
    if (existingCourses.isNotEmpty) {
      return; // Already has data
    }
    await loadDemoData();
  }

  Future<void> loadDemoData() async {
    // 1. Demo Indian Curriculum Courses
    final demoCourses = [
      CoursesTableCompanion.insert(
        id: 'course-cs101',
        code: 'CS 101',
        name: 'Data Structures & Algorithms',
        credits: 4,
        department: 'Computer Science & Engineering',
        instructor: 'Dr. R. Sharma',
        color: '0xFF3F3DDB',
        room: 'Lab Complex 3',
        syllabus: 'Linear & Non-linear data structures, Trees, Graphs, Sorting, Algorithm analysis.',
        examDate: Value(DateTime.now().add(const Duration(days: 35))),
        attendanceGoal: const Value(75.0),
      ),
      CoursesTableCompanion.insert(
        id: 'course-ma102',
        code: 'MA 102',
        name: 'Linear Algebra & Calculus',
        credits: 4,
        department: 'Mathematics',
        instructor: 'Prof. K. Iyer',
        color: '0xFF0D9488',
        room: 'Lecture Hall 102',
        syllabus: 'Matrices, Eigenvalues, Vector spaces, Multiple integrals, Differential equations.',
        examDate: Value(DateTime.now().add(const Duration(days: 42))),
        attendanceGoal: const Value(75.0),
      ),
      CoursesTableCompanion.insert(
        id: 'course-ee103',
        code: 'EE 103',
        name: 'Basic Electrical Engineering',
        credits: 3,
        department: 'Electrical Engineering',
        instructor: 'Dr. V. Patel',
        color: '0xFF8B5CF6',
        room: 'EE Department Room 204',
        syllabus: 'DC & AC Circuits, Transformers, Electrical Machines, Semiconductor Basics.',
        examDate: Value(DateTime.now().add(const Duration(days: 50))),
        attendanceGoal: const Value(75.0),
      ),
    ];

    for (final c in demoCourses) {
      await db.into(db.coursesTable).insertOnConflictUpdate(c);
    }

    // 2. Demo Timetable (Monday to Saturday)
    final demoTimetable = [
      TimetableTableCompanion.insert(
        id: 'tt-1',
        courseId: 'course-cs101',
        courseCode: 'CS 101',
        title: 'Data Structures Lecture',
        dayOfWeek: 1, // Monday
        startTime: '09:00',
        endTime: '10:00',
        room: 'LH 101',
        color: '0xFF3F3DDB',
        type: 'Theory',
      ),
      TimetableTableCompanion.insert(
        id: 'tt-2',
        courseId: 'course-ma102',
        courseCode: 'MA 102',
        title: 'Linear Algebra Lecture',
        dayOfWeek: 1, // Monday
        startTime: '10:15',
        endTime: '11:15',
        room: 'LH 102',
        color: '0xFF0D9488',
        type: 'Theory',
      ),
      TimetableTableCompanion.insert(
        id: 'tt-3',
        courseId: 'course-cs101',
        courseCode: 'CS 101',
        title: 'DSA Lab Practical (Batch A)',
        dayOfWeek: 2, // Tuesday
        startTime: '14:00',
        endTime: '17:00',
        room: 'Computing Lab 2',
        color: '0xFF3F3DDB',
        type: 'Practical',
      ),
      TimetableTableCompanion.insert(
        id: 'tt-4',
        courseId: 'course-ee103',
        courseCode: 'EE 103',
        title: 'Electrical Machines Lecture',
        dayOfWeek: 3, // Wednesday
        startTime: '11:30',
        endTime: '12:30',
        room: 'Room 204',
        color: '0xFF8B5CF6',
        type: 'Theory',
      ),
    ];

    for (final tt in demoTimetable) {
      await db.into(db.timetableTable).insertOnConflictUpdate(tt);
    }

    // 3. Demo Tasks
    final now = DateTime.now();
    final demoTasks = [
      TasksTableCompanion.insert(
        id: 'task-demo-1',
        courseId: const Value('course-cs101'),
        title: 'Implement AVL Tree Self-Balancing in C++',
        description: const Value('Complete left/right rotation cases and test balance factor.'),
        dueDate: now.add(const Duration(days: 3)),
        priority: const Value('HIGH'),
        status: const Value('IN_PROGRESS'),
      ),
      TasksTableCompanion.insert(
        id: 'task-demo-2',
        courseId: const Value('course-ma102'),
        title: 'Tutorial Sheet 3: Diagonalization & Eigenbases',
        description: const Value('Solve questions 1 through 15 for CIA preparation.'),
        dueDate: now.add(const Duration(days: 5)),
        priority: const Value('NORMAL'),
        status: const Value('TODO'),
      ),
    ];

    for (final t in demoTasks) {
      await db.into(db.tasksTable).insertOnConflictUpdate(t);
    }

    // 4. Demo Attendance Records
    for (int i = 0; i < 18; i++) {
      await db.into(db.attendanceTable).insertOnConflictUpdate(
            AttendanceTableCompanion.insert(
              id: 'att-cs-$i',
              courseId: 'course-cs101',
              date: now.subtract(Duration(days: i + 1)),
              status: i == 4 || i == 11 ? 'ABSENT' : 'PRESENT',
            ),
          );
    }

    // 5. Demo Expenses in ₹
    final demoExpenses = [
      BudgetTableCompanion.insert(
        id: 'exp-1',
        title: 'Canteen Lunch (Thali + Tea)',
        amount: 85.0,
        category: 'Mess & Canteen',
        date: now.subtract(const Duration(hours: 3)),
      ),
      BudgetTableCompanion.insert(
        id: 'exp-2',
        title: 'Photocopy & Lab Manual Binding',
        amount: 140.0,
        category: 'Books & Printouts',
        date: now.subtract(const Duration(days: 1)),
      ),
      BudgetTableCompanion.insert(
        id: 'exp-3',
        title: 'Monthly Bus Pass Renewal',
        amount: 650.0,
        category: 'Travel',
        date: now.subtract(const Duration(days: 4)),
      ),
    ];

    for (final exp in demoExpenses) {
      await db.into(db.budgetTable).insertOnConflictUpdate(exp);
    }
  }

  /// Complete data erasure (DPDP Act 2023 compliance & Demo clear)
  Future<void> clearAllData() async {
    await db.delete(db.coursesTable).go();
    await db.delete(db.timetableTable).go();
    await db.delete(db.tasksTable).go();
    await db.delete(db.attendanceTable).go();
    await db.delete(db.gradesTable).go();
    await db.delete(db.notesTable).go();
    await db.delete(db.flashcardsTable).go();
    await db.delete(db.habitsTable).go();
    await db.delete(db.budgetTable).go();
    await db.delete(db.moodTable).go();
    await db.delete(db.encryptedVaultTable).go();
    await db.delete(db.outboxSyncQueue).go();
  }
}
