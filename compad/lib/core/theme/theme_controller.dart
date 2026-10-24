import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeState {
  final ThemeMode themeMode;
  final Color userAccent;
  final double textScale;

  const ThemeState({
    required this.themeMode,
    required this.userAccent,
    required this.textScale,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? userAccent,
    double? textScale,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      userAccent: userAccent ?? this.userAccent,
      textScale: textScale ?? this.textScale,
    );
  }
}

class ThemeController extends StateNotifier<ThemeState> {
  static const _keyThemeMode = 'app_theme_mode';
  static const _keyAccent = 'app_theme_accent';
  static const _keyTextScale = 'app_theme_text_scale';

  ThemeController()
      : super(const ThemeState(
          themeMode: ThemeMode.system,
          userAccent: CompadColors.primaryIndigo,
          textScale: 1.0,
        )) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeStr = prefs.getString(_keyThemeMode);
      ThemeMode mode = ThemeMode.system;
      if (modeStr == 'light') mode = ThemeMode.light;
      if (modeStr == 'dark') mode = ThemeMode.dark;

      final accentVal = prefs.getInt(_keyAccent);
      final accent = accentVal != null ? Color(accentVal) : CompadColors.primaryIndigo;

      final scale = prefs.getDouble(_keyTextScale) ?? 1.0;

      state = ThemeState(
        themeMode: mode,
        userAccent: accent,
        textScale: scale,
      );
    } catch (e) {
      debugPrint('[ThemeController] Warning: Could not load preferences: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    String val = 'system';
    if (mode == ThemeMode.light) val = 'light';
    if (mode == ThemeMode.dark) val = 'dark';
    await prefs.setString(_keyThemeMode, val);
  }

  Future<void> setUserAccent(Color color) async {
    state = state.copyWith(userAccent: color);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAccent, color.toARGB32());
  }

  Future<void> setTextScale(double scale) async {
    state = state.copyWith(textScale: scale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTextScale, scale);
  }

  void toggleTheme() {
    if (state.themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

final themeControllerProvider = StateNotifierProvider<ThemeController, ThemeState>((ref) {
  return ThemeController();
});
