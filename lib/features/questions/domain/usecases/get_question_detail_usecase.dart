import '../../../../core/error/result.dart';
import '../entities/question_detail.dart';
import '../repositories/questions_repository.dart';

class GetQuestionDetailUseCase {
  final QuestionsRepository _repository;
  GetQuestionDetailUseCase(this._repository);

  Future<Result<QuestionDetail>> call(String id) =>
      _repository.getQuestionDetail(id);
}
