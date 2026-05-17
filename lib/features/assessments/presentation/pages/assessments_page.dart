import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AssessmentsPage extends StatelessWidget {
  const AssessmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text('tabAssessments'.tr())),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_rounded, size: 56, color: muted),
            const SizedBox(height: 12),
            Text(
              'tabAssessments'.tr(),
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
