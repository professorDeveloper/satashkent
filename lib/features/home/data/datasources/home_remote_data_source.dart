import 'package:dio/dio.dart';

import '../../../auth/data/models/user_model.dart';
import '../models/assessment_active_model.dart';
import '../models/last_exam_result_model.dart';

class HomeRemoteDataSource {
  final Dio dio;
  const HomeRemoteDataSource({required this.dio});

  Future<List<AssessmentActiveModel>> getAssessmentsSummary() async {
    final response = await dio.get('/assessments/summary');
    final data = response.data;
    if (data is! Map || data['result'] is! List) return const [];
    return (data['result'] as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(AssessmentActiveModel.fromJson)
        .toList();
  }

  Future<LastExamResultModel> getLastExamResult() async {
    final response = await dio.get('/profile/last-exam-results');
    return LastExamResultModel.fromJson(response.data);
  }

  Future<UserModel> setGoalScore({
    required int math,
    required int english,
  }) async {
    final response = await dio.put(
      '/profile/set-goal-score',
      data: {'math': math, 'english': english},
    );
    return _unwrapUser(response);
  }

  Future<UserModel> setGoalUniversity(String url) async {
    final response = await dio.put(
      '/profile/set-goal-university',
      data: {'goalUniversity': url},
    );
    return _unwrapUser(response);
  }

  Future<UserModel> setExamDate(DateTime date) async {
    final response = await dio.put(
      '/profile/set-exam-date',
      data: {'tillExam': date.toUtc().toIso8601String()},
    );
    return _unwrapUser(response);
  }

  UserModel _unwrapUser(Response response) {
    final data = response.data;
    if (data is! Map || data['result'] is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid response',
      );
    }
    return UserModel.fromJson(data['result'] as Map<String, dynamic>);
  }
}
