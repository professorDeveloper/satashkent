import '../../../../core/error/result.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/home_repository.dart';

class SetGoalScoreUseCase {
  final HomeRepository _repository;
  SetGoalScoreUseCase(this._repository);

  Future<Result<User>> call({required int math, required int english}) =>
      _repository.setGoalScore(math: math, english: english);
}
