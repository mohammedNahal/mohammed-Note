import 'package:final_project_note_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/locale_provider.dart';
import '../generated/l10n.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final localeProvider = Provider.of<LocaleProvider>(context);

    return IconButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
        backgroundColor: WidgetStatePropertyAll(AppThemes.lightTheme().primaryColor),
      ),
      onPressed: () {
        localeProvider.setLocale(
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
