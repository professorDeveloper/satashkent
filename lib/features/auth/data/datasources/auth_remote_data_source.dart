import 'package:dio/dio.dart';

import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  const AuthRemoteDataSource({required this.dio});

  Future<AuthModel> login({
    required String login,
    required String password,
    bool rememberMe = true,
  }) async {
    final response = await dio.post(
      '/auth/login',
      data: {
        'login': login,
        'password': password,
        'rememberMe': rememberMe,
      },
    );
    return AuthModel.fromJson(_unwrap(response));
  }

  Future<AuthModel> register({
    required String name,
    required String login,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/auth/register',
      data: {
        'name': name,
        'login': login,
        'email': email,
        'password': password,
      },
    );
    return AuthModel.fromJson(_unwrap(response));
  }

  Future<void> logout() async {
    await dio.post('/auth/logout');
  }

  Future<void> forgotPassword({
    required String login,
    required String url,
  }) async {
    final response = await dio.post(
      '/auth/forgot-password',
      data: {'login': login, 'url': url},
    );
    final body = response.data;
    if (body is Map && body['success'] == false) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: (body['message'] as String?) ?? 'Request failed',
      );
    }
  }

  Map<String, dynamic> _unwrap(Response response) {
    final body = response.data;
    if (body is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid response',
      );
    }
    if (body['success'] == false) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: (body['message'] as String?) ?? 'Request failed',
      );
    }
    final result = body['result'];
    if (result is Map<String, dynamic>) return result;
    return Map<String, dynamic>.from(body);
  }
}
