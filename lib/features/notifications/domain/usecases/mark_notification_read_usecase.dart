import '../../../../core/error/result.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationsRepository _repository;
  MarkNotificationReadUseCase(this._repository);

  Future<Result<bool>> call(String id) => _repository.markRead(id);
}
