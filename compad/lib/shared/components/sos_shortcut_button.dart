import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SosShortcutButton extends StatelessWidget {
  final VoidCallback onTap;

  const SosShortcutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final compadColors = Theme.of(context).extension<CompadThemeColors>();
    final urgentColor = compadColors?.urgent ?? CompadColors.urgentRed;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: urgentColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: urgentColor.withAlpha(80),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emergency_rounded,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 4),
              Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
