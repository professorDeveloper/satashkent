import '../../../../core/error/result.dart';
import '../entities/balance_sync.dart';
import '../repositories/profile_repository.dart';

class SyncBalanceUseCase {
  final ProfileRepository _repository;
  SyncBalanceUseCase(this._repository);

  Future<Result<BalanceSync>> call() => _repository.syncBalance();
}
