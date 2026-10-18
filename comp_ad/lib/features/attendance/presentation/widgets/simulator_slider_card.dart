import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/spatial_colors.dart';
import '../../../../core/theme/spatial_neumorphic.dart';
import '../../../../core/utils/attendance_calculator.dart';
import '../../../../core/widgets/spatial_slider.dart';

class SimulatorSliderCard extends StatelessWidget {
  final int simulatedMisses;
  final bool exemptionFlag;
  final AttendanceResult baseStats;
  final AttendanceResult simulatedResult;
  final ValueChanged<int> onMissesChanged;
  final ValueChanged<bool> onExemptionChanged;
  final VoidCallback onReset;

  const SimulatorSliderCard({
    super.key,
    required this.simulatedMisses,
    required this.exemptionFlag,
    required this.baseStats,
    required this.simulatedResult,
    required this.onMissesChanged,
    required this.onExemptionChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isSafe = simulatedResult.isSafe;
    final primaryColor = isSafe ? SpatialColors.accentEmerald : SpatialColors.accentCoral;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SpatialColors.surfaceContainer,
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
            color: isSafe
                ? SpatialColors.accentEmerald.withValues(alpha: 0.08)
                : SpatialColors.accentCoral.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: SpatialDecorations.raised(
                      radius: 10,
                      base: SpatialColors.surfaceContainerHighest,
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.flaskConical,
                        size: 17,
                        color: SpatialColors.accentCyan,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safe-Bunk Simulator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SpatialColors.onSurface,
                        ),
                      ),
                      Text(
                        'Stress-test non-attendance scenarios',
                        style: TextStyle(
                          fontSize: 11,
                          color: SpatialColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: onReset,
                child: const Text(
                  'RESET',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    color: SpatialColors.outline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Stepper Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SIMULATE UPCOMING MISSED LECTURES',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: SpatialColors.onSurfaceVariant,
                ),
              ),
              Text(
                '$simulatedMisses Misses',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JetBrainsMono',
                  color: SpatialColors.accentCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Tactile Slider
          SpatialSlider(
            value: simulatedMisses.toDouble(),
            min: 0,
            max: 15,
            divisions: 15,
            onChanged: (val) => onMissesChanged(val.round()),
          ),
          const SizedBox(height: 4),

          // Stepper Legend Markers
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0', style: TextStyle(fontSize: 10, fontFamily: 'JetBrainsMono', color: SpatialColors.outline)),
                Text('3 (Safe)', style: TextStyle(fontSize: 10, fontFamily: 'JetBrainsMono', fontWeight: FontWeight.bold, color: SpatialColors.accentEmerald)),
                Text('7', style: TextStyle(fontSize: 10, fontFamily: 'JetBrainsMono', color: SpatialColors.outline)),
                Text('11', style: TextStyle(fontSize: 10, fontFamily: 'JetBrainsMono', color: SpatialColors.outline)),
                Text('15 (Danger)', style: TextStyle(fontSize: 10, fontFamily: 'JetBrainsMono', fontWeight: FontWeight.bold, color: SpatialColors.accentCoral)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Dynamic Feedback Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: SpatialDecorations.inset(
              radius: 14,
              base: SpatialColors.surfaceContainerLowest,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Icon(
                      isSafe ? LucideIcons.checkCircle : LucideIcons.alertTriangle,
                      size: 18,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isSafe ? 'Status: Optimal Buffer' : 'Status: Deficit Alert',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            '${simulatedResult.percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'JetBrainsMono',
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSafe
                            ? 'Holding steady at ${simulatedResult.attended}/${simulatedResult.held} lectures. Headroom stands at ${simulatedResult.safeBunks} safe bunks before dropping below 75% boundary.'
                            : 'Attendance drops to ${simulatedResult.percentage.toStringAsFixed(1)}%. You MUST attend next ${simulatedResult.classesToRecover} consecutive lectures to recover safe 75% threshold!',
                        style: const TextStyle(
                          fontSize: 12,
                          color: SpatialColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Medical / Duty Exemption Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medical / Duty Exemption Flag',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: SpatialColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Offset missed slots with verified paperwork',
                    style: TextStyle(
                      fontSize: 11,
                      color: SpatialColors.outline,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => onExemptionChanged(!exemptionFlag),
                child: Container(
                  width: 52,
                  height: 30,
                  padding: const EdgeInsets.all(3),
                  decoration: SpatialDecorations.inset(
                    radius: 15,
                    base: exemptionFlag
                        ? SpatialColors.accentEmerald.withValues(alpha: 0.25)
                        : SpatialColors.surfaceContainerLowest,
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 180),
                    alignment: exemptionFlag ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: exemptionFlag
                            ? SpatialColors.accentEmerald
                            : SpatialColors.surfaceContainerHighest,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
