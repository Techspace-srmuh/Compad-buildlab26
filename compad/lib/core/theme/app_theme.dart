import 'package:flutter/material.dart';

/// Semantic and Group Tint Extension for Compad Design System
@immutable
class CompadThemeColors extends ThemeExtension<CompadThemeColors> {
  // Group Tints
  final Color academicsTint;
  final Color campusTint;
  final Color lifeTint;
  final Color wellbeingTint;

  // Semantic Colors
  final Color success;
  final Color urgent;
  final Color warning;
  final Color info;

  // Structural & Neutral Tokens
  final Color cardBackground;
  final Color cardBorder;
  final Color subtext;
  final Color chipBackground;
  final Color heroCardBackground;
  final Color heroCardForeground;
  final Color bannerWarningBg;
  final Color bannerWarningText;

  const CompadThemeColors({
    required this.academicsTint,
    required this.campusTint,
    required this.lifeTint,
    required this.wellbeingTint,
    required this.success,
    required this.urgent,
    required this.warning,
    required this.info,
    required this.cardBackground,
    required this.cardBorder,
    required this.subtext,
    required this.chipBackground,
    required this.heroCardBackground,
    required this.heroCardForeground,
    required this.bannerWarningBg,
    required this.bannerWarningText,
  });

  @override
  CompadThemeColors copyWith({
    Color? academicsTint,
    Color? campusTint,
    Color? lifeTint,
    Color? wellbeingTint,
    Color? success,
    Color? urgent,
    Color? warning,
    Color? info,
    Color? cardBackground,
    Color? cardBorder,
    Color? subtext,
    Color? chipBackground,
    Color? heroCardBackground,
    Color? heroCardForeground,
    Color? bannerWarningBg,
    Color? bannerWarningText,
  }) {
    return CompadThemeColors(
      academicsTint: academicsTint ?? this.academicsTint,
      campusTint: campusTint ?? this.campusTint,
      lifeTint: lifeTint ?? this.lifeTint,
      wellbeingTint: wellbeingTint ?? this.wellbeingTint,
      success: success ?? this.success,
      urgent: urgent ?? this.urgent,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      subtext: subtext ?? this.subtext,
      chipBackground: chipBackground ?? this.chipBackground,
      heroCardBackground: heroCardBackground ?? this.heroCardBackground,
      heroCardForeground: heroCardForeground ?? this.heroCardForeground,
      bannerWarningBg: bannerWarningBg ?? this.bannerWarningBg,
      bannerWarningText: bannerWarningText ?? this.bannerWarningText,
    );
  }

  @override
  CompadThemeColors lerp(ThemeExtension<CompadThemeColors>? other, double t) {
    if (other is! CompadThemeColors) return this;
    return CompadThemeColors(
      academicsTint: Color.lerp(academicsTint, other.academicsTint, t)!,
      campusTint: Color.lerp(campusTint, other.campusTint, t)!,
      lifeTint: Color.lerp(lifeTint, other.lifeTint, t)!,
      wellbeingTint: Color.lerp(wellbeingTint, other.wellbeingTint, t)!,
      success: Color.lerp(success, other.success, t)!,
      urgent: Color.lerp(urgent, other.urgent, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      subtext: Color.lerp(subtext, other.subtext, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      heroCardBackground: Color.lerp(heroCardBackground, other.heroCardBackground, t)!,
      heroCardForeground: Color.lerp(heroCardForeground, other.heroCardForeground, t)!,
      bannerWarningBg: Color.lerp(bannerWarningBg, other.bannerWarningBg, t)!,
      bannerWarningText: Color.lerp(bannerWarningText, other.bannerWarningText, t)!,
    );
  }

  // Pre-configured light extension
  static const CompadThemeColors light = CompadThemeColors(
    academicsTint: Color(0xFF3F3DDB),
    campusTint: Color(0xFF0D9488),
    lifeTint: Color(0xFF8B5CF6),
    wellbeingTint: Color(0xFF10B981),
    success: Color(0xFF059669),
    urgent: Color(0xFFDC2626),
    warning: Color(0xFFD97706),
    info: Color(0xFF2563EB),
    cardBackground: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE2E7FF),
    subtext: Color(0xFF4B5563), // WCAG AA 4.6:1 on white
    chipBackground: Color(0xFFEEF2FF),
    heroCardBackground: Color(0xFF3F3DDB),
    heroCardForeground: Color(0xFFFFFFFF),
    bannerWarningBg: Color(0xFFFEF3C7),
    bannerWarningText: Color(0xFF78350F), // WCAG AA compliant on amber
  );

  // Pre-configured dark extension
  static const CompadThemeColors dark = CompadThemeColors(
    academicsTint: Color(0xFF818CF8),
    campusTint: Color(0xFF2DD4BF),
    lifeTint: Color(0xFFA78BFA),
    wellbeingTint: Color(0xFF34D399),
    success: Color(0xFF10B981),
    urgent: Color(0xFFEF4444),
    warning: Color(0xFFFBBF24),
    info: Color(0xFF60A5FA),
    cardBackground: Color(0xFF1E263D),
    cardBorder: Color(0xFF334155),
    subtext: Color(0xFFCBD5E1), // WCAG AA 5.8:1 on dark surface
    chipBackground: Color(0xFF283044),
    heroCardBackground: Color(0xFF2D2A8C),
    heroCardForeground: Color(0xFFFAF8FF),
    bannerWarningBg: Color(0xFF451A03),
    bannerWarningText: Color(0xFFFDE68A),
  );
}

class CompadColors {
  // Base constants
  static const Color primaryIndigo = Color(0xFF3F3DDB);
  static const Color primaryIndigoDark = Color(0xFF818CF8);
  static const Color secondaryTeal = Color(0xFF14B8A6);
  static const Color accentAmber = Color(0xFFF59E0B);

