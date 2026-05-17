import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_locale.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/primary_button.dart';

class LanguageSelectPage extends StatelessWidget {
  const LanguageSelectPage({super.key});

  Future<void> _confirm(BuildContext context) async {
    await getIt<HiveService>().setLanguageSelected(true);
    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final selected = AppLocale.fromCode(context.locale.languageCode);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 4),
              const Align(
                alignment: Alignment.center,
                child: AppLogo(size: 96),
              ),
              const SizedBox(height: 24),
              Text(
                'chooseLanguage'.tr(),
                textAlign: TextAlign.center,
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'chooseLanguageSubtitle'.tr(),
                textAlign: TextAlign.center,
                style: tt.bodySmall?.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: 28),
              for (final locale in AppLocale.values) ...[
                _LanguageCard(
                  locale: locale,
                  selected: selected == locale,
                  onTap: () => context.setLocale(Locale(locale.code)),
                ),
                const SizedBox(height: 10),
              ],
              const Spacer(flex: 2),
              PrimaryButton(
                label: 'continueLabel'.tr(),
                onPressed: () => _confirm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final AppLocale locale;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.locale,
    required this.selected,
    required this.onTap,
  });

  String get _flag {
    switch (locale) {
      case AppLocale.uz:
        return '🇺🇿';
      case AppLocale.en:
        return '🇬🇧';
      case AppLocale.ru:
        return '🇷🇺';
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        splashColor: AppColors.brand.withValues(alpha: 0.14),
        highlightColor: AppColors.brand.withValues(alpha: 0.06),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: selected
                ? AppColors.brand.withValues(alpha: 0.10)
                : AppColors.darkCard,
            border: Border.all(
              width: 0.8,
              color: selected ? AppColors.brand : AppColors.darkBorder,
            ),
          ),
          child: Row(
            children: [
              Text(_flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  locale.label,
                  style: const TextStyle(
                    color: AppColors.darkTextPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _Radio(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  final bool selected;
  const _Radio({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? AppColors.brand
              : AppColors.darkTextSecondary.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedScale(
        scale: selected ? 1 : 0,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutBack,
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.brand,
          ),
        ),
      ),
    );
  }
}
