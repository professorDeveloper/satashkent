import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static String get baseUrl => 'https://api.satashkent.uz/user-api';


  static String? get devLogin => dotenv.maybeGet('DEV_LOGIN') ?? "saikou";

  static String? get devPassword =>
      dotenv.maybeGet('DEV_PASSWORD') ?? "_bujR2NQB7i6L.3";

  static const String authBox = 'auth_box';
  static const String settingsBox = 'settings_box';

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';

  static const String themeModeKey = 'theme_mode';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String languageSelectedKey = 'language_selected';
}
