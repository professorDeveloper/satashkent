import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_level_checks_usecase.dart';
import 'level_checks_event.dart';
import 'level_checks_state.dart';

class LevelChecksBloc extends Bloc<LevelChecksEvent, LevelChecksState> {
  final GetLevelChecksUseCase getLevelChecksUseCase;

  LevelChecksBloc({required this.getLevelChecksUseCase})
      : super(const LevelChecksState()) {
    on<LevelChecksRequested>(_onRequested);
    on<LevelChecksRefreshed>(_onRefreshed);
  }

  Future<void> _load(Emitter<LevelChecksState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    final result = await getLevelChecksUseCase();
    result.when(
      success: (page) {
        emit(state.copyWith(loading: false, page: page));
      },
      failure: (e) {
        emit(state.copyWith(
          loading: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      },
    );
  }

  Future<void> _onRequested(
    LevelChecksRequested event,
    Emitter<LevelChecksState> emit,
  ) =>
      _load(emit);

  Future<void> _onRefreshed(
    LevelChecksRefreshed event,
    Emitter<LevelChecksState> emit,
  ) =>
      _load(emit);
}
