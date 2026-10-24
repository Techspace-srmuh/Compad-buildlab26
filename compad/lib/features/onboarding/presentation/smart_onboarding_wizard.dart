import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';
import '../../campus/domain/offline_map_service.dart';

const List<String> kCommonCourses = [
  'B.Tech / B.E. (Computer Science)',
  'B.Tech / B.E. (Electronics / Electrical)',
  'B.Tech / B.E. (Mechanical / Civil)',
  'B.Sc / B.C.A.',
  'B.Com / B.B.A.',
  'B.A. / Humanities',
  'M.Tech / M.E.',
  'M.B.A. / Management',
  'M.Sc / M.C.A.',
  'Medical / Pharmacy / Law',
  'Polytechnic / Diploma',
];

const List<String> kStudyYears = [
  '1st Year',
  '2nd Year',
  '3rd Year',
  '4th Year',
  '5th Year / PG',
];

class SmartOnboardingWizard extends ConsumerStatefulWidget {
  const SmartOnboardingWizard({super.key});

  @override
  ConsumerState<SmartOnboardingWizard> createState() => _SmartOnboardingWizardState();
}

class _SmartOnboardingWizardState extends ConsumerState<SmartOnboardingWizard> {
  int _currentStep = 0; // 0 to 3 (4 steps total)
  final _nameCtrl = TextEditingController();
  final _rollCtrl = TextEditingController();

  String _selectedCourse = kCommonCourses[0];
  String _selectedYear = kStudyYears[0];
  String _selectedCampusId = 'iit_bombay';

