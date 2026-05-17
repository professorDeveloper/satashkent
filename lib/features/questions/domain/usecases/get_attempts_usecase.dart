import '../../../../core/error/result.dart';
import '../entities/question_detail.dart';
import '../repositories/questions_repository.dart';

class GetAttemptsUseCase {
  final QuestionsRepository _repository;
  GetAttemptsUseCase(this._repository);

  Future<Result<List<Attempt>>> call(String questionId) =>
      _repository.getAttempts(questionId);
}
