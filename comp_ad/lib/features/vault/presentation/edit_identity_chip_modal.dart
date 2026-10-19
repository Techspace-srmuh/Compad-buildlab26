import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/profile/controllers/profile_controller.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/widgets/spatial_button.dart';

class EditIdentityChipModal extends ConsumerStatefulWidget {
  final bool isInitialSetup;

  const EditIdentityChipModal({
    super.key,
    this.isInitialSetup = false,
  });

  @override
  ConsumerState<EditIdentityChipModal> createState() => _EditIdentityChipModalState();
}

class _EditIdentityChipModalState extends ConsumerState<EditIdentityChipModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _collegeController;
  late TextEditingController _rollNoController;
  late TextEditingController _deptController;
  String _selectedYear = '1st Year';

  final List<String> _yearOptions = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
    'Postgraduate / Masters',
    'PhD / Research Scholar',
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).profile;
    _nameController = TextEditingController(text: profile.name);
    _collegeController = TextEditingController(text: profile.collegeName);
    _rollNoController = TextEditingController(text: profile.rollNo);
    _deptController = TextEditingController(text: profile.department);
    _selectedYear = _yearOptions.contains(profile.year) ? profile.year : '1st Year';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _collegeController.dispose();
    _rollNoController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(profileControllerProvider.notifier).updateProfile(
      name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Student',
      collegeName: _collegeController.text.trim().isNotEmpty ? _collegeController.text.trim() : 'Campus',
      rollNo: _rollNoController.text.trim().isNotEmpty ? _rollNoController.text.trim() : 'UNASSIGNED',
      year: _selectedYear,
      department: _deptController.text.trim().isNotEmpty ? _deptController.text.trim() : 'General',
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Identity Chip saved and synced across CompAd!'),
        backgroundColor: SpatialColors.accentEmerald,
      ),
    );
  }

  void _skip() {
    ref.read(profileControllerProvider.notifier).skipSetup();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SpatialColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pill Bar
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

              // Title Header with Skip Option
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: SpatialColors.accentCyan.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset('assets/icons/app_logo.png', fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.isInitialSetup ? 'Student Identity Setup' : 'Edit Identity Chip',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: SpatialColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _skip,
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(
                        color: SpatialColors.accentCyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Universal student credential for all colleges. Stored 100% offline on your device.',
                style: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),

              // Student Name Field
              _buildField(
                label: 'FULL NAME',
                hint: 'e.g. Aryan Sharma',
                icon: LucideIcons.user,
                controller: _nameController,
              ),
              const SizedBox(height: 14),

              // College / Institution Name Field
              _buildField(
                label: 'COLLEGE / INSTITUTION',
                hint: 'e.g. Delhi Technological University / IIT / NIT',
                icon: LucideIcons.building2,
                controller: _collegeController,
              ),
              const SizedBox(height: 14),

              // Roll No / Registration No Field
              _buildField(
                label: 'ROLL NO. / REGISTRATION NO.',
                hint: 'e.g. 2024-CS-0842',
                icon: LucideIcons.hash,
                controller: _rollNoController,
              ),
              const SizedBox(height: 14),

              // Department / Branch Field
              _buildField(
                label: 'DEPARTMENT / BRANCH',
                hint: 'e.g. CSE-AIML, ECE, Mechanical',
                icon: LucideIcons.bookOpen,
                controller: _deptController,
              ),
              const SizedBox(height: 14),

              // Year of Study Dropdown
              const Text(
                'YEAR OF STUDY',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: SpatialColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: SpatialDecorations.inset(
                  radius: 14,
                  base: SpatialColors.surfaceContainerLowest,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedYear,
                    isExpanded: true,
                    dropdownColor: SpatialColors.surfaceContainer,
                    icon: const Icon(LucideIcons.chevronDown, color: SpatialColors.accentCyan, size: 18),
                    items: _yearOptions.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(
                          year,
                          style: const TextStyle(color: SpatialColors.onSurface, fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedYear = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons: Save & Skip
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: SpatialColors.outlineVariant),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _skip,
                      child: const Text('Skip', style: TextStyle(color: SpatialColors.onSurfaceVariant)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SpatialButton(
                      label: 'Save Identity Chip',
                      icon: LucideIcons.check,
                      accentColor: SpatialColors.accentCyan,
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: SpatialColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: SpatialDecorations.inset(
            radius: 14,
            base: SpatialColors.surfaceContainerLowest,
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: SpatialColors.accentCyan),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: SpatialColors.onSurface, fontSize: 13),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(color: SpatialColors.outline, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
