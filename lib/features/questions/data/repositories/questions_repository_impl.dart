import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/question_detail.dart';
import '../../domain/entities/question_filter.dart';
import '../../domain/repositories/questions_repository.dart';
import '../datasources/questions_remote_data_source.dart';

class QuestionsRepositoryImpl implements QuestionsRepository {
  final QuestionsRemoteDataSource _remote;
  QuestionsRepositoryImpl(this._remote);

  @override
  Future<Result<QuestionsPage>> getQuestions({
    required int page,
    int limit = 20,
    QuestionFilter filter = const QuestionFilter(),
  }) =>
      _guard(() => _remote.getQuestions(
            page: page,
            limit: limit,
            filter: filter,
          ));

  @override
  Future<Result<QuestionDetail>> getQuestionDetail(String id) =>
      _guard(() => _remote.getQuestionDetail(id));

  @override
  Future<Result<SubmitResult>> submitAnswer({
    required String questionId,
    required SubmitAnswer answer,
  }) =>
      _guard(() => _remote.submitAnswer(
            questionId: questionId,
            answer: answer,
          ));

  @override
  Future<Result<List<Attempt>>> getAttempts(String questionId) =>
      _guard(() async => await _remote.getAttempts(questionId));

  @override
  Future<Result<QuestionComments>> getComments(String questionId) =>
      _guard(() => _remote.getComments(questionId));

  @override
  Future<Result<QuestionComment>> postComment({
    required String questionId,
    required String text,
  }) =>
      _guard(() => _remote.postComment(
            questionId: questionId,
            text: text,
          ));

  Future<Result<T>> _guard<T>(Future<T> Function() task) async {
    try {
      return Success(await task());
    } on DioException catch (e) {
      return Failure(Exception(_msg(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  String _msg(DioException e) {
    final d = e.response?.data;
    if (d is Map) {
      final m = d['message'];
      if (m is String && m.isNotEmpty) return m;
    }
    return e.message ?? 'Xatolik yuz berdi';
  }
}
