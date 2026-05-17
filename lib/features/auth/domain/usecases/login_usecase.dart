import '../../../../core/error/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<Result<User>> call({
    required String login,
    required String password,
    bool rememberMe = true,
  }) {
    return _repository.login(
      login: login.trim(),
      password: password,
      rememberMe: rememberMe,
    );
  }
}
