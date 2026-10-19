import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../timetable/controllers/timetable_controller.dart';
import '../controllers/attendance_lab_controller.dart';
import '../data/attendance_repository.dart';
import 'widgets/attendance_entry_modal.dart';
import 'widgets/simulator_slider_card.dart';

class AttendanceLabScreen extends ConsumerWidget {
  const AttendanceLabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceLabControllerProvider);
    final controller = ref.read(attendanceLabControllerProvider.notifier);
    final timetableCtrl = ref.read(timetableControllerProvider.notifier);

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: SpatialColors.accentCyan),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Context Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TELEMETRY & SIMULATIONS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: SpatialColors.accentCyan,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Attendance Lab',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: SpatialDecorations.raised(
                            radius: 14,
                            base: SpatialColors.surfaceContainerHigh,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: state.aggregateStats.isSafe
                                      ? SpatialColors.accentEmerald
                                      : SpatialColors.accentCoral,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (state.aggregateStats.isSafe
                                              ? SpatialColors.accentEmerald
                                              : SpatialColors.accentCoral)
                                          .withValues(alpha: 0.8),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                state.aggregateStats.isSafe ? 'STABLE BUFFER' : 'DEFICIT ALERT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'JetBrainsMono',
                                  fontWeight: FontWeight.bold,
                                  color: state.aggregateStats.isSafe
                                      ? SpatialColors.accentEmerald
                                      : SpatialColors.accentCoral,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Holographic Attendance Chamber
                    _buildChamberCard(state),
                    const SizedBox(height: 20),

                    // Safe-Bunk Simulator Control Core
                    SimulatorSliderCard(
                      simulatedMisses: state.simulatedMisses,
                      exemptionFlag: state.exemptionFlag,
                      baseStats: state.aggregateStats,
                      simulatedResult: state.simulatedResult,
                      onMissesChanged: (m) => controller.setSimulatedMisses(m),
                      onExemptionChanged: (f) => controller.toggleExemption(f),
                      onReset: () => controller.resetSimulation(),
                    ),
                    const SizedBox(height: 24),

                    // Subject Breakdown Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MODULAR ROSTER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: SpatialColors.accentIndigo,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Subject Breakdowns',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SpatialColors.accentCyan.withValues(alpha: 0.15),
                            foregroundColor: SpatialColors.accentCyan,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: SpatialColors.accentCyan, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const AttendanceEntryModal(),
                            );
                          },
                          icon: const Icon(LucideIcons.userCheck, size: 14),
                          label: const Text(
                            'Entry Option',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Course Breakdown Cards
                    if (state.courseStats.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: SpatialDecorations.raised(radius: 18),
                        child: const Column(
                          children: [
                            Icon(LucideIcons.flaskConical, size: 36, color: SpatialColors.accentCyan),
                            SizedBox(height: 12),
                            Text(
                              'No Subjects Added Yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Add your subjects in the Timetable tab or use AI Timetable Scan to begin tracking attendance and safe-bunk simulations.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.courseStats.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final stat = state.courseStats[index];
                          return _buildCourseStatCard(context, stat, timetableCtrl, controller);
                        },
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildChamberCard(AttendanceLabState state) {
    final stats = state.aggregateStats;
    final isSafe = stats.isSafe;
    final primaryColor = isSafe ? SpatialColors.accentEmerald : SpatialColors.accentCoral;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SpatialColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: SpatialColors.accentCyan.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AGGREGATED PRECISION',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: SpatialColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${stats.percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: primaryColor,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isSafe ? 'Safe Zone' : 'Danger Zone',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Reg. Threshold: 75.0%',
                    style: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                  ),
                ],
              ),
              Container(
                width: 72,
                height: 72,
                decoration: SpatialDecorations.inset(
                  radius: 36,
                  base: SpatialColors.surfaceContainerLowest,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 54,
                        height: 54,
                        child: CircularProgressIndicator(
                          value: (stats.percentage / 100.0).clamp(0.0, 1.0),
                          backgroundColor: SpatialColors.surfaceContainerHigh,
                          color: primaryColor,
                          strokeWidth: 4,
                        ),
                      ),
                      const Icon(LucideIcons.radar, size: 22, color: SpatialColors.accentCyan),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 3-Column Telemetry Readouts
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: SpatialDecorations.inset(
                    radius: 12,
                    base: SpatialColors.surfaceContainerLowest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ATTENDED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: SpatialColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${stats.attended}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: SpatialColors.onSurface,
                        ),
                      ),
                      const Text(
                        'Verified',
                        style: TextStyle(fontSize: 10, color: SpatialColors.outline),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: SpatialDecorations.inset(
                    radius: 12,
                    base: SpatialColors.surfaceContainerLowest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'HELD',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: SpatialColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${stats.held}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: SpatialColors.onSurface,
                        ),
                      ),
                      const Text(
                        'Total slots',
                        style: TextStyle(fontSize: 10, color: SpatialColors.outline),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: SpatialDecorations.inset(
                    radius: 12,
                    base: SpatialColors.surfaceContainerLowest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BUFFER',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: SpatialColors.accentEmerald,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '+${stats.safeBunks}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: SpatialColors.accentEmerald,
                        ),
                      ),
                      const Text(
                        'Bunk capacity',
                        style: TextStyle(fontSize: 10, color: SpatialColors.accentEmerald),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseStatCard(
    BuildContext context,
    CourseAttendanceStat stat,
    TimetableController timetableCtrl,
    AttendanceLabController labCtrl,
  ) {
    final isSafe = stat.result.isSafe;
    final primaryColor = isSafe ? SpatialColors.accentEmerald : SpatialColors.accentCoral;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: SpatialDecorations.raised(
        radius: 16,
        base: SpatialColors.surfaceContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.courseCode,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.bold,
                      color: SpatialColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stat.courseName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: SpatialColors.onSurface,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${stat.result.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    '${stat.attended} / ${stat.held}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'JetBrainsMono',
                      color: SpatialColors.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Linear Progress Track
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: SpatialColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (stat.result.percentage / 100.0).clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quick Log Actions (+ Attended, - Bunked)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSafe
                    ? 'Safe to bunk: ${stat.result.safeBunks} lectures'
                    : 'Attend next ${stat.result.classesToRecover} lectures',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.minusCircle, size: 20, color: SpatialColors.accentCoral),
                    onPressed: () async {
                      await timetableCtrl.logAttendanceForSlot(stat.courseId, 'absent');
                      await labCtrl.loadData();
                    },
                    tooltip: 'Log Absent',
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.plusCircle, size: 20, color: SpatialColors.accentEmerald),
                    onPressed: () async {
                      await timetableCtrl.logAttendanceForSlot(stat.courseId, 'present');
                      await labCtrl.loadData();
                    },
                    tooltip: 'Log Present',
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.pencil, size: 17, color: SpatialColors.accentCyan),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AttendanceEntryModal(
                          initialCourseId: stat.courseId,
                          initialAttended: stat.attended,
                          initialHeld: stat.held,
                        ),
                      );
                    },
                    tooltip: 'Set Exact Attendance Numbers',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
