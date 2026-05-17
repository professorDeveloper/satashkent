import '../../../../core/error/result.dart';
import '../entities/competition.dart';

abstract class CompetitionsRepository {
  Future<Result<CompetitionPage>> getActive({int page = 1, int limit = 12});
}
