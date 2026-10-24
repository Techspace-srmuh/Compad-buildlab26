import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/components/compad_card.dart';
import '../../../../shared/components/tinted_icon_circle.dart';

// 1. Local Backup & Restore Screen (compad_local_backup_restore)
class BackupRestoreScreen extends StatelessWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Local Backup & Restore', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.academicsTint.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.backup_rounded, tintColor: colors.academicsTint),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Zero-Cloud Device Backups', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Export your entire local SQLite database (notes, grades, attendance) as an encrypted file.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
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
                const Text('Create New Backup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text('Saves to your Downloads folder: compad_backup_20261021.sqlite', style: TextStyle(fontSize: 12, color: colors.subtext)),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: colors.academicsTint, foregroundColor: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup created: compad_backup_20261021.sqlite (142 KB)')));
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Export Backup Now'),
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
                const Text('Restore from Backup File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text('Select a previously exported .sqlite or .json backup file.', style: TextStyle(fontSize: 12, color: colors.subtext)),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening file picker for restore...')));
                  },
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Select Backup File'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Language & Script Settings (compad_language_settings)
class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLang = 'en_IN';

  final languages = [
    {'code': 'en_IN', 'name': 'English (India)', 'script': 'Latin', 'native': 'English'},
    {'code': 'hi_IN', 'name': 'Hindi', 'script': 'Devanagari', 'native': 'हिन्दी'},
    {'code': 'mr_IN', 'name': 'Marathi', 'script': 'Devanagari', 'native': 'मराठी'},
    {'code': 'bn_IN', 'name': 'Bengali', 'script': 'Bengali', 'native': 'বাংলা'},
    {'code': 'te_IN', 'name': 'Telugu', 'script': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'ta_IN', 'name': 'Tamil', 'script': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'gu_IN', 'name': 'Gujarati', 'script': 'Gujarati', 'native': 'ગુજરાતી'},
    {'code': 'kn_IN', 'name': 'Kannada', 'script': 'Kannada', 'native': 'ಕನ್ನಡ'},
    {'code': 'ml_IN', 'name': 'Malayalam', 'script': 'Malayalam', 'native': 'മലയാളം'},
    {'code': 'pa_IN', 'name': 'Punjabi', 'script': 'Gurmukhi', 'native': 'ਪੰਜਾਬੀ'},
    {'code': 'ur_PK', 'name': 'Urdu (RTL)', 'script': 'Nastaliq / Arabic', 'native': 'اردو'},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Language & Indic Scripts', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.campusTint.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.translate_rounded, tintColor: colors.campusTint),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Indic Script Typography Standards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Line heights >= 1.4 applied across all screens to ensure no upper matras or conjuncts are clipped.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...languages.map((l) {
            final isSelected = _selectedLang == l['code'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CompadCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onTap: () {
                  setState(() => _selectedLang = l['code'] as String);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Language switched to ${l['name']}')));
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l['native'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('${l['name']} • Script: ${l['script']}', style: TextStyle(fontSize: 12, color: colors.subtext)),
                        ],
                      ),
                    ),
                    if (isSelected) Icon(Icons.check_circle_rounded, color: colors.academicsTint),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// 3. Home Screen Widgets Preview (compad_home_screen_widgets)
class WidgetsScreen extends StatelessWidget {
  const WidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen Widgets', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.academicsTint.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.widgets_rounded, tintColor: colors.academicsTint),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Android Glance Widgets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Long-press on your phone home screen to place Compad Quick Widgets.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Available Widgets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          // Widget 1: Next Class
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Next Class Widget (2×2)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(8)), child: const Text('Medium', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      TintedIconCircle(icon: Icons.school_rounded, tintColor: colors.academicsTint),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Operating Systems', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('10:00 AM • Room LH 101', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Widget 2: Attendance Ring
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Attendance Health Ring (1×1)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(8)), child: const Text('Small', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      CircularProgressIndicator(value: 0.82, color: colors.campusTint, backgroundColor: colors.cardBackground),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('82% Overall', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('3 safe skips available', style: TextStyle(fontSize: 11, color: Colors.green)),
                        ],
                      ),
                    ],
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
