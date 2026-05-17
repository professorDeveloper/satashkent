enum AppLocale {
  uz('uz', 'O‘zbekcha'),
  en('en', 'English'),
  ru('ru', 'Русский');

  final String code;
  final String label;
  const AppLocale(this.code, this.label);

  static AppLocale fromCode(String? code) =>
      AppLocale.values.firstWhere((e) => e.code == code,
          orElse: () => AppLocale.en);
}
