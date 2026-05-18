import 'package:equatable/equatable.dart';

abstract class LevelChecksEvent extends Equatable {
  const LevelChecksEvent();
  @override
  List<Object?> get props => const [];
}

class LevelChecksRequested extends LevelChecksEvent {
  const LevelChecksRequested();
}

class LevelChecksRefreshed extends LevelChecksEvent {
  const LevelChecksRefreshed();
}
