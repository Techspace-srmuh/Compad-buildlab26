import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';
import '../../campus/data/indian_emergency_directory.dart';

class WellbeingHubScreen extends ConsumerStatefulWidget {
  const WellbeingHubScreen({super.key});

  @override
  ConsumerState<WellbeingHubScreen> createState() => _WellbeingHubScreenState();
}

class _WellbeingHubScreenState extends ConsumerState<WellbeingHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMood = 4;
  String? _symptomDecision;
  bool _breathingIn = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: compadColors.wellbeingTint,
          unselectedLabelColor: compadColors.subtext,
          indicatorColor: compadColors.wellbeingTint,
          tabs: const [
            Tab(text: 'Daily Mood Log'),
            Tab(text: 'Symptom Triage (MoHFW)'),
            Tab(text: 'Exam Stress & Breathing'),
            Tab(text: 'Gym & Fitness'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMoodTab(compadColors, db),
          _buildSymptomCheckerTab(compadColors),
          _buildBreathingTab(compadColors),
          _buildGymTab(compadColors),
        ],
      ),
    );
  }

  // --- TAB 1: DAILY MOOD ---
  Widget _buildMoodTab(CompadThemeColors colors, AppDatabase db) {
    final moods = [
      {'val': 1, 'emoji': '😫', 'label': 'Exhausted'},
      {'val': 2, 'emoji': '😕', 'label': 'Stressed'},
      {'val': 3, 'emoji': '😐', 'label': 'Neutral'},
      {'val': 4, 'emoji': '🙂', 'label': 'Good'},
      {'val': 5, 'emoji': '🤩', 'label': 'Energized'},
    ];

    return StreamBuilder<List<MoodTableData>>(
      stream: db.select(db.moodTable).watch(),
      builder: (context, snapshot) {
        final moodLogs = snapshot.data ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            CompadCard(
              color: colors.chipBackground,
              accentBorderColor: colors.wellbeingTint,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('How are you feeling right now?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      if (moodLogs.isNotEmpty)
                        Text('${moodLogs.length} logs', style: TextStyle(fontSize: 11, color: colors.subtext)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: moods.map((m) {
                      final isSelected = _selectedMood == m['val'];
                      return GestureDetector(
                        onTap: () async {
                          setState(() => _selectedMood = m['val'] as int);
                          await db.into(db.moodTable).insert(
                                MoodTableCompanion.insert(
                                  id: 'mood-${DateTime.now().millisecondsSinceEpoch}',
                                  score: m['val'] as int,
                                  emotion: m['label'] as String,
                                  notes: const Value('Daily check-in'),
                                  timestamp: DateTime.now(),
                                ),
                              );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Mood recorded: ${m['label']} ${m['emoji']}')),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: isSelected ? colors.wellbeingTint : colors.cardBackground,
                                shape: BoxShape.circle,
                                boxShadow: isSelected
                                    ? [BoxShadow(color: colors.wellbeingTint.withAlpha(80), blurRadius: 10, offset: const Offset(0, 3))]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(m['emoji'] as String, style: const TextStyle(fontSize: 26)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              m['label'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? colors.wellbeingTint : colors.subtext,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tele-MANAS Mental Health Support Card
            CompadCard(
              padding: const EdgeInsets.all(16),
              color: colors.chipBackground,
              onTap: () => IndianEmergencyDirectory.callNumber(IndianEmergencyDirectory.teleManas14416),
              child: Row(
                children: [
                  Icon(Icons.support_agent_rounded, size: 36, color: colors.wellbeingTint),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tele-MANAS & KIRAN Helplines (Tap to Call)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(
                          '24/7 free toll-free psychological support for exam anxiety, loneliness, and emotional distress. Call 14416 or 1800-599-0019.',
                          style: TextStyle(fontSize: 11, color: colors.subtext, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.phone_in_talk_rounded, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Exam Stress & Wellness Modules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildWellbeingTool('5-4-3-2-1 Sensory Grounding & SOS', 'Overcome panic & acute exam anxiety in 3 minutes', Icons.healing_rounded, () => context.push('/wellbeing/stress-toolkit'), colors),
            _buildWellbeingTool('Emergency First Aid (ICMR / Red Cross)', 'CPR, bleeding, heatstroke & fracture care', Icons.medical_services_rounded, () => context.push('/wellbeing/first-aid'), colors),
            _buildWellbeingTool('Sleep & Wellness Duration Log', 'Optimize circadian cycle during exam revision weeks', Icons.bedtime_rounded, () => context.push('/wellbeing/sleep'), colors),
            _buildWellbeingTool('Mess Nutrition & Calorie Estimator', 'Indian mess diets, protein & hydration tracker', Icons.egg_alt_rounded, () => context.push('/wellbeing/nutrition'), colors),
          ],
        );
      },
    );
  }

  Widget _buildWellbeingTool(String title, String desc, IconData icon, VoidCallback onTap, CompadThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CompadCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            TintedIconCircle(icon: icon, tintColor: colors.wellbeingTint, size: 44, iconSize: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(fontSize: 12, color: colors.subtext)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: SYMPTOM TRIAGE (MoHFW GUIDANCE) ---
  Widget _buildSymptomCheckerTab(CompadThemeColors colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        // Mandatory Medical Disclaimer
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.bannerWarningBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.warning),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_rounded, color: colors.bannerWarningText, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'MANDATORY DISCLAIMER: This symptom checker is a conservative triage tree based on public health guidance (MoHFW/ICMR). It is NOT a medical diagnosis. For life-threatening emergencies, call 112 or visit the campus health center immediately.',
                  style: TextStyle(fontSize: 11, color: colors.bannerWarningText, height: 1.35, fontWeight: FontWeight.w600),
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
              const Text('Rule-Based Triage Evaluation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 6),
              Text('Select what you are currently experiencing:', style: TextStyle(fontSize: 12, color: colors.subtext)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSymptomChip('Fever & Body Ache', colors),
                  _buildSymptomChip('Acute Exam Anxiety / Panic', colors),
                  _buildSymptomChip('Dehydration & Heat Exhaustion', colors),
                  _buildSymptomChip('Acid Reflux & Stomach Upset', colors),
                ],
              ),
              if (_symptomDecision != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.chipBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.health_and_safety_rounded, color: colors.wellbeingTint, size: 20),
                          const SizedBox(width: 8),
                          Text('Triage Guidance: $_symptomDecision', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getGuidanceText(_symptomDecision!),
                        style: TextStyle(fontSize: 12, color: colors.subtext, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomChip(String label, CompadThemeColors colors) {
    final isSelected = _symptomDecision == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: colors.wellbeingTint,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : colors.subtext,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      onSelected: (selected) {
        setState(() => _symptomDecision = selected ? label : null);
      },
    );
  }

  String _getGuidanceText(String symptom) {
    switch (symptom) {
      case 'Fever & Body Ache':
        return 'Hydrate with boiled lukewarm water and ORS. Rest in a well-ventilated hostel room. If temperature exceeds 101°F for over 48 hours or accompanied by severe rash, visit Campus Health Clinic to test for Dengue/Malaria.';
      case 'Acute Exam Anxiety / Panic':
        return 'Practice 4-4-4 box breathing (see tab 3). Ground yourself: drink a glass of water. If panic is overwhelming, immediately dial Tele-MANAS (14416 toll-free) for free counseling.';
      case 'Dehydration & Heat Exhaustion':
        return 'Move to an air-conditioned room. Drink chilled ORS or electrolyte water. Avoid heavy physical exercise under afternoon sun. If confusion or vomiting occurs, call 108 ambulance.';
      default:
        return 'Avoid spicy mess food. Drink tender coconut water or buttermilk. Consult the campus doctor if symptoms persist.';
    }
  }

  // --- TAB 3: BREATHING ---
  Widget _buildBreathingTab(CompadThemeColors colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        CompadCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Text('4-4-4 Box Breathing for Exam Calm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Text('Inhale 4s • Hold 4s • Exhale 4s to regulate parasympathetic vagus nerve response.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: colors.subtext)),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => setState(() => _breathingIn = !_breathingIn),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 4),
                  width: _breathingIn ? 160 : 100,
                  height: _breathingIn ? 160 : 100,
                  decoration: BoxDecoration(
                    color: colors.wellbeingTint.withAlpha(_breathingIn ? 70 : 30),
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.wellbeingTint, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _breathingIn ? 'INHALE' : 'EXHALE',
                    style: TextStyle(fontWeight: FontWeight.bold, color: colors.wellbeingTint, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => setState(() => _breathingIn = !_breathingIn),
                icon: const Icon(Icons.touch_app_rounded),
                label: const Text('Tap to Cycle Phase'),
                style: ElevatedButton.styleFrom(backgroundColor: colors.wellbeingTint, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 4: GYM & FITNESS ---
  Widget _buildGymTab(CompadThemeColors colors) {
    final exercises = [
      {'name': 'Campus Pull-Up Bar', 'target': 'Back & Biceps', 'tip': 'Full range of motion, avoid swinging.'},
      {'name': 'Hostel Room Push-Ups', 'target': 'Chest & Core', 'tip': 'Keep elbows at 45 degrees, 3 sets of 15.'},
      {'name': 'Track Jogging / Brisk Walk', 'target': 'Cardio & Stamina', 'tip': '4 laps around campus athletic track (1.6 km).'},
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        ...exercises.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Target: ${e['target']!}', style: TextStyle(fontSize: 12, color: colors.wellbeingTint, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(e['tip']!, style: TextStyle(fontSize: 12, color: colors.subtext)),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
