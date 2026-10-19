import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/profile/controllers/profile_controller.dart';
import '../../../core/profile/models/student_profile_model.dart';
import '../../../core/settings/settings_modal.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/widgets/spatial_glass.dart';
import '../../p2p_share/presentation/p2p_export_import_modal.dart';
import '../../p2p_share/presentation/widgets/sharing_history_sheet.dart';
import 'edit_identity_chip_modal.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  void _openEditModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditIdentityChipModal(),
    );
  }

  void _openQrFullScreen(StudentProfileModel profile) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SpatialColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset('assets/icons/app_logo.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Identity QR Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SpatialColors.onSurface),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: profile.toQrPayload(),
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              profile.displayName,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: SpatialColors.onSurface),
            ),
            Text(
              '${profile.displayCollege} • ${profile.displayDepartment}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(
              profile.isAnonymous ? '(Anonymous Identity Mode Active)' : 'Roll No: ${profile.displayRollNo}',
              style: const TextStyle(fontSize: 11, fontFamily: 'JetBrainsMono', color: SpatialColors.accentCyan),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: SpatialColors.accentCyan)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;
    final controller = ref.read(profileControllerProvider.notifier);

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      body: SafeArea(
        child: profileState.isLoading
            ? const Center(child: CircularProgressIndicator(color: SpatialColors.accentCyan))
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UNIVERSAL STUDENT IDENTITY',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'JetBrainsMono',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: SpatialColors.accentCyan,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Identity Vault',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.settings, color: SpatialColors.onSurfaceVariant, size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SettingsModal()),
                                );
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: SpatialDecorations.inset(
                                radius: 12,
                                base: SpatialColors.surfaceContainerLowest,
                              ),
                              child: const Row(
                                children: [
                                  Icon(LucideIcons.shieldCheck, size: 12, color: SpatialColors.accentEmerald),
                                  SizedBox(width: 4),
                                  Text(
                                    'AIR-GAPPED',
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
                    const SizedBox(height: 16),

                    // First-Time Setup Banner (If skipped or not completed)
                    if (!profile.isSetupCompleted)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              SpatialColors.accentCyan.withValues(alpha: 0.15),
                              SpatialColors.accentIndigo.withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: SpatialColors.accentCyan.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.sparkles, color: SpatialColors.accentCyan, size: 20),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Personalize Your Identity Chip',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: SpatialColors.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Set your name, college & department or skip anytime.',
                                    style: TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: _openEditModal,
                              child: const Text('Setup', style: TextStyle(color: SpatialColors.accentCyan, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),

                    // ==========================================
                    // THE UNIVERSAL STUDENT IDENTITY CHIP
                    // ==========================================
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: SpatialColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: SpatialColors.accentCyan.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: SpatialColors.accentCyan.withValues(alpha: 0.12),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            // Ambient Specular Highlights
                            Positioned(
                              top: -40,
                              right: -40,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SpatialColors.accentCyan.withValues(alpha: 0.12),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top Row: Logo, College & Chip Badge
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: SpatialColors.accentCyan.withValues(alpha: 0.3),
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.asset('assets/icons/app_logo.png', fit: BoxFit.cover),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                profile.displayCollege.toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'JetBrainsMono',
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.0,
                                                  color: SpatialColors.accentCyan,
                                                ),
                                              ),
                                              Text(
                                                profile.displayDepartment,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: SpatialColors.onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: SpatialDecorations.inset(
                                          radius: 8,
                                          base: SpatialColors.surfaceContainerLowest,
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(LucideIcons.cpu, size: 12, color: SpatialColors.accentAmber),
                                            SizedBox(width: 4),
                                            Text(
                                              'ID CHIP',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontFamily: 'JetBrainsMono',
                                                fontWeight: FontWeight.bold,
                                                color: SpatialColors.accentAmber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Student Name & Roll No.
                                  Text(
                                    profile.displayName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: SpatialColors.onSurface,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text(
                                        'REG/ROLL: ',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'JetBrainsMono',
                                          color: SpatialColors.outline,
                                        ),
                                      ),
                                      Text(
                                        profile.displayRollNo,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'JetBrainsMono',
                                          fontWeight: FontWeight.bold,
                                          color: SpatialColors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Year Pill & QR Code Section
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: SpatialColors.surfaceContainerHigh,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: SpatialColors.outlineVariant, width: 0.8),
                                            ),
                                            child: Text(
                                              profile.year,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: SpatialColors.onSurface,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: _openEditModal,
                                            child: const Row(
                                              children: [
                                                Icon(LucideIcons.pencil, size: 12, color: SpatialColors.accentCyan),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Edit Identity',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: SpatialColors.accentCyan,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Embedded QR Code (Tap to view large)
                                      GestureDetector(
                                        onTap: () => _openQrFullScreen(profile),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: SpatialColors.accentCyan.withValues(alpha: 0.4),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                          child: QrImageView(
                                            data: profile.toQrPayload(),
                                            version: QrVersions.auto,
                                            size: 68.0,
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Privacy Preference Strip
                    SpatialGlass(
                      radius: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                profile.isAnonymous ? LucideIcons.userX : LucideIcons.userCheck,
                                size: 16,
                                color: profile.isAnonymous ? SpatialColors.accentAmber : SpatialColors.accentEmerald,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.isAnonymous ? 'Anonymous Sharing Mode' : 'Full Identity Sharing',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: SpatialColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    profile.isAnonymous
                                        ? 'Your name and roll no. are hidden from peers'
                                        : 'Identity Chip details attached when sharing',
                                    style: const TextStyle(fontSize: 10, color: SpatialColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch(
                            value: profile.isAnonymous,
                            activeThumbColor: SpatialColors.accentAmber,
                            activeTrackColor: SpatialColors.accentAmber.withValues(alpha: 0.3),
                            inactiveTrackColor: SpatialColors.surfaceContainerLowest,
                            onChanged: (val) => controller.toggleAnonymous(val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Utility Actions
                    const Text(
                      'P2P AIR-SHARE & TRANSFERS',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: SpatialColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2 Big Buttons: Share via Bluetooth/Wi-Fi & Transfer History
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const P2PExportImportModal()),
                              );
                            },
                            child: SpatialGlass(
                              radius: 18,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: SpatialDecorations.raised(
                                      radius: 10,
                                      base: SpatialColors.surfaceContainer,
                                    ),
                                    child: const Center(
                                      child: Icon(LucideIcons.share2, size: 18, color: SpatialColors.accentCyan),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Air-Share',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: SpatialColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Wi-Fi & Bluetooth fast share',
                                    style: TextStyle(fontSize: 10, color: SpatialColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: SpatialDecorations.raised(
                                      radius: 10,
                                      base: SpatialColors.surfaceContainer,
                                    ),
                                    child: const Center(
                                      child: Icon(LucideIcons.history, size: 18, color: SpatialColors.accentEmerald),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Sharing History',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: SpatialColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Review sent & received logs',
                                    style: TextStyle(fontSize: 10, color: SpatialColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quick Pairing Prompt
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: SpatialDecorations.inset(
                        radius: 18,
                        base: SpatialColors.surfaceContainerLow,
                      ),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.qrCode, color: SpatialColors.accentCyan, size: 24),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'QR Pairing Ready',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: SpatialColors.onSurface),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Have a friend scan your QR code or scan theirs in CompAd to exchange timetables instantly.',
                                  style: TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                                ),
                              ],
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
