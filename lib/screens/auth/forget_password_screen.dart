import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Helpers/Helper.dart';
import '../../provider/user_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

/// Screen that lets the user request a password reset email.
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with Helper {
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // Return to login if user taps back
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Reset Password'),
      ),
      body: Consumer<UserProvider>(
        builder: (_, provider, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const Text('Forgot your password?'),
                const SizedBox(height: 8),
                const Text(
                  'Enter your email address below to receive a password reset link.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Email input field
                      AppTextField(
                        controller: _emailController,
                        hint: 'E-mail',
                        prefix: Icons.email_outlined,
                        borderRadius: 7,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-mail is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      /// Send reset email button
                      AppButton(
                        borderRadius: 7,
                        backgroundColor: Colors.teal.shade500,
                        onTap:
                            () => provider.resetPassword(
                              context: context,
                              emailController: _emailController,
                              formKey: _formKey,
                            ),
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
