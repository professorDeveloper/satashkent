import '../../../../core/error/result.dart';
import '../entities/notification_item.dart';

abstract class NotificationsRepository {
  Future<Result<NotificationsPage>> getAll();
  Future<Result<bool>> markRead(String id);
}
