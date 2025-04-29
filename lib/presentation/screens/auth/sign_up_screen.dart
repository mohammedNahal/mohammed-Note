import 'package:final_project_note_app/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/Helpers/helpers.dart';
import '../../../generated/l10n.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_text_field.dart';

import '../../widgets/language_toggle_button.dart';

/// Screen for user registration (Sign Up)
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with Helper {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _rePasswordController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  // Initialize all controllers
  void _initializeControllers() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  // Dispose all controllers
  void _disposeControllers() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
  }

  // Clean the form fields
  void _cleanForm() {
    _emailController.clear();
    _passwordController.clear();
    _rePasswordController.clear();
    _fullNameController.clear();
    _phoneNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final local = S.of(context); // Localized text reference

    return Scaffold(
      appBar: _buildAppBar(local),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (_, provider, __) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildForm(context, provider, local),
            );
          },
        ),
      ),
    );
  }

  // Build the AppBar with back navigation
  AppBar _buildAppBar(S local) {
    return AppBar(
      actions: [
        LanguageToggleButton(),
      ],
      title: Text(local.signUp), // 'Sign Up'
      leading: IconButton(
        onPressed: () {
          _cleanForm();
          Navigator.pushReplacementNamed(context, '/login');
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  // Build the form with all input fields and buttons
  Widget _buildForm(BuildContext context, UserProvider provider, S local) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildWelcomeText(local),
        const SizedBox(height: 20),
        _buildRegistrationForm(context, provider, local),
      ],
    );
  }

  // Build the welcome text at the top of the form
  Widget _buildWelcomeText(S local) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(local.welcome), // 'Welcome...'
        const SizedBox(height: 8),
        Text(
          local.createAccountToStartTakingNotes, // 'Create an account to start taking notes.'
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Build the registration form fields
  Widget _buildRegistrationForm(BuildContext context, UserProvider provider, S local) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(_fullNameController, local.fullName, TextInputType.text, Icons.person_2_outlined, local.fullNameRequired,),
          const SizedBox(height: 10),
          _buildTextField(_emailController, local.email,TextInputType.emailAddress, Icons.email_outlined, local.emailRequired),
          const SizedBox(height: 10),
          _buildPasswordField(_passwordController, local.password, provider.isPasswordObscured, provider.passwordIcon, provider.togglePasswordVisibility, local.passwordRequired),
          const SizedBox(height: 10),
          _buildPasswordField(_rePasswordController, local.confirmPassword, provider.isRePasswordObscured, provider.rePasswordIcon, provider.toggleRePasswordVisibility, local.confirmPasswordRequired, confirmPassword: true),
          const SizedBox(height: 10),
          _buildTextField(_phoneNumberController, local.phoneNumber,  TextInputType.text, Icons.phone, local.phoneNumberRequired),
          const SizedBox(height: 25),
          _buildSignUpButton(provider, context, local),
          const SizedBox(height: 20),
          _buildOrSignInWithText(local),
          const SizedBox(height: 15),
          _buildGoogleSignInButton(provider, context, local),
        ],
      ),
    );
  }

  // Build a regular text field with validation
  Widget _buildTextField(TextEditingController controller, String hint, TextInputType keyboardType, IconData prefix, String validationMessage) {
    return AppTextField(
      keyboardType: keyboardType,
      controller: controller,
      hint: hint,
      prefix: prefix,
      borderRadius: 7,
      validator: (value) => (value == null || value.isEmpty) ? validationMessage : null,
    );
  }

  // Build password fields with visibility toggle
  Widget _buildPasswordField(TextEditingController controller, String hint, bool obscureText, IconData suffixIcon, VoidCallback toggleVisibility, String validationMessage, {bool confirmPassword = false}) {
    return AppTextField(
      keyboardType: TextInputType.visiblePassword,
      controller: controller,
      hint: hint,
      prefix: Icons.lock_outline,
      obscureText: obscureText,
      suffix: IconButton(
        icon: Icon(suffixIcon),
        onPressed: toggleVisibility,
      ),
      borderRadius: 7,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        if (confirmPassword && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  // Build the sign-up button
  Widget _buildSignUpButton(UserProvider provider, BuildContext context, S local) {
    return AppPrimaryButton(
      backgroundColor: Colors.teal.shade500,
      onPressed: () => provider.signup(
        context: context,
        passwordController: _passwordController,
        emailController: _emailController,
        formKey: _formKey,
      ),
      label: local.signUp, // 'Sign Up'
    );
  }

  // Build the "OR SIGN IN WITH" text
  Widget _buildOrSignInWithText(S local) {
    return Text(
      local.orSignInWith, // '- OR SIGN IN WITH -'
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  // Build the Google sign-in button
  Widget _buildGoogleSignInButton(UserProvider provider, BuildContext context, S strings) {
    return AppPrimaryButton(
      backgroundColor: Colors.white,
      textColor: Colors.black,
      onPressed: () {
        provider.signInWithGoogle(context: context);
      },
      label: strings.google,
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     SvgPicture.asset('images/google.svg'),
      //     const SizedBox(width: 10),
      //     const Text(
      //       'GOOGLE',
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //     ),
      //   ],
      // ),
    );
  }
}
