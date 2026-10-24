import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CompadCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? accentBorderColor;
  final double elevation;

  const CompadCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.color,
    this.accentBorderColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>();
    final cardColor = color ?? compadColors?.cardBackground ?? (isDark ? CompadColors.darkSurface : CompadColors.lightSurface);
    final borderColor = accentBorderColor ?? compadColors?.cardBorder ?? (isDark ? CompadColors.darkBorder : CompadColors.lightBorder);

    return Material(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor, width: accentBorderColor != null ? 1.5 : 1.0),
      ),
      elevation: !isDark ? elevation : 0,
      shadowColor: Colors.black.withAlpha(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
