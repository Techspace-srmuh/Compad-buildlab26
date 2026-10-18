import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/utils/date_time_extensions.dart';
import '../../../core/widgets/spatial_button.dart';
import '../../../core/widgets/spatial_glass.dart';
import '../controllers/timetable_controller.dart';
import '../models/timetable_slot_model.dart';
import 'widgets/add_slot_modal.dart';
import 'widgets/day_selector_strip.dart';
import 'widgets/manage_courses_modal.dart';

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timetableControllerProvider);
    final controller = ref.read(timetableControllerProvider.notifier);

    // Compute total duration of sessions today
    int totalMinutes = 0;
    for (final s in state.slots) {
      totalMinutes += DateTimeExtensions.durationMinutes(s.startTime, s.endTime);
    }
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: SpatialColors.accentCyan),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Header with "My Courses" Manager
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'WEEKLY MATRIX',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'JetBrainsMono',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: SpatialColors.accentCyan,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _openManageCoursesModal(context, state, controller),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: SpatialColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: SpatialColors.accentCyan.withValues(alpha: 0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.bookOpen, size: 13, color: SpatialColors.accentCyan),
                                    const SizedBox(width: 6),
                                    Text(
                                      'My Courses (${state.courses.length})',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'JetBrainsMono',
                                        fontWeight: FontWeight.bold,
                                        color: SpatialColors.accentCyan,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Day Selector Strip
                        DaySelectorStrip(
                          selectedDay: state.selectedDay,
                          onDaySelected: (day) => controller.selectDay(day),
                        ),
                        const SizedBox(height: 16),

                        // Day Summary HUD (Sunken Tactile Metric Capsule)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: SpatialDecorations.inset(
                            radius: 16,
                            base: SpatialColors.surfaceContainerLow,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: SpatialDecorations.raised(
                                      radius: 8,
                                      base: SpatialColors.surfaceContainer,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        LucideIcons.clock,
                                        size: 16,
                                        color: SpatialColors.accentIndigo,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${state.slots.length} Sessions Today',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: SpatialColors.onSurface,
                                        ),
                                      ),
                                      Text(
                                        '${hours}h ${mins}m Total Duration',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: SpatialColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: SpatialDecorations.inset(
                                  radius: 12,
                                  base: SpatialColors.surfaceContainerLowest,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: SpatialColors.accentEmerald,
                                        boxShadow: [
                                          BoxShadow(
                                            color: SpatialColors.accentEmerald.withValues(alpha: 0.8),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'Active Day',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'JetBrainsMono',
                                        color: SpatialColors.accentEmerald,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section Heading
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TIMELINE SCHEDULE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: SpatialColors.outline,
                              ),
                            ),
                            Text(
                              'Tap card for attendance actions',
                              style: TextStyle(
                                fontSize: 11,
                                color: SpatialColors.accentCyan,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Class Cards Stack
                        if (state.slots.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                            decoration: SpatialDecorations.raised(radius: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(LucideIcons.calendarX2, size: 38, color: SpatialColors.onSurfaceVariant),
                                const SizedBox(height: 12),
                                const Text(
                                  'No classes scheduled for this day',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: SpatialColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  state.courses.isEmpty
                                      ? 'Add your semester courses once, then easily schedule them across the week.'
                                      : 'Quickly pick from your enrolled courses to schedule a class.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: SpatialColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                if (state.courses.isEmpty)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: SpatialColors.accentCyan,
                                      foregroundColor: SpatialColors.canvas,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    ),
                                    onPressed: () => _openManageCoursesModal(context, state, controller),
                                    icon: const Icon(LucideIcons.bookPlus, size: 16),
                                    label: const Text('Add Courses (1-Time)', style: TextStyle(fontWeight: FontWeight.bold)),
                                  )
                                else
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: SpatialColors.accentCyan,
                                      foregroundColor: SpatialColors.canvas,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    ),
                                    onPressed: () => _openAddSlotModal(context, state, controller),
                                    icon: const Icon(LucideIcons.plus, size: 16),
                                    label: const Text('Schedule a Class', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.slots.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final slot = state.slots[index];
                              return _buildClassCard(context, slot, controller);
                            },
                          ),
                        const SizedBox(height: 90), // Bottom padding for FAB and dock
                      ],
                    ),
                  ),

                  // Floating Neumorphic + Add Slot Button
                  Positioned(
                    bottom: 96,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => _openAddSlotModal(context, state, controller),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SpatialColors.surfaceContainerHighest,
                          border: Border.all(
                            color: SpatialColors.accentCyan.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: SpatialColors.accentCyan.withValues(alpha: 0.4),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              blurRadius: 16,
                              offset: const Offset(4, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.plus,
                            size: 26,
                            color: SpatialColors.accentCyan,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context,
    TimetableSlotModel slot,
    TimetableController controller,
  ) {
    final course = slot.course;
    final color = course?.color ?? SpatialColors.accentIndigo;
    final code = course?.code ?? 'GEN';
    final name = course?.name ?? 'Course Session';
    final duration = DateTimeExtensions.durationMinutes(slot.startTime, slot.endTime);
    final startDisplay = DateTimeExtensions.formatTimeString(slot.startTime);
    final endDisplay = DateTimeExtensions.formatTimeString(slot.endTime);

    return GestureDetector(
      onTap: () => _showAttendanceActionSheet(context, slot, controller),
      child: Container(
        decoration: BoxDecoration(
          color: SpatialColors.surfaceContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // Vertical Light-pipe along left edge
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Timing & Duration Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$startDisplay — $endDisplay',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JetBrainsMono',
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: SpatialColors.outlineVariant)),
                            const SizedBox(width: 8),
                            Text(
                              '$duration min',
                              style: const TextStyle(
                                fontSize: 11,
                                color: SpatialColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: SpatialDecorations.inset(
                            radius: 10,
                            base: SpatialColors.surfaceContainerLowest,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.checkCheck, size: 12, color: SpatialColors.accentEmerald),
                              SizedBox(width: 4),
                              Text(
                                'Mark Status',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.accentEmerald,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Subject Title
                    Text(
                      '$code: $name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SpatialColors.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Venue & Instructor Row
                    Row(
                      children: [
                        const Icon(LucideIcons.mapPin, size: 14, color: SpatialColors.accentCyan),
                        const SizedBox(width: 5),
                        Text(
                          slot.room,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'JetBrainsMono',
                            color: SpatialColors.onSurfaceVariant,
                          ),
                        ),
                        if (course?.instructor.isNotEmpty ?? false) ...[
                          const SizedBox(width: 12),
                          const Icon(LucideIcons.user, size: 14, color: SpatialColors.accentIndigo),
                          const SizedBox(width: 5),
                          Text(
                            course!.instructor,
                            style: const TextStyle(
                              fontSize: 12,
                              color: SpatialColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttendanceActionSheet(
    BuildContext context,
    TimetableSlotModel slot,
    TimetableController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return SpatialGlass(
          radius: 28,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SpatialColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Log Attendance: ${slot.course?.code ?? "Class"}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SpatialColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${slot.course?.name ?? ""} (${slot.startTime} - ${slot.endTime})',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SpatialButton(
                      label: 'Present',
                      icon: LucideIcons.checkCircle,
                      accentColor: SpatialColors.accentEmerald,
                      isSelected: true,
                      onPressed: () {
                        controller.logAttendanceForSlot(slot.courseId, 'present');
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Attendance Logged: Present (+1)'),
                            backgroundColor: SpatialColors.accentEmerald,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SpatialButton(
                      label: 'Absent',
                      icon: LucideIcons.xCircle,
                      accentColor: SpatialColors.accentCoral,
                      onPressed: () {
                        controller.logAttendanceForSlot(slot.courseId, 'absent');
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Attendance Logged: Absent / Bunked'),
                            backgroundColor: SpatialColors.accentCoral,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SpatialButton(
                      label: 'Canceled',
                      icon: LucideIcons.ban,
                      accentColor: SpatialColors.outline,
                      onPressed: () {
                        controller.logAttendanceForSlot(slot.courseId, 'canceled');
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lecture Marked Canceled (Held count neutral)'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  controller.deleteSlot(slot.id);
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Delete Slot from Timetable',
                  style: TextStyle(color: SpatialColors.accentCoral, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddSlotModal(
    BuildContext context,
    TimetableState state,
    TimetableController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return AddSlotModal(
          courses: state.courses,
          initialDay: state.selectedDay,
          onSave: (newSlot, newCourse) {
            if (newCourse != null) {
              controller.addCourseAndSlot(newCourse, newSlot);
            } else {
              controller.addSlot(newSlot);
            }
          },
        );
      },
    );
  }

  void _openManageCoursesModal(
    BuildContext context,
    TimetableState state,
    TimetableController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return ManageCoursesModal(
          courses: state.courses,
          currentDay: state.selectedDay,
          controller: controller,
        );
      },
    );
  }
}
