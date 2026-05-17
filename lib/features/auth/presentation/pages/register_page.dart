import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg.withValues(alpha: 0.45),
        shape: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 0.6,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 22,
              sigmaY: 22,
              tileMode: TileMode.mirror,
            ),
            child: const SizedBox.shrink(),
          ),
        ),
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/login'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeader(
                    title: 'signUp'.tr(),
                    subtitle: 'loginToAccount'.tr(),
                  ),
                  const SizedBox(height: 32),
                  const RegisterForm(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('haveAccount'.tr(),
                          style: Theme.of(context).textTheme.bodySmall),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text('signIn'.tr()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
