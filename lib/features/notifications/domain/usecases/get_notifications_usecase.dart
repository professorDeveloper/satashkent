import '../../../../core/error/result.dart';
import '../entities/notification_item.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository _repository;
  GetNotificationsUseCase(this._repository);

  Future<Result<NotificationsPage>> call() => _repository.getAll();
}
