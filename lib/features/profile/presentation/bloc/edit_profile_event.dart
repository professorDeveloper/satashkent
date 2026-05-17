import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();
  @override
  List<Object?> get props => const [];
}

class EditProfileStarted extends EditProfileEvent {
  const EditProfileStarted();
}

class EditProfileSubmitted extends EditProfileEvent {
  final String name;
  final String login;
  final String? email;
  final String? phone;
  const EditProfileSubmitted({
    required this.name,
    required this.login,
    this.email,
    this.phone,
  });
  @override
  List<Object?> get props => [name, login, email, phone];
}

class EditProfileImagePicked extends EditProfileEvent {
  final Uint8List bytes;
  const EditProfileImagePicked(this.bytes);
  @override
  List<Object?> get props => [bytes.length];
}
