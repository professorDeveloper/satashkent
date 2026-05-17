import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../../features/auth/data/models/user_model.dart';

class HiveService {
  final Box _authBox = Hive.box(AppConstants.authBox);
  final Box _settingsBox = Hive.box(AppConstants.settingsBox);

  String? getToken() => _authBox.get(AppConstants.accessTokenKey);
  String? getRefreshToken() => _authBox.get(AppConstants.refreshTokenKey);

  bool get isLoggedIn => (getToken()?.isNotEmpty ?? false);

  UserModel? getUser() {
    final raw = _authBox.get(AppConstants.userKey);
    if (raw is! String || raw.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _authBox.put(AppConstants.accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _authBox.put(AppConstants.refreshTokenKey, refreshToken);
    }
  }

  Future<void> saveUser(UserModel user) =>
      _authBox.put(AppConstants.userKey, jsonEncode(user.toJson()));

  Future<void> saveAuth({
    required String accessToken,
    String? refreshToken,
    required UserModel user,
  }) async {
    await saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    await saveUser(user);
  }

  Future<void> clearAuth() async {
    await _authBox.delete(AppConstants.accessTokenKey);
    await _authBox.delete(AppConstants.refreshTokenKey);
    await _authBox.delete(AppConstants.userKey);
  }

  String getThemeMode() => _settingsBox.get(
        AppConstants.themeModeKey,
        defaultValue: 'system',
      );

  Future<void> saveThemeMode(String mode) =>
      _settingsBox.put(AppConstants.themeModeKey, mode);

  bool getOnboardingCompleted() => _settingsBox.get(
        AppConstants.onboardingCompletedKey,
        defaultValue: false,
      );

  Future<void> setOnboardingCompleted(bool value) =>
      _settingsBox.put(AppConstants.onboardingCompletedKey, value);

  bool getLanguageSelected() => _settingsBox.get(
        AppConstants.languageSelectedKey,
        defaultValue: false,
      );

  Future<void> setLanguageSelected(bool value) =>
      _settingsBox.put(AppConstants.languageSelectedKey, value);
}
