import 'package:equatable/equatable.dart';

class AssessmentSection extends Equatable {
  final String id;
  final String name;
  final String type;
  final int total;
  final int submitted;
  final String state;

  const AssessmentSection({
    required this.id,
    required this.name,
    required this.type,
    this.total = 0,
    this.submitted = 0,
    this.state = '',
  });

  @override
  List<Object?> get props => [id, name, type, total, submitted, state];
}

class AssessmentItem extends Equatable {
  final String id;
  final String type;
  final String name;
  final String state;
  final DateTime? finishesAt;
  final int total;
  final int right;
  final List<AssessmentSection> sections;
  final bool couldReview;
  final bool fullScreenRequired;
  final bool desmosEnabled;

  const AssessmentItem({
    required this.id,
    this.type = '',
    this.name = '',
    this.state = '',
    this.finishesAt,
    this.total = 0,
    this.right = 0,
    this.sections = const [],
    this.couldReview = false,
    this.fullScreenRequired = false,
    this.desmosEnabled = false,
  });

  bool get isPlanned => state == 'planned';
  bool get isActive => state == 'active';
  bool get isPassed => state == 'passed';

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        state,
        finishesAt,
        total,
        right,
        sections,
        couldReview,
        fullScreenRequired,
        desmosEnabled,
      ];
}

class AssessmentListPage extends Equatable {
  final int total;
  final List<AssessmentItem> items;
  const AssessmentListPage({this.total = 0, this.items = const []});

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [total, items];
}
