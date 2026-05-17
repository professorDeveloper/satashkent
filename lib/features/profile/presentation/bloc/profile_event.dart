import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => const [];
}

class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}

class ProfileRefreshed extends ProfileEvent {
  const ProfileRefreshed();
}

class ProfileBalanceRefreshed extends ProfileEvent {
  const ProfileBalanceRefreshed();
}

class ProfileUserPatched extends ProfileEvent {
  final User user;
  const ProfileUserPatched(this.user);
  @override
  List<Object?> get props => [user.id, user.name, user.image];
}
