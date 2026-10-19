import 'package:flutter/material.dart';
import '../theme/spatial_colors.dart';
import '../theme/spatial_neumorphic.dart';

class SpatialButton extends StatefulWidget {
  final Widget? child;
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? accentColor;
  final bool isSelected;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const SpatialButton({
    super.key,
    this.child,
    this.label,
    this.icon,
    this.onPressed,
    this.accentColor,
    this.isSelected = false,
    this.radius = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.width,
    this.height,
  });

  @override
  State<SpatialButton> createState() => _SpatialButtonState();
}

class _SpatialButtonState extends State<SpatialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final pressed = _isPressed || widget.isSelected;
    final accent = widget.accentColor ?? SpatialColors.accentIndigo;

    final decoration = pressed
        ? SpatialDecorations.inset(
            radius: widget.radius,
            base: SpatialColors.surfaceContainerLowest,
            border: Border.all(
              color: accent.withValues(alpha: widget.isSelected ? 0.6 : 0.2),
              width: 1.0,
            ),
          )
        : SpatialDecorations.raised(
            radius: widget.radius,
            base: SpatialColors.surfaceContainerHigh,
            border: Border.all(
              color: widget.isSelected
                  ? accent.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1.0,
            ),
          );

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: decoration,
        child: Center(
          child: widget.child ??
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 18,
                      color: widget.isSelected ? accent : SpatialColors.onSurface,
                    ),
                    if (widget.label != null) const SizedBox(width: 8),
                  ],
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.isSelected ? accent : SpatialColors.onSurface,
                        letterSpacing: 0.3,
                      ),
                    ),
                ],
              ),
        ),
      ),
    );
  }
}
