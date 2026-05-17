import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../widgets/auth_header.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _login = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _login.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await getIt<ForgotPasswordUseCase>()(login: _login.text);
    if (!mounted) return;
    setState(() => _loading = false);
    result.when(
      success: (_) {
        setState(() => _sent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('resetLinkSent'.tr()),
            backgroundColor: AppColors.success,
          ),
        );
      },
      failure: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/login'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      title: 'forgotPasswordTitle'.tr(),
                      subtitle: 'forgotPasswordSubtitle'.tr(),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: _login,
                      hint: 'loginOrEmail'.tr(),
                      prefix: Icons.alternate_email_rounded,
                      textInputAction: TextInputAction.done,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'fieldRequired'.tr()
                          : null,
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'sendResetLink'.tr(),
                      isLoading: _loading,
                      onPressed: _submit,
                    ),
                    if (_sent) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.mark_email_read_rounded,
                                color: AppColors.success),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'resetLinkSent'.tr(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
