import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/metric_ring.dart';
import '../domain/attendance_calculator.dart';

class AttendanceManagerScreen extends ConsumerStatefulWidget {
  const AttendanceManagerScreen({super.key});

  @override
  ConsumerState<AttendanceManagerScreen> createState() => _AttendanceManagerScreenState();
}

class _AttendanceManagerScreenState extends ConsumerState<AttendanceManagerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- ACTIONS ---
  Future<void> _markAttendance(AppDatabase db, CoursesTableData course, String status) async {
    final uuid = const Uuid().v4();
    final now = DateTime.now();

    await db.into(db.attendanceTable).insert(
          AttendanceTableCompanion.insert(
            id: uuid,
            courseId: course.id,
            date: now,
            status: status,
          ),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marked $status for ${course.code}'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddCourseDialog(BuildContext context, AppDatabase db) {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final attendedCtrl = TextEditingController(text: '0');
    final totalCtrl = TextEditingController(text: '0');
    final creditsCtrl = TextEditingController(text: '3');
    final deptCtrl = TextEditingController(text: 'General');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Subject / Course',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Course Code (e.g. CS201 / MAT101)',
                  prefixIcon: Icon(Icons.tag_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Subject Title (e.g. Data Structures & Algorithms)',
                  prefixIcon: Icon(Icons.book_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: attendedCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Attended Classes',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: totalCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total Conducted',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: creditsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Credits',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: deptCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (codeCtrl.text.isEmpty || nameCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter code and course name')),
                    );
                    return;
                  }

                  final id = 'course_${DateTime.now().millisecondsSinceEpoch}';
                  final att = int.tryParse(attendedCtrl.text) ?? 0;
                  final tot = int.tryParse(totalCtrl.text) ?? 0;
                  final creds = int.tryParse(creditsCtrl.text) ?? 3;

                  await db.into(db.coursesTable).insert(
                        CoursesTableCompanion.insert(
                          id: id,
                          code: codeCtrl.text.trim().toUpperCase(),
                          name: nameCtrl.text.trim(),
                          credits: creds,
                          department: deptCtrl.text.trim(),
                          instructor: 'Faculty',
                          color: '#3F3DDB',
                          room: 'Room 101',
                          syllabus: 'CBCS Curriculum Syllabus',
                        ),
                      );

                  // Seed initial attendance records if entered
                  final now = DateTime.now();
                  for (int i = 0; i < att; i++) {
                    await db.into(db.attendanceTable).insert(
                          AttendanceTableCompanion.insert(
                            id: const Uuid().v4(),
                            courseId: id,
                            date: now.subtract(Duration(days: i + 1)),
                            status: 'PRESENT',
                          ),
                        );
                  }
                  final absentCount = (tot - att).clamp(0, 999);
                  for (int i = 0; i < absentCount; i++) {
                    await db.into(db.attendanceTable).insert(
                          AttendanceTableCompanion.insert(
                            id: const Uuid().v4(),
                            courseId: id,
                            date: now.subtract(Duration(days: att + i + 1)),
                            status: 'ABSENT',
                          ),
                        );
                  }

                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Add Course', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdjustCourseDialog(BuildContext context, AppDatabase db, CoursesTableData course, int currentAtt, int currentTot) {
    final attendedCtrl = TextEditingController(text: currentAtt.toString());
    final totalCtrl = TextEditingController(text: currentTot.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Adjust ${course.code} Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: attendedCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Attended Classes'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: totalCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Classes Conducted'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final att = int.tryParse(attendedCtrl.text) ?? currentAtt;
              final tot = int.tryParse(totalCtrl.text) ?? currentTot;

              // Re-seed attendance records for this course to match count
              await (db.delete(db.attendanceTable)..where((t) => t.courseId.equals(course.id))).go();

              final now = DateTime.now();
              for (int i = 0; i < att; i++) {
                await db.into(db.attendanceTable).insert(
                      AttendanceTableCompanion.insert(
                        id: const Uuid().v4(),
                        courseId: course.id,
                        date: now.subtract(Duration(days: i + 1)),
                        status: 'PRESENT',
                      ),
                    );
              }
              final absentCount = (tot - att).clamp(0, 999);
              for (int i = 0; i < absentCount; i++) {
                await db.into(db.attendanceTable).insert(
                      AttendanceTableCompanion.insert(
                        id: const Uuid().v4(),
                        courseId: course.id,
                        date: now.subtract(Duration(days: att + i + 1)),
                        status: 'ABSENT',
                      ),
                    );
              }

              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCourse(AppDatabase db, CoursesTableData course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${course.code}?'),
        content: Text('Are you sure you want to delete ${course.name} and its records?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await (db.delete(db.attendanceTable)..where((t) => t.courseId.equals(course.id))).go();
      await (db.delete(db.coursesTable)..where((t) => t.id.equals(course.id))).go();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);
    final colorScheme = Theme.of(context).colorScheme;

    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Manager', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: compadColors.academicsTint,
          unselectedLabelColor: compadColors.subtext,
          indicatorColor: compadColors.academicsTint,
          tabs: const [
            Tab(text: 'Subjects (75% Rule)'),
            Tab(text: 'Daily Log History'),
          ],
        ),
      ),
      body: StreamBuilder<List<CoursesTableData>>(
        stream: db.select(db.coursesTable).watch(),
        builder: (context, coursesSnapshot) {
          final courses = coursesSnapshot.data ?? [];

          return StreamBuilder<List<AttendanceTableData>>(
            stream: (db.select(db.attendanceTable)..orderBy([(t) => drift.OrderingTerm.desc(t.date)])).watch(),
            builder: (context, logsSnapshot) {
              final logs = logsSnapshot.data ?? [];

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildSubjectsTab(courses, logs, compadColors, colorScheme, db),
                  _buildHistoryTab(logs, courses, compadColors, colorScheme, db),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCourseDialog(context, db),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Subject'),
      ),
    );
  }

  Widget _buildSubjectsTab(
    List<CoursesTableData> courses,
    List<AttendanceTableData> logs,
    CompadThemeColors compadColors,
    ColorScheme colorScheme,
    AppDatabase db,
  ) {
    final totalAttended = logs.where((l) => l.status == 'PRESENT').length;
    final totalConducted = logs.where((l) => l.status != 'CANCELLED').length;

    final overallAnalysis = AttendanceCalculator.analyze(
      attended: totalAttended,
      total: totalConducted,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. OVERALL HERO CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  compadColors.academicsTint,
                  compadColors.academicsTint.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: compadColors.academicsTint.withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                MetricRing(
                  value: totalConducted > 0 ? (totalAttended / totalConducted) : 1.0,
                  size: 64,
                  strokeWidth: 7,
                  progressColor: overallAnalysis.currentPercentage >= 75.0 ? Colors.greenAccent : Colors.amberAccent,
                  backgroundColor: Colors.white24,
                  centerChild: Text(
                    totalConducted > 0 ? '${overallAnalysis.currentPercentage.toStringAsFixed(0)}%' : '—',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SEMESTER AGGREGATE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalAttended / $totalConducted Classes Attended',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        overallAnalysis.statusMessage,
                        style: TextStyle(
                          color: overallAnalysis.riskLevel == AttendanceRiskLevel.safe
                              ? Colors.greenAccent
                              : (overallAnalysis.riskLevel == AttendanceRiskLevel.condonationEligible
                                  ? Colors.amberAccent
                                  : Colors.orangeAccent),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. REGULATION NOTICE
          CompadCard(
            color: compadColors.chipBackground,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.gavel_rounded, size: 20, color: compadColors.academicsTint),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'UGC / AICTE 75% Mandatory Attendance: Minimum 65% eligible for medical condonation.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: compadColors.subtext,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. COURSES LIST HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Registered Courses (${courses.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Instant Log & Bunk Headroom',
                style: TextStyle(fontSize: 11, color: compadColors.subtext),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 4. EMPTY OR COURSE CARDS
          if (courses.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.school_outlined, size: 54, color: compadColors.subtext),
                    const SizedBox(height: 12),
                    const Text('No courses added yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(
                      'Tap "Add Subject" below to add your registered courses and start tracking daily attendance.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: compadColors.subtext),
                    ),
                  ],
                ),
              ),
            )
          else
            ...courses.map((c) {
              final cLogs = logs.where((l) => l.courseId == c.id).toList();
              final cAtt = cLogs.where((l) => l.status == 'PRESENT').length;
              final cTot = cLogs.where((l) => l.status != 'CANCELLED').length;

              return _buildCourseCard(c, cAtt, cTot, compadColors, colorScheme, db);
            }),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    CoursesTableData course,
    int attended,
    int total,
    CompadThemeColors compadColors,
    ColorScheme colorScheme,
    AppDatabase db,
  ) {
    final analysis = AttendanceCalculator.analyze(
      attended: attended,
      total: total,
    );

    Color statusColor;
    if (analysis.riskLevel == AttendanceRiskLevel.safe) {
      statusColor = compadColors.success;
    } else if (analysis.riskLevel == AttendanceRiskLevel.condonationEligible) {
      statusColor = compadColors.warning;
    } else {
      statusColor = compadColors.urgent;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: CompadCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Code, Name, Options
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: compadColors.academicsTint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    course.code,
                    style: TextStyle(
                      color: compadColors.academicsTint,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    course.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (val) {
                    if (val == 'adjust') _showAdjustCourseDialog(context, db, course, attended, total);
                    if (val == 'delete') _deleteCourse(db, course);
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'adjust', child: Text('Adjust Count')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete Subject', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress & Stats Row
            Row(
              children: [
                MetricRing(
                  value: total > 0 ? (attended / total) : 1.0,
                  size: 46,
                  strokeWidth: 5,
                  progressColor: statusColor,
                  centerChild: Text(
                    total > 0 ? '${analysis.currentPercentage.toStringAsFixed(0)}%' : '—',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: statusColor),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$attended attended / $total conducted',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        analysis.statusMessage,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // QUICK LOG ACTION BUTTONS (DATA ENTRY!)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: compadColors.success.withValues(alpha: 0.15),
                      foregroundColor: compadColors.success,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _markAttendance(db, course, 'PRESENT'),
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                    label: const Text('+ Present', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: compadColors.urgent.withValues(alpha: 0.15),
                      foregroundColor: compadColors.urgent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _markAttendance(db, course, 'ABSENT'),
                    icon: const Icon(Icons.highlight_off_rounded, size: 16),
                    label: const Text('+ Absent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Class Cancelled',
                  icon: const Icon(Icons.event_busy_rounded, size: 20),
                  onPressed: () => _markAttendance(db, course, 'CANCELLED'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(
    List<AttendanceTableData> logs,
    List<CoursesTableData> courses,
    CompadThemeColors compadColors,
    ColorScheme colorScheme,
    AppDatabase db,
  ) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off_rounded, size: 54, color: compadColors.subtext),
            const SizedBox(height: 12),
            const Text('No attendance logs yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              'Mark Present or Absent on the Subjects tab to record daily attendance sessions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: compadColors.subtext),
            ),
          ],
        ),
      );
    }

    final courseMap = {for (final c in courses) c.id: c};

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (ctx, idx) {
        final log = logs[idx];
        final course = courseMap[log.courseId];
        final courseTitle = course != null ? '${course.code} - ${course.name}' : 'Unknown Subject';

        Color statusColor;
        IconData statusIcon;
        if (log.status == 'PRESENT') {
          statusColor = compadColors.success;
          statusIcon = Icons.check_circle_rounded;
        } else if (log.status == 'ABSENT') {
          statusColor = compadColors.urgent;
          statusIcon = Icons.cancel_rounded;
        } else {
          statusColor = compadColors.warning;
          statusIcon = Icons.event_busy_rounded;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CompadCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${log.date.day}/${log.date.month}/${log.date.year} • Status: ${log.status}',
                        style: TextStyle(fontSize: 11, color: compadColors.subtext),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: compadColors.subtext),
                  tooltip: 'Delete Log',
                  onPressed: () async {
                    await (db.delete(db.attendanceTable)..where((t) => t.id.equals(log.id))).go();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
