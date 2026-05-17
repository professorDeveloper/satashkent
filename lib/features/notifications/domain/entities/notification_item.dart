import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String id;
  final String status;
  final String type;
  final DateTime? createdAt;

  const NotificationItem({
    required this.id,
    this.status = 'new',
    this.type = '',
    this.createdAt,
  });

  bool get isUnread => status == 'new';

  @override
  List<Object?> get props => [id, status, type, createdAt];
}

class NotificationsPage extends Equatable {
  final List<NotificationItem> items;
  final int newTotal;

  const NotificationsPage({this.items = const [], this.newTotal = 0});

  @override
  List<Object?> get props => [items, newTotal];
}
