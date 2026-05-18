import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/level_check.dart';
import '../../domain/repositories/level_checks_repository.dart';
import '../datasources/level_checks_remote_data_source.dart';

class LevelChecksRepositoryImpl implements LevelChecksRepository {
  final LevelChecksRemoteDataSource _remote;
  LevelChecksRepositoryImpl(this._remote);

  @override
  Future<Result<LevelChecksPage>> getNew({int page = 1, int limit = 6}) async {
    try {
      final page0 = await _remote.getNew(page: page, limit: limit);
      return Success(page0);
    } on DioException catch (e) {
      return Failure(Exception(_messageFrom(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  String _messageFrom(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return e.message ?? 'Xatolik yuz berdi';
  }
}
