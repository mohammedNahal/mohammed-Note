import 'dart:async';
import 'package:flutter/material.dart';

import '../Helpers/Helper.dart';
import '../firebase/firebase_auth.dart';

/// Provider responsible for managing user authentication
/// and form controllers lifecycle.
class UserProvider extends ChangeNotifier with Helper {




  // StreamSubscription for Firebase auth state changes
  StreamSubscription? _authSubscription;

  // Icons and state for password visibility toggles
  IconData _passwordIcon = Icons.visibility;
  bool _isPasswordObscured = true;
  IconData _rePasswordIcon = Icons.visibility;
  bool _isRePasswordObscured = true;

  // ===== Getters =====
  IconData get passwordIcon => _passwordIcon;
  bool get isPasswordObscured => _isPasswordObscured;
  IconData get rePasswordIcon => _rePasswordIcon;
  bool get isRePasswordObscured => _isRePasswordObscured;

  /// Start listening to authentication state changes after a delay.
  void startAuthListener({required BuildContext context}) {
    Future.delayed(const Duration(seconds: 3), () {
      _authSubscription = FirebaseAuthController().checkUserState(
        listener: ({required bool status}) {
          final route = status ? '/home' : '/login';
          Navigator.pushReplacementNamed(context, route);
        },
      );
    });
  }

  /// Stop listening to authentication state changes.
  void stopAuthListener() {
    _authSubscription?.cancel();
  }

  // ===== Visibility Toggles =====

  /// Toggle visibility of password field.
  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    _passwordIcon = _isPasswordObscured ? Icons.visibility : Icons.visibility_off;
    notifyListeners();
  }

  /// Toggle visibility of re-password field.
  void toggleRePasswordVisibility() {
    _isRePasswordObscured = !_isRePasswordObscured;
    _rePasswordIcon = _isRePasswordObscured ? Icons.visibility : Icons.visibility_off;
    notifyListeners();
  }

  // ===== Authentication Actions =====

  /// Attempt to sign in the user.
  /// Shows a SnackBar on success or error.
  Future<void> login({required BuildContext context, required GlobalKey<FormState> formKey, required TextEditingController emailController, required TextEditingController passwordController}) async {
    if (formKey.currentState?.validate() ?? false) {
      final success = await FirebaseAuthController().signIn(
        context: context,
        email: emailController.text,
        password: passwordController.text,
      );
      if (success) {
        appSnackBar(context: context, message: 'Login successful', error: false);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  /// Attempt to register a new user.
  /// Shows a SnackBar on success or error.
  Future<void> signup({required BuildContext context, required GlobalKey<FormState> formKey, required TextEditingController emailController, required TextEditingController passwordController}) async {
    if (formKey.currentState?.validate() ?? false) {
      final success = await FirebaseAuthController().signup(
        context: context,
        email: emailController.text,
        password: passwordController.text,
      );
      if (success) {
        appSnackBar(context: context, message: 'Signup successful', error: false);
      }
    }
  }

  /// Send a password-reset email.
  Future<void> resetPassword({required BuildContext context, required GlobalKey<FormState> formKey, required TextEditingController emailController,}) async {
    if (formKey.currentState?.validate() ?? false) {
      final success = await FirebaseAuthController().forgetPassword(
        context: context,
        email: emailController.text ?? '',
      );
      if (success) {
        Navigator.pushReplacementNamed(context, '/forget_pass/send_success');
      }
    }
  }

  /// Sign out the current user.
  Future<void> logout({required BuildContext context}) async {
    await FirebaseAuthController().signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

}