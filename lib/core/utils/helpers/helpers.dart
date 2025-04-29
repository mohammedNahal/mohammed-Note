import 'package:flutter/material.dart';

import 'package:final_project_note_app/generated/l10n.dart';

/// A mixin that provides reusable helper methods for UI components
mixin Helper {
  /// Displays a SnackBar on the screen
  ///
  /// [context] is the current BuildContext.
  /// [message] is the text to be displayed inside the SnackBar.
  /// [error] determines the color of the SnackBar:
  /// - Red for error messages
  /// - Green for success messages
  void appSnackBar({
    required BuildContext context,
    required String? message,
    bool error = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? ''),
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating, // Makes it float above content
      ),
    );
  }

  String? validateEmail(String? value, S local) {
    if (value?.isEmpty ?? true) return local.emailRequired;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return local.invalidEmail;
    }
    return null;
  }
  /// Validates password with localization support
  ///
  /// [value]: Password input value
  /// [local]: Localization instance (S)
  ///
  /// Returns localized error message or null if valid
  String? validatePassword(String? value, S local) {
    if (value == null || value.isEmpty) {
      return local.passwordRequired;
    }

    if (value.length < 8) {
      return local.passwordMinLength;
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return local.passwordUppercase;
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return local.passwordLowercase;
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return local.passwordNumber;
    }

    return null;
  }
}
