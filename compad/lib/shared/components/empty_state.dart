import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/compad_logo.dart';

class CompadEmptyState extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;
  final bool useLogoHeader;

  const CompadEmptyState({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.ctaLabel,
    this.onCtaPressed,
    this.useLogoHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (useLogoHeader)
              const CompadLogo(size: 64)
            else if (icon != null)
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isDark ? CompadColors.darkSurfaceVariant : CompadColors.lightSurfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: CompadColors.primaryIndigo,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : CompadColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? CompadColors.darkTextSecondary : CompadColors.lightTextSecondary,
              ),
            ),
            if (ctaLabel != null && onCtaPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onCtaPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CompadColors.primaryIndigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
