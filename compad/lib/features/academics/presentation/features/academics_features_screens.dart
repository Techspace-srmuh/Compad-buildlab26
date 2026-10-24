import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../../../shared/components/compad_card.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/components/tinted_icon_circle.dart';

// 1. Syllabus & Lecture Notes Reader
class SyllabusNotesScreen extends ConsumerWidget {
  const SyllabusNotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Syllabus & Lecture Notes', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<CoursesTableData>>(
        stream: db.select(db.coursesTable).watch(),
        builder: (context, snapshot) {
          final courses = snapshot.data ?? [];
          if (courses.isEmpty) {
            return Center(
              child: CompadEmptyState(
                icon: Icons.menu_book_rounded,
                title: 'No Course Syllabi Found',
                subtitle: 'Add your subjects to view unit-by-unit outcomes and download lecture notes.',
                ctaLabel: 'Add First Subject',
                onCtaPressed: () => _showAddCourseDialog(context, db),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final c = courses[i];
              return CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: colors.academicsTint.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                          child: Text(c.code, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: colors.academicsTint)),
                        ),
                        Text('${c.credits} Credits • CBCS Core', style: TextStyle(fontSize: 12, color: colors.subtext)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Instructor: ${c.instructor} | Room: ${c.room}', style: TextStyle(fontSize: 13, color: colors.subtext)),
                    const SizedBox(height: 12),
                    Text('Syllabus & Units:\n${c.syllabus}', style: const TextStyle(fontSize: 13, height: 1.4)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.academicsTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Subject'),
        onPressed: () => _showAddCourseDialog(context, db),
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context, AppDatabase db) {
    final codeCtrl = TextEditingController(text: 'CS301');
    final nameCtrl = TextEditingController();
    final syllabusCtrl = TextEditingController(text: 'Unit 1: Fundamentals\nUnit 2: Advanced Topics\nUnit 3: Applications');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Course Syllabus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Course Code')),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Course Name')),
            TextField(controller: syllabusCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Units & Syllabus')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                await db.into(db.coursesTable).insert(
                      CoursesTableCompanion.insert(
                        id: 'course-${DateTime.now().millisecondsSinceEpoch}',
                        code: codeCtrl.text.trim(),
                        name: nameCtrl.text.trim(),
                        credits: 4,
                        department: 'Engineering',
                        instructor: 'Faculty In-Charge',
                        color: '0xFF3F3DDB',
                        room: 'LH 101',
                        syllabus: syllabusCtrl.text.trim(),
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
}

// 2. Exam Countdown Screen
class ExamCountdownScreen extends ConsumerWidget {
  const ExamCountdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final exams = [
      {'title': 'Operating Systems (CS301)', 'date': '12 Nov 2026', 'days': 22, 'time': '09:30 AM – 12:30 PM'},
      {'title': 'Database Management Systems (CS302)', 'date': '15 Nov 2026', 'days': 25, 'time': '09:30 AM – 12:30 PM'},
      {'title': 'Computer Networks (CS303)', 'date': '18 Nov 2026', 'days': 28, 'time': '09:30 AM – 12:30 PM'},
      {'title': 'Theory of Computation (CS304)', 'date': '21 Nov 2026', 'days': 31, 'time': '09:30 AM – 12:30 PM'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Exam Countdown', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.academicsTint.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.timer_outlined, tintColor: colors.academicsTint),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('End-Semester Examinations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text('First paper in 22 days. Hall tickets available at exam cell 7 days prior.', style: TextStyle(fontSize: 12, color: colors.subtext)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...exams.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CompadCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(14)),
                        child: Column(
                          children: [
                            Text('${e['days']}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.urgent)),
                            const Text('DAYS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Date: ${e['date']} • ${e['time']}', style: TextStyle(fontSize: 12, color: colors.subtext)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// 3. Pomodoro Focus Timer Screen (Matches compad_focus_timer & dark mode)
class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  static const int _workDuration = 25 * 60;
  static const int _breakDuration = 5 * 60;
  int _secondsLeft = _workDuration;
  bool _isRunning = false;
  bool _isBreak = false;
  Timer? _timer;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft > 0) {
          setState(() => _secondsLeft--);
        } else {
          timer.cancel();
          setState(() {
            _isBreak = !_isBreak;
            _secondsLeft = _isBreak ? _breakDuration : _workDuration;
            _isRunning = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_isBreak ? 'Work session complete! Take a 5-min break.' : 'Break over! Ready to focus?')),
          );
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsLeft = _isBreak ? _breakDuration : _workDuration;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    final progress = 1.0 - (_secondsLeft / (_isBreak ? _breakDuration : _workDuration));

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Focus Timer', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _isBreak ? colors.campusTint.withOpacity(0.15) : colors.academicsTint.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isBreak ? 'REST INTERVAL' : 'FOCUS INTERVAL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _isBreak ? colors.campusTint : colors.academicsTint),
              ),
            ),
            const SizedBox(height: 36),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: colors.chipBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(_isBreak ? colors.campusTint : colors.academicsTint),
                  ),
                ),
                Text('$minutes:$seconds', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1)),
              ],
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.academicsTint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _toggleTimer,
                  icon: Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  label: Text(_isRunning ? 'Pause' : 'Start Focus', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Past Question Papers Screen (Matches compad_past_papers_library)
class PastPapersScreen extends ConsumerWidget {
  const PastPapersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Past Papers Library (PYQ)', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<PastPapersTableData>>(
        stream: db.select(db.pastPapersTable).watch(),
        builder: (context, snapshot) {
          final papers = snapshot.data ?? [];
          if (papers.isEmpty) {
            return Center(
              child: CompadEmptyState(
                icon: Icons.folder_copy_rounded,
                title: 'No Question Papers Added',
                subtitle: 'Archive university previous year question papers (PYQs) for offline revision.',
                ctaLabel: 'Add First Paper',
                onCtaPressed: () => _showAddPaperDialog(context, db),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: papers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final p = papers[i];
              return CompadCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    TintedIconCircle(icon: Icons.picture_as_pdf_rounded, tintColor: colors.urgent),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${p.courseCode} • ${p.examType} ${p.year}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('${p.courseName} • Sem ${p.semester}', style: TextStyle(fontSize: 12, color: colors.subtext)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      tooltip: 'Share via Compad Share',
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Compad Share...'))),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.academicsTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Add PYQ Paper'),
        onPressed: () => _showAddPaperDialog(context, db),
      ),
    );
  }

  void _showAddPaperDialog(BuildContext context, AppDatabase db) {
    final codeCtrl = TextEditingController(text: 'CS301');
    final nameCtrl = TextEditingController(text: 'Operating Systems');
    final yearCtrl = TextEditingController(text: '2025');
    String examType = 'End-Sem';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Question Paper (PYQ)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Subject Code')),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Subject Name')),
            TextField(controller: yearCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Year')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await db.into(db.pastPapersTable).insert(
                    PastPapersTableCompanion.insert(
                      id: 'pyq-${DateTime.now().millisecondsSinceEpoch}',
                      courseCode: codeCtrl.text.trim(),
                      courseName: nameCtrl.text.trim(),
                      year: int.tryParse(yearCtrl.text) ?? 2025,
                      examType: examType,
                      semester: 5,
                    ),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Paper'),
          ),
        ],
      ),
    );
  }
}

