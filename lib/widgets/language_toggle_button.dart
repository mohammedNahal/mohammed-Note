import 'package:final_project_note_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';
import '../generated/l10n.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final localeProvider = Provider.of<SettingsProvider>(context);

    return IconButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
        backgroundColor: WidgetStatePropertyAll(AppThemes.lightTheme().primaryColor),
      ),
      onPressed: () {
        localeProvider.changeLanguage(
          isArabic ? Locale('en') : Locale('ar'),
        ); // Update the language
      },
      icon: Text(
        isArabic ? 'EN' : 'ع',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
    );
  }
}
