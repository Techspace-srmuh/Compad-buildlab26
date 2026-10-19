import 'package:flutter/material.dart';
import '../theme/spatial_colors.dart';
import '../theme/spatial_neumorphic.dart';

class SpatialSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final String label;

  const SpatialSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: SpatialDecorations.inset(
            radius: 26,
            base: SpatialColors.surfaceContainerLowest,
          ),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: SpatialColors.accentCyan,
              inactiveTrackColor: SpatialColors.surfaceContainerHigh,
              thumbColor: SpatialColors.surfaceContainerHighest,
              overlayColor: SpatialColors.accentCyan.withValues(alpha: 0.15),
              thumbShape: const _SpatialSliderThumbShape(
                thumbRadius: 18,
              ),
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _SpatialSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const _SpatialSliderThumbShape({required this.thumbRadius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Ambient drop shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.75)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center.translate(2, 3), thumbRadius, shadowPaint);

    // Neon Cyan rim glow
    final glowPaint = Paint()
      ..color = SpatialColors.accentCyan.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, thumbRadius + 1, glowPaint);

    // Neumorphic thumb body
    final thumbPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          SpatialColors.surfaceContainerHighest,
          SpatialColors.surfaceContainerHigh,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius));
    canvas.drawCircle(center, thumbRadius, thumbPaint);

    // Key-light specular ring
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, thumbRadius, borderPaint);

    // Center tactile dot
    final dotPaint = Paint()..color = SpatialColors.accentCyan;
    canvas.drawCircle(center, 4, dotPaint);
  }
}
