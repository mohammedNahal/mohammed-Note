import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:final_project_note_app/provider/note_provider.dart';
import 'package:final_project_note_app/provider/user_provider.dart';

// Screens
import 'package:final_project_note_app/screens/auth/forget_password_screen.dart';
import 'package:final_project_note_app/screens/auth/send_email_verification.dart';
import 'package:final_project_note_app/screens/auth/send_password_success_screen.dart';
import 'package:final_project_note_app/screens/auth/sign_up_screen.dart';
import 'package:final_project_note_app/screens/auth/login_screen.dart';
import 'package:final_project_note_app/screens/notes_screen.dart';
import 'package:final_project_note_app/screens/launch_screen.dart';

// Theme
import '../themes/theme.dart'; // استيراد الثيمات

/// التطبيق الرئيسي الذي يستخدم مزودي الحالة (Note و User)
class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // مزود للملاحظات
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        // مزود للمستخدم
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: _buildMaterialApp(),
    );
  }

  /// يبني تطبيق MaterialApp مع كل الإعدادات العامة والتنقل بين الصفحات
  Widget _buildMaterialApp() {
    return MaterialApp(
      title: 'Note',
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'), // اللغة الافتراضية (يمكنك تخصيصها لاحقاً)

      // أول شاشة تظهر
      initialRoute: '/',

      // جميع المسارات المستخدمة في التطبيق
      routes: {
        '/': (context) => const LaunchScreen(),
        '/login': (context) => const LoginScreen(),
        '/login/send_email_verify': (context) => const SendEmailVerificationScreen(),
        '/login/signup': (context) => const SignUpScreen(),
        '/login/forget_pass': (context) => const ForgetPasswordScreen(),
        '/forget_pass/send_success': (context) => const SendPasswordSuccessScreen(),
        '/home': (context) => const NotesScreen(),
      },

      // ثيم التطبيق
      theme: AppThemes.lightTheme(), // استخدام الثيم الفاتح
      darkTheme: AppThemes.darkTheme(), // استخدام الثيم الداكن
      themeMode: ThemeMode.system, // يعتمد على وضع النظام (فاتح أو داكن)
    );
  }
}
