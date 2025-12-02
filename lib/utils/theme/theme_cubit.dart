import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme_mode';

  ThemeCubit() : super(const ThemeState(ThemeMode.system, false));

  /// Initialize theme from saved preferences
  Future<void> initializeTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themeKey);

      if (savedThemeIndex != null) {
        final themeMode = ThemeMode.values[savedThemeIndex];
        final isDarkMode = themeMode == ThemeMode.dark;
        emit(ThemeState(themeMode, isDarkMode));
      }
    } catch (e) {
      // If there's an error, keep system default
      emit(const ThemeState(ThemeMode.system, false));
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final currentMode = state.themeMode;
    ThemeMode newMode;
    bool newIsDarkMode;

    if (currentMode == ThemeMode.light) {
      newMode = ThemeMode.dark;
      newIsDarkMode = true;
    } else if (currentMode == ThemeMode.dark) {
      newMode = ThemeMode.light;
      newIsDarkMode = false;
    } else {
      // If system, switch to light first
      newMode = ThemeMode.light;
      newIsDarkMode = false;
    }

    emit(ThemeState(newMode, newIsDarkMode));
    await _saveThemePreference(newMode);
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    final isDarkMode = mode == ThemeMode.dark;
    emit(ThemeState(mode, isDarkMode));
    await _saveThemePreference(mode);
  }

  /// Use system theme
  Future<void> useSystemTheme() async {
    emit(const ThemeState(ThemeMode.system, false));
    await _saveThemePreference(ThemeMode.system);
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
    } catch (e) {
      // Handle error silently - theme will still work for current session
    }
  }
}
