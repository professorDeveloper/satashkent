import '../../../../core/error/result.dart';
import '../entities/competition.dart';
import '../repositories/competitions_repository.dart';

class GetActiveCompetitionsUseCase {
  final CompetitionsRepository _repository;
  GetActiveCompetitionsUseCase(this._repository);

  Future<Result<CompetitionPage>> call({int page = 1, int limit = 12}) {
    return _repository.getActive(page: page, limit: limit);
  }
}
