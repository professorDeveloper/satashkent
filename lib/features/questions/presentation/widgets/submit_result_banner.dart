import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SubmitResultInfo extends StatelessWidget {
  final bool isRight;
  final VoidCallback? onDismiss;

  const SubmitResultInfo({
    super.key,
    required this.isRight,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final color = isRight ? AppColors.success : AppColors.error;
    final icon = isRight
        ? Icons.check_circle_rounded
        : Icons.cancel_rounded;
    final label =
        isRight ? 'answerCorrect'.tr() : 'answerIncorrect'.tr();
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 0.2,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close_rounded, color: color, size: 18),
              splashRadius: 18,
            ),
        ],
      ),
    );
  }
}
