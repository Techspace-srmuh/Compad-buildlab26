import 'package:flutter/material.dart';

class TintedIconCircle extends StatelessWidget {
  final IconData icon;
  final Color tintColor;
  final double size;
  final double iconSize;
  final VoidCallback? onTap;

  const TintedIconCircle({
    super.key,
    required this.icon,
    required this.tintColor,
    this.size = 48.0, // Minimum 48px touch target
    this.iconSize = 22.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tintColor.withAlpha(35),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: tintColor,
        size: iconSize,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: circle,
      );
    }

    return circle;
  }
}
