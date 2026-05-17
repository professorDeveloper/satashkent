import 'package:dio/dio.dart';

import '../models/competition_model.dart';

class CompetitionsRemoteDataSource {
  final Dio dio;
  const CompetitionsRemoteDataSource({required this.dio});

  Future<CompetitionPageModel> getActive({int page = 1, int limit = 12}) async {
    final response = await dio.get(
      '/competitions/active',
      queryParameters: {'page': page, 'limit': limit},
    );
    return CompetitionPageModel.fromJson(response.data);
  }
}
