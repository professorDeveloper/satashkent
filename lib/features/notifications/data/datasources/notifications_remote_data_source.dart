import 'package:dio/dio.dart';

import '../models/notification_models.dart';

class NotificationsRemoteDataSource {
  final Dio dio;
  const NotificationsRemoteDataSource({required this.dio});

  Future<NotificationsPageModel> getAll() async {
    final response = await dio.get('/notifications');
    return NotificationsPageModel.fromJson(response.data);
  }

  Future<bool> markRead(String id) async {
    final response = await dio.patch('/notifications/$id/read', data: {});
    final data = response.data;
    if (data is Map && data['success'] == true) return true;
    return false;
  }
}
