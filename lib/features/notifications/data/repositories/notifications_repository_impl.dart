import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remote;
  NotificationsRepositoryImpl(this._remote);

  @override
  Future<Result<NotificationsPage>> getAll() async {
    try {
      final page = await _remote.getAll();
      return Success(page);
    } on DioException catch (e) {
      return Failure(Exception(_msg(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> markRead(String id) async {
    try {
      final ok = await _remote.markRead(id);
      return Success(ok);
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
