import 'dart:ui';
import 'package:flutter/material.dart';

class SpatialGlass extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Border? border;
  final double blur;
  final VoidCallback? onTap;

  const SpatialGlass({
    super.key,
    required this.child,
    this.radius = 20,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.border,
    this.blur = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? const Color(0x66161B26); // rgba(22, 27, 38, 0.4)
    final effectiveBorder = border ??
        Border.all(
          color: Colors.white.withValues(alpha: 0.14),
          width: 1.0,
        );

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: BorderRadius.circular(radius),
            border: effectiveBorder,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.05),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }
    return content;
  }
}
