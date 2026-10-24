import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OfflineIndicator extends StatelessWidget {
  final bool isOnline;
  final String? lastSyncedTime;

  const OfflineIndicator({
    super.key,
    this.isOnline = false,
    this.lastSyncedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline
            ? CompadColors.successGreen.withAlpha(30)
            : CompadColors.primaryIndigo.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnline ? CompadColors.successGreen : CompadColors.primaryIndigo.withAlpha(80),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? CompadColors.successGreen : CompadColors.primaryIndigo,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'Online' : 'Offline Ready',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isOnline ? CompadColors.successGreen : CompadColors.primaryIndigo,
            ),
          ),
        ],
      ),
    );
  }
}
