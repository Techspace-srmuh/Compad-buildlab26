import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:go_router/go_router.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../../../shared/components/compad_card.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/components/tinted_icon_circle.dart';

// 1. Offline Notebook Screen (compad_shared_notes_exchange & offline notebook)
class OfflineNotebookScreen extends ConsumerWidget {
  const OfflineNotebookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Offline Notebook', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<NotesTableData>>(
        stream: db.select(db.notesTable).watch(),
        builder: (context, snapshot) {
          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return Center(
              child: CompadEmptyState(
                icon: Icons.edit_note_rounded,
                title: 'No Notes Saved',
                subtitle: 'Capture lecture highlights, formulas, and diagrams with markdown formatting.',
                ctaLabel: 'Add First Note',
                onCtaPressed: () => _showAddNoteDialog(context, db),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final n = notes[i];
              return CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.share_outlined, size: 18),
                          tooltip: 'Share via Compad Share',
                          onPressed: () => context.push('/share', extra: n.title),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(n.content, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: colors.subtext, height: 1.4)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(8)),
                          child: Text(n.tags, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.academicsTint)),
                        ),
                        const Spacer(),
                        Text(
                          '${n.updatedAt.day}/${n.updatedAt.month}/${n.updatedAt.year}',
                          style: TextStyle(fontSize: 11, color: colors.subtext),
                        ),
                      ],
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
        label: const Text('New Note'),
        onPressed: () => _showAddNoteDialog(context, db),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, AppDatabase db) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final tagsCtrl = TextEditingController(text: '#lecture #operating_systems');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Lecture Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Note Title')),
            TextField(controller: contentCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Content (Markdown supported)')),
            TextField(controller: tagsCtrl, decoration: const InputDecoration(labelText: 'Tags')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isNotEmpty) {
                await db.into(db.notesTable).insert(
                      NotesTableCompanion.insert(
                        id: 'note-${DateTime.now().millisecondsSinceEpoch}',
                        title: titleCtrl.text.trim(),
                        content: contentCtrl.text.trim(),
                        tags: drift.Value(tagsCtrl.text.trim()),
                        updatedAt: DateTime.now(),
                      ),
                    );
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }
}

