import 'package:flutter/material.dart';

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
}
