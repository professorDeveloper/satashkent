import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_item.dart';

class NotificationsState extends Equatable {
  final bool loading;
  final NotificationsPage page;
  final String? errorMessage;

  const NotificationsState({
    this.loading = false,
    this.page = const NotificationsPage(),
    this.errorMessage,
  });

  NotificationsState copyWith({
    bool? loading,
    NotificationsPage? page,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [loading, page, errorMessage];
}
