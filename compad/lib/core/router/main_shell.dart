import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../../shared/components/offline_indicator.dart';
import '../../shared/components/sos_shortcut_button.dart';
import '../../shared/components/quick_add_modal.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String _studentName = 'Student';

  @override
  void initState() {
    super.initState();
    _loadStudentName();
  }

  Future<void> _loadStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('student_name');
    if (name != null && name.isNotEmpty) {
      setState(() => _studentName = name);
    }
  }

  void _onQuickAdd(BuildContext context) async {
    final selected = await QuickAddModal.show(context);
    if (selected != null && context.mounted) {
      switch (selected) {
        case QuickAddType.task:
          context.push('/academics/tasks');
          break;
        case QuickAddType.note:
          context.push('/life/notebook');
          break;
        case QuickAddType.flashcard:
          context.push('/life/flashcards');
          break;
        case QuickAddType.mood:
          context.push('/wellbeing/mood');
          break;
        case QuickAddType.expense:
          context.push('/life/budget');
          break;
        case QuickAddType.voiceNote:
          context.push('/life/voice-notes');
          break;
        case QuickAddType.scanDocument:
          context.push('/life/scanner');
          break;
        case QuickAddType.shareFile:
          context.push('/share');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        leadingWidth: 48,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: GestureDetector(
            onTap: () => context.push('/settings'),
            child: CircleAvatar(
              backgroundColor: compadColors.academicsTint.withAlpha(40),
              child: Text(
                _studentName.isNotEmpty ? _studentName[0].toUpperCase() : 'S',
                style: TextStyle(
                  color: compadColors.academicsTint,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Namaste, $_studentName',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            const OfflineIndicator(isOnline: false),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search Campus & Notes',
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings & Theme',
            onPressed: () => context.push('/settings'),
          ),
          // Persistent red SOS button on Home and Campus
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SosShortcutButton(
              onTap: () => context.push('/campus/emergency'),
            ),
          ),
        ],
      ),
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school_rounded),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map_rounded),
            label: 'Campus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.interests_outlined),
            activeIcon: Icon(Icons.interests_rounded),
            label: 'Life',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_outlined),
            activeIcon: Icon(Icons.spa_rounded),
            label: 'Wellbeing',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onQuickAdd(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