// 5. Study Planner Screen (Matches compad_study_planner)
class StudyPlannerScreen extends ConsumerWidget {
  const StudyPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Exam Study Planner', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<StudyPlansTableData>>(
        stream: db.select(db.studyPlansTable).watch(),
        builder: (context, snapshot) {
          final plans = snapshot.data ?? [];
          if (plans.isEmpty) {
            return Center(
              child: CompadEmptyState(
                icon: Icons.alt_route_rounded,
                title: 'No Study Plans Created',
                subtitle: 'Break down your revision topics with planned hours and completion milestones.',
                ctaLabel: 'Create Study Goal',
                onCtaPressed: () => _showAddGoalDialog(context, db),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final p = plans[i];
              final progress = (p.completedHours / p.totalHours).clamp(0.0, 1.0);
              return CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('${(progress * 100).toInt()}% Done', style: TextStyle(fontWeight: FontWeight.bold, color: colors.academicsTint, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(value: progress, backgroundColor: colors.chipBackground, color: colors.academicsTint),
                    const SizedBox(height: 8),
                    Text('${p.completedHours.toStringAsFixed(1)} / ${p.totalHours.toStringAsFixed(1)} Hours Logged', style: TextStyle(fontSize: 12, color: colors.subtext)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.academicsTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Study Plan'),
        onPressed: () => _showAddGoalDialog(context, db),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, AppDatabase db) {
    final titleCtrl = TextEditingController();
    final hoursCtrl = TextEditingController(text: '10');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Study Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Topic / Subject Goal')),
            TextField(controller: hoursCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Target Hours')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isNotEmpty) {
                await db.into(db.studyPlansTable).insert(
                      StudyPlansTableCompanion.insert(
                        id: 'plan-${DateTime.now().millisecondsSinceEpoch}',
                        title: titleCtrl.text.trim(),
                        targetDate: DateTime.now().add(const Duration(days: 7)),
                        totalHours: double.tryParse(hoursCtrl.text) ?? 10.0,
                        completedHours: const drift.Value(0.0),
                      ),
                    );
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Create Plan'),
          ),
        ],
      ),
    );
  }
}

// 6. Group Projects Hub Screen (Matches compad_group_project_hub)
class GroupProjectScreen extends ConsumerWidget {
  const GroupProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Group Project Hub', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<GroupProjectsTableData>>(
        stream: db.select(db.groupProjectsTable).watch(),
        builder: (context, snapshot) {
          final projects = snapshot.data ?? [];
          if (projects.isEmpty) {
            return Center(
              child: CompadEmptyState(
                icon: Icons.groups_rounded,
                title: 'No Group Projects',
                subtitle: 'Manage team milestones, peer responsibilities & project submissions.',
                ctaLabel: 'Create Project',
                onCtaPressed: () => _showAddProjectDialog(context, db),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final p = projects[i];
              return CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(p.description, style: TextStyle(fontSize: 13, color: colors.subtext)),
                    const SizedBox(height: 8),
                    Text('Team: ${p.teamMembers}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.academicsTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
        onPressed: () => _showAddProjectDialog(context, db),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context, AppDatabase db) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final membersCtrl = TextEditingController(text: 'You, Aarav, Priya');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Group Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Project Title')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description / Objective')),
            TextField(controller: membersCtrl, decoration: const InputDecoration(labelText: 'Team Members (Comma-separated)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isNotEmpty) {
                await db.into(db.groupProjectsTable).insert(
                      GroupProjectsTableCompanion.insert(
                        id: 'proj-${DateTime.now().millisecondsSinceEpoch}',
                        title: titleCtrl.text.trim(),
                        description: drift.Value(descCtrl.text.trim()),
                        teamMembers: drift.Value(membersCtrl.text.trim()),
                        dueDate: DateTime.now().add(const Duration(days: 30)),
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
}

// 7. Office Hours Booking Screen (Matches compad_office_hours_booking)
class OfficeHoursScreen extends ConsumerWidget {
  const OfficeHoursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Office Hours Booking', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<OfficeHoursTableData>>(
        stream: db.select(db.officeHoursTable).watch(),
        builder: (context, snapshot) {
          final slots = snapshot.data ?? [];
          if (slots.isEmpty) {
            return Center(
              child: CompadEmptyState(
                icon: Icons.meeting_room_rounded,
                title: 'No Office Hours Listed',
                subtitle: 'Add faculty consultation slots to book 1-on-1 doubt clearing sessions.',
                ctaLabel: 'Add Faculty Slot',
                onCtaPressed: () => _showAddSlotDialog(context, db),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: slots.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final s = slots[i];
              return CompadCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    TintedIconCircle(icon: Icons.person_search_rounded, tintColor: colors.academicsTint),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.facultyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${s.department} • Room ${s.location}', style: TextStyle(fontSize: 12, color: colors.subtext)),
                          const SizedBox(height: 4),
                          Text('Slot: ${s.timeSlot} • Status: ${s.bookingStatus}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.campusTint)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.academicsTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Faculty Slot'),
        onPressed: () => _showAddSlotDialog(context, db),
      ),
    );
  }

  void _showAddSlotDialog(BuildContext context, AppDatabase db) {
    final profCtrl = TextEditingController(text: 'Dr. R. K. Sharma');
    final deptCtrl = TextEditingController(text: 'Computer Science');
    final slotCtrl = TextEditingController(text: 'Tue & Thu 3:00 PM – 4:30 PM');
    final roomCtrl = TextEditingController(text: 'Cabin 304');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Office Hours Slot'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: profCtrl, decoration: const InputDecoration(labelText: 'Professor Name')),
            TextField(controller: deptCtrl, decoration: const InputDecoration(labelText: 'Department')),
            TextField(controller: slotCtrl, decoration: const InputDecoration(labelText: 'Time Slot')),
            TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Cabin / Room')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await db.into(db.officeHoursTable).insert(
                    OfficeHoursTableCompanion.insert(
                      id: 'slot-${DateTime.now().millisecondsSinceEpoch}',
                      facultyName: profCtrl.text.trim(),
                      department: deptCtrl.text.trim(),
                      dayOfWeek: 2,
                      timeSlot: slotCtrl.text.trim(),
                      location: roomCtrl.text.trim(),
                    ),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Slot'),
          ),
        ],
      ),
    );
  }
}
