import 'package:equatable/equatable.dart';

import '../../domain/entities/level_check.dart';

class LevelChecksState extends Equatable {
  final bool loading;
  final LevelChecksPage page;
  final String? errorMessage;

  const LevelChecksState({
    this.loading = false,
    this.page = const LevelChecksPage(),
    this.errorMessage,
  });

  bool get isEmpty => !loading && page.isEmpty && errorMessage == null;

  LevelChecksState copyWith({
    bool? loading,
    LevelChecksPage? page,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LevelChecksState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [loading, page, errorMessage];
}
