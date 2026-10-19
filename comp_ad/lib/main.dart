import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'core/database/database_helper.dart';
import 'core/settings/settings_modal.dart';
import 'core/theme/spatial_colors.dart';
import 'core/theme/spatial_neumorphic.dart';
import 'core/widgets/biometric_gate.dart';
import 'core/widgets/spatial_glass.dart';
import 'features/attendance/presentation/attendance_lab_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/p2p_share/presentation/p2p_export_import_modal.dart';
import 'features/scratchpad/presentation/scratchpad_screen.dart';
import 'features/timetable/presentation/timetable_screen.dart';
import 'features/vault/presentation/edit_identity_chip_modal.dart';
import 'features/vault/presentation/vault_screen.dart';
import 'core/database/secure_key_storage.dart';
import 'core/profile/controllers/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Resilient error handling so unhandled rendering errors don't crash the app
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('CompAd caught error: ${details.exception}');
  };

  // Pre-load biometric lock state so initial frame renders locked immediately if enabled
  final isBioEnabled = await SecureKeyStorage.isBiometricEnabled();

  runApp(
    ProviderScope(
      child: CompAdApp(initialBiometricLocked: isBioEnabled),
    ),
  );
}

class CompAdApp extends StatelessWidget {
  final bool initialBiometricLocked;

  const CompAdApp({
    super.key,
    this.initialBiometricLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CompAd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: SpatialColors.canvas,
        colorScheme: const ColorScheme.dark(
          primary: SpatialColors.accentIndigo,
          secondary: SpatialColors.accentCyan,
          surface: SpatialColors.surface,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: BiometricGate(
        initiallyLocked: initialBiometricLocked,
        child: const CompAdMainShell(),
      ),
    );
  }
}

class CompAdMainShell extends ConsumerStatefulWidget {
  const CompAdMainShell({super.key});

  @override
  ConsumerState<CompAdMainShell> createState() => _CompAdMainShellState();
}

class _CompAdMainShellState extends ConsumerState<CompAdMainShell> {
  int _currentIndex = 0;
  bool _hasCheckedSetup = false;

  @override
  void initState() {
    super.initState();
    _warmUpDatabase();
  }

  void _checkSetupWhenReady(ProfileState state) {
    if (_hasCheckedSetup) return;
    if (!state.isLoading && !state.profile.isSetupCompleted) {
      _hasCheckedSetup = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !ref.read(profileControllerProvider).profile.isSetupCompleted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const EditIdentityChipModal(isInitialSetup: true),
          );
        }
      });
    }
  }

  Future<void> _warmUpDatabase() async {
    try {
      await DatabaseHelper.instance.database;
    } catch (e) {
      debugPrint('DB initialization info: $e');
    }
  }

  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _openP2PShareModal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const P2PExportImportModal()),
    );
  }

  void _openSettingsModal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsModal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    _checkSetupWhenReady(profileState);

    final screens = [
      DashboardScreen(
        onNavigateToTab: _navigateToTab,
        onOpenP2PShare: _openP2PShareModal,
      ),
      const TimetableScreen(),
      const AttendanceLabScreen(),
      const ScratchpadScreen(),
      const VaultScreen(),
    ];

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      body: Stack(
        children: [
          // Ambient Specular Gradient Orbs
          Positioned(
            top: -60,
            left: 20,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SpatialColors.accentCyan.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 240,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SpatialColors.accentIndigo.withValues(alpha: 0.07),
              ),
            ),
          ),

          // Main Screen Content with Top Bar
          Column(
            children: [
              // Global VisionOS Frosted Top Bar
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SpatialGlass(
                    radius: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: SpatialColors.accentCyan.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/icons/app_logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CompAd',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3,
                                    color: SpatialColors.onSurface,
                                  ),
                                ),
                                Text(
                                  _getTabSubtitle(_currentIndex),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontFamily: 'JetBrainsMono',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                    color: SpatialColors.accentCyan,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // P2P Share Quick Launch
                            GestureDetector(
                              onTap: _openP2PShareModal,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: SpatialDecorations.raised(
                                  radius: 12,
                                  base: SpatialColors.surfaceContainerHigh,
                                ),
                                child: const Row(
                                  children: [
                                    Icon(LucideIcons.share2, size: 12, color: SpatialColors.accentCyan),
                                    SizedBox(width: 4),
                                    Text(
                                      'Air-Share',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'JetBrainsMono',
                                        color: SpatialColors.accentCyan,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: _openSettingsModal,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: SpatialDecorations.raised(
                                  radius: 10,
                                  base: SpatialColors.surfaceContainerHigh,
                                ),
                                child: const Icon(
                                  LucideIcons.settings,
                                  size: 13,
                                  color: SpatialColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Offline Status Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: SpatialDecorations.inset(
                                radius: 12,
                                base: SpatialColors.surfaceContainerLowest,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: SpatialColors.accentEmerald,
                                      boxShadow: [
                                        BoxShadow(
                                          color: SpatialColors.accentEmerald.withValues(alpha: 0.8),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'OFFLINE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'JetBrainsMono',
                                      fontWeight: FontWeight.bold,
                                      color: SpatialColors.accentEmerald,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Active Screen Body
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: screens,
                ),
              ),
            ],
          ),

          // Floating Spatial Action Glass Dock at bottom
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: SpatialGlass(
                radius: 28,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDockItem(0, LucideIcons.layoutGrid, 'Hub'),
                    _buildDockItem(1, LucideIcons.calendarDays, 'Sched'),
                    _buildDockItem(2, LucideIcons.flaskConical, 'Lab'),
                    _buildDockItem(3, LucideIcons.fileText, 'Notes'),
                    _buildDockItem(4, LucideIcons.shieldCheck, 'Vault'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTabSubtitle(int index) {
    switch (index) {
      case 0:
        return 'COMMAND CENTER';
      case 1:
        return 'TIMETABLE MATRIX';
      case 2:
        return 'SAFE-BUNK LAB';
      case 3:
        return 'RAW SCRATCHPAD';
      case 4:
        return 'CREDENTIAL VAULT';
      default:
        return 'OFFLINE';
    }
  }

  Widget _buildDockItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? SpatialColors.accentCyan : SpatialColors.outline;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52,
        height: 52,
        decoration: isSelected
            ? SpatialDecorations.inset(
                radius: 18,
                base: SpatialColors.surfaceContainerLowest,
                border: Border.all(
                  color: SpatialColors.accentCyan.withValues(alpha: 0.5),
                  width: 1.0,
                ),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.transparent,
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: color,
                fontFamily: 'JetBrainsMono',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
