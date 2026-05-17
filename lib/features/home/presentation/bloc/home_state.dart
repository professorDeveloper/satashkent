import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/assessment_active.dart';
import '../../domain/entities/last_exam_result.dart';

class HomeState extends Equatable {
  final bool loading;
  final bool mutating;
  final User? user;
  final LastExamResult lastExam;
  final List<AssessmentActive> assessments;
  final String? errorMessage;
  final String? toastMessage;
  final int toastNonce;

  const HomeState({
    this.loading = false,
    this.mutating = false,
    this.user,
    this.lastExam = const LastExamResult(),
    this.assessments = const [],
    this.errorMessage,
    this.toastMessage,
    this.toastNonce = 0,
  });

  HomeState copyWith({
    bool? loading,
    bool? mutating,
    User? user,
    LastExamResult? lastExam,
    List<AssessmentActive>? assessments,
    String? errorMessage,
    bool clearError = false,
    String? toastMessage,
    int? toastNonce,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      mutating: mutating ?? this.mutating,
      user: user ?? this.user,
      lastExam: lastExam ?? this.lastExam,
      assessments: assessments ?? this.assessments,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      toastMessage: toastMessage ?? this.toastMessage,
      toastNonce: toastNonce ?? this.toastNonce,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        mutating,
        user,
        lastExam,
        assessments,
        errorMessage,
        toastMessage,
        toastNonce,
      ];
}
