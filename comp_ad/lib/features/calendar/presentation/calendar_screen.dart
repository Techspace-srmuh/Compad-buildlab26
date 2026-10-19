import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/widgets/spatial_glass.dart';
import '../controllers/calendar_controller.dart';
import '../models/calendar_activity_model.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final _monthFormat = DateFormat('MMMM yyyy');
  final _selectedDateFormat = DateFormat('EEEE, dd MMMM');

  void _openAddActivityModal(DateTime selectedDate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AddActivitySheet(selectedDate: selectedDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calendarControllerProvider);
    final controller = ref.read(calendarControllerProvider.notifier);

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: SpatialColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(LucideIcons.calendarDays, size: 20, color: SpatialColors.accentCyan),
            SizedBox(width: 8),
            Text(
              'ACADEMIC CALENDAR',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: SpatialColors.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final now = DateTime.now();
              controller.changeMonth(now.month - state.currentMonth.month + (now.year - state.currentMonth.year) * 12);
              controller.selectDate(DateTime(now.year, now.month, now.day));
            },
            child: const Text('Today', style: TextStyle(color: SpatialColors.accentCyan, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus, color: SpatialColors.accentCyan),
            onPressed: () => _openAddActivityModal(state.selectedDate),
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: SpatialColors.accentCyan))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month Navigation & Selector
                    SpatialGlass(
                      radius: 24,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(LucideIcons.chevronLeft, color: SpatialColors.onSurface),
                                onPressed: () => controller.changeMonth(-1),
                              ),
                              Text(
                                _monthFormat.format(state.currentMonth),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'JetBrainsMono',
                                  color: SpatialColors.onSurface,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(LucideIcons.chevronRight, color: SpatialColors.onSurface),
                                onPressed: () => controller.changeMonth(1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Days of Week Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                .map((d) => SizedBox(
                                      width: 36,
                                      child: Text(
                                        d,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'JetBrainsMono',
                                          color: SpatialColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 8),

                          // Calendar Matrix
                          _buildMonthGrid(state, controller),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tagged Activities on Selected Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TAGGED ACTIVITIES',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'JetBrainsMono',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: SpatialColors.accentCyan,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedDateFormat.format(state.selectedDate),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SpatialColors.surfaceContainerHigh,
                            foregroundColor: SpatialColors.accentCyan,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _openAddActivityModal(state.selectedDate),
                          icon: const Icon(LucideIcons.plus, size: 14),
                          label: const Text('Tag Activity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (state.selectedDateActivities.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: SpatialDecorations.raised(radius: 18),
                        child: const Column(
                          children: [
                            Icon(LucideIcons.calendarCheck, size: 36, color: SpatialColors.onSurfaceVariant),
                            SizedBox(height: 10),
                            Text(
                              'No activities tagged for this date',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tag upcoming assignments, exams, vivas, or deadlines.',
                              style: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.selectedDateActivities.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final act = state.selectedDateActivities[i];
                          return _buildActivityCard(act, controller);
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMonthGrid(CalendarState state, CalendarController controller) {
    final year = state.currentMonth.year;
    final month = state.currentMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1 = Mon ... 7 = Sun
    final now = DateTime.now();

    final List<Widget> dayWidgets = [];

    // Empty spaces before first day
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 36, height: 38));
    }

    // Days of month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final isSelected = date.year == state.selectedDate.year &&
          date.month == state.selectedDate.month &&
          date.day == state.selectedDate.day;
      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final hasActivities = state.monthActivities.any((a) => a.date == dateStr);

      dayWidgets.add(
        GestureDetector(
          onTap: () => controller.selectDate(date),
          child: Container(
            width: 36,
            height: 38,
            decoration: BoxDecoration(
              color: isSelected
                  ? SpatialColors.accentCyan
                  : (isToday ? SpatialColors.surfaceContainerHighest : Colors.transparent),
              borderRadius: BorderRadius.circular(10),
              border: isToday && !isSelected
                  ? Border.all(color: SpatialColors.accentCyan.withValues(alpha: 0.6), width: 1.2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                    fontFamily: 'JetBrainsMono',
                    color: isSelected ? SpatialColors.canvas : SpatialColors.onSurface,
                  ),
                ),
                if (hasActivities) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? SpatialColors.canvas : SpatialColors.accentCyan,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 6,
      runSpacing: 6,
      children: dayWidgets,
    );
  }

  Widget _buildActivityCard(CalendarActivityModel act, CalendarController controller) {
    return Container(
      decoration: SpatialDecorations.raised(
        radius: 16,
        base: SpatialColors.surfaceContainer,
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: act.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: act.color.withValues(alpha: 0.5), width: 1),
                ),
                child: Center(
                  child: Icon(act.icon, size: 18, color: act.color),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      act.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: SpatialColors.onSurface,
                        decoration: act.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: act.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            act.category,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: act.color),
                          ),
                        ),
                        if (act.time.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          const Icon(LucideIcons.clock, size: 11, color: SpatialColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            act.time,
                            style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                    if (act.notes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        act.notes,
                        style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
              Checkbox(
                value: act.isCompleted,
                activeColor: SpatialColors.accentEmerald,
                checkColor: Colors.black,
                onChanged: (val) {
                  if (val != null) controller.toggleCompleted(act.id, val);
                },
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 15, color: SpatialColors.accentCoral),
                onPressed: () => controller.deleteActivity(act.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddActivitySheet extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const _AddActivitySheet({required this.selectedDate});

  @override
  ConsumerState<_AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends ConsumerState<_AddActivitySheet> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _timeCtrl = TextEditingController(text: '10:00 AM');
  final TextEditingController _notesCtrl = TextEditingController();

  String _category = 'Exam';
  final List<String> _categories = [
    'Exam',
    'Assignment',
    'Lab/Viva',
    'Event',
    'Deadline',
    'Personal',
  ];

  final List<String> _palette = [
    'EF4444', // Coral (Exam)
    '06B6D4', // Cyan (Assignment)
    '10B981', // Emerald (Lab)
    'F59E0B', // Amber (Deadline)
    '8B5CF6', // Purple (Event)
    'EC4899', // Pink (Personal)
  ];
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = _palette.first;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _timeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an activity title.'),
          backgroundColor: SpatialColors.accentCoral,
        ),
      );
      return;
    }

    ref.read(calendarControllerProvider.notifier).addActivity(
      title: _titleCtrl.text.trim(),
      category: _category,
      colorHex: _selectedColor,
      time: _timeCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMMM yyyy').format(widget.selectedDate);

    return Container(
      decoration: const BoxDecoration(
        color: SpatialColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: SpatialColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tag Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: SpatialColors.onSurface,
                    ),
                  ),
                  Text(
                    'For $dateStr',
                    style: const TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(LucideIcons.x, color: SpatialColors.onSurfaceVariant),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'ACTIVITY TITLE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: SpatialDecorations.inset(
                      radius: 14,
                      base: SpatialColors.surfaceContainerLow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: TextField(
                      controller: _titleCtrl,
                      style: const TextStyle(fontSize: 14, color: SpatialColors.onSurface),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g. Data Structures Mid-Sem Exam',
                        hintStyle: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Category
                  const Text(
                    'CATEGORY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((c) {
                      final isSel = _category == c;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _category = c;
                            if (c == 'Exam') _selectedColor = 'EF4444';
                            if (c == 'Assignment') _selectedColor = '06B6D4';
                            if (c == 'Lab/Viva') _selectedColor = '10B981';
                            if (c == 'Deadline') _selectedColor = 'F59E0B';
                            if (c == 'Event') _selectedColor = '8B5CF6';
                            if (c == 'Personal') _selectedColor = 'EC4899';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSel ? SpatialColors.accentCyan : SpatialColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            c,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSel ? SpatialColors.canvas : SpatialColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Time
                  const Text(
                    'TIMINGS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: SpatialDecorations.inset(
                      radius: 14,
                      base: SpatialColors.surfaceContainerLow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: TextField(
                      controller: _timeCtrl,
                      style: const TextStyle(fontSize: 13, color: SpatialColors.onSurface),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g. 10:00 AM - 01:00 PM',
                        hintStyle: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Notes
                  const Text(
                    'NOTES (OPTIONAL)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: SpatialDecorations.inset(
                      radius: 14,
                      base: SpatialColors.surfaceContainerLow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: TextField(
                      controller: _notesCtrl,
                      style: const TextStyle(fontSize: 13, color: SpatialColors.onSurface),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g. Syllabus: Units 1 to 3, bring calculator',
                        hintStyle: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SpatialColors.accentCyan,
                      foregroundColor: SpatialColors.canvas,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _save,
                    icon: const Icon(LucideIcons.check, size: 18),
                    label: const Text('Save to Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
