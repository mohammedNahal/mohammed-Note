import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:final_project_note_app/generated/l10n.dart';
import '../../../core/utils/helpers/helpers.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/language_toggle_button.dart';
import 'package:final_project_note_app/presentation/widgets/app_button.dart';

/// Screen for requesting a password reset email.
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> with Helper {
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
    final local = S.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          LanguageToggleButton(),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(local.resetPassword),
      ),
      body: Consumer<UserProvider>(
        builder: (_, provider, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Text(local.forgotPasswordTitle),
                const SizedBox(height: 8),
                Text(
                  local.forgotPasswordDescription,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _buildForm(provider, local),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(UserProvider provider, S local) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _emailController,
            hint: local.email,
            prefix: Icons.email_outlined,
            borderRadius: 7,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return local.emailRequired;
              }
              return null;
            }, keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          AppPrimaryButton(
            backgroundColor: Colors.teal.shade500,
            onPressed: () => provider.resetPassword(
              context: context,
              emailController: _emailController,
              formKey: _formKey,
            ),
            label: local.send,
          ),
        ],
      ),
    );
  }
}
