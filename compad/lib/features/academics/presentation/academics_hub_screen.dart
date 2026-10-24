import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';
import '../domain/gpa_calculator.dart';

class AcademicsHubScreen extends ConsumerStatefulWidget {
  const AcademicsHubScreen({super.key});

  @override
  ConsumerState<AcademicsHubScreen> createState() => _AcademicsHubScreenState();
}

class _AcademicsHubScreenState extends ConsumerState<AcademicsHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDayIndex = 1; // 1 = Monday .. 6 = Saturday

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: compadColors.academicsTint,
          unselectedLabelColor: compadColors.subtext,
          indicatorColor: compadColors.academicsTint,
          tabs: const [
            Tab(text: 'Overview & Tools'),
            Tab(text: 'Timetable (Mon–Sat)'),
            Tab(text: 'Tasks & CIA'),
            Tab(text: '10-Pt SGPA & Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(compadColors, db),
          _buildTimetableTab(compadColors, db),
          _buildTasksTab(compadColors, db),
          _buildSgpaTab(compadColors, db),
        ],
      ),
    );
  }

  // --- TAB 1: OVERVIEW & TOOLS ---
  Widget _buildOverviewTab(CompadThemeColors colors, AppDatabase db) {
    return StreamBuilder<List<CoursesTableData>>(
      stream: db.select(db.coursesTable).watch(),
      builder: (context, snapshot) {
        final courses = snapshot.data ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            // Semester Banner
            CompadCard(
              color: colors.heroCardBackground,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                        child: const Text('ACADEMIC YEAR 2026-27', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      Text('${courses.length} Registered Courses', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Indian CBCS / NEP-2020 Curriculum', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Track core subjects, laboratory practicals, and 75% attendance criteria.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () => _showAddCourseDialog(db),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Course / Subject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: colors.heroCardBackground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Registered Courses List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Registered Subjects', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (courses.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _showAddCourseDialog(db),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add'),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (courses.isEmpty)
              CompadCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 48, color: colors.subtext),
                      const SizedBox(height: 10),
                      const Text('No courses added yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text('Add your semester subjects to generate your timetable and track attendance.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: colors.subtext)),
                    ],
                  ),
                ),
              )
            else
              ...courses.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CompadCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.academicsTint,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text('${c.code} • ${c.credits} Credits • ${c.instructor}', style: TextStyle(fontSize: 12, color: colors.subtext)),
                                Text('Room: ${c.room}', style: TextStyle(fontSize: 11, color: colors.subtext)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            const SizedBox(height: 20),
            const Text('Academic Tools & Planning', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _buildAcademicToolCard('Attendance Manager', '75% rule & bunk tracker', Icons.co_present_rounded, colors.academicsTint, () => context.push('/academics/attendance'), colors),
                _buildAcademicToolCard('Syllabus & Notes', 'Units & course outcomes', Icons.menu_book_rounded, colors.academicsTint, () => context.push('/academics/syllabus'), colors),
                _buildAcademicToolCard('Exam Countdown', 'End-sem & mid-sem dates', Icons.timer_outlined, colors.urgent, () => context.push('/academics/exams'), colors),
                _buildAcademicToolCard('Pomodoro Timer', '25/5 min focus cycles', Icons.hourglass_top_rounded, colors.campusTint, () => context.push('/academics/focus-timer'), colors),
                _buildAcademicToolCard('Study Planner', 'Revision topics & goals', Icons.alt_route_rounded, colors.wellbeingTint, () => context.push('/academics/study-planner'), colors),
                _buildAcademicToolCard('Past Papers (PYQ)', 'University question bank', Icons.folder_copy_rounded, colors.warning, () => context.push('/academics/past-papers'), colors),
                _buildAcademicToolCard('Group Projects', 'Milestones & deliverables', Icons.groups_rounded, colors.academicsTint, () => context.push('/academics/group-projects'), colors),
                _buildAcademicToolCard('Office Hours', 'Book faculty consultation', Icons.meeting_room_rounded, colors.campusTint, () => context.push('/academics/office-hours'), colors),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAcademicToolCard(String title, String sub, IconData icon, Color tint, VoidCallback onTap, CompadThemeColors colors) {
    return CompadCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TintedIconCircle(icon: icon, tintColor: tint, size: 38, iconSize: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 2),
              Text(sub, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: colors.subtext)),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 2: TIMETABLE ---
  Widget _buildTimetableTab(CompadThemeColors colors, AppDatabase db) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        // Day selector strip (Mon to Sat)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (idx) {
              final dayNum = idx + 1;
              final isSelected = _selectedDayIndex == dayNum;
              return GestureDetector(
                onTap: () => setState(() => _selectedDayIndex = dayNum),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.academicsTint : colors.chipBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    days[idx],
                    style: TextStyle(
                      color: isSelected ? Colors.white : colors.subtext,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // Day's lectures stream
        Expanded(
          child: StreamBuilder<List<TimetableTableData>>(
            stream: (db.select(db.timetableTable)..where((tbl) => tbl.dayOfWeek.equals(_selectedDayIndex))).watch(),
            builder: (context, snapshot) {
              final entries = snapshot.data ?? [];

              if (entries.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_rounded, size: 54, color: colors.subtext),
                        const SizedBox(height: 12),
                        const Text('No classes scheduled for this day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text('Tap + below or add courses in Overview to schedule lectures & labs.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: colors.subtext)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _showAddTimetableDialog(db),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Lecture / Lab Slot'),
                          style: ElevatedButton.styleFrom(backgroundColor: colors.academicsTint, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: entries.length,
                itemBuilder: (ctx, i) {
                  final e = entries[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CompadCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.startTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(e.endTime, style: TextStyle(fontSize: 12, color: colors.subtext)),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Container(width: 2, height: 40, color: colors.cardBorder),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text('${e.courseCode} • ${e.type}', style: TextStyle(fontSize: 12, color: colors.subtext)),
                                Text('Room: ${e.room}', style: TextStyle(fontSize: 11, color: colors.subtext)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // --- TAB 3: TASKS & CIA ---
  Widget _buildTasksTab(CompadThemeColors colors, AppDatabase db) {
    return StreamBuilder<List<TasksTableData>>(
      stream: db.select(db.tasksTable).watch(),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];

        if (tasks.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 54, color: colors.subtext),
                  const SizedBox(height: 12),
                  const Text('No Tasks or Assignments Yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('Log upcoming CIA tests, assignments, practical files, and viva deadlines.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: colors.subtext)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddTaskDialog(db),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                    style: ElevatedButton.styleFrom(backgroundColor: colors.academicsTint, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          itemCount: tasks.length + 1,
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${tasks.length} Pending & Completed Items', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: () => _showAddTaskDialog(db),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Task'),
                      style: ElevatedButton.styleFrom(backgroundColor: colors.academicsTint, foregroundColor: Colors.white),
                    ),
                  ],
                ),
              );
            }

            final t = tasks[i - 1];
            final isDone = t.status == 'DONE';

            return Dismissible(
              key: Key(t.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: colors.urgent,
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              onDismissed: (_) async {
                await (db.delete(db.tasksTable)..where((tbl) => tbl.id.equals(t.id))).go();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CompadCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          color: isDone ? colors.success : colors.subtext,
                        ),
                        onPressed: () async {
                          final newStatus = isDone ? 'TODO' : 'DONE';
                          await (db.update(db.tasksTable)..where((tbl) => tbl.id.equals(t.id)))
                              .write(TasksTableCompanion(status: Value(newStatus)));
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            if (t.description.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(t.description, style: TextStyle(fontSize: 12, color: colors.subtext)),
                            ],
                            const SizedBox(height: 4),
                            Text('Due: ${t.dueDate.day}/${t.dueDate.month}/${t.dueDate.year}', style: TextStyle(fontSize: 11, color: colors.subtext)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- TAB 4: 10-POINT SGPA & WHAT-IF ---
  Widget _buildSgpaTab(CompadThemeColors colors, AppDatabase db) {
    double targetNextSgpa = 8.5;
    double currentCgpa = 8.12;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        final projected = IndianGradingScheme.projectWhatIf(
          currentCgpa: currentCgpa,
          currentCredits: 40,
          upcomingCredits: 20,
          targetUpcomingSgpa: targetNextSgpa,
        );

        final percentage = IndianGradingScheme.convertCgpaToPercentage(cgpa: currentCgpa);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            // Indian 10-Point Card
            CompadCard(
              color: colors.heroCardBackground,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Cumulative Grade Point Average (CGPA)', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text('$currentCgpa / 10.0', style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Equivalent Percentage: $percentage% (AICTE Formula: CGPA × 9.5)', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  const Text('Standing: First Class with Distinction (CBCS)', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('UGC 10-Point Grading Standard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CompadCard(
              padding: const EdgeInsets.all(12),
              child: Table(
                columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(2), 2: FlexColumnWidth(3)},
                children: const [
                  TableRow(children: [
                    Text('Letter Grade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Grade Point', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                  TableRow(children: [Text('O'), Text('10'), Text('Outstanding')]),
                  TableRow(children: [Text('A+'), Text('9'), Text('Excellent')]),
                  TableRow(children: [Text('A'), Text('8'), Text('Very Good')]),
                  TableRow(children: [Text('B+'), Text('7'), Text('Good')]),
                  TableRow(children: [Text('B'), Text('6'), Text('Above Average')]),
                  TableRow(children: [Text('C'), Text('5'), Text('Average')]),
                  TableRow(children: [Text('P'), Text('4'), Text('Pass')]),
                  TableRow(children: [Text('F / Ab'), Text('0'), Text('Fail / Absent')]),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Prospective Semester What-If Projection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Simulate upcoming semester performance on graduation CGPA.', style: TextStyle(fontSize: 12, color: colors.subtext)),
            const SizedBox(height: 10),
            CompadCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Target Upcoming SGPA:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${targetNextSgpa.toStringAsFixed(2)} / 10.0', style: TextStyle(fontWeight: FontWeight.bold, color: colors.academicsTint, fontSize: 15)),
                    ],
                  ),
                  Slider(
                    value: targetNextSgpa,
                    min: 4.0,
                    max: 10.0,
                    divisions: 24,
                    activeColor: colors.academicsTint,
                    onChanged: (val) => setInnerState(() => targetNextSgpa = val),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Projected Cumulative CGPA:'),
                      Text('$projected / 10.0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.success)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddCourseDialog(AppDatabase db) {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final creditsCtrl = TextEditingController(text: '4');
    final facultyCtrl = TextEditingController();
    final roomCtrl = TextEditingController(text: 'LH 101');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Course / Subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Course Code (e.g. CS 201)')),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Subject Name (e.g. Operating Systems)')),
              TextField(controller: creditsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Credits (e.g. 3 or 4)')),
              TextField(controller: facultyCtrl, decoration: const InputDecoration(labelText: 'Faculty / Professor Name')),
              TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Room / Hall')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                final id = 'course-${DateTime.now().millisecondsSinceEpoch}';
                await db.into(db.coursesTable).insert(
                      CoursesTableCompanion.insert(
                        id: id,
                        code: codeCtrl.text.isEmpty ? 'SUB' : codeCtrl.text.trim(),
                        name: nameCtrl.text.trim(),
                        credits: int.tryParse(creditsCtrl.text) ?? 4,
                        department: 'Engineering / Science',
                        instructor: facultyCtrl.text.trim(),
                        color: '0xFF3F3DDB',
                        room: roomCtrl.text.trim(),
                        syllabus: 'Standard CBCS university syllabus.',
                      ),
                    );
              }
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Add Subject'),
          ),
        ],
      ),
    );
  }

  void _showAddTimetableDialog(AppDatabase db) {
    final titleCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final startCtrl = TextEditingController(text: '09:00');
    final endCtrl = TextEditingController(text: '10:00');
    final roomCtrl = TextEditingController(text: 'LH 101');
    String slotType = 'Theory';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Lecture / Lab Slot'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Lecture Title')),
                TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Course Code')),
                Row(
                  children: [
                    Expanded(child: TextField(controller: startCtrl, decoration: const InputDecoration(labelText: 'Start Time'))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: endCtrl, decoration: const InputDecoration(labelText: 'End Time'))),
                  ],
                ),
                TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Room / Lab')),
                DropdownButtonFormField<String>(
                  initialValue: slotType,
                  items: ['Theory', 'Practical', 'Tutorial', 'Seminar']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => slotType = val!),
                  decoration: const InputDecoration(labelText: 'Slot Type'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleCtrl.text.isNotEmpty) {
                  await db.into(db.timetableTable).insert(
                        TimetableTableCompanion.insert(
                          id: 'tt-${DateTime.now().millisecondsSinceEpoch}',
                          courseId: 'custom',
                          courseCode: codeCtrl.text.trim().isEmpty ? 'SUB' : codeCtrl.text.trim(),
                          title: titleCtrl.text.trim(),
                          dayOfWeek: _selectedDayIndex,
                          startTime: startCtrl.text.trim(),
                          endTime: endCtrl.text.trim(),
                          room: roomCtrl.text.trim(),
                          color: '0xFF3F3DDB',
                          type: slotType,
                        ),
                      );
                }
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(AppDatabase db) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String priority = 'NORMAL';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Assignment / CIA Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Task Title')),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Notes / Description')),
                DropdownButtonFormField<String>(
                  initialValue: priority,
                  items: ['NORMAL', 'HIGH', 'URGENT']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => priority = val!),
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleCtrl.text.isNotEmpty) {
                  await db.into(db.tasksTable).insert(
                        TasksTableCompanion.insert(
                          id: 'task-${DateTime.now().millisecondsSinceEpoch}',
                          title: titleCtrl.text.trim(),
                          description: Value(descCtrl.text.trim()),
                          dueDate: DateTime.now().add(const Duration(days: 3)),
                          priority: Value(priority),
                          status: const Value('TODO'),
                        ),
                      );
                }
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
