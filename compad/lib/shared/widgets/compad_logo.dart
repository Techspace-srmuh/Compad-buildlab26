import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CompadLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final TextStyle? textStyle;
  final Color? color;

  const CompadLogo({
    super.key,
    this.size = 48.0,
    this.showText = false,
    this.textStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: CompadColors.primaryIndigo,
        borderRadius: BorderRadius.circular(size * 0.24),
        boxShadow: [
          BoxShadow(
            color: CompadColors.primaryIndigo.withAlpha(80),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.16),
      child: Image.asset(
        'assets/branding/splash_logo.png',
        fit: BoxFit.contain,
        color: color ?? Colors.white,
      ),
    );

    if (!showText) {
      return logoWidget;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultTextStyle = TextStyle(
      fontSize: size * 0.5,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      color: isDark ? Colors.white : CompadColors.lightTextPrimary,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoWidget,
        SizedBox(width: size * 0.25),
        Text(
          'Compad',
          style: textStyle ?? defaultTextStyle,
        ),
      ],
    );
  }
}
