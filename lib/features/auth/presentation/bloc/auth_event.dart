import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => const [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginSubmitted extends AuthEvent {
  final String login;
  final String password;
  final bool rememberMe;
  const AuthLoginSubmitted({
    required this.login,
    required this.password,
    this.rememberMe = true,
  });
  @override
  List<Object?> get props => [login, password, rememberMe];
}

class AuthRegisterSubmitted extends AuthEvent {
  final String name;
  final String login;
  final String email;
  final String password;
  const AuthRegisterSubmitted({
    required this.name,
    required this.login,
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [name, login, email, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}
