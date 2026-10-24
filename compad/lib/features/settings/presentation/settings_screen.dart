import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/seed_loader.dart';
import '../../../core/upi/upi_payment_dialog.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';
import '../../../shared/widgets/compad_logo.dart';
import '../../campus/domain/offline_map_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _studentName = '';
  String _enrollmentNo = '';
  String _apaarId = '';
  String _course = '';
  String _upiId = '';
  String _selectedCampusId = 'iit_bombay';
  String _selectedCampusName = 'IIT Bombay';
  bool _workingDaysMonSat = true;
  double _attendanceThreshold = 75.0;

  @override
  void initState() {
    super.initState();
    _loadStoredSettings();
  }

  Future<void> _loadStoredSettings() async {
    final db = ref.read(appDatabaseProvider);
    final profile = await (db.select(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).getSingleOrNull();

    final prefs = await SharedPreferences.getInstance();

    if (profile != null) {
      setState(() {
        _studentName = profile.fullName;
        _enrollmentNo = profile.enrollmentNumber;
        _apaarId = profile.apaarId ?? '';
        _course = profile.degree.isNotEmpty ? '${profile.degree} (${profile.branch})' : '';
        _upiId = profile.upiId;
        _selectedCampusId = profile.selectedCampusId.isNotEmpty ? profile.selectedCampusId : 'iit_bombay';
        _selectedCampusName = profile.selectedCampusName.isNotEmpty ? profile.selectedCampusName : 'IIT Bombay';
        _attendanceThreshold = profile.attendanceRuleThreshold;
      });
    } else {
      setState(() {
        _studentName = prefs.getString('student_name') ?? '';
        _enrollmentNo = prefs.getString('enrollment_no') ?? '';
        _apaarId = prefs.getString('apaar_id') ?? '';
        _course = prefs.getString('student_course') ?? '';
        _upiId = prefs.getString('student_upi_id') ?? '';
        _selectedCampusId = prefs.getString('selected_campus_id') ?? 'iit_bombay';
        _selectedCampusName = prefs.getString('selected_campus_name') ?? 'IIT Bombay';
        _workingDaysMonSat = prefs.getBool('working_days_mon_sat') ?? true;
        _attendanceThreshold = prefs.getDouble('attendance_threshold') ?? 75.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeState = ref.watch(themeControllerProvider);
    final themeNotifier = ref.read(themeControllerProvider.notifier);
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          // 1. Profile Section
          _buildSectionHeader('Profile & Student Identity', Icons.person_rounded, compadColors.academicsTint),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: compadColors.academicsTint.withAlpha(40),
                      child: Text(
                        _studentName.isNotEmpty ? _studentName[0].toUpperCase() : 'S',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: compadColors.academicsTint,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_studentName.isNotEmpty ? _studentName : 'Setup Student Profile', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text('${_course.isNotEmpty ? _course : 'Course not set'} • Roll: ${_enrollmentNo.isNotEmpty ? _enrollmentNo : 'Not set'}', style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                          const SizedBox(height: 2),
                          Text('Campus: $_selectedCampusName • UPI: ${_upiId.isNotEmpty ? _upiId : 'Not configured'}', style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit Profile & Campus',
                      onPressed: () => _showEditProfileDialog(),
                    ),
                  ],
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: TintedIconCircle(icon: Icons.edit_note_rounded, tintColor: compadColors.academicsTint),
                  title: const Text('Edit Profile / Change Campus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Switch campus, update Roll No, course, and UPI ID', style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showEditProfileDialog(),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: TintedIconCircle(icon: Icons.map_rounded, tintColor: compadColors.campusTint),
                  title: const Text('Offline Campus Map Manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Download, update, or verify local campus maps', style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/campus/map-download'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: TintedIconCircle(icon: Icons.school_rounded, tintColor: compadColors.warning),
                  title: const Text('App Tutorial (Interactive Replay)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Replay the 5-screen campus companion walkthrough', style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/tutorial'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: TintedIconCircle(icon: Icons.currency_rupee_rounded, tintColor: compadColors.success),
                  title: const Text('Launch UPI Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Instant GPay, PhonePe, Paytm, BHIM campus payment', style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => UpiPaymentDialog.show(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Appearance Section
          _buildSectionHeader('Appearance & Display', Icons.palette_rounded, compadColors.campusTint),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Theme Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
                    ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                  ],
                  selected: {themeState.themeMode},
                  onSelectionChanged: (Set<ThemeMode> newSelection) {
                    themeNotifier.setThemeMode(newSelection.first);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Accent Color', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildColorChoice(const Color(0xFF3F3DDB), 'Indigo', themeState.userAccent, themeNotifier),
                    _buildColorChoice(const Color(0xFF0D9488), 'Teal', themeState.userAccent, themeNotifier),
                    _buildColorChoice(const Color(0xFFD97706), 'Amber', themeState.userAccent, themeNotifier),
                    _buildColorChoice(const Color(0xFF7C3AED), 'Violet', themeState.userAccent, themeNotifier),
                    _buildColorChoice(const Color(0xFF059669), 'Emerald', themeState.userAccent, themeNotifier),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Text Scale Factor', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text('${(themeState.textScale * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: compadColors.campusTint)),
                  ],
                ),
                Slider(
                  value: themeState.textScale,
                  min: 0.85,
                  max: 1.30,
                  divisions: 3,
                  activeColor: compadColors.campusTint,
                  onChanged: (val) => themeNotifier.setTextScale(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Academics Settings
          _buildSectionHeader('Academics & Schedule', Icons.school_rounded, compadColors.academicsTint),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Monday – Saturday Schedule', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Follow 6-day academic week common in Indian colleges', style: TextStyle(fontSize: 12)),
                  value: _workingDaysMonSat,
                  onChanged: (val) async {
                    setState(() => _workingDaysMonSat = val);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('working_days_mon_sat', val);
                  },
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mandatory Attendance Rule', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('${_attendanceThreshold.toInt()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: compadColors.academicsTint)),
                  ],
                ),
                Slider(
                  value: _attendanceThreshold,
                  min: 60.0,
                  max: 85.0,
                  divisions: 5,
                  activeColor: compadColors.academicsTint,
                  onChanged: (val) async {
                    setState(() => _attendanceThreshold = val);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('attendance_threshold', val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Region & Formats (Phase F1)
          _buildSectionHeader('Region & Formats (India)', Icons.language_rounded, compadColors.lifeTint),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('Locale', 'en_IN (English - India)'),
                _buildInfoRow('Timezone', 'Asia/Kolkata (IST, UTC+5:30)'),
                _buildInfoRow('Currency', '₹ (Indian Rupee, Lakhs/Crores)'),
                _buildInfoRow('Date Format', 'DD/MM/YYYY (21 Oct 2026)'),
                _buildInfoRow('Grading Scheme', '10-Point CGPA (UGC CBCS/NEP-2020)'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. Battery Optimization & Background Execution (Phase F10)
          _buildSectionHeader('Battery & Timetable Reminders', Icons.battery_charging_full_rounded, compadColors.warning),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keep Class & Exam Alarms Reliable',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  'Indian Android phones (MIUI/HyperOS, ColorOS, Funtouch, Realme UI, Samsung) aggressively terminate background alarms. Ensure Compad is exempt from battery saver to receive "leave now" class alerts.',
                  style: TextStyle(fontSize: 12, color: compadColors.subtext),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showBatteryOptimizationHelp(),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: const Text('View Phone-Specific Steps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: compadColors.warning.withAlpha(30),
                    foregroundColor: compadColors.warning,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 6. Privacy & Legal (DPDP Act 2023 - Phase F9)
          _buildSectionHeader('Privacy & Data Governance', Icons.shield_rounded, compadColors.wellbeingTint),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Digital Personal Data Protection Act 2023', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Granular opt-in consent, no advertising, local data storage in India.', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showConsentManager(),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Grievance Officer Contact', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('grievance@compad.in • Response within 72 hours per IT Rules.', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 7. Campus Data & Demo Data Controls (Phase C1)
          _buildSectionHeader('Campus Data & Demo Pack', Icons.dataset_rounded, compadColors.campusTint),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Try Demo University Data', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Loads sample Indian curriculum timetable, tasks, and attendance labeled "Example University".', style: TextStyle(fontSize: 12)),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final db = ref.read(appDatabaseProvider);
                      final loader = SeedDataLoader(db);
                      await loader.loadDemoData();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Demo curriculum loaded!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: compadColors.campusTint,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Load Demo'),
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Clear Demo Data', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Removes all sample entries and restores an empty slate.', style: TextStyle(fontSize: 12)),
                  trailing: OutlinedButton(
                    onPressed: () async {
                      final db = ref.read(appDatabaseProvider);
                      final loader = SeedDataLoader(db);
                      await loader.clearAllData();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All data cleared successfully!')),
                        );
                      }
                    },
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 8. Danger Zone
          _buildSectionHeader('Danger Zone', Icons.warning_amber_rounded, compadColors.urgent),
          CompadCard(
            accentBorderColor: compadColors.urgent,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delete All My Data (Right to Erasure)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: CompadColors.urgentRed)),
                const SizedBox(height: 4),
                Text(
                  'Permanently erases all timetable entries, attendance records, encrypted health logs, and credentials from this device. Complies with DPDP Act 2023.',
                  style: TextStyle(fontSize: 12, color: compadColors.subtext),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _confirmEraseAllData(),
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text('Delete All My Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: compadColors.urgent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Compad Footer
          Center(
            child: Column(
              children: [
                const CompadLogo(size: 32, showText: true),
                const SizedBox(height: 6),
                Text(
                  'Compad v1.0.0 • Offline-First Campus Companion\nDesigned for Higher Education in India',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: compadColors.subtext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color tint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        children: [
          TintedIconCircle(icon: icon, tintColor: tint, size: 28, iconSize: 16),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildColorChoice(Color color, String name, Color current, ThemeController controller) {
    final isSelected = current.toARGB32() == color.toARGB32();
    return GestureDetector(
      onTap: () => controller.setUserAccent(color),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected ? [BoxShadow(color: color.withAlpha(120), blurRadius: 8)] : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _studentName);
    final rollCtrl = TextEditingController(text: _enrollmentNo);
    final apaarCtrl = TextEditingController(text: _apaarId);
    final courseCtrl = TextEditingController(text: _course);
    final upiCtrl = TextEditingController(text: _upiId);
    String dialogCampusId = _selectedCampusId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Profile & Campus'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
                const SizedBox(height: 8),
                TextField(controller: rollCtrl, decoration: const InputDecoration(labelText: 'Enrollment / Roll No.')),
                const SizedBox(height: 8),
                TextField(controller: apaarCtrl, decoration: const InputDecoration(labelText: '12-digit APAAR / ABC ID')),
                const SizedBox(height: 8),
                TextField(controller: courseCtrl, decoration: const InputDecoration(labelText: 'Degree / Course')),
                const SizedBox(height: 8),
                TextField(
                  controller: upiCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Student UPI ID (Optional VPA)',
                    hintText: 'e.g. name@oksbi',
                    prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: dialogCampusId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Current University Campus',
                    prefixIcon: Icon(Icons.account_balance_rounded, size: 18),
                  ),
                  items: OfflineCampusMapService.officialCampuses.map((c) {
                    return DropdownMenuItem(
                      value: c.id,
                      child: Text('${c.name} (${c.city})'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => dialogCampusId = val);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final campusObj = OfflineCampusMapService.officialCampuses.firstWhere((c) => c.id == dialogCampusId);

                final db = ref.read(appDatabaseProvider);
                await db.into(db.studentProfileTable).insertOnConflictUpdate(
                      StudentProfileTableCompanion.insert(
                        id: 'profile_main',
                        fullName: drift.Value(nameCtrl.text.trim()),
                        enrollmentNumber: drift.Value(rollCtrl.text.trim()),
                        apaarId: drift.Value(apaarCtrl.text.trim().isEmpty ? null : apaarCtrl.text.trim()),
                        branch: drift.Value(courseCtrl.text.trim()),
                        upiId: drift.Value(upiCtrl.text.trim()),
                        selectedCampusId: drift.Value(dialogCampusId),
                        selectedCampusName: drift.Value(campusObj.name),
                        college: drift.Value(campusObj.name),
                        city: drift.Value(campusObj.city),
                        state: drift.Value(campusObj.state),
                        updatedAt: DateTime.now(),
                      ),
                    );

                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('student_name', nameCtrl.text.trim());
                await prefs.setString('enrollment_no', rollCtrl.text.trim());
                await prefs.setString('apaar_id', apaarCtrl.text.trim());
                await prefs.setString('student_course', courseCtrl.text.trim());
                await prefs.setString('student_upi_id', upiCtrl.text.trim());
                await prefs.setString('selected_campus_id', dialogCampusId);
                await prefs.setString('selected_campus_name', campusObj.name);

                setState(() {
                  _studentName = nameCtrl.text.trim();
                  _enrollmentNo = rollCtrl.text.trim();
                  _apaarId = apaarCtrl.text.trim();
                  _course = courseCtrl.text.trim();
                  _upiId = upiCtrl.text.trim();
                  _selectedCampusId = dialogCampusId;
                  _selectedCampusName = campusObj.name;
                });

                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBatteryOptimizationHelp() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Keep Reminders Working (OEM Guides)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('• Xiaomi / Redmi / POCO: Settings > Apps > Manage Apps > Compad > Enable Autostart, Battery Saver: "No restrictions".'),
            const SizedBox(height: 8),
            const Text('• OnePlus / Oppo / Realme: Settings > Battery > More battery settings > App Battery Management > Allow background activity.'),
            const SizedBox(height: 8),
            const Text('• Samsung: Settings > Battery > Background usage limits > Never sleeping apps > Add Compad.'),
            const SizedBox(height: 8),
            const Text('• Vivo / iQOO: Settings > Battery > High background power consumption > Enable Compad.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Center(child: Text('Understood')),
            ),
          ],
        ),
      ),
    );
  }

  void _showConsentManager() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('DPDP Act 2023 Consent Manager'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Purpose Limitation & Data Minimisation:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• 100% On-Device: Timetables, notes, attendance, and emergency contacts remain stored only on your phone.'),
            SizedBox(height: 6),
            Text('• Encrypted Health Logs: Mood entries and counseling notes are locked with AES-256 encryption.'),
            SizedBox(height: 6),
            Text('• No Commercial Tracking: Zero third-party advertising SDKs or behavioural telemetry.'),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _confirmEraseAllData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erase All Data?'),
        content: const Text('This will delete all courses, timetable records, grades, notes, and local files permanently. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CompadColors.urgentRed, foregroundColor: Colors.white),
            onPressed: () async {
              final db = ref.read(appDatabaseProvider);
              final loader = SeedDataLoader(db);
              await loader.clearAllData();
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (mounted) context.go('/onboarding');
            },
            child: const Text('Yes, Erase Everything'),
          ),
        ],
      ),
    );
  }
}
