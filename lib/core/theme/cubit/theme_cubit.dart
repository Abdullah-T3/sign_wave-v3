import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';

  ThemeCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(ThemeState(
          themeMode: ThemeMode.values[
              prefs.getInt(_themeKey) ?? ThemeMode.system.index],
        )) {
    // Initialize theme from saved preferences
    final savedThemeIndex = _prefs.getInt(_themeKey);
    if (savedThemeIndex != null) {
      emit(ThemeState(themeMode: ThemeMode.values[savedThemeIndex]));
    }
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    final newTheme = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _saveThemePreference(newTheme);
    emit(ThemeState(themeMode: newTheme));
  }

  /// Set a specific theme mode
  void setTheme(ThemeMode themeMode) {
    _saveThemePreference(themeMode);
    emit(ThemeState(themeMode: themeMode));
  }

  /// Save theme preference to shared preferences
  void _saveThemePreference(ThemeMode themeMode) {
    _prefs.setInt(_themeKey, themeMode.index);
  }
}