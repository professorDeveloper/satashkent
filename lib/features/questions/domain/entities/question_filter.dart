import 'package:equatable/equatable.dart';

import 'question.dart';

class QuestionFilter extends Equatable {
  final String search;
  final QuestionStatus? status;
  final Set<QuestionType> types;
  final Set<QuestionComplexity> complexities;
  final Set<QuestionSubject> subjects;

  const QuestionFilter({
    this.search = '',
    this.status,
    this.types = const {},
    this.complexities = const {},
    this.subjects = const {},
  });

  QuestionFilter copyWith({
    String? search,
    QuestionStatus? status,
    bool clearStatus = false,
    Set<QuestionType>? types,
    Set<QuestionComplexity>? complexities,
    Set<QuestionSubject>? subjects,
  }) {
    return QuestionFilter(
      search: search ?? this.search,
      status: clearStatus ? null : status ?? this.status,
      types: types ?? this.types,
      complexities: complexities ?? this.complexities,
      subjects: subjects ?? this.subjects,
    );
  }

  bool get isEmpty =>
      search.isEmpty &&
      status == null &&
      types.isEmpty &&
      complexities.isEmpty &&
      subjects.isEmpty;

  @override
  List<Object?> get props => [search, status, types, complexities, subjects];
}
