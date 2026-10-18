import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/spatial_colors.dart';
import '../../../../core/theme/spatial_neumorphic.dart';
import '../../../../core/widgets/spatial_button.dart';
import '../../../../core/widgets/spatial_glass.dart';
import '../../controllers/timetable_controller.dart';
import '../../models/course_model.dart';
import 'add_slot_modal.dart';

class ManageCoursesModal extends StatefulWidget {
  final List<CourseModel> courses;
  final int currentDay;
  final TimetableController controller;

  const ManageCoursesModal({
    super.key,
    required this.courses,
    required this.currentDay,
    required this.controller,
  });

  @override
  State<ManageCoursesModal> createState() => _ManageCoursesModalState();
}

class _ManageCoursesModalState extends State<ManageCoursesModal> {
  bool _isAddingNew = false;
  final TextEditingController _codeCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _instructorCtrl = TextEditingController();
  final TextEditingController _defaultRoomCtrl = TextEditingController();

  final List<String> _palette = [
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
    _selectedColorHex = _palette.first;
    if (widget.courses.isEmpty) {
      _isAddingNew = true;
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _instructorCtrl.dispose();
    _defaultRoomCtrl.dispose();
    super.dispose();
  }

  void _saveCourse() async {
    final code = _codeCtrl.text.trim();
    final name = _nameCtrl.text.trim();

    if (code.isEmpty && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least a course code or name.'),
          backgroundColor: SpatialColors.accentCoral,
        ),
      );
      return;
    }

    final newCourse = CourseModel(
      id: 'course_${DateTime.now().millisecondsSinceEpoch}',
      code: code.isNotEmpty ? code : 'SUB${widget.courses.length + 1}',
      name: name.isNotEmpty ? name : (code.isNotEmpty ? code : 'Subject ${widget.courses.length + 1}'),
      instructor: _instructorCtrl.text.trim(),
      defaultRoom: _defaultRoomCtrl.text.trim(),
      colorHex: _selectedColorHex,
    );

    await widget.controller.addCourse(newCourse);

    _codeCtrl.clear();
    _nameCtrl.clear();
    _instructorCtrl.clear();
    _defaultRoomCtrl.clear();

    if (mounted) {
      setState(() {
        _isAddingNew = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course "${newCourse.code}" saved! Now schedule it into your week.'),
          backgroundColor: SpatialColors.accentEmerald,
        ),
      );
    }
  }

  void _confirmDeleteCourse(CourseModel course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SpatialColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Course?', style: TextStyle(color: SpatialColors.onSurface)),
        content: Text(
          'Are you sure you want to delete ${course.code} (${course.name})? This will also remove all its scheduled slots from your timetable.',
          style: const TextStyle(color: SpatialColors.onSurfaceVariant, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: SpatialColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SpatialColors.accentCoral,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              widget.controller.deleteCourse(course.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openScheduleSlot(CourseModel course) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddSlotModal(
        courses: widget.courses,
        initialDay: widget.currentDay,
        preselectedCourseId: course.id,
        onSave: (slot, _) {
          widget.controller.addSlot(slot);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = widget.courses;

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
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enrolled Courses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: SpatialColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${courses.length} ${courses.length == 1 ? "Subject" : "Subjects"} registered for this semester',
                    style: const TextStyle(
                      fontSize: 12,
                      color: SpatialColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SpatialButton(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onPressed: () {
                  setState(() {
                    _isAddingNew = !_isAddingNew;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isAddingNew ? LucideIcons.x : LucideIcons.plus,
                      size: 15,
                      color: SpatialColors.accentCyan,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isAddingNew ? 'Close' : 'Add Course',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: SpatialColors.accentCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: SpatialColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: SpatialColors.accentCyan.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.lightbulb, size: 14, color: SpatialColors.accentCyan),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Add your semester courses once. Then simply pick them to assign days & times—no repetitive typing!',
                    style: TextStyle(
                      fontSize: 11,
                      color: SpatialColors.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Main scrollable content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collapsible Add Course Form
                  if (_isAddingNew) ...[
                    SpatialGlass(
                      radius: 20,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.bookOpen, size: 16, color: SpatialColors.accentCyan),
                              SizedBox(width: 8),
                              Text(
                                'Register New Course',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Course Code & Title
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildTextField(
                                  controller: _codeCtrl,
                                  label: 'Code (e.g. CS401)',
                                  hint: 'CS401',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: _buildTextField(
                                  controller: _nameCtrl,
                                  label: 'Course Name',
                                  hint: 'Data Structures',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Instructor & Room
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _instructorCtrl,
                                  label: 'Instructor (Optional)',
                                  hint: 'Dr. Sharma',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildTextField(
                                  controller: _defaultRoomCtrl,
                                  label: 'Default Room (Opt.)',
                                  hint: 'Room 301 / Lab 2',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Color selector
                          const Text(
                            'Color Theme',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: SpatialColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: _palette.map((hex) {
                              final isSelected = _selectedColorHex == hex;
                              final c = Color(int.parse('FF$hex', radix: 16));
                              return GestureDetector(
                                onTap: () => setState(() => _selectedColorHex = hex),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Colors.transparent,
                                      width: 2.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: c.withValues(alpha: 0.6),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? const Center(
                                          child: Icon(Icons.check, size: 14, color: Colors.white),
                                        )
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Save Button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SpatialColors.accentCyan,
                              foregroundColor: SpatialColors.canvas,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _saveCourse,
                            icon: const Icon(LucideIcons.check, size: 16),
                            label: const Text(
                              'Save Course to My List',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Courses List
                  if (courses.isEmpty && !_isAddingNew)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(LucideIcons.bookOpen, size: 36, color: SpatialColors.onSurfaceVariant),
                            SizedBox(height: 10),
                            Text(
                              'No courses added yet',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tap "Add Course" above to register your semester subjects.',
                              style: TextStyle(
                                fontSize: 12,
                                color: SpatialColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...courses.map((c) => _buildCourseCard(c)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
              // Color Accent Strip
              Container(
                width: 10,
                height: 48,
                decoration: BoxDecoration(
                  color: course.color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 12),

              // Course Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          course.code,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'JetBrainsMono',
                            color: SpatialColors.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            course.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: SpatialColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (course.instructor.isNotEmpty) ...[
                          const Icon(LucideIcons.user, size: 11, color: SpatialColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            course.instructor,
                            style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                          ),
                          const SizedBox(width: 10),
                        ],
                        if (course.defaultRoom.isNotEmpty) ...[
                          const Icon(LucideIcons.mapPin, size: 11, color: SpatialColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            course.defaultRoom,
                            style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              IconButton(
                icon: const Icon(LucideIcons.calendarPlus, size: 18, color: SpatialColors.accentCyan),
                tooltip: 'Schedule in Timetable',
                onPressed: () => _openScheduleSlot(course),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 17, color: SpatialColors.accentCoral),
                tooltip: 'Delete Course',
                onPressed: () => _confirmDeleteCourse(course),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: SpatialColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: SpatialDecorations.inset(
            radius: 12,
            base: SpatialColors.surfaceContainerLow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13, color: SpatialColors.onSurface),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 12,
                color: SpatialColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
