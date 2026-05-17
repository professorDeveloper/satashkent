import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeController>();
    return AnimatedBuilder(
      animation: theme,
      builder: (context, _) {
        return BlocProvider<AuthBloc>.value(
          value: getIt<AuthBloc>(),
          child: MaterialApp.router(
            title: 'appName'.tr(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: theme.mode,
            themeAnimationDuration: Duration.zero,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
