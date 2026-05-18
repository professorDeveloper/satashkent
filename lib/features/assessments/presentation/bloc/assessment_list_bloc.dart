import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/assessment_type.dart';
import '../../domain/usecases/get_assessment_list_usecase.dart';
import 'assessment_list_event.dart';
import 'assessment_list_state.dart';

class AssessmentListBloc
    extends Bloc<AssessmentListEvent, AssessmentListState> {
  final GetAssessmentListUseCase getAssessmentList;
  final AssessmentType type;

  AssessmentListBloc({
    required this.getAssessmentList,
    required this.type,
  }) : super(const AssessmentListState()) {
    on<AssessmentListRequested>(_onRequested);
    on<AssessmentListRefreshed>(_onRefreshed);
  }

  Future<void> _load(Emitter<AssessmentListState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    final result = await getAssessmentList(type);
    result.when(
      success: (page) => emit(state.copyWith(loading: false, page: page)),
      failure: (e) => emit(state.copyWith(
        loading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      )),
    );
  }

  Future<void> _onRequested(
    AssessmentListRequested event,
    Emitter<AssessmentListState> emit,
  ) =>
      _load(emit);

  Future<void> _onRefreshed(
    AssessmentListRefreshed event,
    Emitter<AssessmentListState> emit,
  ) =>
      _load(emit);
}
