import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum used to manage shared preference keys
enum SharedKeys { language, theme }

/// Singleton class to manage shared preferences
class SharedPreferenceController {
  // Private named constructor
  SharedPreferenceController._internal();

  // Static instance (singleton)
  static final SharedPreferenceController _instance =
  SharedPreferenceController._internal();

  // Factory constructor to access the same instance
  factory SharedPreferenceController() => _instance;

  late SharedPreferences _preferences;

  /// Initializes the shared preferences instance
  Future<void> initSharedPref() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // ------------------ Language Methods ------------------

  /// Saves the selected language code (e.g., "en", "ar") to local storage
  Future<void> saveLanguage({required Locale lang}) async {
    await _preferences.setString(
      SharedKeys.language.name,
      lang.languageCode,
    );
  }

  /// Retrieves the stored language code, or defaults to 'en'
  String get getLanguage =>
      _preferences.getString(SharedKeys.language.name) ?? 'en';

  // ------------------ Theme Mode Methods ------------------

  /// Saves the selected theme mode (true for dark, false for light)
  Future<void> saveThemeMode({required bool isDarkMode}) async {
    await _preferences.setBool(
      SharedKeys.theme.name,
      isDarkMode,
    );
  }

  /// Retrieves the stored theme mode, defaults to false (light mode)
  ThemeMode get getTheme {
    final isDark = _preferences.getBool(SharedKeys.theme.name);
    if(isDark == null) {
      return ThemeMode.system;
    }
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
