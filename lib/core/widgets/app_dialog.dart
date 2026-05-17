import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final String submitLabel;
  final VoidCallback? onSubmit;
  final Color? submitBackground;
  final Color? submitForeground;

  const AppDialog({
    super.key,
    required this.title,
    required this.child,
    required this.submitLabel,
    this.onSubmit,
    this.submitBackground,
    this.submitForeground,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close_rounded, size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            child,
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: Colors.white,
                disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.3),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}
