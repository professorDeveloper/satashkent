import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final _login = TextEditingController(text: AppConstants.devLogin ?? '');
  late final _password =
      TextEditingController(text: AppConstants.devPassword ?? '');

  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthLoginSubmitted(
          login: _login.text,
          password: _password.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _login,
            hint: 'loginOrEmail'.tr(),
            prefix: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'fieldRequired'.tr() : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _password,
            hint: 'password'.tr(),
            prefix: Icons.lock_outline,
            obscure: true,
            textInputAction: TextInputAction.done,
            validator: (v) =>
                (v == null || v.length < 4) ? 'passwordTooShort'.tr() : null,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/forgot-password'),
              child: Text('forgotPassword'.tr()),
            ),
          ),
          const SizedBox(height: 4),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) => PrimaryButton(
              label: 'signIn'.tr(),
              isLoading: state is AuthLoading,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
