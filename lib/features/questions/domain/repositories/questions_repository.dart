import '../../../../core/error/result.dart';
import '../entities/question.dart';
import '../entities/question_detail.dart';
import '../entities/question_filter.dart';

abstract class QuestionsRepository {
  Future<Result<QuestionsPage>> getQuestions({
    required int page,
    int limit = 20,
    QuestionFilter filter = const QuestionFilter(),
  });

  Future<Result<QuestionDetail>> getQuestionDetail(String id);

  Future<Result<SubmitResult>> submitAnswer({
    required String questionId,
    required SubmitAnswer answer,
  });

  Future<Result<List<Attempt>>> getAttempts(String questionId);

  Future<Result<QuestionComments>> getComments(String questionId);

  Future<Result<QuestionComment>> postComment({
    required String questionId,
    required String text,
  });
}
