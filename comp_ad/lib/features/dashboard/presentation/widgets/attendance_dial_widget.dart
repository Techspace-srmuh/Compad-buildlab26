import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/spatial_colors.dart';
import '../../../../core/theme/spatial_neumorphic.dart';
import '../../../../core/utils/attendance_calculator.dart';

class AttendanceDialWidget extends StatelessWidget {
  final AttendanceResult stats;
  final VoidCallback? onTap;

  const AttendanceDialWidget({
    super.key,
    required this.stats,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSafe = stats.isSafe;
    final primaryColor = isSafe ? SpatialColors.accentEmerald : SpatialColors.accentCoral;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            blurRadius: 8,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.shieldCheck, size: 20, color: SpatialColors.accentIndigo),
                  SizedBox(width: 8),
                  Text(
                    'Attendance Shield',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: SpatialColors.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: SpatialDecorations.inset(
                  radius: 12,
                  base: SpatialColors.surfaceContainerLowest,
                ),
                child: const Text(
                  'MIN 75% REQ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: SpatialColors.accentIndigo,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Giant Sunken Well with Center Dial
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 230,
              height: 230,
              decoration: SpatialDecorations.inset(
                radius: 115,
                base: SpatialColors.surfaceContainerLowest,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Toroidal Progress Ring
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: _ToroidProgressPainter(
                      percentage: stats.percentage.clamp(0.0, 100.0),
                      isSafe: isSafe,
                    ),
                  ),

                  // Center Extruded Island
                  Container(
                    width: 145,
                    height: 145,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        center: Alignment(0, -0.3),
                        colors: [
                          SpatialColors.surfaceContainerHighest,
                          SpatialColors.surfaceContainer,
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.65),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'COMPOSITE RATE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: SpatialColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              stats.percentage.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JetBrainsMono',
                                color: SpatialColors.onSurface,
                                letterSpacing: -1.0,
                              ),
                            ),
                            Text(
                              '%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JetBrainsMono',
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Safe-to-bunk capsule
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                                  color: primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withValues(alpha: 0.7),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isSafe
                                    ? 'Safe: ${stats.safeBunks} Bunks'
                                    : 'Attend ${stats.classesToRecover} Next',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Discrete Metrics Bar
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: SpatialDecorations.inset(
                    radius: 12,
                    base: SpatialColors.surfaceContainerLowest,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'CONDUCTED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: SpatialColors.outline,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${stats.held}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: SpatialColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: SpatialDecorations.inset(
                    radius: 12,
                    base: SpatialColors.surfaceContainerLowest,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'ATTENDED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: SpatialColors.accentEmerald,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${stats.attended}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: SpatialColors.accentEmerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: SpatialDecorations.inset(
                    radius: 12,
                    base: SpatialColors.surfaceContainerLowest,
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'TARGET GOAL',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: SpatialColors.accentIndigo,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '75%',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: SpatialColors.accentIndigo,
                        ),
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
}

class _ToroidProgressPainter extends CustomPainter {
  final double percentage;
  final bool isSafe;

  _ToroidProgressPainter({
    required this.percentage,
    required this.isSafe,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const strokeWidth = 14.0;

    // Background inactive track
    final bgPaint = Paint()
      ..color = SpatialColors.surfaceContainerLow
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (percentage <= 0) return;

    // Active illuminated arc
    final sweepAngle = (percentage / 100.0) * 2 * pi;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final gradientColors = isSafe
        ? [
            SpatialColors.accentEmerald,
            SpatialColors.accentCyan,
            SpatialColors.accentIndigo,
          ]
        : [
            SpatialColors.accentCoral,
            const Color(0xFFE11D48),
          ];

    final glowPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: gradientColors,
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawArc(arcRect, -pi / 2, sweepAngle, false, glowPaint);

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: gradientColors,
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, -pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ToroidProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.isSafe != isSafe;
  }
}
