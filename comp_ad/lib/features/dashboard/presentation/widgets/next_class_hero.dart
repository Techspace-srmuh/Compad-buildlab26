import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/spatial_colors.dart';
import '../../../../core/theme/spatial_neumorphic.dart';
import '../../../../core/utils/date_time_extensions.dart';
import '../../../timetable/models/timetable_slot_model.dart';

class NextClassHero extends StatelessWidget {
  final TimetableSlotModel? slot;
  final int minutesUntil;
  final bool isActive;
  final bool isCheckedIn;
  final VoidCallback onQuickCheckIn;

  const NextClassHero({
    super.key,
    required this.slot,
    required this.minutesUntil,
    required this.isActive,
    required this.isCheckedIn,
    required this.onQuickCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    if (slot == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: SpatialDecorations.raised(radius: 20),
        child: const Column(
          children: [
            Icon(LucideIcons.calendarCheck, size: 40, color: SpatialColors.accentEmerald),
            SizedBox(height: 12),
            Text(
              'No Classes Scheduled',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: SpatialColors.onSurface,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Your schedule is clear. Add classes in the Timetable tab or use AI Scan to load your schedule.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: SpatialColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    final course = slot!.course;
    final title = course?.name ?? 'University Lecture';
    final code = course?.code ?? 'GEN';
    final instructor = (course?.instructor != null && course!.instructor.isNotEmpty)
        ? course.instructor
        : 'Faculty Instructor';
    final room = slot!.room.isNotEmpty ? slot!.room : 'Main Campus';
    final startDisplay = DateTimeExtensions.formatTimeString(slot!.startTime);
    final endDisplay = DateTimeExtensions.formatTimeString(slot!.endTime);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: SpatialColors.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ambient specular light glow
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SpatialColors.accentCyan.withValues(alpha: 0.12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badges Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: SpatialDecorations.raised(
                        radius: 10,
                        base: SpatialColors.surfaceContainerHigh,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SpatialColors.accentCyan,
                              boxShadow: [
                                BoxShadow(
                                  color: SpatialColors.accentCyan.withValues(alpha: 0.7),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$code • ${slot!.room}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: SpatialColors.accentCyan,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: SpatialDecorations.inset(
                        radius: 20,
                        base: SpatialColors.surfaceContainerLowest,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isActive ? LucideIcons.radio : LucideIcons.clock,
                            size: 13,
                            color: isActive
                                ? SpatialColors.accentEmerald
                                : SpatialColors.accentCyan,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isActive ? 'ACTIVE NOW' : 'in ${minutesUntil}m',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'JetBrainsMono',
                              color: isActive
                                  ? SpatialColors.accentEmerald
                                  : SpatialColors.accentCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Subject Title & Venue
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: SpatialColors.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(LucideIcons.graduationCap, size: 15, color: SpatialColors.accentIndigo),
                    const SizedBox(width: 6),
                    Text(
                      instructor,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SpatialColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('•', style: TextStyle(color: SpatialColors.outlineVariant)),
                    const SizedBox(width: 6),
                    Text(
                      room,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'JetBrainsMono',
                        color: SpatialColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Timing & Projected Impact Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: SpatialDecorations.inset(
                          radius: 10,
                          base: SpatialColors.surfaceContainerLowest,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SLOT TIME',
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.outline,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$startDisplay - $endDisplay',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'JetBrainsMono',
                                color: SpatialColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: SpatialDecorations.inset(
                          radius: 10,
                          base: SpatialColors.surfaceContainerLowest,
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ATTENDED IMPACT',
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.accentEmerald,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '+1.2% Overall',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JetBrainsMono',
                                color: SpatialColors.accentEmerald,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Quick Physical Check-in Button
                GestureDetector(
                  onTap: onQuickCheckIn,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isCheckedIn
                          ? SpatialColors.accentEmerald.withValues(alpha: 0.15)
                          : SpatialColors.surfaceContainerHighest.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCheckedIn
                            ? SpatialColors.accentEmerald.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.12),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: isCheckedIn
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: SpatialColors.accentEmerald,
                                      boxShadow: [
                                        BoxShadow(
                                          color: SpatialColors.accentEmerald.withValues(alpha: 0.6),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    )
                                  : SpatialDecorations.inset(
                                      radius: 13,
                                      base: SpatialColors.surfaceContainerLowest,
                                    ),
                              child: Center(
                                child: Icon(
                                  LucideIcons.check,
                                  size: 15,
                                  color: isCheckedIn
                                      ? SpatialColors.canvas
                                      : SpatialColors.outline,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isCheckedIn ? 'Checked-in' : 'Quick Check-in',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isCheckedIn
                                    ? SpatialColors.accentEmerald
                                    : SpatialColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              isCheckedIn ? 'Logged' : 'Pending',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'JetBrainsMono',
                                color: isCheckedIn
                                    ? SpatialColors.accentEmerald
                                    : SpatialColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              LucideIcons.chevronRight,
                              size: 16,
                              color: isCheckedIn
                                  ? SpatialColors.accentEmerald
                                  : SpatialColors.outline,
                            ),
                          ],
                        ),
                      ],
                    ),
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
