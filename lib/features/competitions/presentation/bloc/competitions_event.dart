import 'package:equatable/equatable.dart';

abstract class CompetitionsEvent extends Equatable {
  const CompetitionsEvent();
  @override
  List<Object?> get props => const [];
}

class CompetitionsRequested extends CompetitionsEvent {
  const CompetitionsRequested();
}

class CompetitionsRefreshed extends CompetitionsEvent {
  const CompetitionsRefreshed();
}
