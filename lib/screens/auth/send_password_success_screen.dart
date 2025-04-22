import 'package:flutter/material.dart';
import 'package:final_project_note_app/widgets/app_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../generated/l10n.dart';

/// Screen displayed after successfully sending the password reset link.
/// Informs the user to check their email and provides a button to navigate back to the login page.
class SendPasswordSuccessScreen extends StatelessWidget {
  const SendPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = S.of(context);  // Localization reference

    return Scaffold(
      // Wrapping the body content inside SafeArea to avoid notches and status bar overlap
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            // Centering content vertically and horizontally
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // RichText widget to display a formatted message to the user
              _buildResetPasswordMessage(local),
              const SizedBox(height: 20),

              // Button to navigate back to the login screen
              _buildBackToLoginButton(context, local),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the rich text message informing the user about the password reset email.
  Widget _buildResetPasswordMessage(S local) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: local.passwordResetEmailSentTextPart1, // 'We have sent a password reset link to your email'
        style: TextStyle(fontSize: 13, color: Colors.grey),
        children: [
          TextSpan(
            text: local.passwordResetLink, // 'Password reset link'
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: local.passwordResetEmailSentTextPart2, // '. Please check your email and try again.'
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Builds the "Back to Login" button.
  Widget _buildBackToLoginButton(BuildContext context, S local) {
    return AppButton(
      borderRadius: 7,
      backgroundColor: Colors.teal.shade500,
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Text(local.backToLogin), // 'Back to Login'
    );
  }
}
