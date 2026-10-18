import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import '../../controllers/sharing_history_controller.dart';
import '../../../../core/theme/spatial_colors.dart';
import '../../../../core/theme/spatial_neumorphic.dart';
import '../../../../core/widgets/spatial_glass.dart';

class SharingHistorySheet extends ConsumerWidget {
  const SharingHistorySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sharingHistoryControllerProvider);
    final controller = ref.read(sharingHistoryControllerProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: SpatialColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: SpatialColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header with Clear All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.history, size: 20, color: SpatialColors.accentEmerald),
                  SizedBox(width: 8),
                  Text(
                    'P2P Sharing History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: SpatialColors.onSurface,
                    ),
                  ),
                ],
              ),
              if (state.history.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: SpatialColors.surfaceContainer,
                        title: const Text('Clear All Transfer History?', style: TextStyle(color: SpatialColors.onSurface)),
                        content: const Text(
                          'This will delete all sent and received transfer logs from your device storage.',
                          style: TextStyle(color: SpatialColors.onSurfaceVariant, fontSize: 13),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel', style: TextStyle(color: SpatialColors.outline)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              controller.clearAll();
                            },
                            child: const Text('Delete All', style: TextStyle(color: SpatialColors.accentCoral)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.trash2, size: 14, color: SpatialColors.accentCoral),
                  label: const Text(
                    'Clear All',
                    style: TextStyle(color: SpatialColors.accentCoral, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Locally stored history of Bluetooth and Wi-Fi data exchanges. 100% private to your device.',
            style: TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // History List
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator(color: SpatialColors.accentCyan))
                : state.history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: SpatialDecorations.inset(
                                radius: 30,
                                base: SpatialColors.surfaceContainerLowest,
                              ),
                              child: const Center(
                                child: Icon(LucideIcons.inbox, size: 28, color: SpatialColors.outline),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No Transfers Yet',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'When you share or receive timetables, notes, or datesheets over Wi-Fi or Bluetooth, logs will appear here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.history.length,
                        itemBuilder: (context, index) {
                          final item = state.history[index];
                          final isWifi = item.isWifi;
                          final isSent = item.isSent;

                          String? filePath;
                          if (item.rawJson != null && item.rawJson!.isNotEmpty) {
                            try {
                              final parsed = jsonDecode(item.rawJson!);
                              if (parsed is Map && parsed['filePath'] != null) {
                                filePath = parsed['filePath'] as String;
                              }
                            } catch (_) {}
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: SpatialGlass(
                              radius: 16,
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: SpatialDecorations.raised(
                                      radius: 10,
                                      base: SpatialColors.surfaceContainer,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        isWifi ? LucideIcons.wifi : LucideIcons.bluetooth,
                                        size: 18,
                                        color: isWifi ? SpatialColors.accentCyan : SpatialColors.accentIndigo,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isSent
                                                    ? SpatialColors.accentCyan.withValues(alpha: 0.15)
                                                    : SpatialColors.accentEmerald.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                isSent ? 'SENT' : 'RECEIVED',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontFamily: 'JetBrainsMono',
                                                  fontWeight: FontWeight.bold,
                                                  color: isSent ? SpatialColors.accentCyan : SpatialColors.accentEmerald,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              item.transport,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontFamily: 'JetBrainsMono',
                                                color: SpatialColors.outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: SpatialColors.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Peer: ${item.peerInfo}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: SpatialColors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (filePath != null)
                                    IconButton(
                                      icon: const Icon(LucideIcons.externalLink, size: 18, color: SpatialColors.accentEmerald),
                                      tooltip: 'Open Received Document',
                                      onPressed: () async {
                                        final path = filePath;
                                        if (path == null) return;
                                        final file = File(path);
                                        if (!await file.exists()) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('File not found in storage.')),
                                            );
                                          }
                                          return;
                                        }
                                        final result = await OpenFilex.open(path);
                                        if (result.type != ResultType.done && context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Could not open file: ${result.message}')),
                                          );
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(LucideIcons.trash2, size: 16, color: SpatialColors.outline),
                                    onPressed: () => controller.deleteItem(item.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
