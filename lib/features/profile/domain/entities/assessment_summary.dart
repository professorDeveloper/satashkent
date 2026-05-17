import 'package:equatable/equatable.dart';

class AssessmentRecent extends Equatable {
  final String id;
  final String? name;
  final String? state;
  final int right;
  final int wrong;
  final int total;
  final DateTime? finishedAt;

  const AssessmentRecent({
    required this.id,
    this.name,
    this.state,
    this.right = 0,
    this.wrong = 0,
    this.total = 0,
    this.finishedAt,
  });

  @override
  List<Object?> get props => [id, name, state, right, wrong, total, finishedAt];
}

class AssessmentSummary extends Equatable {
  final String type;
  final int newCount;
  final int active;
  final int passed;
  final List<AssessmentRecent> recent;

  const AssessmentSummary({
    required this.type,
    this.newCount = 0,
    this.active = 0,
    this.passed = 0,
    this.recent = const [],
  });

  @override
  List<Object?> get props => [type, newCount, active, passed, recent];
}
