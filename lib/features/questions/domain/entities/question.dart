import 'package:equatable/equatable.dart';

enum QuestionType {
  singleChoice,
  multiChoice,
  input,
  multiInput,
  inputOption,
  unknown,
}

enum QuestionComplexity { easy, medium, hard, unknown }

enum QuestionStatus { newOne, correct, wrong, unknown }

enum QuestionSubject {
  math,
  english,
  apCalculus,
  apChemistry,
  apCsA,
  apMacro,
  apMicro,
  apBiology,
  apStatistics,
  apPhysicsC,
  unknown,
}

class Question extends Equatable {
  final String id;
  final String code;
  final String title;
  final String content;
  final QuestionType type;
  final QuestionComplexity complexity;
  final QuestionSubject subject;
  final QuestionStatus status;

  const Question({
    required this.id,
    this.code = '',
    this.title = '',
    this.content = '',
    this.type = QuestionType.unknown,
    this.complexity = QuestionComplexity.unknown,
    this.subject = QuestionSubject.unknown,
    this.status = QuestionStatus.newOne,
  });

  @override
  List<Object?> get props => [id, code, title, content, type, complexity, subject, status];
}

class QuestionsPage extends Equatable {
  final List<Question> items;
  final int total;
  final int page;
  final int limit;

  const QuestionsPage({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
  });

  bool get hasMore => items.length < total;

  @override
  List<Object?> get props => [items, total, page, limit];
}
