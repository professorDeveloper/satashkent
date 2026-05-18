import 'package:dio/dio.dart';

import '../models/level_check_model.dart';

class LevelChecksRemoteDataSource {
  final Dio dio;
  const LevelChecksRemoteDataSource({required this.dio});

  Future<LevelChecksPageModel> getNew({int page = 1, int limit = 6}) async {
    final response = await dio.get(
      '/level-checks/new',
      queryParameters: {'page': page, 'limit': limit},
    );
    return LevelChecksPageModel.fromJson(response.data);
  }
}
