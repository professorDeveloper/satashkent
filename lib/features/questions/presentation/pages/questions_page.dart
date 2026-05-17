import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text('tabQuestions'.tr())),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help_outline_rounded, size: 56, color: muted),
            const SizedBox(height: 12),
            Text(
              'tabQuestions'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}
