import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/question.dart';
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
  }) async {
    try {
      final result = await _remote.getQuestions(
        page: page,
        limit: limit,
        filter: filter,
      );
      return Success(result);
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
