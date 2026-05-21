import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/assessments/presentation/pages/exams_page.dart';
import '../../features/assessments/presentation/pages/homework_page.dart';
import '../../features/assessments/presentation/pages/last_dances_page.dart';
import '../../features/assessments/presentation/pages/level_checks_page.dart';
import '../../features/assessments/presentation/pages/placements_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/main_shell/presentation/pages/main_shell_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/questions/presentation/pages/question_detail_page.dart';
import '../../features/referral/presentation/pages/referral_page.dart';
import '../../features/profile/presentation/settings/pages/settings_page.dart';
import '../../features/language/presentation/pages/language_select_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static late final GoRouter router;
  static void configure({required AuthBloc authBloc}) {
    router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: _MergedListenable([authBloc.stream]),
      redirect: (context, state) {
        final loc = state.matchedLocation;
        if (loc == '/splash') return null;
        final s = authBloc.state;
        final isAuthRoute = loc == '/login' || loc == '/register' || loc == '/forgot-password';
        if (s is AuthAuthenticated) {
          return isAuthRoute ? '/home' : null;
        }
        if (s is AuthUnauthenticated || s is AuthError) {
          return isAuthRoute ? null : '/splash';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (c, _) => SplashPage(key: _localeKey(c, 'splash')),
        ),

        GoRoute(
          path: '/language',
          builder: (c, _) =>
              LanguageSelectPage(key: _localeKey(c, 'language')),
        ),
        GoRoute(
          path: '/login',
          builder: (c, _) => LoginPage(key: _localeKey(c, 'login')),
        ),
        GoRoute(
          path: '/register',
          builder: (c, _) => RegisterPage(key: _localeKey(c, 'register')),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (c, _) =>
              ForgotPasswordPage(key: _localeKey(c, 'forgot')),
        ),
        GoRoute(
          path: '/home',
          builder: (_, _) => const MainShellPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (c, _) => SettingsPage(key: _localeKey(c, 'settings')),
        ),
        GoRoute(
          path: '/referral',
          builder: (c, _) => ReferralPage(key: _localeKey(c, 'referral')),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (c, _) => EditProfilePage(key: _localeKey(c, 'edit')),
        ),
        GoRoute(
          path: '/notifications',
          builder: (c, _) =>
              NotificationsScreen(key: _localeKey(c, 'notifications')),
        ),
        GoRoute(
          path: '/question/:id',
          builder: (c, st) => QuestionDetailPage(
            key: ValueKey('q-${st.pathParameters['id']}'),
            questionId: st.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/assessments/placements',
          builder: (c, _) => PlacementsPage(key: _localeKey(c, 'placements')),
        ),
        GoRoute(
          path: '/assessments/level-checks',
          builder: (c, _) =>
              LevelChecksPage(key: _localeKey(c, 'level-checks')),
        ),
        GoRoute(
          path: '/assessments/homework',
          builder: (c, _) => HomeworkPage(key: _localeKey(c, 'homework')),
        ),
        GoRoute(
          path: '/assessments/exams',
          builder: (c, _) => ExamsPage(key: _localeKey(c, 'exams')),
        ),
        GoRoute(
          path: '/assessments/last-dances',
          builder: (c, _) =>
              LastDancesPage(key: _localeKey(c, 'last-dances')),
        ),
      ],
    );
  }

  static ValueKey<String> _localeKey(BuildContext c, String tag) =>
      ValueKey<String>('$tag-${c.locale.languageCode}');
}

class _MergedListenable extends ChangeNotifier {
  final List<StreamSubscription> _subs = [];
  _MergedListenable(List<Stream> streams) {
    for (final s in streams) {
      _subs.add(s.listen((_) => notifyListeners()));
    }
  }
  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}
