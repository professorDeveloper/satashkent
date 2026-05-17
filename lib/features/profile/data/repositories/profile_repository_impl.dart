import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/error/result.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/assessment_summary.dart';
import '../../domain/entities/balance_sync.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;
  final HiveService _hive;

  ProfileRepositoryImpl(this._remote, this._hive);

  @override
  Future<Result<User>> getProfile() async {
    try {
      final user = await _remote.getProfile();
      await _hive.saveUser(user);
      return Success(user);
    } on DioException catch (e) {
      return Failure(Exception(_messageFrom(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<AssessmentSummary>>> getAssessments() async {
    try {
      final list = await _remote.getAssessments();
      return Success(list);
    } on DioException catch (e) {
      return Failure(Exception(_messageFrom(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<BalanceSync>> syncBalance() async {
    try {
      final result = await _remote.syncBalance();
      if (result.success && result.balance != null) {
        final cached = _hive.getUser();
        if (cached != null) {
          await _hive.saveUser(
            UserModel(
              id: cached.id,
              name: cached.name,
              login: cached.login,
              email: cached.email,
              phone: cached.phone,
              image: cached.image,
              tillExam: cached.tillExam,
              goalScore: cached.goalScore,
              hasPassword: cached.hasPassword,
              state: cached.state,
              studentBalance: result.balance!,
              paidUntil: result.paidUntil ?? cached.paidUntil,
            ),
          );
        }
      }
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<User>> updateProfile({
    required String name,
    required String login,
    String? email,
    String? phone,
  }) async {
    try {
      final user = await _remote.updateProfile(
        name: name,
        login: login,
        email: email,
        phone: phone,
      );
      await _hive.saveUser(user);
      return Success(user);
    } on DioException catch (e) {
      return Failure(Exception(_messageFrom(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<String?>> updateProfileImage({
    required Uint8List bytes,
    String filename = 'avatar.jpg',
    String contentType = 'image/jpeg',
  }) async {
    try {
      final url = await _remote.updateProfileImage(
        bytes: bytes,
        filename: filename,
        contentType: contentType,
      );
      if (url != null) {
        final fresh = '$url?t=${DateTime.now().millisecondsSinceEpoch}';
        final cached = _hive.getUser();
        if (cached != null) {
          await _hive.saveUser(
            UserModel(
              id: cached.id,
              name: cached.name,
              login: cached.login,
              email: cached.email,
              phone: cached.phone,
              image: fresh,
              tillExam: cached.tillExam,
              goalScore: cached.goalScore,
              hasPassword: cached.hasPassword,
              state: cached.state,
              studentBalance: cached.studentBalance,
              paidUntil: cached.paidUntil,
            ),
          );
        }
        return Success(fresh);
      }
      return const Success(null);
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
