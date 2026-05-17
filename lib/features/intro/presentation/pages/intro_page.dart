import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/hive_service.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  Future<void> _finish(BuildContext context) async {
    await getIt<HiveService>().setOnboardingCompleted(true);
    if (!context.mounted) return;
    final hasLanguage = getIt<HiveService>().getLanguageSelected();
    context.go(hasLanguage ? '/login' : '/language');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () => _finish(context),
            child: Text('continueLabel'.tr()),
          ),
        ),
      ),
    );
  }
}
