import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/registry/feature_registry.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    final matchedFeatures = FeatureRegistry.search(_query);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search courses, timetable, tools, campus...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: compadColors.subtext, fontSize: 15),
          ),
          onChanged: (val) => setState(() => _query = val),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          Text(
            _query.isEmpty ? 'Suggested Tools & Features' : '${matchedFeatures.length} Results Found',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: compadColors.subtext),
          ),
          const SizedBox(height: 10),
          ...matchedFeatures.map((f) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CompadCard(
                onTap: () => context.push(f.route),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    TintedIconCircle(
                      icon: f.icon,
                      tintColor: f.category == FeatureCategory.academics
                          ? compadColors.academicsTint
                          : f.category == FeatureCategory.campus
                              ? compadColors.campusTint
                              : f.category == FeatureCategory.wellbeing
                                  ? compadColors.wellbeingTint
                                  : compadColors.lifeTint,
                      size: 40,
                      iconSize: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(f.subtitle, style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 18),
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
