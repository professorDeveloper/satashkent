import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/competition.dart';
import '../../domain/repositories/competitions_repository.dart';
import '../datasources/competitions_remote_data_source.dart';

class CompetitionsRepositoryImpl implements CompetitionsRepository {
  final CompetitionsRemoteDataSource _remote;
  CompetitionsRepositoryImpl(this._remote);

  @override
  Future<Result<CompetitionPage>> getActive({int page = 1, int limit = 12}) async {
    try {
      final page0 = await _remote.getActive(page: page, limit: limit);
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
