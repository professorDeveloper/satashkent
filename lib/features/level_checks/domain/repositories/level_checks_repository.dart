import '../../../../core/error/result.dart';
import '../entities/level_check.dart';

abstract class LevelChecksRepository {
  Future<Result<LevelChecksPage>> getNew({int page = 1, int limit = 6});
}
