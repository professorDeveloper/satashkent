import 'package:equatable/equatable.dart';

class LevelCheck extends Equatable {
  final String id;
  final String? title;
  final String? subject;
  final String? state;
  final num? score;
  final num? maxScore;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? createdAt;

  const LevelCheck({
    required this.id,
    this.title,
    this.subject,
    this.state,
    this.score,
    this.maxScore,
    this.startsAt,
    this.endsAt,
    this.createdAt,
  });

  bool get isActive => state == 'new' || state == 'active';

  @override
  List<Object?> get props => [
        id,
        title,
        subject,
        state,
        score,
        maxScore,
        startsAt,
        endsAt,
        createdAt,
      ];
}

class LevelChecksPage extends Equatable {
  final int total;
  final List<LevelCheck> items;
  const LevelChecksPage({this.total = 0, this.items = const []});

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [total, items];
}
