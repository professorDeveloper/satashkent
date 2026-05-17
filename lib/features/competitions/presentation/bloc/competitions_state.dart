import 'package:equatable/equatable.dart';

import '../../domain/entities/competition.dart';

class CompetitionsState extends Equatable {
  final bool loading;
  final CompetitionPage page;
  final String? errorMessage;

  const CompetitionsState({
    this.loading = false,
    this.page = const CompetitionPage(),
    this.errorMessage,
  });

  bool get isEmpty => !loading && page.isEmpty && errorMessage == null;

  CompetitionsState copyWith({
    bool? loading,
    CompetitionPage? page,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CompetitionsState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [loading, page, errorMessage];
}
