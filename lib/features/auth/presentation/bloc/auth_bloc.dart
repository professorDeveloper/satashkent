import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/hive_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;
  final HiveService hiveService;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.authRepository,
    required this.hiveService,
  }) : super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthRegisterSubmitted>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthSessionExpired>(
        (_, emit) => emit(const AuthUnauthenticated('Session expired')));
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    if (!authRepository.isLoggedIn) {
      emit(const AuthUnauthenticated());
      return;
    }
    final cached = authRepository.getCachedUser();
    if (cached != null) {
      emit(AuthAuthenticated(cached));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
      AuthLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await loginUseCase(
      login: event.login,
      password: event.password,
      rememberMe: event.rememberMe,
    );
    result.when(
      success: (u) => emit(AuthAuthenticated(u)),
      failure: (e) => emit(AuthError(_messageOf(e))),
    );
  }

  Future<void> _onRegister(
      AuthRegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await registerUseCase(
      name: event.name,
      login: event.login,
      email: event.email,
      password: event.password,
    );
    result.when(
      success: (u) => emit(AuthAuthenticated(u)),
      failure: (e) => emit(AuthError(_messageOf(e))),
    );
  }

  Future<void> _onLogout(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(const AuthUnauthenticated());
  }

  String _messageOf(Exception e) =>
      e.toString().replaceFirst('Exception: ', '');
}
