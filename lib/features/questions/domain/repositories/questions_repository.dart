import '../../../../core/error/result.dart';
import '../entities/question.dart';
import '../entities/question_filter.dart';

abstract class QuestionsRepository {
  Future<Result<QuestionsPage>> getQuestions({
    required int page,
    int limit = 20,
    QuestionFilter filter = const QuestionFilter(),
  });
}
