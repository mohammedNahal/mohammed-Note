import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/utils/helpers/helpers.dart';
import '../../data/datasources/remote/firebase_auth.dart';

/// [UserProvider] is a ChangeNotifier responsible for managing
/// all user authentication logic and UI-related state such as visibility toggles and loading.
class UserProvider extends ChangeNotifier with Helper {
  StreamSubscription? _authSubscription;

  IconData _passwordIcon = Icons.visibility;
  bool _isPasswordObscured = true;

  IconData _rePasswordIcon = Icons.visibility;
  bool _isRePasswordObscured = true;

  bool _isLoading = false;

  // ===== Getters for UI Binding =====
  IconData get passwordIcon => _passwordIcon;
  bool get isPasswordObscured => _isPasswordObscured;

  IconData get rePasswordIcon => _rePasswordIcon;
  bool get isRePasswordObscured => _isRePasswordObscured;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Initializes Firebase authentication state listener with optional delay.
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

  /// Stops listening to auth state changes to avoid memory leaks.
  void stopAuthListener() => _authSubscription?.cancel();

  /// Toggle the visibility state of the password field.
  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    _passwordIcon = _isPasswordObscured ? Icons.visibility : Icons.visibility_off;
    notifyListeners();
  }

  /// Toggle the visibility state of the retype password field.
  void toggleRePasswordVisibility() {
    _isRePasswordObscured = !_isRePasswordObscured;
    _rePasswordIcon = _isRePasswordObscured ? Icons.visibility : Icons.visibility_off;
    notifyListeners();
  }

  /// Handles user login using FirebaseAuth.
  Future<void> login({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        _setLoading(true);
        final success = await FirebaseAuthController().signIn(
          context: context,
          email: emailController.text,
          password: passwordController.text,
        );
        if (success) {
          appSnackBar(context: context, message: 'Login successful', error: false);
          Navigator.pushReplacementNamed(context, '/home');
        }
      } finally {
        _setLoading(false);
      }
    }
  }

  /// Handles user registration using FirebaseAuth.
  Future<void> signup({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        _setLoading(true);
        final success = await FirebaseAuthController().signup(
          context: context,
          email: emailController.text,
          password: passwordController.text,
        );
        if (success) {
          appSnackBar(context: context, message: 'Signup successful', error: false);
        }
      } finally {
        _setLoading(false);
      }
    }
  }

  /// Handles Google Sign-In using FirebaseAuth.
  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      _setLoading(true);
      final success = await FirebaseAuthController().signWithGoogle(context: context);
      if (success) {
        appSnackBar(context: context, message: 'Google Sign-In successful', error: false);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Sends a password reset email.
  Future<void> resetPassword({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
  }) async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        _setLoading(true);
        final success = await FirebaseAuthController().forgetPassword(
          context: context,
          email: emailController.text,
        );
        if (success) {
          Navigator.pushReplacementNamed(context, '/forget_pass/send_success');
        }
      } finally {
        _setLoading(false);
      }
    }
  }

  /// Logs out the user and navigates back to login screen.
  Future<void> logout({required BuildContext context}) async {
    await FirebaseAuthController().signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
