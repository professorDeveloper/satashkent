import 'package:equatable/equatable.dart';

class LastExamSection extends Equatable {
  final String? name;
  final int right;
  final int wrong;
  final int total;
  final int? score;

  const LastExamSection({
    this.name,
    this.right = 0,
    this.wrong = 0,
    this.total = 0,
    this.score,
  });

  @override
  List<Object?> get props => [name, right, wrong, total, score];
}

class LastExamResult extends Equatable {
  final String? name;
  final List<LastExamSection> sections;

  const LastExamResult({this.name, this.sections = const []});

  int get totalRight => sections.fold(0, (a, s) => a + s.right);
  int get totalQuestions => sections.fold(0, (a, s) => a + s.total);
  int get totalScore => sections.fold(0, (a, s) => a + (s.score ?? 0));
  bool get isEmpty => sections.isEmpty;

  @override
  List<Object?> get props => [name, sections];
}
