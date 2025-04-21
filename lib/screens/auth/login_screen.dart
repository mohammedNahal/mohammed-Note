import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Helpers/Helper.dart';
import '../../provider/user_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

/// Screen for user login with email and password.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helper {
  late TextEditingController _emailController, _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Text('Welcome Back...'),
            const SizedBox(height: 8),
            const Text(
              'To login safely, enter your correct email and password.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// Login form
            Consumer<UserProvider>(
              builder: (_, provider, __) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Email input
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
                      const SizedBox(height: 10),

                      // Password input with visibility toggle
                      AppTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        obscureText: provider.isPasswordObscured,
                        prefix: Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(provider.passwordIcon),
                          onPressed: provider.togglePasswordVisibility,
                        ),
                        borderRadius: 7,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Navigation to sign up or forget-password
                      Row(
                        children: [
                          TextButton(
                            onPressed:
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  '/login/signup',
                                ),
                            child: const Text('Sign Up'),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed:
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  '/login/forget_pass',
                                ),
                            child: const Text('Forget Password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Login button
                      AppButton(
                        height: 60,
                        borderRadius: 7,
                        backgroundColor: Colors.teal.shade500,
                        onTap:
                            () => provider.login(
                              context: context,
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                            ),
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        '- OR SIGN IN WITH -',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Example Google sign-in button
                      AppButton(
                        height: 60,
                        borderRadius: 7,
                        backgroundColor: Colors.white,
                        childColor: Colors.black,
                        onTap: () {
                          provider.signInWithGoogle(context: context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Assuming you have an SVG asset for Google logo
                            SvgPicture.asset('images/google.svg'),
                            const SizedBox(width: 10),
                            const Text(
                              'GOOGLE',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
