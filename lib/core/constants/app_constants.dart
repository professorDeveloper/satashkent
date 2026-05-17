import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static String get baseUrl =>
      dotenv.maybeGet('API_BASE_URL') ?? 'https://api.satashkent.uz/user-api';

  static String get webBaseUrl =>
      dotenv.maybeGet('WEB_BASE_URL') ?? 'https://1600.satashkent.uz';

  static String? get devLogin => dotenv.maybeGet('DEV_LOGIN');
  static String? get devPassword => dotenv.maybeGet('DEV_PASSWORD');

  static const String authBox = 'auth_box';
  static const String settingsBox = 'settings_box';

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';

  static const String themeModeKey = 'theme_mode';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String languageSelectedKey = 'language_selected';
}
