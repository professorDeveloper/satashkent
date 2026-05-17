import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/hive_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final HiveService _hive;

  AuthRepositoryImpl(this._remote, this._hive);

  @override
  Future<Result<User>> login({
    required String login,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      final model = await _remote.login(
        login: login,
        password: password,
        rememberMe: rememberMe,
      );
      if (model.accessToken.isEmpty) {
        return Failure(Exception('Access token not found'));
      }
      await _hive.saveAuth(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
        user: model.user,
      );
      return Success(model.user);
    } on DioException catch (e) {
      return Failure(Exception(_messageFrom(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<User>> register({
    required String name,
    required String login,
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remote.register(
        name: name,
        login: login,
        email: email,
        password: password,
      );
      if (model.accessToken.isEmpty) {
        return Failure(Exception('Access token not found'));
      }
      await _hive.saveAuth(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
        user: model.user,
      );
      return Success(model.user);
    } on DioException catch (e) {
      return Failure(Exception(_messageFrom(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } on DioException catch (_) {
    }
    await _hive.clearAuth();
  }

  @override
  Future<Result<bool>> forgotPassword({required String login}) async {
    try {
      await _remote.forgotPassword(
        login: login.trim(),
        url: "https://1600.satashkent.uz",
      );
      return const Success(true);
    } on DioException catch (e) {
      return Failure(Exception(_messageFrom(e)));
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  bool get isLoggedIn => _hive.isLoggedIn;

  @override
  User? getCachedUser() => _hive.getUser();

  String _messageFrom(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return e.message ?? 'Xatolik yuz berdi';
  }
}
