import '../../../../core/error/result.dart';
import '../entities/level_check.dart';
import '../repositories/level_checks_repository.dart';

class GetLevelChecksUseCase {
  final LevelChecksRepository _repository;
  GetLevelChecksUseCase(this._repository);

  Future<Result<LevelChecksPage>> call({int page = 1, int limit = 6}) {
    return _repository.getNew(page: page, limit: limit);
  }
}
