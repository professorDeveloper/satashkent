import 'package:equatable/equatable.dart';

import '../../domain/entities/question_filter.dart';

abstract class QuestionsEvent extends Equatable {
  const QuestionsEvent();
  @override
  List<Object?> get props => const [];
}

class QuestionsRequested extends QuestionsEvent {
  const QuestionsRequested();
}

class QuestionsRefreshed extends QuestionsEvent {
  const QuestionsRefreshed();
}

class QuestionsNextPageRequested extends QuestionsEvent {
  const QuestionsNextPageRequested();
}

class QuestionsFilterChanged extends QuestionsEvent {
  final QuestionFilter filter;
  const QuestionsFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class QuestionsSearchChanged extends QuestionsEvent {
  final String search;
  const QuestionsSearchChanged(this.search);
  @override
  List<Object?> get props => [search];
}
