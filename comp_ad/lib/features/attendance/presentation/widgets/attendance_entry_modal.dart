import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/spatial_colors.dart';
import '../../../../core/theme/spatial_neumorphic.dart';
import '../../../../core/widgets/spatial_button.dart';
import '../../../../core/widgets/spatial_glass.dart';
import '../../../timetable/controllers/timetable_controller.dart';
import '../../controllers/attendance_lab_controller.dart';

class AttendanceEntryModal extends ConsumerStatefulWidget {
  final String? initialCourseId;
  final int? initialAttended;
  final int? initialHeld;

  const AttendanceEntryModal({
    super.key,
    this.initialCourseId,
    this.initialAttended,
    this.initialHeld,
  });

  @override
  ConsumerState<AttendanceEntryModal> createState() => _AttendanceEntryModalState();
}

class _AttendanceEntryModalState extends ConsumerState<AttendanceEntryModal> {
  // Mode: 'DIRECT' (Set attended/held numbers) or 'SESSION' (Log single lecture)
  String _mode = 'DIRECT';

  String? _selectedCourseId;
  late TextEditingController _attendedController;
  late TextEditingController _heldController;

  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'present'; // 'present', 'absent', 'canceled'

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedCourseId = widget.initialCourseId;
    _attendedController = TextEditingController(text: (widget.initialAttended ?? 0).toString());
    _heldController = TextEditingController(text: (widget.initialHeld ?? 0).toString());
  }

  @override
  void dispose() {
    _attendedController.dispose();
    _heldController.dispose();
    super.dispose();
  }

  int get _attended => int.tryParse(_attendedController.text) ?? 0;
  int get _held => int.tryParse(_heldController.text) ?? 0;

  double get _percentage {
    if (_held <= 0) return 100.0;
    return (_attended / _held * 100.0).clamp(0.0, 100.0);
  }

  bool get _isSafe => _percentage >= 75.0;

  void _adjustAttended(int delta) {
    int next = _attended + delta;
    if (next < 0) next = 0;
    if (next > _held) {
      _heldController.text = next.toString();
    }
    setState(() {
      _attendedController.text = next.toString();
    });
  }

  void _adjustHeld(int delta) {
    int next = _held + delta;
    if (next < 0) next = 0;
    if (next < _attended) {
      next = _attended;
    }
    setState(() {
      _heldController.text = next.toString();
    });
  }

  Future<void> _saveEntry() async {
    if (_selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a course first.'),
          backgroundColor: SpatialColors.accentCoral,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final labCtrl = ref.read(attendanceLabControllerProvider.notifier);

    try {
      if (_mode == 'DIRECT') {
        if (_attended > _held) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Attended classes cannot exceed total classes held.'),
              backgroundColor: SpatialColors.accentCoral,
            ),
          );
          return;
        }

        await labCtrl.setDirectAttendance(
          courseId: _selectedCourseId!,
          attended: _attended,
          held: _held,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Attendance updated: $_attended/$_held (${_percentage.toStringAsFixed(1)}%)'),
              backgroundColor: SpatialColors.accentEmerald,
            ),
          );
        }
      } else {
        await labCtrl.logSingleSession(
          courseId: _selectedCourseId!,
          status: _selectedStatus,
          timestamp: _selectedDate,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Class logged as ${_selectedStatus.toUpperCase()}!'),
              backgroundColor: _selectedStatus == 'present'
                  ? SpatialColors.accentEmerald
                  : SpatialColors.accentCoral,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving attendance: $e'),
            backgroundColor: SpatialColors.accentCoral,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timetableState = ref.watch(timetableControllerProvider);
    final courses = timetableState.courses;

    // Default to first course if none selected
    if (_selectedCourseId == null && courses.isNotEmpty) {
      _selectedCourseId = courses.first.id;
    }

    return Container(
      decoration: const BoxDecoration(
        color: SpatialColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SpatialColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.userCheck, color: SpatialColors.accentCyan, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Attendance Entry',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SpatialColors.onSurface,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: SpatialColors.outline, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Enter your attendance numbers directly or log today\'s classes.',
              style: TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),

            // Mode Selector: Direct Count vs Daily Log
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mode = 'DIRECT'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _mode == 'DIRECT'
                            ? SpatialColors.accentCyan.withValues(alpha: 0.15)
                            : SpatialColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _mode == 'DIRECT' ? SpatialColors.accentCyan : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Direct Numbers',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _mode == 'DIRECT' ? SpatialColors.accentCyan : SpatialColors.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mode = 'SESSION'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _mode == 'SESSION'
                            ? SpatialColors.accentCyan.withValues(alpha: 0.15)
                            : SpatialColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _mode == 'SESSION' ? SpatialColors.accentCyan : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Log Single Class',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _mode == 'SESSION' ? SpatialColors.accentCyan : SpatialColors.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Course Dropdown / Picker
            const Text(
              'SELECT COURSE / SUBJECT',
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.bold,
                color: SpatialColors.accentCyan,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            if (courses.isEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: SpatialDecorations.raised(radius: 14),
                child: const Text(
                  'No courses found. Add your subjects in the Timetable tab first.',
                  style: TextStyle(fontSize: 12, color: SpatialColors.accentCoral),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: SpatialDecorations.inset(
                  radius: 14,
                  base: SpatialColors.surfaceContainerLowest,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCourseId,
                    isExpanded: true,
                    dropdownColor: SpatialColors.surfaceContainerHigh,
                    icon: const Icon(LucideIcons.chevronDown, size: 18, color: SpatialColors.outline),
                    items: courses.map((c) {
                      return DropdownMenuItem<String>(
                        value: c.id,
                        child: Text(
                          '${c.code} - ${c.name}',
                          style: const TextStyle(fontSize: 13, color: SpatialColors.onSurface),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCourseId = val;
                      });
                    },
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Mode 1: Direct Count Entry
            if (_mode == 'DIRECT') ...[
              // Live Percentage Preview Card
              SpatialGlass(
                radius: 18,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PREDICTED ATTENDANCE',
                          style: TextStyle(
                            fontSize: 9,
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.bold,
                            color: SpatialColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'JetBrainsMono',
                            color: _isSafe ? SpatialColors.accentEmerald : SpatialColors.accentCoral,
                          ),
                        ),
                        Text(
                          _isSafe ? 'Safe Zone (≥ 75%)' : 'Deficit Zone (< 75%)',
                          style: TextStyle(
                            fontSize: 11,
                            color: _isSafe ? SpatialColors.accentEmerald : SpatialColors.accentCoral,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: SpatialDecorations.inset(
                        radius: 12,
                        base: SpatialColors.surfaceContainerLowest,
                      ),
                      child: Text(
                        '$_attended / $_held',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JetBrainsMono',
                          color: SpatialColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Attended Classes Counter
              _buildCounterRow(
                title: 'Attended Classes',
                subtitle: 'Lectures / labs you were present in',
                controller: _attendedController,
                accentColor: SpatialColors.accentEmerald,
                onMinus: () => _adjustAttended(-1),
                onPlus: () => _adjustAttended(1),
              ),
              const SizedBox(height: 16),

              // Total Held Classes Counter
              _buildCounterRow(
                title: 'Total Classes Held',
                subtitle: 'Total conducted sessions by college',
                controller: _heldController,
                accentColor: SpatialColors.accentCyan,
                onMinus: () => _adjustHeld(-1),
                onPlus: () => _adjustHeld(1),
              ),
            ] else ...[
              // Mode 2: Log Single Class
              const Text(
                'DATE OF SESSION',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  color: SpatialColors.accentCyan,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: SpatialDecorations.inset(
                    radius: 14,
                    base: SpatialColors.surfaceContainerLowest,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 16, color: SpatialColors.accentCyan),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                            style: const TextStyle(fontSize: 13, color: SpatialColors.onSurface),
                          ),
                        ],
                      ),
                      const Icon(LucideIcons.chevronRight, size: 16, color: SpatialColors.outline),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'ATTENDANCE STATUS',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  color: SpatialColors.accentCyan,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildStatusChip('present', 'Present', LucideIcons.checkCircle2, SpatialColors.accentEmerald),
                  const SizedBox(width: 8),
                  _buildStatusChip('absent', 'Absent', LucideIcons.xCircle, SpatialColors.accentCoral),
                  const SizedBox(width: 8),
                  _buildStatusChip('canceled', 'Cancelled', LucideIcons.slash, SpatialColors.outline),
                ],
              ),
            ],
            const SizedBox(height: 28),

            // Save Action Button
            SizedBox(
              width: double.infinity,
              child: _isSaving
                  ? const Center(
                      child: CircularProgressIndicator(color: SpatialColors.accentCyan),
                    )
                  : SpatialButton(
                      label: _mode == 'DIRECT' ? 'Save Attendance Numbers' : 'Save Class Record',
                      icon: LucideIcons.save,
                      accentColor: SpatialColors.accentCyan,
                      onPressed: _saveEntry,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required Color accentColor,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: SpatialDecorations.raised(
        radius: 16,
        base: SpatialColors.surfaceContainerLow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: SpatialColors.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.minusCircle, size: 24, color: SpatialColors.outline),
                onPressed: onMinus,
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              IconButton(
                icon: Icon(LucideIcons.plusCircle, size: 24, color: accentColor),
                onPressed: onPlus,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String key, String label, IconData icon, Color color) {
    final isSelected = _selectedStatus == key;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedStatus = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : SpatialColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: isSelected ? color : SpatialColors.outline),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : SpatialColors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
