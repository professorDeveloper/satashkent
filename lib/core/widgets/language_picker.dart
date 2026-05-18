import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_locale.dart';
import '../theme/app_colors.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Language',
      icon: const Icon(Icons.language_rounded),
      onPressed: () => showLanguageSheet(context),
    );
  }
}

Future<void> showLanguageSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _LanguageSheet(),
  );
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context) {
    final current = AppLocale.fromCode(context.locale.languageCode);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'chooseLanguage'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              for (final l in AppLocale.values) ...[
                _LanguageTile(
                  locale: l,
                  selected: l == current,
                  onTap: () {
                    context.setLocale(Locale(l.code));
                    Navigator.of(context).pop();
                  },
                ),
                if (l != AppLocale.values.last) const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final AppLocale locale;
  final bool selected;
  final VoidCallback onTap;
  const _LanguageTile({
    required this.locale,
    required this.selected,
    required this.onTap,
  });

  String get _flag => switch (locale) {
        AppLocale.uz => '🇺🇿',
        AppLocale.en => '🇬🇧',
      };

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: selected
                ? AppColors.brand.withValues(alpha: 0.10)
                : Theme.of(context).colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
            border: Border.all(
              width: 0.8,
              color: selected
                  ? AppColors.brand
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: Row(
            children: [
              Text(_flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  locale.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.brand,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
