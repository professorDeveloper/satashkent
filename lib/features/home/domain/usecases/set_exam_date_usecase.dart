import '../../../../core/error/result.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/home_repository.dart';

class SetExamDateUseCase {
  final HomeRepository _repository;
  SetExamDateUseCase(this._repository);

  Future<Result<User>> call(DateTime date) => _repository.setExamDate(date);
}
