import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => const [];
}

class HomeRequested extends HomeEvent {
  const HomeRequested();
}

class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

class HomeGoalScoreSubmitted extends HomeEvent {
  final int math;
  final int english;
  const HomeGoalScoreSubmitted({required this.math, required this.english});
  @override
  List<Object?> get props => [math, english];
}

class HomeExamDateSubmitted extends HomeEvent {
  final DateTime date;
  const HomeExamDateSubmitted(this.date);
  @override
  List<Object?> get props => [date];
}

class HomeUserPatched extends HomeEvent {
  final User user;
  const HomeUserPatched(this.user);
  @override
  List<Object?> get props => [user.id, user.goalScore, user.tillExam, user.goalUniversity];
}
