import '../../../../core/error/result.dart';
import '../entities/question_detail.dart';
import '../repositories/questions_repository.dart';

class GetCommentsUseCase {
  final QuestionsRepository _repository;
  GetCommentsUseCase(this._repository);

  Future<Result<QuestionComments>> call(String questionId) =>
      _repository.getComments(questionId);
}
