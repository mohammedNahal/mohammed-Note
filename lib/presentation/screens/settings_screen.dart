import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_alter_dialog.dart';

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
            const SizedBox(height: 12),
            _buildLogoutCard(context, appStrings, primaryColor),
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

  /// Builds the logout card with visual feedback and interaction handling
  Widget _buildLogoutCard(
    BuildContext context,
    S appStrings,
    Color primaryColor,
  ) {
    return _styledCard(
      context: context,
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.red.shade700, // Use red shade for destructive actions
        ),
        title: Text(
          appStrings.logout,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.red.shade700,
            fontWeight: FontWeight.w600, // Semi-bold for emphasis
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.red.shade700, // Consistent red accent
          size: 18, // Matches other trailing icon sizing
        ),
        onTap: () {
          AppDialog.show(
            context: context,
            title: appStrings.logout_title,
            content: appStrings.logout_content,
            confirm: appStrings.logout,
            confirmAction:
                () => Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).logout(context: context),
          );
        },
      ),
    );
  }

  /// Common styled card with consistent elevation and interaction effects
  ///
  /// [context]: Current build context for theme access
  /// [child]: Content widget to display inside the card
  ///
  /// Returns: A [Card] widget with unified styling including:
  /// - Rounded corners
  /// - Dynamic shadow based on theme
  /// - Touch ripple effect
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
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
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
