import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../config/app_config.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode _themeMode;
  
  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  void _loadThemeMode() {
    final savedTheme = StorageService.getString(AppConfig.themeKey);
    switch (savedTheme) {
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'system':
      default:
        _themeMode = ThemeMode.system;
        break;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    String modeString;
    switch (mode) {
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    
    await StorageService.setString(AppConfig.themeKey, modeString);
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }

  String get currentThemeName {
    switch (_themeMode) {
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.system:
        return 'System';
    }
  }

  IconData get currentThemeIcon {
    switch (_themeMode) {
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}