import '../../../../core/error/result.dart';
import '../entities/question_detail.dart';
import '../repositories/questions_repository.dart';

class SubmitAnswerUseCase {
  final QuestionsRepository _repository;
  SubmitAnswerUseCase(this._repository);

  Future<Result<SubmitResult>> call({
    required String questionId,
    required SubmitAnswer answer,
  }) =>
      _repository.submitAnswer(questionId: questionId, answer: answer);
}
