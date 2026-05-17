import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_branding.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _firstDuration = Duration(milliseconds: 3200);
  static const _transitionDuration = Duration(milliseconds: 700);
  static bool _firstShown = false;
  StreamSubscription<AuthState>? _sub;
  bool _navigated = false;
  DateTime? _startedAt;
  late final Duration _minDuration;

  @override
  void initState() {
    super.initState();
    _minDuration = _firstShown ? _transitionDuration : _firstDuration;
    _firstShown = true;
    _startedAt = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final authBloc = context.read<AuthBloc>();
    if (_isResolved(authBloc.state)) {
      _scheduleNavigate(authBloc.state);
    } else {
      _sub = authBloc.stream.listen((state) {
        if (_isResolved(state)) _scheduleNavigate(state);
      });
    }
  }

  bool _isResolved(AuthState s) =>
      s is AuthAuthenticated || s is AuthUnauthenticated || s is AuthError;

  Future<void> _scheduleNavigate(AuthState state) async {
    if (_navigated) return;
    _navigated = true;
    final elapsed = DateTime.now().difference(_startedAt ?? DateTime.now());
    final remaining = _minDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
    if (!mounted) return;
    context.go(state is AuthAuthenticated ? '/home' : '/login');
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashBackground(
        child: SafeArea(child: SplashBranding()),
      ),
    );
  }
}
