enum AppLocale {
  uz('uz', 'O‘zbekcha'),
  en('en', 'English');

  final String code;
  final String label;
  const AppLocale(this.code, this.label);

  static AppLocale fromCode(String? code) =>
      AppLocale.values.firstWhere((e) => e.code == code,
          orElse: () => AppLocale.uz);
}
