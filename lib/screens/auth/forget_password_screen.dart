import 'package:final_project_note_app/widgets/language_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Helpers/Helper.dart';
import '../../generated/l10n.dart';
import '../../provider/user_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

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
            },
          ),
          const SizedBox(height: 25),
          AppButton(
            borderRadius: 7,
            backgroundColor: Colors.teal.shade500,
            onTap: () => provider.resetPassword(
              context: context,
              emailController: _emailController,
              formKey: _formKey,
            ),
            child: Text(local.send),
          ),
        ],
      ),
    );
  }
}
