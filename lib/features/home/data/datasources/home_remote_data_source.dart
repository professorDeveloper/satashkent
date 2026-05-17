import 'dart:typed_data';

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
    final iso =
        DateTime.utc(date.year, date.month, date.day).toIso8601String();
    final response = await dio.put(
      '/profile/set-exam-date',
      data: {'examDate': iso},
    );
    return _unwrapUser(response);
  }

  Future<String> uploadUserImage({
    required Uint8List bytes,
    required String filename,
    String contentType = 'image/png',
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: DioMediaType.parse(contentType),
      ),
    });
    final response =
        await dio.post('/file-upload/userImages', data: form);
    final url = _extractUrl(response.data);
    if (url == null || url.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Upload returned no URL',
      );
    }
    return url;
  }

  String? _extractUrl(dynamic data) {
    if (data is String) return data;
    if (data is Map) {
      for (final key in ['url', 'link', 'location', 'fileUrl']) {
        final v = data[key];
        if (v is String && v.isNotEmpty) return v;
      }
      final r = data['result'];
      if (r is String && r.isNotEmpty) return r;
      if (r is Map) {
        for (final key in ['url', 'link', 'location', 'fileUrl']) {
          final v = r[key];
          if (v is String && v.isNotEmpty) return v;
        }
      }
    }
    return null;
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
