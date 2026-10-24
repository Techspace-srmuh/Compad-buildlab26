import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/upi/upi_payment_dialog.dart';
import '../../../main.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';
import '../../../shared/components/metric_ring.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    final db = ref.watch(appDatabaseProvider);

    return StreamBuilder<List<CoursesTableData>>(
      stream: db.select(db.coursesTable).watch(),
      builder: (context, coursesSnapshot) {
        final courses = coursesSnapshot.data ?? [];

        return StreamBuilder<List<TasksTableData>>(
          stream: db.select(db.tasksTable).watch(),
          builder: (context, tasksSnapshot) {
            final tasks = tasksSnapshot.data ?? [];

            return StreamBuilder<List<TimetableTableData>>(
              stream: db.select(db.timetableTable).watch(),
              builder: (context, timetableSnapshot) {
                final timetable = timetableSnapshot.data ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Next Up Hero Card or Empty State
                      if (timetable.isNotEmpty)
                        _buildNextClassHero(context, timetable.first, compadColors)
                      else
                        _buildEmptyCurriculumHero(context, compadColors),

                      const SizedBox(height: 16),

                      // 2. Metrics Row (Attendance Pulse & Exam Countdown)
                      Row(
                        children: [
                          Expanded(
                            child: CompadCard(
                              onTap: () => context.push('/academics/attendance'),
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  MetricRing(
                                    value: courses.isNotEmpty ? 0.82 : 1.0,
                                    size: 44,
                                    strokeWidth: 5,
                                    progressColor: compadColors.success,
                                    centerChild: Text(
                                      courses.isNotEmpty ? '82%' : '—',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Attendance',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          courses.isNotEmpty ? 'Safe to skip: 2' : '75% Required',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: compadColors.success,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CompadCard(
                              onTap: () => context.push('/academics/calendar'),
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: compadColors.warning.withAlpha(30),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      courses.isNotEmpty ? '12d' : '—',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: compadColors.warning,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'End-Sem Exams',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          courses.isNotEmpty ? 'Odd Semester' : 'Add exam dates',
                                          style: TextStyle(fontSize: 11, color: compadColors.subtext),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Campus Action Bar: App Tutorial & Campus UPI
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: BorderSide(color: compadColors.academicsTint.withValues(alpha: 0.5)),
                              ),
                              onPressed: () => context.push('/tutorial'),
                              icon: Icon(Icons.school_rounded, size: 18, color: compadColors.academicsTint),
                              label: const Text('App Tutorial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: compadColors.campusTint,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => UpiPaymentDialog.show(context),
                              icon: const Icon(Icons.currency_rupee_rounded, size: 18),
                              label: const Text('Campus UPI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 3. Quick Campus Hubs Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Campus Hubs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton.icon(
                            onPressed: () => context.push('/share'),
                            icon: const Icon(Icons.wifi_tethering_rounded, size: 16),
                            label: const Text('Compad Share'),
                            style: TextButton.styleFrom(foregroundColor: compadColors.academicsTint),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHubQuickIcon(context, 'Timetable', Icons.calendar_today_rounded, compadColors.academicsTint, '/academics/timetable'),
                          _buildHubQuickIcon(context, 'Campus Map', Icons.map_rounded, compadColors.campusTint, '/campus/map'),
                          _buildHubQuickIcon(context, 'Study Spaces', Icons.local_cafe_rounded, compadColors.lifeTint, '/campus/study-spaces'),
                          _buildHubQuickIcon(context, 'Mess & Food', Icons.restaurant_rounded, compadColors.wellbeingTint, '/campus/cafeteria'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 4. Upcoming Tasks & CIA Deadlines
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Upcoming Tasks & CIA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () => context.push('/academics/tasks'),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (tasks.isNotEmpty)
                        ...tasks.take(3).map((t) => _buildTaskRow(context, t, compadColors))
                      else
                        CompadCard(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.checklist_rtl_rounded, size: 40, color: compadColors.subtext),
                                const SizedBox(height: 8),
                                const Text('No pending assignments or lab reports', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('Tap + below to add your first task', style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // 5. Academic Advisory / Notice Card
                      CompadCard(
                        padding: const EdgeInsets.all(16),
                        color: compadColors.chipBackground,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline_rounded, color: compadColors.academicsTint),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Academic Notice Board', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Odd Semester Examination forms open next week. Verify registered CBCS elective courses before submission.',
                                    style: TextStyle(fontSize: 12, color: compadColors.subtext, height: 1.35),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildNextClassHero(BuildContext context, TimetableTableData nextClass, CompadThemeColors colors) {
    return CompadCard(
      onTap: () => context.push('/academics/timetable'),
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
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'NEXT CLASS • ${nextClass.startTime}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            nextClass.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${nextClass.courseCode} • ${nextClass.type}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(nextClass.room, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text('${nextClass.startTime} - ${nextClass.endTime}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCurriculumHero(BuildContext context, CompadThemeColors colors) {
    return CompadCard(
      onTap: () => context.push('/academics'),
      color: colors.heroCardBackground,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'NEW SEMESTER START',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Set Up Your Semester Timetable',
            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add your Theory, Lab, and Elective courses to activate timetable alerts and safe-to-skip tracking.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.35),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => context.push('/academics'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Courses'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colors.heroCardBackground,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHubQuickIcon(BuildContext context, String label, IconData icon, Color tint, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        children: [
          TintedIconCircle(icon: icon, tintColor: tint, size: 52, iconSize: 24),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTaskRow(BuildContext context, TasksTableData task, CompadThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CompadCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 36,
              decoration: BoxDecoration(
                color: task.priority == 'HIGH' ? colors.urgent : colors.academicsTint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    'Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                    style: TextStyle(fontSize: 11, color: colors.subtext),
                  ),
                ],
              ),
            ),
            Icon(
              task.status == 'DONE' ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: task.status == 'DONE' ? colors.success : colors.subtext,
            ),
          ],
        ),
      ),
    );
  }
}
