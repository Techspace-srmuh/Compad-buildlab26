import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CompadSkeletonCard extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const CompadSkeletonCard({
    super.key,
    this.height = 80.0,
    this.width = double.infinity,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? CompadColors.darkSurfaceVariant : const Color(0xFFE8EDFB);

    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
