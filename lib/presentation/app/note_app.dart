import 'package:final_project_note_app/data/datasources/local/shared_preferance_controller.dart';
import 'package:final_project_note_app/presentation/screens/auth/send_password_success_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';




import 'package:final_project_note_app/generated/l10n.dart';
import '../../core/themes/theme.dart';
import '../providers/note_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/forget_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/send_email_verification.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/launch_screen.dart';
import '../screens/my_note_screen.dart';
import '../screens/notes_screen.dart';
import '../screens/settings_screen.dart';

// Themes

/// The root widget of the Note App.
/// Wraps the app with multiple providers for state management.
class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const _AppContent(),
    );
  }
}

/// The inner widget that builds the MaterialApp.
/// Separated from the root widget to ensure proper access to context-bound providers.
class _AppContent extends StatelessWidget {
  const _AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;

    return MaterialApp(
      title: 'Note',
      debugShowCheckedModeBanner: false,

      // Localization support
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      // Theming
      theme: AppThemes.lightTheme(),
      darkTheme: AppThemes.darkTheme(),
      themeMode: SharedPreferenceController().getTheme,

      // App routing
      initialRoute: '/',
      routes: {
        '/': (context) => const LaunchScreen(),
        '/login': (context) => const LoginScreen(),
        '/login/signup': (context) => const SignUpScreen(),
        '/login/forget_pass': (context) => const ForgetPasswordScreen(),
        '/login/send_email_verify': (context) => const SendEmailVerificationScreen(),
        '/forget_pass/send_success': (context) => const SendPasswordSuccessScreen(),
        '/home': (context) => const NotesScreen(),
        '/myNote': (context) => const MyNoteScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
