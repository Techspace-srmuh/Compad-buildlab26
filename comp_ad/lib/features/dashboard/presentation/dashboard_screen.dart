import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/profile/controllers/profile_controller.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/widgets/spatial_glass.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/attendance_dial_widget.dart';
import 'widgets/next_class_hero.dart';
import '../../calendar/presentation/calendar_screen.dart';
import '../../expenses/presentation/expenses_screen.dart';

class DashboardScreen extends ConsumerWidget {
  final Function(int tabIndex)? onNavigateToTab;
  final VoidCallback? onOpenP2PShare;

  const DashboardScreen({
    super.key,
    this.onNavigateToTab,
    this.onOpenP2PShare,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);
    final profile = ref.watch(profileControllerProvider).profile;

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: SpatialColors.accentCyan),
              )
            : RefreshIndicator(
                color: SpatialColors.accentCyan,
                backgroundColor: SpatialColors.surfaceContainer,
                onRefresh: () => controller.loadDashboard(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sub-Island Greeting & Local Sync Tag
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: SpatialColors.accentCyan,
                                      boxShadow: [
                                        BoxShadow(
                                          color: SpatialColors.accentCyan.withValues(alpha: 0.8),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'AUTONOMOUS TERMINAL',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                      color: SpatialColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: SpatialColors.accentCyan.withValues(alpha: 0.35),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/icons/app_logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Good day, ${profile.displayName}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: SpatialColors.onSurface,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      Text(
                                        '${profile.displayCollege} • ${profile.year}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'JetBrainsMono',
                                          color: SpatialColors.accentCyan,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: SpatialDecorations.inset(
                              radius: 20,
                              base: SpatialColors.surfaceContainerLowest,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.lock, size: 12, color: SpatialColors.accentEmerald),
                                SizedBox(width: 4),
                                Text(
                                  'LOCAL SYNC',
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
                      const SizedBox(height: 18),

                      // Hero Active / Upcoming Class Card
                      NextClassHero(
                        slot: state.data?.activeOrUpcomingSlot,
                        minutesUntil: state.data?.minutesUntilNext ?? 0,
                        isActive: state.data?.isCurrentlyActive ?? false,
                        isCheckedIn: state.isQuickCheckedIn,
                        onQuickCheckIn: () => controller.toggleQuickCheckIn(),
                      ),
                      const SizedBox(height: 20),

                      // Tactile Attendance Dial
                      if (state.data != null)
                        AttendanceDialWidget(
                          stats: state.data!.attendance,
                          onTap: () => onNavigateToTab?.call(2), // Jump to Lab
                        ),
                      const SizedBox(height: 24),

                      // Quick Utility Spatial Glass Tray
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deck Utilities',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: SpatialColors.onSurface,
                            ),
                          ),
                          Text(
                            'FAST TELEMETRY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: SpatialColors.outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 2x3 Utility Grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.15,
                        children: [
                          // 01 Master Timetable
                          _buildDeckUtilityCard(
                            title: 'Master Schedule',
                            subtitle: '${state.data?.totalSessionsToday ?? 0} slots today',
                            icon: LucideIcons.calendarClock,
                            accentColor: SpatialColors.accentCyan,
                            badge: '11:30 AM',
                            onTap: () => onNavigateToTab?.call(1),
                          ),
                          // 02 Academic Calendar
                          _buildDeckUtilityCard(
                            title: 'Academic Calendar',
                            subtitle: 'Tag exams & activities',
                            icon: LucideIcons.calendarDays,
                            accentColor: SpatialColors.accentCyan,
                            badge: 'PLANNER',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CalendarScreen()),
                              );
                            },
                          ),
                          // 03 Expense Vault
                          _buildDeckUtilityCard(
                            title: 'Expense Vault',
                            subtitle: 'Daily student budget',
                            icon: LucideIcons.wallet,
                            accentColor: SpatialColors.accentEmerald,
                            badge: 'FINANCE',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                              );
                            },
                          ),
                          // 04 Attendance Lab
                          _buildDeckUtilityCard(
                            title: 'Safe-Bunk Sim',
                            subtitle: 'Simulate skipped labs',
                            icon: LucideIcons.flaskConical,
                            accentColor: SpatialColors.accentEmerald,
                            badge: 'PRO',
                            onTap: () => onNavigateToTab?.call(2),
                          ),
                          // 05 Scratchpad
                          _buildDeckUtilityCard(
                            title: 'Dev Scratchpad',
                            subtitle: 'Offline markdown notes',
                            icon: LucideIcons.fileCode,
                            accentColor: SpatialColors.accentIndigo,
                            badge: 'RAM CACHE',
                            onTap: () => onNavigateToTab?.call(3),
                          ),
                          // 06 P2P Air Share
                          _buildDeckUtilityCard(
                            title: 'Local Air-Beam',
                            subtitle: 'Encrypted offline mesh',
                            icon: LucideIcons.wifi,
                            accentColor: SpatialColors.accentCyan,
                            badge: 'P2P PEERS',
                            onTap: () => onOpenP2PShare?.call(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDeckUtilityCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required String badge,
    required VoidCallback onTap,
  }) {
    return SpatialGlass(
      radius: 18,
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: SpatialDecorations.raised(
                  radius: 10,
                  base: SpatialColors.surfaceContainer,
                ),
                child: Center(
                  child: Icon(icon, size: 18, color: accentColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: SpatialDecorations.inset(
                  radius: 8,
                  base: SpatialColors.surfaceContainerLowest,
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: SpatialColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: SpatialColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