  // Group Tints
  static const Color academicsTint = Color(0xFF3F3DDB);
  static const Color campusTint = Color(0xFF0D9488);
  static const Color lifeTint = Color(0xFF8B5CF6);
  static const Color wellbeingTint = Color(0xFF10B981);

  // Surfaces Light
  static const Color lightBg = Color(0xFFFAF8FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF2F3FF);
  static const Color lightBorder = Color(0xFFE2E7FF);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF4B5563);

  // Surfaces Dark
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E263D);
  static const Color darkSurfaceVariant = Color(0xFF283044);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  // Semantic
  static const Color urgentRed = Color(0xFFDC2626);
  static const Color successGreen = Color(0xFF059669);
  static const Color warningAmber = Color(0xFFD97706);
}

class CompadTheme {
  // Base font family fallback with Indic script support
  static const List<String> fontFallbacks = [
    'Plus Jakarta Sans',
    'Noto Sans Devanagari',
    'Noto Sans',
    'Inter',
    'sans-serif',
  ];

  static ThemeData light({Color? userAccent, double fontScale = 1.0}) {
    final primary = userAccent ?? CompadColors.primaryIndigo;

    final baseTextTheme = Typography.blackMountainView.apply(
      fontFamily: 'Plus Jakarta Sans',
      fontFamilyFallback: fontFallbacks,
      fontSizeFactor: fontScale,
    );

    // Apply Indic line-height rule (>= 1.4 to prevent matra clipping)
    final adjustedTextTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(height: 1.4, color: CompadColors.lightTextPrimary),
      displayMedium: baseTextTheme.displayMedium?.copyWith(height: 1.4, color: CompadColors.lightTextPrimary),
      displaySmall: baseTextTheme.displaySmall?.copyWith(height: 1.4, color: CompadColors.lightTextPrimary),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(height: 1.4, fontWeight: FontWeight.bold, color: CompadColors.lightTextPrimary),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(height: 1.4, fontWeight: FontWeight.bold, color: CompadColors.lightTextPrimary),
      titleLarge: baseTextTheme.titleLarge?.copyWith(height: 1.4, fontWeight: FontWeight.bold, color: CompadColors.lightTextPrimary),
      titleMedium: baseTextTheme.titleMedium?.copyWith(height: 1.4, fontWeight: FontWeight.w600, color: CompadColors.lightTextPrimary),
      titleSmall: baseTextTheme.titleSmall?.copyWith(height: 1.4, fontWeight: FontWeight.w600, color: CompadColors.lightTextPrimary),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(height: 1.45, color: CompadColors.lightTextPrimary),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(height: 1.45, color: CompadColors.lightTextPrimary),
      bodySmall: baseTextTheme.bodySmall?.copyWith(height: 1.4, color: CompadColors.lightTextSecondary),
      labelLarge: baseTextTheme.labelLarge?.copyWith(height: 1.4, fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primary.withAlpha(25),
        onPrimaryContainer: primary,
        secondary: CompadColors.secondaryTeal,
        tertiary: CompadColors.accentAmber,
        error: CompadColors.urgentRed,
        surface: CompadColors.lightSurface,
        onSurface: CompadColors.lightTextPrimary,
        outline: CompadColors.lightBorder,
      ),
      scaffoldBackgroundColor: CompadColors.lightBg,
      fontFamily: 'Plus Jakarta Sans',
      fontFamilyFallback: fontFallbacks,
      textTheme: adjustedTextTheme,
      extensions: const <ThemeExtension<dynamic>>[
        CompadThemeColors.light,
      ],
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: CompadColors.lightBorder, width: 1),
        ),
        color: CompadColors.lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CompadColors.lightBg,
        foregroundColor: CompadColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CompadColors.lightTextPrimary,
          height: 1.4,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CompadColors.lightSurface,
        selectedItemColor: CompadColors.primaryIndigo,
        unselectedItemColor: CompadColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(height: 1.4, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(height: 1.4),
      ),
    );
  }

  static ThemeData dark({Color? userAccent, double fontScale = 1.0}) {
    final primary = userAccent ?? CompadColors.primaryIndigoDark;

    final baseTextTheme = Typography.whiteMountainView.apply(
      fontFamily: 'Plus Jakarta Sans',
      fontFamilyFallback: fontFallbacks,
      fontSizeFactor: fontScale,
    );

    final adjustedTextTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(height: 1.4, color: CompadColors.darkTextPrimary),
      displayMedium: baseTextTheme.displayMedium?.copyWith(height: 1.4, color: CompadColors.darkTextPrimary),
      displaySmall: baseTextTheme.displaySmall?.copyWith(height: 1.4, color: CompadColors.darkTextPrimary),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(height: 1.4, fontWeight: FontWeight.bold, color: CompadColors.darkTextPrimary),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(height: 1.4, fontWeight: FontWeight.bold, color: CompadColors.darkTextPrimary),
      titleLarge: baseTextTheme.titleLarge?.copyWith(height: 1.4, fontWeight: FontWeight.bold, color: CompadColors.darkTextPrimary),
      titleMedium: baseTextTheme.titleMedium?.copyWith(height: 1.4, fontWeight: FontWeight.w600, color: CompadColors.darkTextPrimary),
      titleSmall: baseTextTheme.titleSmall?.copyWith(height: 1.4, fontWeight: FontWeight.w600, color: CompadColors.darkTextPrimary),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(height: 1.45, color: CompadColors.darkTextPrimary),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(height: 1.45, color: CompadColors.darkTextPrimary),
      bodySmall: baseTextTheme.bodySmall?.copyWith(height: 1.4, color: CompadColors.darkTextSecondary),
      labelLarge: baseTextTheme.labelLarge?.copyWith(height: 1.4, fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primary.withAlpha(50),
        onPrimaryContainer: Colors.white,
        secondary: CompadColors.secondaryTeal,
        tertiary: CompadColors.accentAmber,
        error: CompadColors.urgentRed,
        surface: CompadColors.darkSurface,
        onSurface: CompadColors.darkTextPrimary,
        outline: CompadColors.darkBorder,
      ),
      scaffoldBackgroundColor: CompadColors.darkBg,
      fontFamily: 'Plus Jakarta Sans',
      fontFamilyFallback: fontFallbacks,
      textTheme: adjustedTextTheme,
      extensions: const <ThemeExtension<dynamic>>[
        CompadThemeColors.dark,
      ],
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: CompadColors.darkBorder, width: 1),
        ),
        color: CompadColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CompadColors.darkBg,
        foregroundColor: CompadColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CompadColors.darkTextPrimary,
          height: 1.4,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CompadColors.darkSurface,
        selectedItemColor: CompadColors.secondaryTeal,
        unselectedItemColor: CompadColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(height: 1.4, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(height: 1.4),
      ),
    );
  }
}
