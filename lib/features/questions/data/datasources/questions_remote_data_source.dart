import 'package:dio/dio.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/question_detail.dart';
import '../../domain/entities/question_filter.dart';
import '../models/question_detail_model.dart';
import '../models/question_model.dart';

class QuestionsRemoteDataSource {
  final Dio dio;
  const QuestionsRemoteDataSource({required this.dio});

  Future<QuestionsPageModel> getQuestions({
    required int page,
    int limit = 20,
    QuestionFilter filter = const QuestionFilter(),
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (filter.search.isNotEmpty) {
      query['search'] = filter.search;
    }
    if (filter.status != null && filter.status != QuestionStatus.unknown) {
      query['submissionStatus'] = QuestionEnums.statusKey(filter.status!);
    }
    if (filter.types.length == 1) {
      query['type'] = QuestionEnums.typeKey(filter.types.first);
    }
    if (filter.complexities.length == 1) {
      query['complexityLevel'] =
          QuestionEnums.complexityKey(filter.complexities.first);
    }
    if (filter.subjects.length == 1) {
      query['subject'] = QuestionEnums.subjectKey(filter.subjects.first);
    }
    final response = await dio.get('/questions', queryParameters: query);
    return QuestionsPageModel.fromJson(
      response.data,
      page: page,
      limit: limit,
    );
  }

  Future<QuestionDetailModel> getQuestionDetail(String id) async {
    final response = await dio.get('/questions/$id');
    final result = _unwrap(response.data);
    if (result is! Map<String, dynamic>) {
      throw Exception('Invalid question detail response');
    }
    return QuestionDetailModel.fromJson(result);
  }

  Future<SubmitResultModel> submitAnswer({
    required String questionId,
    required SubmitAnswer answer,
  }) async {
    final body = answer.answerId != null
        ? {'answer': {'answerId': answer.answerId}}
        : {'answer': {'answer': answer.text ?? ''}};
    final response = await dio.post(
      '/user-submissions/$questionId/submit',
      data: body,
    );
    final result = _unwrap(response.data);
    if (result is! Map<String, dynamic>) {
      throw Exception('Invalid submit response');
    }
    return SubmitResultModel.fromJson(result);
  }

  Future<List<AttemptModel>> getAttempts(String questionId) async {
    final response = await dio.get('/user-submissions/$questionId');
    final result = _unwrap(response.data);
    if (result is! List) return const [];
    return result
        .whereType<Map<String, dynamic>>()
        .map(AttemptModel.fromJson)
        .toList();
  }

  Future<QuestionCommentsModel> getComments(
    String questionId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/questions/$questionId/comments',
      queryParameters: {'page': page, 'limit': limit},
    );
    final result = _unwrap(response.data);
    if (result is! Map<String, dynamic>) {
      return const QuestionCommentsModel();
    }
    return QuestionCommentsModel.fromJson(result);
  }

  Future<QuestionCommentModel> postComment({
    required String questionId,
    required String text,
  }) async {
    final response = await dio.post(
      '/questions/$questionId/comment',
      data: {
        'comment': text,
        'assessmentId': '',
        'assessmentType': '',
      },
    );
    final result = _unwrap(response.data);
    if (result is Map<String, dynamic>) {
      return QuestionCommentModel.fromJson(result);
    }
    return QuestionCommentModel(
      id: '',
      comment: text,
      createdAt: DateTime.now(),
    );
  }

  dynamic _unwrap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['result'] ?? data;
    }
    return data;
  }
}
