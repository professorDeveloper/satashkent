import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_assets.dart';

class CompetitionsEmpty extends StatelessWidget {
  const CompetitionsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              AppAssets.trophyLottie,
              width: 200,
              height: 200,
              repeat: true,
            ),
            const SizedBox(height: 12),
            Text(
              'noActiveCompetitions'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'noActiveCompetitionsDesc'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: muted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
