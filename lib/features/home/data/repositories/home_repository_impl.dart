import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/assessment_active.dart';
import '../../domain/entities/last_exam_result.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remote;
  final HiveService _hive;
  HomeRepositoryImpl(this._remote, this._hive);

  @override
  Future<Result<List<AssessmentActive>>> getAssessmentsSummary() async {
    try {
      final list = await _remote.getAssessmentsSummary();
      return Success(list);
    } on DioException catch (e) {
      return Failure(Exception(_msg(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<LastExamResult>> getLastExamResult() async {
    try {
      final result = await _remote.getLastExamResult();
      return Success(result);
    } on DioException catch (e) {
      return Failure(Exception(_msg(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<User>> setGoalScore({
    required int math,
    required int english,
  }) async {
    try {
      final user = await _remote.setGoalScore(math: math, english: english);
      await _hive.saveUser(user);
      return Success(user);
    } on DioException catch (e) {
      return Failure(Exception(_msg(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<User>> setGoalUniversity(String url) async {
    try {
      final user = await _remote.setGoalUniversity(url);
      await _hive.saveUser(user);
      return Success(user);
    } on DioException catch (e) {
      return Failure(Exception(_msg(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<User>> setExamDate(DateTime date) async {
    try {
      final user = await _remote.setExamDate(date);
      await _hive.saveUser(user);
      return Success(user);
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