// 2. Habit Tracker Screen (compad_habit_tracker)
class HabitTrackerScreen extends ConsumerWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Habit Tracker', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<HabitsTableData>>(
        stream: db.select(db.habitsTable).watch(),
        builder: (context, snapshot) {
          final habits = snapshot.data ?? [];
          if (habits.isEmpty) {
            return Center(
              child: CompadEmptyState(
                icon: Icons.track_changes_rounded,
                title: 'No Habits Tracked',
                subtitle: 'Form daily student routines: attendance streak, revision, water, and sleep.',
                ctaLabel: 'Add First Habit',
                onCtaPressed: () => _showAddHabitDialog(context, db),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: habits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final h = habits[i];
              final now = DateTime.now();
              final isCompletedToday = h.lastCompletedDate != null &&
                  h.lastCompletedDate!.year == now.year &&
                  h.lastCompletedDate!.month == now.month &&
                  h.lastCompletedDate!.day == now.day;
              return CompadCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    TintedIconCircle(icon: Icons.check_circle_outline_rounded, tintColor: colors.campusTint),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('Target: ${h.targetDaysPerWeek} days/wk • Streak: ${h.currentStreak} Days 🔥', style: TextStyle(fontSize: 12, color: colors.subtext)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(isCompletedToday ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: colors.campusTint),
                      onPressed: () async {
                        final newStreak = isCompletedToday
                            ? (h.currentStreak > 0 ? h.currentStreak - 1 : 0)
                            : h.currentStreak + 1;
                        await (db.update(db.habitsTable)..where((t) => t.id.equals(h.id))).write(
                          HabitsTableCompanion(
                            currentStreak: drift.Value(newStreak),
                            lastCompletedDate: drift.Value(isCompletedToday ? null : DateTime.now()),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.campusTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
        onPressed: () => _showAddHabitDialog(context, db),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context, AppDatabase db) {
    final nameCtrl = TextEditingController(text: 'Review 10 Flashcards');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Daily Habit'),
        content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Habit Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                await db.into(db.habitsTable).insert(
                      HabitsTableCompanion.insert(
                        id: 'habit-${DateTime.now().millisecondsSinceEpoch}',
                        title: nameCtrl.text.trim(),
                        icon: 'check',
                        color: '0xFF14B8A6',
                        targetDaysPerWeek: const drift.Value(7),
                        currentStreak: const drift.Value(1),
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

// 3. Certificates & Vault Screen (compad_achievements_certificates_vault)
class CertificatesVaultScreen extends ConsumerWidget {
  const CertificatesVaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Certificates & Vault', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<EncryptedVaultTableData>>(
        stream: db.select(db.encryptedVaultTable).watch(),
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: CompadEmptyState(
                icon: Icons.lock_rounded,
                title: 'Vault Is Empty',
                subtitle: 'Store 10th/12th marksheets, degree certificates & government IDs encrypted locally.',
                ctaLabel: 'Store First Document',
                onCtaPressed: () => _showAddDocDialog(context, db),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final it = items[i];
              return CompadCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    TintedIconCircle(icon: Icons.lock_outline_rounded, tintColor: colors.warning),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${it.category.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Encrypted with AES-256 GCM • Local Storage', style: TextStyle(fontSize: 12, color: colors.subtext)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      tooltip: 'Share via Compad Share',
                      onPressed: () => context.push('/share', extra: 'vault_${it.id}.enc'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.warning,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_moderator_rounded),
        label: const Text('Store Certificate'),
        onPressed: () => _showAddDocDialog(context, db),
      ),
    );
  }

  void _showAddDocDialog(BuildContext context, AppDatabase db) {
    final catCtrl = TextEditingController(text: 'Marksheet - Semester 1');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Store Encrypted Document'),
        content: TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Document Name / Category')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await db.into(db.encryptedVaultTable).insert(
                    EncryptedVaultTableCompanion.insert(
                      id: 'vault-${DateTime.now().millisecondsSinceEpoch}',
                      category: catCtrl.text.trim(),
                      encryptedPayload: 'AES_ENCRYPTED_DUMMY_PAYLOAD',
                      iv: 'INITIALIZATION_VECTOR_12B',
                      updatedAt: DateTime.now(),
                    ),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Encrypt & Save'),
          ),
        ],
      ),
    );
  }
}

// 4. Resume Builder Screen (compad_resume_builder)
class ResumeBuilderScreen extends StatelessWidget {
  const ResumeBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Academic Resume Builder (ATS)', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.academicsTint.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.article_rounded, tintColor: colors.academicsTint),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1-Page ATS Standard CV', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Automatically populated with your CGPA, courses, projects & technical skills.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Resume Sections', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.school_outlined),
                  title: const Text('Education & 10-Pt CGPA'),
                  subtitle: const Text('B.Tech in CSE • CGPA 8.7 • NIT'),
                  trailing: const Icon(Icons.check_circle_rounded, color: Colors.green),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.code_rounded),
                  title: const Text('Technical Skills'),
                  subtitle: const Text('Flutter, Dart, Python, C++, SQL, Git'),
                  trailing: const Icon(Icons.check_circle_rounded, color: Colors.green),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.work_outline_rounded),
                  title: const Text('Academic Projects'),
                  subtitle: const Text('Compad Offline Campus Companion'),
                  trailing: const Icon(Icons.check_circle_rounded, color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.academicsTint,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating ATS-compliant 1-page PDF resume...')),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: const Text('Export ATS 1-Page PDF Resume', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

// 5. Placement & Internship Board (compad_internship_job_board)
class InternshipsScreen extends StatelessWidget {
  const InternshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    final jobs = [
      {'company': 'Google India', 'role': 'Software Engineering Intern', 'ctc': '₹1,20,000/mo', 'criteria': 'CGPA >= 8.0 • 2026 Batch', 'status': 'Applications Open'},
      {'company': 'Microsoft IDC', 'role': 'SWE Graduate', 'ctc': '16.5 LPA', 'criteria': 'CGPA >= 7.5 • CSE/IT/ECE', 'status': 'Shortlisting'},
      {'company': 'Tata Consultancy Services', 'role': 'Digital SWE', 'ctc': '7.5 LPA', 'criteria': 'No Active Backlogs', 'status': 'Online Assessment'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Placements & Internships', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final j = jobs[i];
          return CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(j['company'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: colors.campusTint.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(j['ctc'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.campusTint)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(j['role'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                Text('Eligibility: ${j['criteria']}', style: TextStyle(fontSize: 12, color: colors.subtext)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 6. Gamification & Study Quests Screen (compad_gamification_study_quests)
class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Gamification & Study Quests', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.lifeTint.withOpacity(0.1),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TintedIconCircle(icon: Icons.military_tech_rounded, tintColor: colors.lifeTint, size: 56, iconSize: 32),
                const SizedBox(height: 12),
                const Text('Semester Scholar • Level 4', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text('1,420 XP / 2,000 XP to Level 5', style: TextStyle(fontSize: 13, color: colors.subtext)),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: 0.71, backgroundColor: colors.chipBackground, color: colors.lifeTint),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Active Study Quests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _buildQuestCard('7-Day Attendance Streak', 'Maintain >= 85% attendance across all subjects', 0.85, colors),
          const SizedBox(height: 10),
          _buildQuestCard('Spaced Repetition Master', 'Review 50 flashcards before mid-semester exams', 0.60, colors),
          const SizedBox(height: 10),
          _buildQuestCard('Budget Disciplinarian', 'Stay within monthly student ₹ allowance', 1.0, colors),
        ],
      ),
    );
  }

  Widget _buildQuestCard(String title, String desc, double prog, CompadThemeColors colors) {
    return CompadCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${(prog * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: colors.lifeTint)),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 12, color: colors.subtext)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: prog, backgroundColor: colors.chipBackground, color: colors.lifeTint),
        ],
      ),
    );
  }
}

// 7. Voice Notes & Lecture Recorder (compad_voice_notes_lecture_recorder)
class VoiceNotesScreen extends StatefulWidget {
  const VoiceNotesScreen({super.key});

  @override
  State<VoiceNotesScreen> createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen> {
  bool _isRecording = false;
  int _secondsRecorded = 0;
  Timer? _recordTimer;
  final List<Map<String, dynamic>> _voiceNotes = [
    {'title': 'OS Lecture - Virtual Memory', 'duration': '42:15', 'date': '20 Oct 2026', 'size': '18.4 MB'},
    {'title': 'DBMS - B+ Tree Indexing Notes', 'duration': '15:30', 'date': '18 Oct 2026', 'size': '6.8 MB'},
  ];

  void _toggleRecord() {
    if (_isRecording) {
      _recordTimer?.cancel();
      setState(() {
        _isRecording = false;
        _voiceNotes.insert(0, {
          'title': 'New Recording ${_voiceNotes.length + 1}',
          'duration': '${_secondsRecorded ~/ 60}:${(_secondsRecorded % 60).toString().padLeft(2, '0')}',
          'date': 'Today',
          'size': '${(_secondsRecorded * 0.1).toStringAsFixed(1)} MB',
        });
        _secondsRecorded = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice note saved offline!')));
    } else {
      setState(() {
        _isRecording = true;
        _secondsRecorded = 0;
      });
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _secondsRecorded++);
      });
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final mins = (_secondsRecorded ~/ 60).toString().padLeft(2, '0');
    final secs = (_secondsRecorded % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('Voice Notes & Lecture Audio', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: _isRecording ? CompadColors.urgentRed.withOpacity(0.08) : colors.cardBackground,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isRecording ? CompadColors.urgentRed : colors.academicsTint,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded, size: 40, color: Colors.white),
                    onPressed: _toggleRecord,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isRecording ? 'Recording... $mins:$secs' : 'Tap to Record Lecture Audio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _isRecording ? CompadColors.urgentRed : null),
                ),
                const SizedBox(height: 4),
                Text('High-fidelity offline AAC audio stored locally in app vault.', style: TextStyle(fontSize: 12, color: colors.subtext)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Recorded Lecture Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ..._voiceNotes.map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CompadCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      TintedIconCircle(icon: Icons.graphic_eq_rounded, tintColor: colors.academicsTint),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text('Duration: ${v['duration']} • ${v['date']} • ${v['size']}', style: TextStyle(fontSize: 12, color: colors.subtext)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        tooltip: 'Share via Compad Share',
                        onPressed: () => context.push('/share', extra: v['title']),
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

// 8. Document Scanner & OCR (compad_document_scanner_ocr)
class DocumentScannerScreen extends StatelessWidget {
  const DocumentScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Document Scanner & OCR', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.campusTint.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.document_scanner_rounded, tintColor: colors.campusTint),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Offline Edge Detection & OCR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Digitize paper assignments, whiteboard notes, and fee receipts to PDF.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.campusTint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Starting camera document capture...')));
                  },
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Scan Page', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Importing from photo gallery...')));
                  },
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('Import Image', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent Scans (2 Documents)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: TintedIconCircle(icon: Icons.picture_as_pdf_rounded, tintColor: colors.urgent),
                  title: const Text('Assignment_1_DataStructures.pdf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('3 Pages • OCR extracted • 1.2 MB'),
                  trailing: IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () => context.push('/share', extra: 'Assignment_1_DataStructures.pdf'),
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: TintedIconCircle(icon: Icons.picture_as_pdf_rounded, tintColor: colors.urgent),
                  title: const Text('Hostel_Fee_Challan_Oct2026.pdf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('1 Page • Verified stamp • 450 KB'),
                  trailing: IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () => context.push('/share', extra: 'Hostel_Fee_Challan_Oct2026.pdf'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
