import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/spatial_colors.dart';
import '../../../../core/theme/spatial_neumorphic.dart';

class DaySelectorStrip extends StatelessWidget {
  final int selectedDay; // 1 = Mon, ..., 6 = Sat
  final ValueChanged<int> onDaySelected;

  const DaySelectorStrip({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  static const List<Map<String, dynamic>> _days = [
    {'day': 1, 'name': 'Mon', 'date': '14'},
    {'day': 2, 'name': 'Tue', 'date': '15'},
    {'day': 3, 'name': 'Wed', 'date': '16'},
    {'day': 4, 'name': 'Thu', 'date': '17'},
    {'day': 5, 'name': 'Fri', 'date': '18'},
    {'day': 6, 'name': 'Sat', 'date': '19'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month & Week Indicator Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(LucideIcons.calendar, size: 17, color: SpatialColors.accentCyan),
                SizedBox(width: 6),
                Text(
                  'Oct 2024',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: SpatialColors.onSurface,
                  ),
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
                      color: SpatialColors.accentCyan,
                      boxShadow: [
                        BoxShadow(
                          color: SpatialColors.accentCyan.withValues(alpha: 0.8),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'WEEK 08',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: SpatialColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal Day Buttons
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final d = _days[index];
              final int dayNum = d['day'] as int;
              final bool isSelected = dayNum == selectedDay;

              return GestureDetector(
                onTap: () => onDaySelected(dayNum),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 54,
                  decoration: isSelected
                      ? BoxDecoration(
                          color: SpatialColors.accentCyan.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: SpatialColors.accentCyan.withValues(alpha: 0.6),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: SpatialColors.accentCyan.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.2),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        )
                      : SpatialDecorations.raised(
                          radius: 16,
                          base: SpatialColors.surfaceContainer,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1.0,
                          ),
                        ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        d['name'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? SpatialColors.accentCyan : SpatialColors.outline,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        d['date'] as String,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: isSelected ? SpatialColors.onSurface : SpatialColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? SpatialColors.accentCyan : Colors.transparent,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: SpatialColors.accentCyan.withValues(alpha: 0.8),
                                    blurRadius: 6,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
