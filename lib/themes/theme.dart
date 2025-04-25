import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

/// AppThemes class defines light and dark themes used throughout the app
class AppThemes {
  // Main primary color used across both themes
  static final Color _primaryColor = Colors.teal.shade500;

  /// Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: _primaryColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,

      // AppBar Styling
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: _primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
        titleTextStyle: TextStyle(
          color: _primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: _primaryColor),

      // Button Themes
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(_primaryColor),
        ),
      ),
      buttonTheme: ButtonThemeData(buttonColor: _primaryColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      primaryColor: _primaryColor,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: HexColor('#413F42'),
      cardColor: HexColor('#7F8487'),

      // AppBar Styling
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.white),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: _primaryColor),

      // Button Themes
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(_primaryColor),
        ),
      ),
      buttonTheme: ButtonThemeData(buttonColor: _primaryColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HexColor('#7F8487'),
        foregroundColor: Colors.white,
      ),
    );
  }
}
