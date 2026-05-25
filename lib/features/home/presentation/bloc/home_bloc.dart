import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/hive_service.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_assessments_summary_usecase.dart';
import '../../domain/usecases/get_last_exam_result_usecase.dart';
import '../../domain/usecases/set_exam_date_usecase.dart';
import '../../domain/usecases/set_goal_score_usecase.dart';
import '../../domain/usecases/upload_goal_university_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProfileUseCase getProfileUseCase;
  final GetAssessmentsSummaryUseCase getAssessmentsSummaryUseCase;
  final GetLastExamResultUseCase getLastExamResultUseCase;
  final SetGoalScoreUseCase setGoalScoreUseCase;
  final SetExamDateUseCase setExamDateUseCase;
  final UploadGoalUniversityUseCase uploadGoalUniversityUseCase;
  final HiveService hiveService;

  HomeBloc({
    required this.getProfileUseCase,
    required this.getAssessmentsSummaryUseCase,
    required this.getLastExamResultUseCase,
    required this.setGoalScoreUseCase,
    required this.setExamDateUseCase,
    required this.uploadGoalUniversityUseCase,
    required this.hiveService,
  }) : super(HomeState(user: hiveService.getUser())) {
    on<HomeRequested>(_onRequested);
    on<HomeRefreshed>(_onRefreshed);
    on<HomeGoalScoreSubmitted>(_onGoalScore);
    on<HomeExamDateSubmitted>(_onExamDate);
    on<HomeGoalUniversityPicked>(_onUniversityPicked);
    on<HomeUserPatched>(_onUserPatched);
  }

  Future<void> _load(Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    final profileFuture = getProfileUseCase();
    final assessFuture = getAssessmentsSummaryUseCase();
    final examFuture = getLastExamResultUseCase();
    final profileRes = await profileFuture;
    final assessRes = await assessFuture;
    final examRes = await examFuture;
    emit(state.copyWith(
      loading: false,
      user: profileRes.getOrNull() ?? state.user,
      assessments: assessRes.getOrNull() ?? state.assessments,
      lastExam: examRes.getOrNull() ?? state.lastExam,
    ));
  }

  Future<void> _onRequested(HomeRequested event, Emitter<HomeState> emit) =>
      _load(emit);

  Future<void> _onRefreshed(HomeRefreshed event, Emitter<HomeState> emit) =>
      _load(emit);

  Future<void> _onGoalScore(
    HomeGoalScoreSubmitted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(mutating: true));
    final res =
        await setGoalScoreUseCase(math: event.math, english: event.english);
    res.when(
      success: (user) => emit(state.copyWith(
        mutating: false,
        user: user,
        toastMessage: 'goalScoreUpdated',
        toastNonce: state.toastNonce + 1,
      )),
      failure: (e) => emit(state.copyWith(
        mutating: false,
        toastMessage: e.toString().replaceFirst('Exception: ', ''),
        toastNonce: state.toastNonce + 1,
      )),
    );
  }

  Future<void> _onExamDate(
    HomeExamDateSubmitted event,
    Emitter<HomeState> emit,
  )
  async {
    emit(state.copyWith(mutating: true));
    final res = await setExamDateUseCase(event.date);
    res.when(
      success: (user) => emit(state.copyWith(
        mutating: false,
        user: user,
        toastMessage: 'examDateUpdated',
        toastNonce: state.toastNonce + 1,
      )),
      failure: (e) => emit(state.copyWith(
        mutating: false,
        toastMessage: e.toString().replaceFirst('Exception: ', ''),
        toastNonce: state.toastNonce + 1,
      )),
    );
  }

  Future<void> _onUniversityPicked(
    HomeGoalUniversityPicked event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(mutating: true));
    final res = await uploadGoalUniversityUseCase(
      bytes: event.bytes,
      filename: event.filename,
      contentType: event.contentType,
    );
    res.when(
      success: (user) => emit(state.copyWith(
        mutating: false,
        user: user,
        toastMessage: 'goalUniversityUpdated',
        toastNonce: state.toastNonce + 1,
      )),
      failure: (e) => emit(state.copyWith(
        mutating: false,
        toastMessage: e.toString().replaceFirst('Exception: ', ''),
        toastNonce: state.toastNonce + 1,
      )),
    );
  }

  void _onUserPatched(HomeUserPatched event, Emitter<HomeState> emit) {
    emit(state.copyWith(user: event.user));
  }
}
