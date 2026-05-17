import 'package:equatable/equatable.dart';

class AssessmentActive extends Equatable {
  final String type;
  final int active;
  const AssessmentActive({required this.type, this.active = 0});

  @override
  List<Object?> get props => [type, active];
}
