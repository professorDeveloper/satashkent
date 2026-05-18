import '../../../../core/error/result.dart';
import '../entities/assessment_item.dart';
import '../entities/assessment_type.dart';

abstract class AssessmentsRepository {
  Future<Result<AssessmentListPage>> getList(
    AssessmentType type, {
    int page = 1,
    int limit = 6,
  });
}
