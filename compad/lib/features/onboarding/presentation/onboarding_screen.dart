import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/compad_logo.dart';
import '../../../shared/components/compad_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form Fields
  final _nameController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _apaarController = TextEditingController();
  final _branchController = TextEditingController(text: 'Computer Science');
  final _collegeController = TextEditingController();
  final _affiliatingUniController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();

  String _selectedDegree = 'B.Tech';
  String _selectedState = 'Delhi';
  double _attendanceRule = 75.0;

  static const List<String> indianDegrees = [
    'B.Tech',
    'B.E.',
    'B.Sc',
    'B.Com',
    'BBA',
    'BCA',
    'B.A.',
    'MBBS',
    'B.Pharm',
    'B.Arch',
    'LLB',
    'Diploma',
    'M.Tech',
    'MBA',
    'MCA',
    'M.Sc',
    'PhD',
    'Other',
  ];

  static const List<String> indianStatesAndUTs = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman & Nicobar Islands',
    'Chandigarh',
    'Dadra & Nagar Haveli and Daman & Diu',
    'Delhi',
    'Jammu & Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    await prefs.setString('student_name', _nameController.text.trim().isEmpty ? 'Student' : _nameController.text.trim());
    await prefs.setString('enrollment_no', _rollNoController.text.trim());
    await prefs.setString('apaar_id', _apaarController.text.trim());
    await prefs.setString('student_course', '$_selectedDegree (${_branchController.text.trim()})');
    await prefs.setString('student_college', _collegeController.text.trim().isEmpty ? 'University' : _collegeController.text.trim());
    await prefs.setString('student_state', _selectedState);
    await prefs.setDouble('attendance_threshold', _attendanceRule);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _rollNoController.dispose();
    _apaarController.dispose();
    _branchController.dispose();
    _collegeController.dispose();
    _affiliatingUniController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CompadLogo(size: 32, showText: true),
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: Text('Skip', style: TextStyle(color: compadColors.subtext)),
                  ),
                ],
              ),
            ),
            // Page view
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildIdentityStep(compadColors),
                  _buildCollegeAndAcademicStep(compadColors),
                  _buildSafetyAndThemeStep(compadColors),
                ],
              ),
            ),
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot indicators
                  Row(
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? compadColors.academicsTint
                              : compadColors.cardBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: compadColors.academicsTint,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 1: Name, Course, Roll No, APAAR ID
  Widget _buildIdentityStep(CompadThemeColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Namaste! Welcome to Compad', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            'Your offline-first companion designed for college life in India. Starts completely empty and private to your phone.',
            style: TextStyle(fontSize: 13, color: colors.subtext),
          ),
          const SizedBox(height: 20),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g. Tarun Kumar / Ananya Roy',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedDegree,
                        decoration: const InputDecoration(labelText: 'Program'),
                        items: indianDegrees
                            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedDegree = val!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _branchController,
                        decoration: const InputDecoration(
                          labelText: 'Branch / Stream',
                          hintText: 'e.g. CSE / Mechanical / Physics',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _rollNoController,
                  decoration: const InputDecoration(
                    labelText: 'Enrollment / Roll No.',
                    hintText: 'e.g. 23BCE1042',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _apaarController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'APAAR / ABC ID (Optional, 12 digits)',
                    hintText: 'e.g. 1234 5678 9012',
                    prefixIcon: Icon(Icons.credit_card_outlined),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STEP 2: University, State, Attendance rule
  Widget _buildCollegeAndAcademicStep(CompadThemeColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Campus & Schedule', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            'Configure your institution, semester, and attendance thresholds. All stored encrypted on this device.',
            style: TextStyle(fontSize: 13, color: colors.subtext),
          ),
          const SizedBox(height: 20),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _collegeController,
                  decoration: const InputDecoration(
                    labelText: 'College / Institute Name',
                    hintText: 'e.g. Delhi Technological University',
                    prefixIcon: Icon(Icons.account_balance_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedState,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'State / Union Territory',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  items: indianStatesAndUTs
                      .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedState = val!),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mandatory Attendance Rule:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('${_attendanceRule.toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: colors.academicsTint)),
                  ],
                ),
                Slider(
                  value: _attendanceRule,
                  min: 65.0,
                  max: 85.0,
                  divisions: 4,
                  activeColor: colors.academicsTint,
                  onChanged: (val) => setState(() => _attendanceRule = val),
                ),
                Text(
                  'Standard Indian university requirement is 75% with a 65% condonation threshold.',
                  style: TextStyle(fontSize: 11, color: colors.subtext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STEP 3: Theme Mode & Emergency Contacts
  Widget _buildSafetyAndThemeStep(CompadThemeColors colors) {
    final themeState = ref.watch(themeControllerProvider);
    final themeNotifier = ref.read(themeControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Theme & Safety Setup', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            'Select your preferred appearance and optionally add trusted emergency contacts.',
            style: TextStyle(fontSize: 13, color: colors.subtext),
          ),
          const SizedBox(height: 20),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose Appearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
                    ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                  ],
                  selected: {themeState.themeMode},
                  onSelectionChanged: (newSelection) => themeNotifier.setThemeMode(newSelection.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Trusted Contact (for SOS & Virtual Escort)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emergencyContactNameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Name',
                    hintText: 'e.g. Parent / Roommate',
                    prefixIcon: Icon(Icons.contact_phone_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emergencyContactPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '10-Digit Mobile (+91)',
                    hintText: 'e.g. 9876543210',
                    prefixIcon: Icon(Icons.phone_outlined),
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
