import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;
  ForgotPasswordUseCase(this._repository);

  Future<Result<bool>> call({required String login}) {
    return _repository.forgotPassword(login: login);
  }
}
