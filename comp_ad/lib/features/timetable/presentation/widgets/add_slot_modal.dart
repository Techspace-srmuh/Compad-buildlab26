import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/spatial_colors.dart';
import '../../../../core/theme/spatial_neumorphic.dart';
import '../../../../core/widgets/spatial_glass.dart';
import '../../models/course_model.dart';
import '../../models/timetable_slot_model.dart';

class AddSlotModal extends StatefulWidget {
  final List<CourseModel> courses;
  final int initialDay;
  final String? preselectedCourseId;
  final Function(TimetableSlotModel slot, CourseModel? newCourse) onSave;

  const AddSlotModal({
    super.key,
    required this.courses,
    required this.initialDay,
    this.preselectedCourseId,
    required this.onSave,
  });

  @override
  State<AddSlotModal> createState() => _AddSlotModalState();
}

class _AddSlotModalState extends State<AddSlotModal> {
  late bool _isCreatingNewCourse;
  String? _selectedCourseId;
  late int _selectedDay;

  // Controllers for creating new course
  final TextEditingController _courseCodeCtrl = TextEditingController();
  final TextEditingController _courseNameCtrl = TextEditingController();
  final TextEditingController _instructorCtrl = TextEditingController();

  // Controllers for slot
  final TextEditingController _startTimeCtrl = TextEditingController(text: '09:00');
  final TextEditingController _endTimeCtrl = TextEditingController(text: '10:30');
  final TextEditingController _roomCtrl = TextEditingController(text: 'Room 301');

  final List<String> _colorPalette = [
    '6366F1', // Indigo
    '06B6D4', // Cyan
    '10B981', // Emerald
    'F59E0B', // Amber
    'EC4899', // Pink
    '8B5CF6', // Purple
  ];
  late String _selectedColorHex;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay;
    _selectedColorHex = _colorPalette.first;
    _isCreatingNewCourse = widget.courses.isEmpty;

