import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'tinted_icon_circle.dart';

enum QuickAddType {
  task,
  note,
  flashcard,
  mood,
  expense,
  voiceNote,
  scanDocument,
  shareFile,
}

class QuickAddModal extends StatelessWidget {
  final Function(QuickAddType) onSelect;

  const QuickAddModal({
    super.key,
    required this.onSelect,
  });

  static Future<QuickAddType?> show(BuildContext context) {
    return showModalBottomSheet<QuickAddType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => QuickAddModal(
        onSelect: (type) => Navigator.of(ctx).pop(type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? CompadColors.darkSurface : CompadColors.lightSurface;

    final actions = [
      _QuickActionItem(
        type: QuickAddType.task,
        label: 'New Task',
        icon: Icons.check_circle_outline_rounded,
        color: CompadColors.academicsTint,
      ),
      _QuickActionItem(
        type: QuickAddType.note,
        label: 'Take Note',
        icon: Icons.note_alt_outlined,
        color: CompadColors.lifeTint,
      ),
      _QuickActionItem(
        type: QuickAddType.flashcard,
        label: 'Flashcard',
        icon: Icons.style_outlined,
        color: CompadColors.accentAmber,
      ),
      _QuickActionItem(
        type: QuickAddType.mood,
        label: 'Log Mood',
        icon: Icons.sentiment_satisfied_alt_rounded,
        color: CompadColors.wellbeingTint,
      ),
      _QuickActionItem(
        type: QuickAddType.expense,
        label: 'Add Expense',
        icon: Icons.account_balance_wallet_outlined,
        color: CompadColors.secondaryTeal,
      ),
      _QuickActionItem(
        type: QuickAddType.voiceNote,
        label: 'Voice Note',
        icon: Icons.mic_none_rounded,
        color: const Color(0xFFE11D48),
      ),
      _QuickActionItem(
        type: QuickAddType.scanDocument,
        label: 'Scan OCR',
        icon: Icons.document_scanner_outlined,
        color: const Color(0xFF6366F1),
      ),
      _QuickActionItem(
        type: QuickAddType.shareFile,
        label: 'Compad Share',
        icon: Icons.wifi_tethering_rounded,
        color: CompadColors.primaryIndigo,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Add',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : CompadColors.lightTextPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final item = actions[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onSelect(item.type),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TintedIconCircle(
                      icon: item.icon,
                      tintColor: item.color,
                      size: 52,
                      iconSize: 26,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : CompadColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem {
  final QuickAddType type;
  final String label;
  final IconData icon;
  final Color color;

  _QuickActionItem({
    required this.type,
    required this.label,
    required this.icon,
    required this.color,
  });
}
