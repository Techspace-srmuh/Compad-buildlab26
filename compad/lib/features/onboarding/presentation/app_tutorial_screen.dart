import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialItem {
  final IconData icon;
  final String title; // <= 5 words
  final String subtitle; // <= 5 words
  final Color tintColor;

  const TutorialItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tintColor,
  });
}

class AppTutorialScreen extends ConsumerStatefulWidget {
  final bool isReplay;
  const AppTutorialScreen({super.key, this.isReplay = false});

  @override
  ConsumerState<AppTutorialScreen> createState() => _AppTutorialScreenState();
}

class _AppTutorialScreenState extends ConsumerState<AppTutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<TutorialItem> tutorialItems = [
    TutorialItem(
      icon: Icons.badge_rounded,
      title: 'Your Student Profile',
      subtitle: 'Saved securely on device',
      tintColor: Color(0xFF3F3DDB),
    ),
    TutorialItem(
      icon: Icons.map_rounded,
      title: 'Offline Campus Map',
      subtitle: 'Works without cellular data',
      tintColor: Color(0xFF0D9488),
    ),
    TutorialItem(
      icon: Icons.swap_horizontal_circle_rounded,
      title: 'Direct Peer Share',
      subtitle: 'Share notes without internet',
      tintColor: Color(0xFF8B5CF6),
    ),
    TutorialItem(
      icon: Icons.calendar_month_rounded,
      title: 'Timetable & Attendance',
      subtitle: 'Track your 75% rule',
      tintColor: Color(0xFF10B981),
    ),
  ];

  Future<void> _finishTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_completed', true);

    if (mounted) {
      if (widget.isReplay) {
        context.pop();
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _finishTutorial,
            child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: tutorialItems.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final item = tutorialItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Large Graphic Circle
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: item.tintColor.withAlpha(25),
                            shape: BoxShape.circle,
                            border: Border.all(color: item.tintColor.withAlpha(60), width: 3),
                          ),
                          child: Icon(
                            item.icon,
                            size: 96,
                            color: item.tintColor,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Title (<= 5 words)
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle (<= 5 words)
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dot Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(tutorialItems.length, (index) {
                final isActive = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 36),

            // Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < tutorialItems.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _finishTutorial();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _currentPage == tutorialItems.length - 1 ? 'Start Using App' : 'Next',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
