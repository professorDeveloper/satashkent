import '../../../../core/error/result.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;
  UpdateProfileUseCase(this._repository);

  Future<Result<User>> call({
    required String name,
    required String login,
    String? email,
    String? phone,
  }) {
    return _repository.updateProfile(
      name: name.trim(),
      login: login.trim(),
      email: email == null || email.trim().isEmpty ? null : email.trim(),
      phone: phone == null || phone.trim().isEmpty ? null : phone.trim(),
    );
  }
}
