import '../../../../core/error/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login({
    required String login,
    required String password,
    bool rememberMe = true,
  });

  Future<Result<User>> register({
    required String name,
    required String login,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<Result<bool>> forgotPassword({required String login});

  bool get isLoggedIn;

  User? getCachedUser();
}
