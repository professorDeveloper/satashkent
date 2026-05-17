import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_active_competitions_usecase.dart';
import 'competitions_event.dart';
import 'competitions_state.dart';

class CompetitionsBloc extends Bloc<CompetitionsEvent, CompetitionsState> {
  final GetActiveCompetitionsUseCase getActiveCompetitionsUseCase;

  CompetitionsBloc({required this.getActiveCompetitionsUseCase})
      : super(const CompetitionsState()) {
    on<CompetitionsRequested>(_onRequested);
    on<CompetitionsRefreshed>(_onRefreshed);
  }

  Future<void> _load(Emitter<CompetitionsState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    final result = await getActiveCompetitionsUseCase();
    result.when(
      success: (page) => emit(state.copyWith(loading: false, page: page)),
      failure: (e) => emit(state.copyWith(
        loading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      )),
    );
  }

  Future<void> _onRequested(
    CompetitionsRequested event,
    Emitter<CompetitionsState> emit,
  ) =>
      _load(emit);

  Future<void> _onRefreshed(
    CompetitionsRefreshed event,
    Emitter<CompetitionsState> emit,
  ) =>
      _load(emit);
}
