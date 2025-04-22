import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../Helpers/Helper.dart';
import '../../provider/user_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../generated/l10n.dart';
import '../../widgets/language_toggle_button.dart'; // Import localization

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
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = S.of(context); // Localization instance

    return Scaffold(
      appBar: _buildAppBar(local),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildWelcomeText(local),
            _buildLoginInstructions(local),
            _buildLoginForm(local),
          ],
        ),
      ),
    );
  }

  /// Builds the app bar with the title.
  AppBar _buildAppBar(S local) {
    return AppBar(
      actions: [
        LanguageToggleButton(),
      ],
      title: Text(local.login),
      centerTitle: true,
    );
  }

  /// Welcome text section.
  Widget _buildWelcomeText(S local) {
    return Text(local.welcomeBack, style: const TextStyle(fontSize: 24));
  }

  /// Instructions text for login.
  Widget _buildLoginInstructions(S local) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        local.loginInstructions,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  /// Builds the login form, including email, password fields, and buttons.
  Widget _buildLoginForm(S local) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEmailField(local),
              SizedBox(height: 15,),
              _buildPasswordField(provider, local),
              _buildNavigationButtons(local),
              _buildLoginButton(provider, local),
              _buildOrSignInWithText(local),
              _buildGoogleSignInButton(provider, local),
            ],
          ),
        );
      },
    );
  }

  /// Email input field with validation.
  Widget _buildEmailField(S local) {
    return AppTextField(
      controller: _emailController,
      hint: local.email,
      prefix: Icons.email_outlined,
      borderRadius: 7,
      validator: (value) => value?.isEmpty == true ? local.emailRequired : null,
    );
  }

  /// Password input field with visibility toggle.
  Widget _buildPasswordField(UserProvider provider, S local) {
    return AppTextField(
      controller: _passwordController,
      hint: local.password,
      obscureText: provider.isPasswordObscured,
      prefix: Icons.lock_outline,
      suffix: IconButton(
        icon: Icon(provider.passwordIcon),
        onPressed: provider.togglePasswordVisibility,
      ),
      borderRadius: 7,
      validator: (value) => value?.isEmpty == true ? local.passwordRequired : null,
    );
  }

  /// Navigation buttons for SignUp and Forget Password.
  Widget _buildNavigationButtons(S local) {
    return Row(
      children: [
        _buildSignUpButton(local),
        const Spacer(),
        _buildForgetPasswordButton(local),
      ],
    );
  }

  /// SignUp navigation button.
  Widget _buildSignUpButton(S local) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login/signup'),
      child: Text(local.signUp),
    );
  }

  /// Forget Password navigation button.
  Widget _buildForgetPasswordButton(S local) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login/forget_pass'),
      child: Text(local.forgetPassword),
    );
  }

  /// Login button to submit the form.
  Widget _buildLoginButton(UserProvider provider, S local) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: AppButton(
        height: 60,
        borderRadius: 7,
        backgroundColor: Colors.teal.shade500,
        onTap: () => provider.login(
          context: context,
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
        ),
        child: Text(local.login),
      ),
    );
  }

  /// Separator text for 'OR SIGN IN WITH' section.
  Widget _buildOrSignInWithText(S local) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        local.orSignInWith,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  /// Google Sign-In button.
  Widget _buildGoogleSignInButton(UserProvider provider, S local) {
    return AppButton(
      height: 60,
      borderRadius: 7,
      backgroundColor: Colors.white,
      childColor: Colors.black,
      onTap: () => provider.signInWithGoogle(context: context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('images/google.svg'),
          const SizedBox(width: 10),
          Text(
            local.google,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
