import '../../../../core/error/result.dart';
import '../entities/assessment_item.dart';
import '../entities/assessment_type.dart';
import '../repositories/assessments_repository.dart';

class GetAssessmentListUseCase {
  final AssessmentsRepository _repository;
  GetAssessmentListUseCase(this._repository);

  Future<Result<AssessmentListPage>> call(
    AssessmentType type, {
    int page = 1,
    int limit = 6,
  }) {
    return _repository.getList(type, page: page, limit: limit);
  }
}
