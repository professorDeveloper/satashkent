import '../../../../core/error/result.dart';
import '../entities/question_detail.dart';
import '../repositories/questions_repository.dart';

class PostCommentUseCase {
  final QuestionsRepository _repository;
  PostCommentUseCase(this._repository);

  Future<Result<QuestionComment>> call({
    required String questionId,
    required String text,
  }) =>
      _repository.postComment(questionId: questionId, text: text);
}
