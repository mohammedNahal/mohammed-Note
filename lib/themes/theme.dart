import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppThemes {
  // لايت ثيم
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: Colors.teal.shade500, // اللون المفضل
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.teal.shade500,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.teal.shade500),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.teal.shade500,
        foregroundColor: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.teal.shade500,
      ),
      brightness: Brightness.light,
    );
  }

  // 413F42
  // دارك ثيم
  static ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Colors.teal.shade500,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: HexColor('#413F42'),
      cardColor: HexColor('#7F8487'),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.teal.shade500),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HexColor('#7F8487'),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.teal.shade500,
      ),
      brightness: Brightness.dark,
    );
  }
}
