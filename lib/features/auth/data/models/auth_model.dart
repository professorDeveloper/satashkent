import 'user_model.dart';

class AuthModel {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;

  const AuthModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;
    return AuthModel(
      user: UserModel.fromJson(userJson),
      accessToken:
          (json['token'] ?? json['accessToken']) as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
    );
  }
}
