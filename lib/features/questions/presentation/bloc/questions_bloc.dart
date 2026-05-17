import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/question_filter.dart';
import '../../domain/usecases/get_questions_usecase.dart';

abstract class QuestionsEvent extends Equatable {
  const QuestionsEvent();
  @override
  List<Object?> get props => const [];
}

class QuestionsRequested extends QuestionsEvent {
  const QuestionsRequested();
}

class QuestionsRefreshed extends QuestionsEvent {
  const QuestionsRefreshed();
}

class QuestionsNextPageRequested extends QuestionsEvent {
  const QuestionsNextPageRequested();
}

class QuestionsFilterChanged extends QuestionsEvent {
  final QuestionFilter filter;
  const QuestionsFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class QuestionsSearchChanged extends QuestionsEvent {
  final String search;
  const QuestionsSearchChanged(this.search);
  @override
  List<Object?> get props => [search];
}

class QuestionsState extends Equatable {
  final bool loading;
  final bool loadingMore;
  final List<Question> items;
  final int total;
  final int page;
  final int limit;
  final QuestionFilter filter;
  final String? errorMessage;

  const QuestionsState({
    this.loading = false,
    this.loadingMore = false,
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.filter = const QuestionFilter(),
    this.errorMessage,
  });

  bool get hasMore => items.length < total;

  QuestionsState copyWith({
    bool? loading,
    bool? loadingMore,
    List<Question>? items,
    int? total,
    int? page,
    int? limit,
    QuestionFilter? filter,
    String? errorMessage,
    bool clearError = false,
  }) {
    return QuestionsState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      filter: filter ?? this.filter,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        loadingMore,
        items,
        total,
        page,
        limit,
        filter,
        errorMessage,
      ];
}

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  final GetQuestionsUseCase getQuestionsUseCase;
  int _generation = 0;

  QuestionsBloc({required this.getQuestionsUseCase})
      : super(const QuestionsState()) {
    on<QuestionsRequested>(_onRequested);
    on<QuestionsRefreshed>(_onRefreshed);
    on<QuestionsNextPageRequested>(_onNextPage);
    on<QuestionsFilterChanged>(_onFilterChanged);
    on<QuestionsSearchChanged>(_onSearchChanged);
  }

  Future<void> _reload(Emitter<QuestionsState> emit, QuestionFilter filter) async {
    final gen = ++_generation;
    emit(state.copyWith(
      loading: true,
      page: 1,
      items: const [],
      filter: filter,
      clearError: true,
    ));
    final res = await getQuestionsUseCase(
      page: 1,
      limit: state.limit,
      filter: filter,
    );
    if (gen != _generation || emit.isDone) return;
    res.when(
      success: (p) => emit(state.copyWith(
        loading: false,
        items: p.items,
        total: p.total,
        page: 1,
      )),
      failure: (e) => emit(state.copyWith(
        loading: false,
        errorMessage: _errorText(e),
      )),
    );
  }

  Future<void> _onRequested(
    QuestionsRequested event,
    Emitter<QuestionsState> emit,
  ) =>
      _reload(emit, state.filter);

  Future<void> _onRefreshed(
    QuestionsRefreshed event,
    Emitter<QuestionsState> emit,
  ) =>
      _reload(emit, state.filter);

  Future<void> _onNextPage(
    QuestionsNextPageRequested event,
    Emitter<QuestionsState> emit,
  ) async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    final gen = _generation;
    final nextPage = state.page + 1;
    emit(state.copyWith(loadingMore: true, clearError: true));
    final res = await getQuestionsUseCase(
      page: nextPage,
      limit: state.limit,
      filter: state.filter,
    );
    if (gen != _generation || emit.isDone) return;
    res.when(
      success: (p) => emit(state.copyWith(
        loadingMore: false,
        items: [...state.items, ...p.items],
        total: p.total,
        page: nextPage,
      )),
      failure: (e) => emit(state.copyWith(
        loadingMore: false,
        errorMessage: _errorText(e),
      )),
    );
  }

  Future<void> _onFilterChanged(
    QuestionsFilterChanged event,
    Emitter<QuestionsState> emit,
  ) =>
      _reload(emit, event.filter);

  Future<void> _onSearchChanged(
    QuestionsSearchChanged event,
    Emitter<QuestionsState> emit,
  ) =>
      _reload(emit, state.filter.copyWith(search: event.search));

  String _errorText(Exception e) =>
      e.toString().replaceFirst('Exception: ', '');
}
