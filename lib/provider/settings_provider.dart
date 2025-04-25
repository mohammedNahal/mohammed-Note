import 'package:flutter/material.dart';
import '../prefs/shared_preferance_controller.dart';

class SettingsProvider extends ChangeNotifier {
  // Current locale (language)
  Locale _locale = Locale(SharedPreferenceController().getLanguage);

  // Current theme mode (light or dark)
  ThemeMode _themeMode = SharedPreferenceController().getTheme;

  // Getter for locale
  Locale get locale => _locale;

  // Getter for theme mode
  ThemeMode get themeMode => _themeMode;

  /// Change language and persist it locally
  Future<void> changeLanguage(Locale newLocale) async {
    if (_locale != newLocale) {
      _locale = newLocale;
      await SharedPreferenceController().saveLanguage(lang: newLocale);
      notifyListeners();
    }
  }

  /// Change theme and persist it locally
  Future<void> changeTheme(ThemeMode newTheme) async {
    if (_themeMode != newTheme) {
      _themeMode = newTheme;
      await SharedPreferenceController().saveThemeMode(isDarkMode: newTheme == ThemeMode.dark);
      notifyListeners();
    }
  }
}
