import 'package:equatable/equatable.dart';

abstract class QuestionDetailEvent extends Equatable {
  const QuestionDetailEvent();
  @override
  List<Object?> get props => const [];
}

class DetailRequested extends QuestionDetailEvent {
  const DetailRequested();
}

class DetailRefreshed extends QuestionDetailEvent {
  const DetailRefreshed();
}

class AnswerSelected extends QuestionDetailEvent {
  final String answerId;
  const AnswerSelected(this.answerId);
  @override
  List<Object?> get props => [answerId];
}

class AnswerInputChanged extends QuestionDetailEvent {
  final String text;
  const AnswerInputChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class AnswerSubmitted extends QuestionDetailEvent {
  const AnswerSubmitted();
}

class SubmitResultDismissed extends QuestionDetailEvent {
  const SubmitResultDismissed();
}

class CommentDraftChanged extends QuestionDetailEvent {
  final String text;
  const CommentDraftChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class CommentSubmitted extends QuestionDetailEvent {
  const CommentSubmitted();
}
