import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../auth/data/models/user_model.dart';
import '../models/assessment_summary_model.dart';
import '../models/balance_sync_model.dart';

class ProfileRemoteDataSource {
  final Dio dio;
  const ProfileRemoteDataSource({required this.dio});

  Future<UserModel> getProfile() async {
    final response = await dio.get('/profile');
    final data = response.data;
    if (data is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid response',
      );
    }
    if (data['success'] == false) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: (data['message'] as String?) ?? 'Request failed',
      );
    }
    final result = data['result'];
    final user = result is Map<String, dynamic>
        ? result
        : Map<String, dynamic>.from(data);
    return UserModel.fromJson(user);
  }

  Future<List<AssessmentSummaryModel>> getAssessments() async {
    final response = await dio.get('/assessments/recents');
    final data = response.data;
    if (data is! Map || data['result'] is! List) return const [];
    return (data['result'] as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(AssessmentSummaryModel.fromJson)
        .toList();
  }

  Future<BalanceSyncModel> syncBalance() async {
    try {
      final response = await dio.get(
        '/profile/sync/balance',
        options: Options(validateStatus: (_) => true),
      );
      return BalanceSyncModel.fromJson(response.data);
    } on DioException catch (e) {
      return BalanceSyncModel.fromJson(e.response?.data);
    }
  }

  Future<UserModel> updateProfile({
    required String name,
    required String login,
    String? email,
    String? phone,
  }) async {
    final body = <String, dynamic>{'name': name, 'login': login};
    if (email != null) body['email'] = email;
    if (phone != null) body['phone'] = phone;
    final response = await dio.put('/profile', data: body);
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

  Future<String?> updateProfileImage({
    required Uint8List bytes,
    String filename = 'image.jpg',
    String contentType = 'image/jpeg',
  }) async {
    final form = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: DioMediaType.parse(contentType),
      ),
    });
    final response = await dio.put('/profile/image', data: form);
    final data = response.data;
    if (data is Map && data['result'] is Map<String, dynamic>) {
      return (data['result'] as Map<String, dynamic>)['image'] as String?;
    }
    return null;
  }
}
