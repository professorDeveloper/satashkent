import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _login = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _login.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthRegisterSubmitted(
          name: _name.text,
          login: _login.text,
          email: _email.text,
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
            controller: _name,
            hint: 'fullName'.tr(),
            prefix: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().length < 2) ? 'nameTooShort'.tr() : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _login,
            hint: 'username'.tr(),
            prefix: Icons.alternate_email,
            validator: (v) => (v == null || v.trim().length < 3)
                ? 'usernameTooShort'.tr()
                : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _email,
            hint: 'email'.tr(),
            prefix: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              final t = (v ?? '').trim();
              if (!t.contains('@') || !t.contains('.')) {
                return 'invalidEmail'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _password,
            hint: 'password'.tr(),
            prefix: Icons.lock_outline,
            obscure: true,
            textInputAction: TextInputAction.done,
            validator: (v) =>
                (v == null || v.length < 6) ? 'passwordTooShort'.tr() : null,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) => PrimaryButton(
              label: 'signUp'.tr(),
              isLoading: state is AuthLoading,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
