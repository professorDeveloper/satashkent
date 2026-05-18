import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/question_filter.dart';
import '../../domain/usecases/get_questions_usecase.dart';
import 'questions_event.dart';
import 'questions_state.dart';

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
