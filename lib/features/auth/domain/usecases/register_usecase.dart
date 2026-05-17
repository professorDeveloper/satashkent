import '../../../../core/error/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<Result<User>> call({
    required String name,
    required String login,
    required String email,
    required String password,
  }) {
    return _repository.register(
      name: name.trim(),
      login: login.trim(),
      email: email.trim(),
      password: password,
    );
  }
}
