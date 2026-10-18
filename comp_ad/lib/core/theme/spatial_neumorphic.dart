import 'dart:ui';
import 'package:flutter/material.dart';
import 'spatial_colors.dart';

class SpatialDecorations {
  /// Raised Neumorphic extruded element
  static BoxDecoration raised({
    double radius = 20,
    Color base = SpatialColors.surface,
    Border? border,
  }) {
    return BoxDecoration(
      color: base,
      borderRadius: BorderRadius.circular(radius),
      border: border ??
          Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.0,
          ),
      boxShadow: [
        BoxShadow(
          offset: const Offset(-5, -5),
          blurRadius: 14,
          color: Colors.white.withValues(alpha: 0.04),
        ),
        BoxShadow(
          offset: const Offset(6, 6),
          blurRadius: 18,
          color: Colors.black.withValues(alpha: 0.65),
        ),
      ],
    );
  }

  /// Inset sunken / grooved well element
  static BoxDecoration inset({
    double radius = 16,
    Color base = SpatialColors.surfaceContainerLowest,
    Border? border,
  }) {
    return BoxDecoration(
      color: base,
      borderRadius: BorderRadius.circular(radius),
      border: border ??
          Border.all(
            color: Colors.black.withValues(alpha: 0.5),
            width: 1.0,
          ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.black.withValues(alpha: 0.45),
          base,
          Colors.white.withValues(alpha: 0.02),
        ],
        stops: const [0.0, 0.4, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          offset: const Offset(3, 3),
          blurRadius: 6,
          color: Colors.black.withValues(alpha: 0.7),
        ),
        BoxShadow(
          offset: const Offset(-2, -2),
          blurRadius: 6,
          color: Colors.white.withValues(alpha: 0.03),
        ),
      ],
    );
  }

  /// Translucent frosted glass container (VisionOS inspired)
  static Widget glass({
    required Widget child,
    double radius = 24,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    Color? customColor,
    Border? customBorder,
    VoidCallback? onTap,
  }) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: customColor ?? const Color(0x731E293B), // rgba(30, 41, 59, 0.45)
            borderRadius: BorderRadius.circular(radius),
            border: customBorder ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.0,
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, 10),
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

/// Backwards compatibility alias for easy theme usage
class SpatialTheme {
  static const Color canvas = SpatialColors.canvas;
  static const Color surface = SpatialColors.surface;
  static const Color elevated = SpatialColors.elevated;
  static const Color accentIndigo = SpatialColors.accentIndigo;
  static const Color accentCyan = SpatialColors.accentCyan;
  static const Color accentEmerald = SpatialColors.accentEmerald;
  static const Color accentCoral = SpatialColors.accentCoral;

  static BoxDecoration raised({double radius = 20, Color base = surface}) =>
      SpatialDecorations.raised(radius: radius, base: base);

  static BoxDecoration inset({double radius = 16, Color base = SpatialColors.surfaceContainerLowest}) =>
      SpatialDecorations.inset(radius: radius, base: base);

  static Widget glass({
    required Widget child,
    double radius = 24,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    VoidCallback? onTap,
  }) =>
      SpatialDecorations.glass(
        child: child,
        radius: radius,
        padding: padding,
        onTap: onTap,
      );
}
