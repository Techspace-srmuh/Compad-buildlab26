import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/components/compad_card.dart';
import '../data/indian_emergency_directory.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency & Safety Hub',
          style: TextStyle(color: compadColors.urgent, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: compadColors.urgent),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          // 1. Red Emergency Banner (Always offline accessible)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: compadColors.urgent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Direct Emergency One-Tap Calling',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Official Indian National Helplines (112, Tele-MANAS, UGC Anti-Ragging). Always accessible offline and exempt from App Lock.',
                        style: TextStyle(color: Colors.white.withAlpha(230), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Anti-Ragging & Women Safety Section (Phase F4)
          _buildSpecialSafetyCard(
            title: 'UGC Anti-Ragging & Women Safety',
            desc: 'Ragging is a punishable criminal offence under UGC regulations and IPC. Contact Internal Complaints Committee (ICC) or toll-free national helpline.',
            icon: Icons.gavel_rounded,
            phone: '1800-180-5522',
            authority: 'University Grants Commission',
            colors: compadColors,
          ),
          const SizedBox(height: 12),

          _buildSpecialSafetyCard(
            title: 'Tele-MANAS Mental Health Support',
            desc: '24/7 free, confidential psychological distress and exam-anxiety counseling in all official Indian languages.',
            icon: Icons.psychology_rounded,
            phone: '14416',
            authority: 'Ministry of Health & Family Welfare',
            colors: compadColors,
          ),
          const SizedBox(height: 20),

          // 3. One-Tap National Hotlines
          const Text('National & Emergency Helplines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...IndianEmergencyDirectory.nationalHotlines.map((h) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CompadCard(
                accentBorderColor: h.isUrgent ? compadColors.urgent.withAlpha(120) : null,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: h.isUrgent ? compadColors.urgent.withAlpha(30) : compadColors.academicsTint.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.phone_in_talk_rounded,
                        color: h.isUrgent ? compadColors.urgent : compadColors.academicsTint,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(h.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: h.isUrgent ? compadColors.urgent.withAlpha(30) : compadColors.chipBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  h.number,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: h.isUrgent ? compadColors.urgent : compadColors.academicsTint,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(h.description, style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                          const SizedBox(height: 2),
                          Text('Authority: ${h.authority}', style: TextStyle(fontSize: 10, color: compadColors.subtext, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // 4. First Aid Procedures (Public health guidance from Indian Red Cross / St. John Ambulance)
          const Text('First-Aid Emergency Procedures', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            'Conservative guidance from Indian Red Cross Society, ICMR, and St. John Ambulance India.',
            style: TextStyle(fontSize: 12, color: compadColors.subtext),
          ),
          const SizedBox(height: 12),
          ...IndianEmergencyDirectory.firstAidGuidance.map((f) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(f['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: compadColors.warning.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            f['tag']!,
                            style: TextStyle(color: compadColors.warning, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(f['steps']!, style: const TextStyle(fontSize: 12, height: 1.4)),
                    const SizedBox(height: 4),
                    Text('Source: ${f['source']!}', style: TextStyle(fontSize: 10, color: compadColors.subtext, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSpecialSafetyCard({
    required String title,
    required String desc,
    required IconData icon,
    required String phone,
    required String authority,
    required CompadThemeColors colors,
  }) {
    return CompadCard(
      padding: const EdgeInsets.all(16),
      color: colors.chipBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.academicsTint, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.academicsTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(phone, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: TextStyle(fontSize: 12, color: colors.subtext, height: 1.35)),
          const SizedBox(height: 4),
          Text('Authority: $authority', style: TextStyle(fontSize: 10, color: colors.subtext, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
