import 'package:equatable/equatable.dart';

abstract class AssessmentListEvent extends Equatable {
  const AssessmentListEvent();
  @override
  List<Object?> get props => const [];
}

class AssessmentListRequested extends AssessmentListEvent {
  const AssessmentListRequested();
}

class AssessmentListRefreshed extends AssessmentListEvent {
  const AssessmentListRefreshed();
}
