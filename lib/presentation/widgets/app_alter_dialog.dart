import 'package:flutter/material.dart';

import '../../generated/l10n.dart';


/// A reusable confirmation dialog with consistent styling and localization support
class AppDialog {
  /// Displays a platform-aware confirmation dialog
  ///
  /// [context]: Build context for showing the dialog
  /// [titleKey]: Localization key for the dialog title
  /// [contentKey]: Localization key for the dialog content
  /// [confirmAction]: Callback for confirmation action
  /// [isDestructive]: Whether the action is destructive (changes button colors)
  /// [barrierDismissible]: Whether dialog can be dismissed by tapping outside
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    required String confirm,
    required VoidCallback confirmAction,
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) async {
    return showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                title,
                style: ThemeData().textTheme.titleLarge,
              ),
              content: Text(
                content,
                style: ThemeData().textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(

                    S.of(context).cancel,
                    style: TextStyle(
                      color: ThemeData().disabledColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    confirmAction();
                  },
                  child: Text(
                    confirm,
                    style: TextStyle(
                      color: isDestructive
                          ? ThemeData().colorScheme.error
                          : ThemeData().primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ));
  }
}