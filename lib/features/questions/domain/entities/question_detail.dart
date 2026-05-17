import 'package:equatable/equatable.dart';

import 'question.dart';

class Answer extends Equatable {
  final String id;
  final String content;
  final String contentLatex;
  final String latexHtmlLink;

  const Answer({
    required this.id,
    this.content = '',
    this.contentLatex = '',
    this.latexHtmlLink = '',
  });

  @override
  List<Object?> get props => [id, content, contentLatex, latexHtmlLink];
}

class QuestionDetail extends Equatable {
  final String id;
  final String title;
  final String content;
  final String contentLatex;
  final String latexHtmlLink;
  final QuestionType type;
  final QuestionComplexity complexity;
  final QuestionSubject subject;
  final List<Answer> answers;

  const QuestionDetail({
    required this.id,
    this.title = '',
    this.content = '',
    this.contentLatex = '',
    this.latexHtmlLink = '',
    this.type = QuestionType.unknown,
    this.complexity = QuestionComplexity.unknown,
    this.subject = QuestionSubject.unknown,
    this.answers = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        contentLatex,
        latexHtmlLink,
        type,
        complexity,
        subject,
        answers,
      ];
}

class Attempt extends Equatable {
  final String answer;
  final bool isRight;

  const Attempt({required this.answer, required this.isRight});

  @override
  List<Object?> get props => [answer, isRight];
}

class CommentAuthor extends Equatable {
  final String id;
  final String name;
  final String image;

  const CommentAuthor({
    required this.id,
    this.name = '',
    this.image = '',
  });

  @override
  List<Object?> get props => [id, name, image];
}

class QuestionComment extends Equatable {
  final String id;
  final String comment;
  final DateTime? createdAt;
  final CommentAuthor author;
  final bool hasReply;

  const QuestionComment({
    required this.id,
    this.comment = '',
    this.createdAt,
    this.author = const CommentAuthor(id: ''),
    this.hasReply = false,
  });

  @override
  List<Object?> get props => [id, comment, createdAt, author, hasReply];
}

class QuestionComments extends Equatable {
  final List<QuestionComment> items;
  final int total;

  const QuestionComments({this.items = const [], this.total = 0});

  @override
  List<Object?> get props => [items, total];
}

class SubmitAnswer extends Equatable {
  final String? answerId;
  final String? text;

  const SubmitAnswer.option(this.answerId) : text = null;
  const SubmitAnswer.input(this.text) : answerId = null;

  @override
  List<Object?> get props => [answerId, text];
}

class SubmitResult extends Equatable {
  final bool isRight;

  const SubmitResult({required this.isRight});

  @override
  List<Object?> get props => [isRight];
}
