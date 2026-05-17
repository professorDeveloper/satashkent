import '../../../../core/error/result.dart';
import '../entities/last_exam_result.dart';
import '../repositories/home_repository.dart';

class GetLastExamResultUseCase {
  final HomeRepository _repository;
  GetLastExamResultUseCase(this._repository);

  Future<Result<LastExamResult>> call() => _repository.getLastExamResult();
}
