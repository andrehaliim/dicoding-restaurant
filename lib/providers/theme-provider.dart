import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _colorKey = 'seed_color';

  final SharedPreferences _prefs;
  late ThemeMode _themeMode;
  late Color _seedColor;

  ThemeProvider(this._prefs) {
    _loadFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadFromPrefs() {
    final isDark = _prefs.getBool(_themeKey);
    _themeMode = (isDark ?? false) ? ThemeMode.dark : ThemeMode.light;

    final colorValue = _prefs.getInt(_colorKey);
    _seedColor = colorValue != null ? Color(colorValue) : Colors.blueGrey;
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _prefs.setBool(_themeKey, isDark);
  }

  Future<void> setSeedColor(Color color) async {
    _seedColor = color;
    notifyListeners();
    await _prefs.setInt(_colorKey, color.value);
  }
}
