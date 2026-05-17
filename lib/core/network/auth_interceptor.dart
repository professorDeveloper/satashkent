import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/hive_service.dart';

class AuthInterceptor extends Interceptor {
  static const _skipKey = 'skipAuthInterceptor';
  static const _retriedKey = 'authRetried';

  final HiveService hiveService;
  final Dio dio;
  final VoidCallback? onSessionExpired;

  Future<_RefreshOutcome>? _refreshFuture;

  AuthInterceptor({
    required this.hiveService,
    required this.dio,
    this.onSessionExpired,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[_skipKey] == true) {
      handler.next(options);
      return;
    }
    final token = hiveService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final isRefreshCall = request.path.contains('/auth/refresh');
    final alreadyRetried = request.extra[_retriedKey] == true;
    final isSkipped = request.extra[_skipKey] == true;

    if (err.response?.statusCode != 401 ||
        isRefreshCall ||
        alreadyRetried ||
        isSkipped) {
      handler.next(err);
      return;
    }

    final refreshToken = hiveService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      _log('No refresh token — keeping session, propagating 401');
      handler.next(err);
      return;
    }

    final outcome = await _refresh(refreshToken);
    if (outcome.token != null) {
      request.headers['Authorization'] = 'Bearer ${outcome.token}';
      request.extra[_retriedKey] = true;
      try {
        final retryResponse = await dio.fetch(request);
        handler.resolve(retryResponse);
      } on DioException catch (e) {
        handler.next(e);
      } catch (_) {
        handler.next(err);
      }
      return;
    }

    if (outcome.invalid) {
      _log('Refresh rejected by server — expiring session');
      await _expireSession();
    } else {
      _log('Refresh failed transiently — keeping session, propagating error');
    }
    handler.next(err);
  }

  Future<_RefreshOutcome> _refresh(String refreshToken) {
    _refreshFuture ??= _performRefresh(refreshToken).whenComplete(() {
      _refreshFuture = null;
    });
    return _refreshFuture!;
  }

  Future<_RefreshOutcome> _performRefresh(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          extra: const {_skipKey: true},
          validateStatus: (_) => true,
        ),
      );
      final status = response.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        final data = response.data;
        final result = (data is Map ? data['result'] ?? data : null);
        if (result is! Map) return const _RefreshOutcome.transient();
        final newAccess =
            (result['token'] ?? result['accessToken']) as String? ?? '';
        final newRefresh = result['refreshToken'] as String? ?? refreshToken;
        if (newAccess.isEmpty) return const _RefreshOutcome.transient();
        await hiveService.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );
        return _RefreshOutcome.success(newAccess);
      }
      if (status == 400 || status == 401 || status == 403) {
        return const _RefreshOutcome.invalid();
      }
      return const _RefreshOutcome.transient();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final s = e.response?.statusCode ?? 0;
        if (s == 400 || s == 401 || s == 403) {
          return const _RefreshOutcome.invalid();
        }
      }
      return const _RefreshOutcome.transient();
    } catch (_) {
      return const _RefreshOutcome.transient();
    }
  }

  Future<void> _expireSession() async {
    await hiveService.clearAuth();
    onSessionExpired?.call();
  }

  void _log(String msg) {
    developer.log(msg, name: 'auth');
  }
}

class _RefreshOutcome {
  final String? token;
  final bool invalid;
  const _RefreshOutcome.success(String this.token) : invalid = false;
  const _RefreshOutcome.invalid()
      : token = null,
        invalid = true;
  const _RefreshOutcome.transient()
      : token = null,
        invalid = false;
}
