import '../../../../core/error/result.dart';
import '../entities/question.dart';
import '../entities/question_filter.dart';
import '../repositories/questions_repository.dart';

class GetQuestionsUseCase {
  final QuestionsRepository _repository;
  GetQuestionsUseCase(this._repository);

  Future<Result<QuestionsPage>> call({
    required int page,
    int limit = 20,
    QuestionFilter filter = const QuestionFilter(),
  }) {
    return _repository.getQuestions(page: page, limit: limit, filter: filter);
  }
}
