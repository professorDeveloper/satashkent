import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_locale.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../../../core/widgets/language_picker.dart';
import '../widgets/settings_link_tile.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<ThemeController>();
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final isDark = controller.isDark;
          final currentLocale =
              AppLocale.fromCode(context.locale.languageCode);
          final muted = Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.45);
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
            children: [
              SettingsSection(
                title: 'appearance'.tr(),
                children: [
                  SettingsSwitchTile(
                    leading: isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    title: 'darkMode'.tr(),
                    value: isDark,
                    onChanged: (_) => controller.toggle(),
                  ),
                  SettingsLinkTile(
                    leading: Icons.language_rounded,
                    title: 'languageLabel'.tr(),
                    trailingText: currentLocale.label,
                    onTap: () => showLanguageSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Center(
                child: Text(
                  'SATASHKENT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.4,
                    color: muted,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'v1.0.0',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
