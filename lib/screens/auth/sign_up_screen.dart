import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Helpers/Helper.dart';
import '../../provider/user_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

/// شاشة تسجيل مستخدم جديد (Sign Up)
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with Helper {
  late TextEditingController _emailController,
      _passwordController,
      _rePasswordController,
      _fullNameController,
      _phoneNumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // نضع المحتوى داخل SafeArea لتجنب تداخله مع الـ status bar
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (_, provider, __) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // عنوان وترحيب
                  const Text('Welcome...'),
                  const SizedBox(height: 8),
                  const Text(
                    'Create an account to start taking notes.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // نموذج التسجيل
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // الاسم الكامل
                        AppTextField(
                          controller: _fullNameController,
                          hint: 'Full Name',
                          prefix: Icons.person_2_outlined,
                          borderRadius: 7,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // البريد الإلكتروني
                        AppTextField(
                          controller: _emailController,
                          hint: 'E‑mail',
                          prefix: Icons.email_outlined,
                          borderRadius: 7,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E‑mail is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // كلمة المرور
                        AppTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          prefix: Icons.lock_outline,
                          obscureText: provider.isPasswordObscured,
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

                        // إعادة كتابة كلمة المرور
                        AppTextField(
                          controller: _rePasswordController,
                          hint: 'Confirm Password',
                          prefix: Icons.lock_outline,
                          obscureText: provider.isRePasswordObscured,
                          suffix: IconButton(
                            icon: Icon(provider.rePasswordIcon),
                            onPressed: provider.toggleRePasswordVisibility,
                          ),
                          borderRadius: 7,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // رقم الهاتف
                        AppTextField(
                          controller: _phoneNumberController,
                          hint: 'Phone Number',
                          prefix: Icons.phone,
                          borderRadius: 7,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),

                        // زر تسجيل الحساب
                        AppButton(
                          borderRadius: 7,
                          backgroundColor: Colors.teal.shade500,
                          onTap:
                              () => provider.signup(
                                context: context,
                                passwordController: _passwordController,
                                emailController: _emailController,
                                formKey: _formKey,
                              ),
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
