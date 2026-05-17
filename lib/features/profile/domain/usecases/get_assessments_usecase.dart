import '../../../../core/error/result.dart';
import '../entities/assessment_summary.dart';
import '../repositories/profile_repository.dart';

class GetAssessmentsUseCase {
  final ProfileRepository _repository;
  GetAssessmentsUseCase(this._repository);

  Future<Result<List<AssessmentSummary>>> call() => _repository.getAssessments();
}
