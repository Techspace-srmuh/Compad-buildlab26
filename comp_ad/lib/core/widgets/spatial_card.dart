import 'package:flutter/material.dart';
import '../theme/spatial_colors.dart';
import '../theme/spatial_neumorphic.dart';

class SpatialCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color baseColor;
  final Border? border;
  final VoidCallback? onTap;
  final bool isInset;

  const SpatialCard({
    super.key,
    required this.child,
    this.radius = 20,
    this.padding = const EdgeInsets.all(16),
    this.baseColor = SpatialColors.surface,
    this.border,
    this.onTap,
    this.isInset = false,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = isInset
        ? SpatialDecorations.inset(radius: radius, base: baseColor, border: border)
        : SpatialDecorations.raised(radius: radius, base: baseColor, border: border);

    if (onTap == null) {
      return Container(
        decoration: decoration,
        padding: padding,
        child: child,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        splashColor: SpatialColors.accentIndigo.withValues(alpha: 0.1),
        highlightColor: Colors.black.withValues(alpha: 0.2),
        child: Ink(
          decoration: decoration,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
