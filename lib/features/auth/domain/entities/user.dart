import 'package:equatable/equatable.dart';

class GoalScore extends Equatable {
  final int math;
  final int english;
  const GoalScore({required this.math, required this.english});
  int get total => math + english;
  @override
  List<Object?> get props => [math, english];
}

class User extends Equatable {
  final String id;
  final String name;
  final String login;
  final String? email;
  final String? phone;
  final String? image;
  final DateTime? tillExam;
  final GoalScore? goalScore;
  final String? goalUniversity;
  final bool hasPassword;
  final String state;
  final num studentBalance;
  final DateTime? paidUntil;

  const User({
    required this.id,
    required this.name,
    required this.login,
    this.email,
    this.phone,
    this.image,
    this.tillExam,
    this.goalScore,
    this.goalUniversity,
    this.hasPassword = false,
    this.state = '',
    this.studentBalance = 0,
    this.paidUntil,
  });

  int? get daysUntilExam {
    if (tillExam == null) return null;
    final now = DateTime.now();
    return tillExam!
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        login,
        email,
        phone,
        image,
        tillExam,
        goalScore,
        goalUniversity,
        hasPassword,
        state,
        studentBalance,
        paidUntil,
      ];
}
