import 'package:dio/dio.dart';

import '../../domain/entities/assessment_type.dart';
import '../models/assessment_item_model.dart';

class AssessmentsRemoteDataSource {
  final Dio dio;
  const AssessmentsRemoteDataSource({required this.dio});

  Future<AssessmentListPageModel> getList(
    AssessmentType type, {
    int page = 1,
    int limit = 6,
  }) async {
    final response = await dio.get(
      type.endpoint,
      queryParameters: {'page': page, 'limit': limit},
    );
    return AssessmentListPageModel.fromJson(response.data);
  }
}
