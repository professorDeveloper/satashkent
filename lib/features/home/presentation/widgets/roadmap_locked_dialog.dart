import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_logo.dart';

Future<void> showRoadmapLockedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final scheme = Theme.of(ctx).colorScheme;
      final muted = scheme.onSurface.withValues(alpha: 0.65);
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close_rounded, size: 22),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
              const AppLogo(size: 84),
              const SizedBox(height: 14),
              Text(
                'roadmapsLockedTitle'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'roadmapsLockedMessage'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: muted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.onSurface,
                  foregroundColor: scheme.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'iUnderstand'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
