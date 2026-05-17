import 'package:dio/dio.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/question_filter.dart';
import '../models/question_model.dart';

class QuestionsRemoteDataSource {
  final Dio dio;
  const QuestionsRemoteDataSource({required this.dio});

  Future<QuestionsPageModel> getQuestions({
    required int page,
    int limit = 20,
    QuestionFilter filter = const QuestionFilter(),
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (filter.search.isNotEmpty) {
      query['search'] = filter.search;
    }
    if (filter.status != null && filter.status != QuestionStatus.unknown) {
      query['submissionStatus'] = QuestionEnums.statusKey(filter.status!);
    }
    if (filter.types.length == 1) {
      query['type'] = QuestionEnums.typeKey(filter.types.first);
    }
    if (filter.complexities.length == 1) {
      query['complexityLevel'] =
          QuestionEnums.complexityKey(filter.complexities.first);
    }
    if (filter.subjects.length == 1) {
      query['subject'] = QuestionEnums.subjectKey(filter.subjects.first);
    }
    final response = await dio.get('/questions', queryParameters: query);
    return QuestionsPageModel.fromJson(
      response.data,
      page: page,
      limit: limit,
    );
  }
}
