import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Core
import 'package:final_project_note_app/core/constants/app_assets.dart';
import 'package:final_project_note_app/core/constants/app_dimens.dart';
import 'package:final_project_note_app/core/constants/app_strings.dart';
import 'package:final_project_note_app/core/themes/app_colors.dart';
import 'package:final_project_note_app/core/utils/helpers/helpers.dart';
import 'package:final_project_note_app/generated/l10n.dart';

// Presentation
import 'package:final_project_note_app/presentation/providers/auth_provider.dart';
import 'package:final_project_note_app/presentation/widgets/app_button.dart';
import 'package:final_project_note_app/presentation/widgets/app_text_field.dart';
import 'package:final_project_note_app/presentation/widgets/language_toggle_button.dart';

/// LoginScreen handles email/password and social authentication.
/// It includes form validation, state handling, and navigation to related routes.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helper {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);
    final colors = AppColors();

    return Scaffold(
      appBar: _buildAppBar(theme, strings),
      body: _buildBody(theme, strings, colors),
    );
  }

  /// Builds the AppBar with a localized title and language switcher.
  PreferredSizeWidget _buildAppBar(ThemeData theme, S strings) {
    return AppBar(
      title: Text(
        strings.login,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      ),
      centerTitle: true,
      actions: const [LanguageToggleButton()],
      elevation: 0,
      scrolledUnderElevation: 4,
    );
  }

  /// Constructs the scrollable login body including header and form section.
  Widget _buildBody(ThemeData theme, S strings, AppColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePadding,
        vertical: AppDimens.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(theme, strings),
          const SizedBox(height: AppDimens.xxl),
          _buildAuthForm(strings, colors),
        ],
      ),
    );
  }

  /// Displays welcome message and login instructions.
  Widget _buildHeaderSection(ThemeData theme, S strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.welcomeBack,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: AppDimens.sm),
        Text(
          strings.loginInstructions,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Main login form widget using Provider for state management.
  Widget _buildAuthForm(S strings, AppColors colors) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              _buildEmailField(strings),
              const SizedBox(height: AppDimens.lg),
              _buildPasswordField(strings),
              const SizedBox(height: AppDimens.xl),
              _buildAuthActions(provider, strings, colors),
              const SizedBox(height: AppDimens.xxl),
              _buildSocialAuthSection(provider, strings, colors),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmailField(S strings) {
    return AppTextField(
      controller: _emailController,
      hint: strings.email,
      prefix: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => validateEmail(value, strings),
    );
  }

  Widget _buildPasswordField(S strings) {
    return AppTextField(
      controller: _passwordController,
      hint: strings.password,
      prefix: Icons.lock_outlined,
      obscureText: !_isPasswordVisible,
      suffix: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
      validator: (value) => validatePassword(value, strings),
      keyboardType: TextInputType.visiblePassword,
    );
  }

  Widget _buildAuthActions(UserProvider provider, S strings, AppColors colors) {
    return Column(
      children: [
        AppPrimaryButton(
          label: strings.login,
          isLoading: provider.isLoading,
          onPressed: () => _handleLogin(provider),
        ),
        const SizedBox(height: AppDimens.lg),
        _buildAuthNavigation(strings),
      ],
    );
  }

  /// Handles login logic using provider method.
  Future<void> _handleLogin(UserProvider provider) async {
    if (_formKey.currentState?.validate() ?? false) {
      await provider.login(
        context: context,
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
      );
    }
  }

  /// Navigation links to registration and password reset.
  Widget _buildAuthNavigation(S strings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/login/signup'),
          child: Text(strings.signUp, style: TextStyle(color: AppColors.primary)),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/login/forget_pass'),
          child: Text(strings.resetPassword, style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  /// Google login section including divider and button.
  Widget _buildSocialAuthSection(UserProvider provider, S strings, AppColors colors) {
    return Column(
      children: [
        _buildSocialDivider(strings, colors),
        const SizedBox(height: AppDimens.xl),
        _buildGoogleAuthButton(provider, strings),
      ],
    );
  }

  Widget _buildSocialDivider(S strings, AppColors colors) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.sm),
          child: Text(
            strings.orSignInWith,
            style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8)),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }


  Widget _buildGoogleAuthButton(UserProvider provider, S strings) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.md),
        side: BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        ),
      ),
      onPressed: () => provider.signInWithGoogle(context: context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppAssets.googleLogo),
          const SizedBox(width: AppDimens.sm),
          Text(
            strings.google,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
