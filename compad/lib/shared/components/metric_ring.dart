import 'package:flutter/material.dart';

class MetricRing extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color? backgroundColor;
  final Widget? centerChild;

  const MetricRing({
    super.key,
    required this.value,
    this.size = 64.0,
    this.strokeWidth = 6.0,
    required this.progressColor,
    this.backgroundColor,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? progressColor.withAlpha(40);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            backgroundColor: bgColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            strokeCap: StrokeCap.round,
          ),
          ?centerChild,
        ],
      ),
    );
  }
}
