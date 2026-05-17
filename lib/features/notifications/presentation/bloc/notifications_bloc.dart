import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_item.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => const [];
}

class NotificationsRequested extends NotificationsEvent {
  const NotificationsRequested();
}

class NotificationsRefreshed extends NotificationsEvent {
  const NotificationsRefreshed();
}

class NotificationMarkedRead extends NotificationsEvent {
  final String id;
  const NotificationMarkedRead(this.id);
  @override
  List<Object?> get props => [id];
}

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
      success: (page) => emit(state.copyWith(loading: false, page: page)),
      failure: (e) => emit(state.copyWith(
        loading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      )),
    );
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
