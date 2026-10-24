import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/indian_formatters.dart';
import '../../../../main.dart';
import '../../../../shared/components/compad_card.dart';
import '../../../../shared/components/tinted_icon_circle.dart';
import '../../../campus/data/indian_emergency_directory.dart';

// 1. First Aid Guide (compad_first_aid_guide)
class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    final protocols = [
      {'title': 'Cardiopulmonary Resuscitation (CPR)', 'steps': '1. Check responsiveness and call 112.\n2. Place hands in center of chest.\n3. Push hard & fast (100–120 bpm) to 2 inches depth.\n4. Continue until medical help arrives.'},
      {'title': 'Severe Bleeding & Wounds', 'steps': '1. Apply firm direct pressure with clean cloth.\n2. Elevate injured limb above heart level.\n3. Do NOT remove embedded objects.\n4. Apply pressure bandage.'},
      {'title': 'Heat Exhaustion & Sunstroke', 'steps': '1. Move person to cool shade or AC room.\n2. Loosen tight clothing.\n3. Sip cool water with ORS or salt.\n4. Apply damp towels to neck, armpits, and groin.'},
      {'title': 'Fractures & Sprains (R.I.C.E)', 'steps': '1. Rest the limb; do not move or bear weight.\n2. Ice applied in towel for 20 mins.\n3. Compress with crepe bandage.\n4. Elevate above heart level.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency First Aid (ICMR)', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: CompadColors.urgentRed.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.medical_services_rounded, tintColor: CompadColors.urgentRed),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Red Cross & ICMR Protocols', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Offline emergency guide. For life-threatening emergencies, immediately dial 112.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...protocols.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CompadCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      Text(p['steps'] as String, style: TextStyle(fontSize: 13, color: colors.subtext, height: 1.4)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CompadColors.urgentRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => IndianEmergencyDirectory.callNumber(IndianEmergencyDirectory.nationalEmergency112),
            icon: const Icon(Icons.emergency_rounded),
            label: const Text('Call 112 National Ambulance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

// 2. Exam Stress SOS Toolkit (compad_exam_stress_toolkit)
class StressToolkitScreen extends StatelessWidget {
  const StressToolkitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Exam Stress SOS Toolkit', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.wellbeingTint.withOpacity(0.12),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.spa_rounded, tintColor: colors.wellbeingTint),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('5-4-3-2-1 Sensory Grounding', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 2),
                      Text('Regain presence and halt racing thoughts during pre-exam panic.', style: TextStyle(fontSize: 12)),
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
                const Text('Grounding Steps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                _buildGroundingItem('5', 'LOOK for 5 things you can see around you.', colors),
                _buildGroundingItem('4', 'TOUCH 4 things you can feel (chair, pen, desk).', colors),
                _buildGroundingItem('3', 'LISTEN for 3 distinct sounds in the room.', colors),
                _buildGroundingItem('2', 'SMELL 2 scents in the air (paper, coffee).', colors),
                _buildGroundingItem('1', 'TASTE 1 taste in your mouth, or sip cool water.', colors),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Need someone to talk to?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text('Tele-MANAS is a free, confidential mental health helpline run 24/7 by the Government of India.', style: TextStyle(fontSize: 12, color: colors.subtext)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.wellbeingTint,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => IndianEmergencyDirectory.callNumber(IndianEmergencyDirectory.teleManas14416),
                  icon: const Icon(Icons.phone_in_talk_rounded),
                  label: const Text('Call Tele-MANAS (14416)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroundingItem(String num, String text, CompadThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: colors.wellbeingTint, shape: BoxShape.circle),
            child: Center(child: Text(num, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.3))),
        ],
      ),
    );
  }
}

// 3. Sleep & Wellness Log (compad_sleep_wellness_log)
class SleepLogScreen extends ConsumerStatefulWidget {
  const SleepLogScreen({super.key});

  @override
  ConsumerState<SleepLogScreen> createState() => _SleepLogScreenState();
}

