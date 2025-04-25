import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/settings_provider.dart';
import '../../generated/l10n.dart';

/// Settings screen for managing language and theme preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appStrings = S.of(context);
    final settings = context.watch<SettingsProvider>();
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = context.select<SettingsProvider, bool>(
      (provider) => provider.themeMode == ThemeMode.dark,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Scaffold(
        key: ValueKey(isDark), // triggers the animation when the theme changes
        appBar: AppBar(
          title: Text(appStrings.setting),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.8),
                  primaryColor.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12),
          children: [
            _buildLanguageSelection(
              context,
              settings,
              appStrings,
              primaryColor,
            ),
            const SizedBox(height: 12),
            _buildThemeToggle(
              context,
              settings,
              appStrings,
              primaryColor,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the language selection tile
  Widget _buildLanguageSelection(
    BuildContext context,
    SettingsProvider settings,
    S appStrings,
    Color primaryColor,
  ) {
    final currentLang = settings.locale.languageCode;

    return _styledCard(
      context: context,
      child: ListTile(
        leading: Icon(Icons.language, color: primaryColor),
        title: Text(
          appStrings.lang,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          currentLang == 'en' ? appStrings.en : appStrings.ar,
          style: TextStyle(color: Colors.grey.shade700),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: primaryColor),
        onTap: () => _showLanguageSelection(context, appStrings, currentLang),
      ),
    );
  }

  /// Builds the theme toggle switch
  Widget _buildThemeToggle(
    BuildContext context,
    SettingsProvider settings,
    S texts,
    Color primaryColor,
    bool isDark,
  ) {
    return _styledCard(
      context: context,
      child: SwitchListTile(
        secondary: Icon(Icons.brightness_6, color: primaryColor),
        title: Text(
          texts.theme,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          isDark ? texts.dark : texts.light,
          style: TextStyle(color: Colors.grey.shade700),
        ),
        value: isDark,
        activeColor: primaryColor,
        onChanged: (value) {
          final newMode = value ? ThemeMode.dark : ThemeMode.light;
          settings.changeTheme(newMode);
        },
      ),
    );
  }

  /// Common styled card with shadow and ripple effect
  Widget _styledCard({required Widget child, required BuildContext context}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        highlightColor: Colors.transparent,
        child: child,
      ),
    );
  }

  /// Bottom sheet for language options
  void _showLanguageSelection(
    BuildContext context,
    S appStrings,
    String currentLang,
  ) {
    final primaryColor = Theme.of(context).primaryColor;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appStrings.chooseLang,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _buildLanguageOption(
                  context: context,
                  title: appStrings.en,
                  locale: const Locale('en'),
                  selected: currentLang == 'en',
                  color: primaryColor,
                ),
                const Divider(),
                _buildLanguageOption(
                  context: context,
                  title: appStrings.ar,
                  locale: const Locale('ar'),
                  selected: currentLang == 'ar',
                  color: primaryColor,
                ),
              ],
            ),
          ),
    );
  }

  /// Builds each language option with selection indicator
  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required Locale locale,
    required bool selected,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(Icons.translate, color: selected ? color : null),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? color : null,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing:
          selected
              ? Icon(Icons.check_circle, color: color)
              : const SizedBox.shrink(),
      onTap: () {
        context.read<SettingsProvider>().changeLanguage(locale);
        Navigator.pop(context);
      },
    );
  }
}
