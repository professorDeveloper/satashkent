import 'dart:typed_data';

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

class HomeGoalUniversityPicked extends HomeEvent {
  final Uint8List bytes;
  final String filename;
  final String contentType;
  const HomeGoalUniversityPicked({
    required this.bytes,
    required this.filename,
    this.contentType = 'image/png',
  });
  @override
  List<Object?> get props => [bytes.length, filename, contentType];
}

class HomeUserPatched extends HomeEvent {
  final User user;
  const HomeUserPatched(this.user);
  @override
  List<Object?> get props => [user.id, user.goalScore, user.tillExam, user.goalUniversity];
}