class _SleepLogScreenState extends ConsumerState<SleepLogScreen> {
  final _bedCtrl = TextEditingController(text: '11:30 PM');
  final _wakeCtrl = TextEditingController(text: '07:00 AM');
  int _qualityStars = 4;

  @override
  void dispose() {
    _bedCtrl.dispose();
    _wakeCtrl.dispose();
    super.dispose();
  }

  void _saveSleepLog(AppDatabase db, CompadThemeColors colors) async {
    final now = DateTime.now();
    await db.into(db.sleepLogsTable).insert(
          SleepLogsTableCompanion.insert(
            id: const Uuid().v4(),
            date: now,
            bedTime: _bedCtrl.text.trim(),
            wakeTime: _wakeCtrl.text.trim(),
            durationMinutes: 450, // default ~7.5 hours
            qualityRating: drift.Value(_qualityStars),
          ),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sleep log recorded successfully!'),
          backgroundColor: colors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep & Wellness Log', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder<List<SleepLogsTableData>>(
        stream: db.select(db.sleepLogsTable).watch(),
        builder: (context, snapshot) {
          final logs = snapshot.data ?? [];
          final lastLog = logs.isNotEmpty ? logs.last : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CompadCard(
                color: colors.wellbeingTint.withOpacity(0.08),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    TintedIconCircle(icon: Icons.bedtime_rounded, tintColor: colors.wellbeingTint),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lastLog != null
                                ? 'Recent Sleep: ${lastLog.bedTime} → ${lastLog.wakeTime}'
                                : 'Recent Sleep: 7 hrs 15 mins',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lastLog != null
                                ? 'Quality: ${"⭐" * lastLog.qualityRating} • Recorded on ${IndianFormatters.formatDate(lastLog.date)}'
                                : 'Bedtime: 11:30 PM • Wakeup: 06:45 AM • Quality: Good ⭐⭐⭐⭐',
                            style: TextStyle(fontSize: 12, color: colors.subtext),
                          ),
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
                    const Text('Log Sleep Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _bedCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Bedtime',
                              hintText: '11:00 PM',
                              prefixIcon: Icon(Icons.nightlight_round, size: 18),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _wakeCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Wake time',
                              hintText: '07:00 AM',
                              prefixIcon: Icon(Icons.wb_sunny_rounded, size: 18),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text('Sleep Quality: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        ...List.generate(5, (idx) {
                          final star = idx + 1;
                          return IconButton(
                            icon: Icon(
                              star <= _qualityStars ? Icons.star_rounded : Icons.star_border_rounded,
                              color: colors.warning,
                              size: 22,
                            ),
                            onPressed: () => setState(() => _qualityStars = star),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.wellbeingTint,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _saveSleepLog(db, colors),
                      child: const Text('Save Sleep Entry'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sleep History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${logs.length} logged', style: TextStyle(fontSize: 12, color: colors.subtext)),
                ],
              ),
              const SizedBox(height: 10),

              if (logs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('No custom sleep entries logged yet.', style: TextStyle(color: colors.subtext, fontSize: 13)),
                  ),
                )
              else
                ...logs.reversed.map((l) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CompadCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.bedtime_outlined, color: colors.wellbeingTint, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${l.bedTime}  →  ${l.wakeTime}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text('${IndianFormatters.formatDate(l.date)} • Quality: ${"⭐" * l.qualityRating}', style: TextStyle(fontSize: 11, color: colors.subtext)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, size: 20, color: colors.urgent),
                            onPressed: () async {
                              await (db.delete(db.sleepLogsTable)..where((t) => t.id.equals(l.id))).go();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

// 4. Mess Nutrition Tracker (compad_nutrition_tracker)
class NutritionTrackerScreen extends ConsumerStatefulWidget {
  const NutritionTrackerScreen({super.key});

  @override
  ConsumerState<NutritionTrackerScreen> createState() => _NutritionTrackerScreenState();
}

class _NutritionTrackerScreenState extends ConsumerState<NutritionTrackerScreen> {
  double _waterGlasses = 6.0;

  void _showAddMealDialog(BuildContext context, AppDatabase db, CompadThemeColors colors) {
    String mealType = 'Lunch';
    final itemsCtrl = TextEditingController(text: '2 Chapatis, Dal Makhani, Steamed Rice, Curd');
    final calCtrl = TextEditingController(text: '520');
    bool isVeg = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Log Campus Meal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: mealType,
                  decoration: const InputDecoration(labelText: 'Meal Type', border: OutlineInputBorder()),
                  items: ['Breakfast', 'Lunch', 'Evening Snacks', 'Dinner']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (val) => setModalState(() => mealType = val ?? 'Lunch'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: itemsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Food Items',
                    hintText: 'e.g. Idli Sambhar, Chai',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: calCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Estimated Calories (kcal)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        const Text('Veg: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Switch(
                          value: isVeg,
                          onChanged: (v) => setModalState(() => isVeg = v),
                          activeColor: colors.success,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.wellbeingTint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    final cals = int.tryParse(calCtrl.text.trim()) ?? 400;
                    await db.into(db.nutritionLogsTable).insert(
                          NutritionLogsTableCompanion.insert(
                            id: const Uuid().v4(),
                            date: DateTime.now(),
                            mealType: mealType,
                            foodItems: itemsCtrl.text.trim(),
                            calories: drift.Value(cals),
                            isVeg: drift.Value(isVeg),
                          ),
                        );
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: const Text('Save Meal', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mess Nutrition Tracker', style: TextStyle(fontWeight: FontWeight.bold))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMealDialog(context, db, colors),
        backgroundColor: colors.wellbeingTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Log Meal', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<List<NutritionLogsTableData>>(
        stream: db.select(db.nutritionLogsTable).watch(),
        builder: (context, snapshot) {
          final meals = snapshot.data ?? [];
          final totalCalories = meals.fold<int>(0, (acc, m) => acc + m.calories);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Today’s Intake Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacroPill('Calories', '$totalCalories', 'kcal', colors.academicsTint),
                        _buildMacroPill('Meals Logged', '${meals.length}', 'items', colors.campusTint),
                        _buildMacroPill('Water', '${(_waterGlasses * 0.25).toStringAsFixed(1)}', 'L', colors.wellbeingTint),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Water glass tracker
              CompadCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_drink_rounded, color: colors.campusTint, size: 24),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_waterGlasses.toInt()} Glasses Water', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('${(_waterGlasses * 250).toInt()} ml of 2,500 ml target', style: TextStyle(fontSize: 11, color: colors.subtext)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _waterGlasses > 0 ? () => setState(() => _waterGlasses -= 1) : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: colors.campusTint),
                          onPressed: () => setState(() => _waterGlasses += 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Today’s Meals Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${meals.length} records', style: TextStyle(fontSize: 12, color: colors.subtext)),
                ],
              ),
              const SizedBox(height: 10),

              if (meals.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.restaurant_outlined, size: 40, color: colors.subtext),
                        const SizedBox(height: 8),
                        Text('No meals logged yet today.', style: TextStyle(color: colors.subtext, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('Tap "Log Meal" below to record canteen food.', style: TextStyle(color: colors.subtext, fontSize: 12)),
                      ],
                    ),
                  ),
                )
              else
                ...meals.map((m) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CompadCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              border: Border.all(color: m.isVeg ? const Color(0xFF16A34A) : const Color(0xFFDC2626), width: 1.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: m.isVeg ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.mealType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(m.foodItems, style: TextStyle(fontSize: 12, color: colors.subtext)),
                              ],
                            ),
                          ),
                          Text('${m.calories} kcal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.wellbeingTint)),
                          IconButton(
                            icon: Icon(Icons.delete_outline, size: 18, color: colors.urgent),
                            onPressed: () async {
                              await (db.delete(db.nutritionLogsTable)..where((t) => t.id.equals(m.id))).go();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMacroPill(String label, String val, String unit, Color c) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: c)),
        Text('$label ($unit)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