  // Map download state
  bool _isDownloadingMap = false;
  double _mapDownloadProgress = 0.0;
  bool _mapDownloaded = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rollCtrl.dispose();
    super.dispose();
  }

  Future<void> _startMapDownload() async {
    final catalog = OfflineCampusMapService.officialCampuses;
    final campus = catalog.firstWhere(
      (c) => c.id == _selectedCampusId,
      orElse: () => catalog.first,
    );

    setState(() {
      _isDownloadingMap = true;
      _mapDownloadProgress = 0.05;
    });

    try {
      final service = OfflineCampusMapService();
      await for (final progress in service.downloadCampusMap(campus)) {
        if (!mounted) return;
        setState(() => _mapDownloadProgress = progress);
      }
      if (!mounted) return;
      setState(() {
        _isDownloadingMap = false;
        _mapDownloaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDownloadingMap = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Map download notice: $e'), backgroundColor: Colors.amber[800]),
      );
    }
  }

  Future<void> _finishSetup() async {
    final name = _nameCtrl.text.trim().isEmpty ? 'Student' : _nameCtrl.text.trim();
    final roll = _rollCtrl.text.trim();
    final catalog = OfflineCampusMapService.officialCampuses;
    final campusObj = catalog.firstWhere(
      (c) => c.id == _selectedCampusId,
      orElse: () => catalog.first,
    );

    final db = ref.read(appDatabaseProvider);
    await db.into(db.studentProfileTable).insertOnConflictUpdate(
          StudentProfileTableCompanion.insert(
            id: 'profile_main',
            fullName: drift.Value(name),
            enrollmentNumber: drift.Value(roll),
            degree: drift.Value(_selectedCourse),
            branch: drift.Value(_selectedCourse),
            year: drift.Value(kStudyYears.indexOf(_selectedYear) + 1),
            selectedCampusId: drift.Value(_selectedCampusId),
            selectedCampusName: drift.Value(campusObj.name),
            college: drift.Value(campusObj.name),
            city: drift.Value(campusObj.city),
            state: drift.Value(campusObj.state),
            onboardingCompleted: const drift.Value(true),
            setupStep: const drift.Value(4),
            updatedAt: DateTime.now(),
          ),
        );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', name);
    await prefs.setString('enrollment_no', roll);
    await prefs.setString('student_course', _selectedCourse);
    await prefs.setString('student_year', _selectedYear);
    await prefs.setString('selected_campus_id', _selectedCampusId);
    await prefs.setString('selected_campus_name', campusObj.name);
    await prefs.setBool('setup_complete', true);
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      context.go('/tutorial');
    }
  }

  void _nextStep() {
    if (_currentStep == 0 && _nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _finishSetup();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final compadColors = theme.extension<CompadThemeColors>() ??
        (theme.brightness == Brightness.dark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      appBar: AppBar(
        leading: _currentStep > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _prevStep)
            : null,
        title: Text('Step ${_currentStep + 1} of 4'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentStep + 1) / 4.0,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(compadColors.academicsTint),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 32),

              // Step Content
              Expanded(
                child: SingleChildScrollView(
                  child: _buildCurrentQuestion(colorScheme, compadColors),
                ),
              ),

              // Bottom Navigation Button
              ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: compadColors.academicsTint,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _currentStep == 3 ? 'Get Started' : 'Next',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentQuestion(ColorScheme colorScheme, CompadThemeColors compadColors) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Name(colorScheme, compadColors);
      case 1:
        return _buildStep2Roll(colorScheme, compadColors);
      case 2:
        return _buildStep3CourseYear(colorScheme, compadColors);
      case 3:
      default:
        return _buildStep4CampusMap(colorScheme, compadColors);
    }
  }

  // STEP 1: NAME
  Widget _buildStep1Name(ColorScheme colorScheme, CompadThemeColors compadColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: compadColors.academicsTint.withAlpha(25),
          child: Icon(Icons.person_rounded, size: 36, color: compadColors.academicsTint),
        ),
        const SizedBox(height: 24),
        const Text(
          "What is your name?",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "We use your name for personalized timetables and offline sharing.",
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _nameCtrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your name',
            prefixIcon: const Icon(Icons.badge_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

  // STEP 2: ROLL NUMBER
  Widget _buildStep2Roll(ColorScheme colorScheme, CompadThemeColors compadColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: compadColors.campusTint.withAlpha(25),
          child: Icon(Icons.numbers_rounded, size: 36, color: compadColors.campusTint),
        ),
        const SizedBox(height: 24),
        const Text(
          "What is your roll number?",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Your enrollment number stays strictly offline on this phone.",
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _rollCtrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Roll / Enrollment Number',
            hintText: 'e.g. 24BCS041',
            prefixIcon: const Icon(Icons.tag_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

  // STEP 3: COURSE AND YEAR
  Widget _buildStep3CourseYear(ColorScheme colorScheme, CompadThemeColors compadColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: compadColors.lifeTint.withAlpha(25),
          child: Icon(Icons.school_rounded, size: 36, color: compadColors.lifeTint),
        ),
        const SizedBox(height: 24),
        const Text(
          "Course & Year",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Select your degree and current academic year.",
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 28),
        DropdownButtonFormField<String>(
          initialValue: _selectedCourse,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Degree / Course',
            prefixIcon: const Icon(Icons.auto_stories_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          items: kCommonCourses
              .map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedCourse = val);
          },
        ),
        const SizedBox(height: 20),
        const Text('Current Year of Study', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: kStudyYears.map((yr) {
            final isSelected = _selectedYear == yr;
            return ChoiceChip(
              label: Text(yr),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedYear = yr);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // STEP 4: CAMPUS & OFFLINE MAP DOWNLOAD
  Widget _buildStep4CampusMap(ColorScheme colorScheme, CompadThemeColors compadColors) {
    final catalog = OfflineCampusMapService.officialCampuses;
    final selectedItem = catalog.firstWhere(
      (c) => c.id == _selectedCampusId,
      orElse: () => catalog.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: compadColors.wellbeingTint.withAlpha(25),
          child: Icon(Icons.map_rounded, size: 36, color: compadColors.wellbeingTint),
        ),
        const SizedBox(height: 24),
        const Text(
          "Choose your campus",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Download offline vector navigation data to use without internet.",
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 28),

        DropdownButtonFormField<String>(
          initialValue: _selectedCampusId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Select University Campus',
            prefixIcon: const Icon(Icons.account_balance_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          items: catalog
              .map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.name} (${c.city})'),
                  ))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedCampusId = val;
                _mapDownloaded = false;
              });
            }
          },
        ),

        const SizedBox(height: 24),

        // Map Download Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(120),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.downloading_rounded, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          'Size: ${(selectedItem.fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB • Vector Map',
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  if (_mapDownloaded)
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 26),
                ],
              ),
              if (_isDownloadingMap) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _mapDownloadProgress,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Downloading map: ${(_mapDownloadProgress * 100).toInt()}%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
              if (!_isDownloadingMap && !_mapDownloaded) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _startMapDownload,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download Map Now'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
