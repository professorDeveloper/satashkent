import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_item.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
  }) : super(const NotificationsState()) {
    on<NotificationsRequested>(_onRequested);
    on<NotificationsRefreshed>(_onRefreshed);
    on<NotificationMarkedRead>(_onMarkedRead);
  }

  Future<void> _load(Emitter<NotificationsState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    final res = await getNotificationsUseCase();
    res.when(
      success: (page) => emit(state.copyWith(
        loading: false,
        page: NotificationsPage(
          items: _sortNewestFirst(page.items),
          newTotal: page.newTotal,
        ),
      )),
      failure: (e) => emit(state.copyWith(
        loading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      )),
    );
  }

  List<NotificationItem> _sortNewestFirst(List<NotificationItem> items) {
    final sorted = [...items];
    sorted.sort((a, b) {
      final aTime = a.createdAt;
      final bTime = b.createdAt;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });
    return sorted;
  }

  Future<void> _onRequested(
    NotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) =>
      _load(emit);

  Future<void> _onRefreshed(
    NotificationsRefreshed event,
    Emitter<NotificationsState> emit,
  ) =>
      _load(emit);

  Future<void> _onMarkedRead(
    NotificationMarkedRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final updated = state.page.items.map((n) {
      if (n.id == event.id) {
        return NotificationItem(
          id: n.id,
          status: 'read',
          type: n.type,
          createdAt: n.createdAt,
        );
      }
      return n;
    }).toList();
    final unread = updated.where((n) => n.isUnread).length;
    emit(state.copyWith(
      page: NotificationsPage(items: updated, newTotal: unread),
    ));
    await markNotificationReadUseCase(event.id);
  }
}