    if (widget.preselectedCourseId != null &&
        widget.courses.any((c) => c.id == widget.preselectedCourseId)) {
      _selectedCourseId = widget.preselectedCourseId;
      _applyCourseDefaults(_selectedCourseId!);
    } else if (widget.courses.isNotEmpty) {
      _selectedCourseId = widget.courses.first.id;
      _applyCourseDefaults(_selectedCourseId!);
    }
  }

  void _applyCourseDefaults(String courseId) {
    try {
      final course = widget.courses.firstWhere((c) => c.id == courseId);
      if (course.defaultRoom.isNotEmpty) {
        _roomCtrl.text = course.defaultRoom;
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _courseCodeCtrl.dispose();
    _courseNameCtrl.dispose();
    _instructorCtrl.dispose();
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    _roomCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    CourseModel? newCourse;
    String courseId = _selectedCourseId ?? '';

    if (_isCreatingNewCourse) {
      final code = _courseCodeCtrl.text.trim().isNotEmpty
          ? _courseCodeCtrl.text.trim()
          : 'SUB101';
      final name = _courseNameCtrl.text.trim().isNotEmpty
          ? _courseNameCtrl.text.trim()
          : code;
      courseId = 'course_${DateTime.now().millisecondsSinceEpoch}';

      newCourse = CourseModel(
        id: courseId,
        code: code,
        name: name,
        instructor: _instructorCtrl.text.trim(),
        colorHex: _selectedColorHex,
        defaultRoom: _roomCtrl.text.trim(),
      );
    }

    if (courseId.isEmpty && newCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an enrolled course or create one.'),
          backgroundColor: SpatialColors.accentCoral,
        ),
      );
      return;
    }

    final slot = TimetableSlotModel(
      id: 'slot_${DateTime.now().millisecondsSinceEpoch}',
      courseId: courseId,
      dayOfWeek: _selectedDay,
      startTime: _startTimeCtrl.text.trim().isNotEmpty ? _startTimeCtrl.text.trim() : '09:00',
      endTime: _endTimeCtrl.text.trim().isNotEmpty ? _endTimeCtrl.text.trim() : '10:00',
      room: _roomCtrl.text.trim().isNotEmpty ? _roomCtrl.text.trim() : 'Room 101',
      course: newCourse,
    );

    widget.onSave(slot, newCourse);
    Navigator.pop(context);
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final parts = controller.text.split(':');
    final initialHour = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? 9) : 9;
    final initialMinute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: SpatialColors.accentCyan,
              surface: SpatialColors.surfaceContainer,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final h = picked.hour.toString().padLeft(2, '0');
      final m = picked.minute.toString().padLeft(2, '0');
      setState(() {
        controller.text = '$h:$m';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

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
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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
          const SizedBox(height: 14),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.calendarPlus, size: 20, color: SpatialColors.accentCyan),
                  SizedBox(width: 8),
                  Text(
                    'Schedule Class',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: SpatialColors.onSurface,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(LucideIcons.x, color: SpatialColors.onSurfaceVariant),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Scrollable body
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Choose Course
                  const Text(
                    '1. SELECT COURSE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (widget.courses.isNotEmpty && !_isCreatingNewCourse) ...[
                    // List enrolled courses as selectable chips/cards
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...widget.courses.map((course) {
                          final isSelected = _selectedCourseId == course.id;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCourseId = course.id;
                                _applyCourseDefaults(course.id);
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? course.color.withValues(alpha: 0.22)
                                    : SpatialColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? course.color : Colors.transparent,
                                  width: 1.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: course.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    course.code,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JetBrainsMono',
                                      color: isSelected ? Colors.white : SpatialColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    course.name,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected
                                          ? SpatialColors.onSurface
                                          : SpatialColors.onSurfaceVariant,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 6),
                                    Icon(Icons.check, size: 14, color: course.color),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                        // Quick button to add another course
                        GestureDetector(
                          onTap: () => setState(() => _isCreatingNewCourse = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: SpatialColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: SpatialColors.accentCyan.withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.plus, size: 13, color: SpatialColors.accentCyan),
                                SizedBox(width: 6),
                                Text(
                                  'New Subject',
                                  style: TextStyle(
                                    fontSize: 11,
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
                  ] else ...[
                    // New Course entry form
                    SpatialGlass(
                      radius: 16,
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Register Subject (One-time entry)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.onSurface,
                                ),
                              ),
                              if (widget.courses.isNotEmpty)
                                TextButton(
                                  onPressed: () => setState(() => _isCreatingNewCourse = false),
                                  child: const Text('Pick Existing', style: TextStyle(fontSize: 11, color: SpatialColors.accentCyan)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildSmallInput(_courseCodeCtrl, 'Code (CS101)'),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: _buildSmallInput(_courseNameCtrl, 'Course Name'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildSmallInput(_instructorCtrl, 'Instructor (Optional)'),
                          const SizedBox(height: 10),
                          const Text(
                            'Color Theme',
                            style: TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: _colorPalette.map((hex) {
                              final isSel = _selectedColorHex == hex;
                              final c = Color(int.parse('FF$hex', radix: 16));
                              return GestureDetector(
                                onTap: () => setState(() => _selectedColorHex = hex),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSel ? Colors.white : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

                  // Section 2: Day of Week
                  const Text(
                    '2. DAY OF WEEK',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(6, (i) {
                      final dayNum = i + 1;
                      final isSelected = _selectedDay == dayNum;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedDay = dayNum),
                          child: Container(
                            margin: EdgeInsets.only(right: i < 5 ? 6 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? SpatialColors.accentCyan
                                  : SpatialColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                days[i],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? SpatialColors.canvas
                                      : SpatialColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 18),

                  // Section 3: Time Slot
                  const Text(
                    '3. CLASS TIMINGS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePickerBox(
                          label: 'Start Time',
                          controller: _startTimeCtrl,
                          onTap: () => _pickTime(_startTimeCtrl),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(LucideIcons.arrowRight, size: 16, color: SpatialColors.onSurfaceVariant),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimePickerBox(
                          label: 'End Time',
                          controller: _endTimeCtrl,
                          onTap: () => _pickTime(_endTimeCtrl),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Section 4: Room / Hall
                  const Text(
                    '4. CLASSROOM / LAB',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: SpatialDecorations.inset(
                      radius: 14,
                      base: SpatialColors.surfaceContainerLow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.mapPin, size: 16, color: SpatialColors.accentCyan),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _roomCtrl,
                            style: const TextStyle(fontSize: 13, color: SpatialColors.onSurface),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: 'e.g. Room 301, Lab 2, Main Aud.',
                              hintStyle: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SpatialColors.accentCyan,
                      foregroundColor: SpatialColors.canvas,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _handleSave,
                    icon: const Icon(LucideIcons.check, size: 18),
                    label: const Text(
                      'Save to Timetable',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerBox({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: SpatialDecorations.inset(
          radius: 14,
          base: SpatialColors.surfaceContainerLow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: SpatialColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JetBrainsMono',
                    color: SpatialColors.onSurface,
                  ),
                ),
                const Icon(LucideIcons.clock, size: 14, color: SpatialColors.accentCyan),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallInput(TextEditingController controller, String hint) {
    return Container(
      decoration: SpatialDecorations.inset(
        radius: 12,
        base: SpatialColors.surfaceContainerLowest,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12, color: SpatialColors.onSurface),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 11,
            color: SpatialColors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
