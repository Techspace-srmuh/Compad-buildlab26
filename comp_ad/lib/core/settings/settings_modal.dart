import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../profile/controllers/profile_controller.dart';
import '../services/notification_service.dart';
import '../theme/spatial_colors.dart';
import '../theme/spatial_neumorphic.dart';
import '../widgets/spatial_button.dart';
import '../widgets/spatial_glass.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/expenses/presentation/expenses_screen.dart';
import '../../features/p2p_share/presentation/widgets/sharing_history_sheet.dart';
import '../../features/vault/presentation/edit_identity_chip_modal.dart';

class SettingsModal extends ConsumerStatefulWidget {
  const SettingsModal({super.key});

  @override
  ConsumerState<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends ConsumerState<SettingsModal> {
  bool _notificationsEnabled = true;
  bool _isLoadingNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final enabled = await NotificationService.instance.isNotificationsEnabled();
    if (mounted) {
      setState(() {
        _notificationsEnabled = enabled;
        _isLoadingNotifications = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;
    final controller = ref.read(profileControllerProvider.notifier);

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: SpatialColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings & Preferences',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: SpatialColors.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security Section
              const Text(
                'SECURITY & PRIVACY',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: SpatialColors.accentCyan,
                ),
              ),
              const SizedBox(height: 10),

              // Biometric App Lock Toggle
              SpatialGlass(
                radius: 18,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: SpatialDecorations.raised(
                        radius: 10,
                        base: SpatialColors.surfaceContainer,
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.fingerprint,
                          size: 20,
                          color: SpatialColors.accentCyan,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Biometric App Lock',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: SpatialColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Prompt fingerprint or face unlock on launch',
                            style: TextStyle(
                              fontSize: 11,
                              color: SpatialColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: profile.isBiometricEnabled,
                      activeThumbColor: SpatialColors.accentCyan,
                      activeTrackColor: SpatialColors.accentCyan.withValues(alpha: 0.3),
                      inactiveTrackColor: SpatialColors.surfaceContainerLowest,
                      onChanged: (val) async {
                        if (val) {
                          final auth = LocalAuthentication();
                          final canCheck = await auth.canCheckBiometrics;
                          final isSupported = await auth.isDeviceSupported();

                          if (!canCheck && !isSupported) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No biometric or screen lock configured on this phone.'),
                                  backgroundColor: SpatialColors.accentCoral,
                                ),
                              );
                            }
                            return;
                          }

                          try {
                            final didAuth = await auth.authenticate(
                              localizedReason: 'Verify fingerprint or PIN to enable CompAd lock',
                              options: const AuthenticationOptions(
                                biometricOnly: false,
                                stickyAuth: true,
                              ),
                            );

                            if (!didAuth) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Verification cancelled. Lock was not enabled.'),
                                    backgroundColor: SpatialColors.accentAmber,
                                  ),
                                );
                              }
                              return;
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sensor error: $e'),
                                  backgroundColor: SpatialColors.accentCoral,
                                ),
                              );
                            }
                            return;
                          }
                        }

                        await controller.toggleBiometric(val);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                val ? 'Biometric App Lock is now active!' : 'Biometric App Lock disabled.',
                              ),
                              backgroundColor: val ? SpatialColors.accentEmerald : SpatialColors.surfaceContainerHigh,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Anonymous Identity Toggle
              SpatialGlass(
                radius: 18,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: SpatialDecorations.raised(
                        radius: 10,
                        base: SpatialColors.surfaceContainer,
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.userX,
                          size: 20,
                          color: SpatialColors.accentAmber,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Anonymous Identity Mode',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: SpatialColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Hide your name & college when sharing P2P files',
                            style: TextStyle(
                              fontSize: 11,
                              color: SpatialColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: profile.isAnonymous,
                      activeThumbColor: SpatialColors.accentAmber,
                      activeTrackColor: SpatialColors.accentAmber.withValues(alpha: 0.3),
                      inactiveTrackColor: SpatialColors.surfaceContainerLowest,
                      onChanged: (val) {
                        controller.toggleAnonymous(val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Notifications & Alerts Section
              const Text(
                'NOTIFICATIONS & TIMETABLE ALERTS',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: SpatialColors.accentCyan,
                ),
              ),
              const SizedBox(height: 10),

              // Class Reminder Switch
              SpatialGlass(
                radius: 18,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: SpatialDecorations.raised(
                            radius: 10,
                            base: SpatialColors.surfaceContainer,
                          ),
                          child: const Center(
                            child: Icon(
                              LucideIcons.bellRing,
                              size: 20,
                              color: SpatialColors.accentCyan,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Class Schedule Reminders',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.onSurface,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Alerts 10 mins before upcoming classes',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: SpatialColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_isLoadingNotifications)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: SpatialColors.accentCyan),
                          )
                        else
                          Switch(
                            value: _notificationsEnabled,
                            activeThumbColor: SpatialColors.accentCyan,
                            activeTrackColor: SpatialColors.accentCyan.withValues(alpha: 0.3),
                            inactiveTrackColor: SpatialColors.surfaceContainerLowest,
                            onChanged: (val) async {
                              setState(() => _notificationsEnabled = val);
                              await NotificationService.instance.setNotificationsEnabled(val);
                              if (val) {
                                await NotificationService.instance.requestPermissions();
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: SpatialButton(
                        label: 'Send Test Class Notification',
                        icon: LucideIcons.send,
                        accentColor: SpatialColors.accentCyan,
                        height: 38,
                        onPressed: () async {
                          await NotificationService.instance.sendTestNotification();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Test notification dispatched! Check your status bar.'),
                                backgroundColor: SpatialColors.accentEmerald,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Student Tools Quick Navigation
              const Text(
                'STUDENT VAULTS & TOOLS',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: SpatialColors.accentCyan,
                ),
              ),
              const SizedBox(height: 10),

              // Academic Calendar Quick Access
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CalendarScreen()),
                  );
                },
                child: SpatialGlass(
                  radius: 18,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: SpatialDecorations.raised(
                          radius: 10,
                          base: SpatialColors.surfaceContainer,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.calendarDays,
                            size: 20,
                            color: SpatialColors.accentCyan,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Academic Calendar & Tagged Activities',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Exams, assignments, vivas, events & deadlines',
                              style: TextStyle(
                                fontSize: 11,
                                color: SpatialColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 18, color: SpatialColors.outline),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Expense Vault Quick Access
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                  );
                },
                child: SpatialGlass(
                  radius: 18,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: SpatialDecorations.raised(
                          radius: 10,
                          base: SpatialColors.surfaceContainer,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.wallet,
                            size: 20,
                            color: SpatialColors.accentEmerald,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Expense Manager',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Track daily spending, food, travel, books & budget',
                              style: TextStyle(
                                fontSize: 11,
                                color: SpatialColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 18, color: SpatialColors.outline),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Identity Management Section
              const Text(
                'STUDENT IDENTITY CHIP',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: SpatialColors.accentCyan,
                ),
              ),
              const SizedBox(height: 10),

              // Edit Chip Card
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const EditIdentityChipModal(),
                  );
                },
                child: SpatialGlass(
                  radius: 18,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: SpatialDecorations.raised(
                          radius: 10,
                          base: SpatialColors.surfaceContainer,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.creditCard,
                            size: 20,
                            color: SpatialColors.accentIndigo,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.displayName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.displayCollege} • ${profile.year}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: SpatialColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 18, color: SpatialColors.outline),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sharing & History Section
              const Text(
                'OFFLINE DATA & TRANSFERS',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: SpatialColors.accentCyan,
                ),
              ),
              const SizedBox(height: 10),

              // P2P Sharing History
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const SharingHistorySheet(),
                  );
                },
                child: SpatialGlass(
                  radius: 18,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: SpatialDecorations.raised(
                          radius: 10,
                          base: SpatialColors.surfaceContainer,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.history,
                            size: 20,
                            color: SpatialColors.accentEmerald,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sharing History & Logs',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Review Bluetooth & Wi-Fi transfers or clear records',
                              style: TextStyle(
                                fontSize: 11,
                                color: SpatialColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 18, color: SpatialColors.outline),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // App Version & Architecture Slate
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: SpatialColors.accentCyan.withValues(alpha: 0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/icons/app_logo.png', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'CompAd • Offline Campus Matrix',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: SpatialColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Universal Student Companion • 100% Air-Gapped',
                      style: TextStyle(
                        fontSize: 11,
                        color: SpatialColors.outline,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
