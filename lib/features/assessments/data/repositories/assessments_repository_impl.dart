import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/assessment_item.dart';
import '../../domain/entities/assessment_type.dart';
import '../../domain/repositories/assessments_repository.dart';
import '../datasources/assessments_remote_data_source.dart';

class AssessmentsRepositoryImpl implements AssessmentsRepository {
  final AssessmentsRemoteDataSource _remote;
  AssessmentsRepositoryImpl(this._remote);

  @override
  Future<Result<AssessmentListPage>> getList(
    AssessmentType type, {
    int page = 1,
    int limit = 6,
  }) async {
    try {
      final page0 = await _remote.getList(type, page: page, limit: limit);
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
