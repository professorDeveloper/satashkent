import 'package:equatable/equatable.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/question_filter.dart';

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
