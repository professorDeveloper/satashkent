import '../../../../core/error/result.dart';
import '../entities/assessment_active.dart';
import '../repositories/home_repository.dart';

class GetAssessmentsSummaryUseCase {
  final HomeRepository _repository;
  GetAssessmentsSummaryUseCase(this._repository);

  Future<Result<List<AssessmentActive>>> call() =>
      _repository.getAssessmentsSummary();
}
