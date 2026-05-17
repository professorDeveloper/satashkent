import '../../domain/entities/notification_item.dart';

class NotificationItemModel extends NotificationItem {
  const NotificationItemModel({
    required super.id,
    super.status,
    super.type,
    super.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> j) =>
      NotificationItemModel(
        id: (j['_id'] ?? j['id'] ?? '') as String,
        status: (j['status'] as String?) ?? 'new',
        type: (j['type'] as String?) ?? '',
        createdAt: j['createdAt'] is String
            ? DateTime.tryParse(j['createdAt'] as String)
            : null,
      );
}

class NotificationsPageModel extends NotificationsPage {
  const NotificationsPageModel({super.items, super.newTotal});

  factory NotificationsPageModel.fromJson(dynamic raw) {
    if (raw is! Map) return const NotificationsPageModel();
    final result = raw['result'];
    final source = result is Map<String, dynamic> ? result : raw;
    final list = source['notifications'];
    return NotificationsPageModel(
      items: list is List<dynamic>
          ? list
              .whereType<Map<String, dynamic>>()
              .map(NotificationItemModel.fromJson)
              .toList()
          : const [],
      newTotal: (source['newTotal'] as num?)?.toInt() ?? 0,
    );
  }
}
