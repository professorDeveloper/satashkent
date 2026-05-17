import 'package:equatable/equatable.dart';

class Competition extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? image;
  final String? state;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final int participants;
  final num? prize;

  const Competition({
    required this.id,
    required this.title,
    this.description,
    this.image,
    this.state,
    this.startsAt,
    this.endsAt,
    this.participants = 0,
    this.prize,
  });

  bool get isLive {
    final now = DateTime.now();
    final started = startsAt == null || now.isAfter(startsAt!);
    final notEnded = endsAt == null || now.isBefore(endsAt!);
    return started && notEnded;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        image,
        state,
        startsAt,
        endsAt,
        participants,
        prize,
      ];
}

class CompetitionPage extends Equatable {
  final int total;
  final List<Competition> items;
  const CompetitionPage({this.total = 0, this.items = const []});

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [total, items];
}
