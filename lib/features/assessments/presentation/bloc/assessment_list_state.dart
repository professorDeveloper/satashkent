import 'package:equatable/equatable.dart';

import '../../domain/entities/assessment_item.dart';

class AssessmentListState extends Equatable {
  final bool loading;
  final AssessmentListPage page;
  final String? errorMessage;

  const AssessmentListState({
    this.loading = false,
    this.page = const AssessmentListPage(),
    this.errorMessage,
  });

  bool get isEmpty => !loading && page.isEmpty && errorMessage == null;

  AssessmentListState copyWith({
    bool? loading,
    AssessmentListPage? page,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AssessmentListState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [loading, page, errorMessage];
}
