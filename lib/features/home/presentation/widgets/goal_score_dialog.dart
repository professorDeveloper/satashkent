import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

Future<({int math, int english})?> showGoalScoreDialog(
  BuildContext context, {
  required int initialMath,
  required int initialEnglish,
}) {
  return showDialog<({int math, int english})>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => _GoalScoreDialog(
      initialMath: initialMath,
      initialEnglish: initialEnglish,
    ),
  );
}

class _GoalScoreDialog extends StatefulWidget {
  final int initialMath;
  final int initialEnglish;
  const _GoalScoreDialog({
    required this.initialMath,
    required this.initialEnglish,
  });

  @override
  State<_GoalScoreDialog> createState() => _GoalScoreDialogState();
}

class _GoalScoreDialogState extends State<_GoalScoreDialog> {
  late double math = widget.initialMath.clamp(200, 800).toDouble();
  late double english = widget.initialEnglish.clamp(200, 800).toDouble();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'myGoalScore'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Center(
              child: Image.asset(
                AppAssets.setScore,
                height: 130,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 4),
            _ScoreSlider(
              label: 'mathScore'.tr(),
              value: math,
              activeColor: const Color(0xFF1E88E5),
              onChanged: (v) => setState(() => math = v),
            ),
            const SizedBox(height: 14),
            _ScoreSlider(
              label: 'englishScore'.tr(),
              value: english,
              activeColor: const Color(0xFFE53935),
              onChanged: (v) => setState(() => english = v),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(
                (math: math.round(), english: english.round()),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: scheme.onSurface,
                foregroundColor: scheme.surface,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'submit'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreSlider extends StatelessWidget {
  final String label;
  final double value;
  final Color activeColor;
  final ValueChanged<double> onChanged;
  const _ScoreSlider({
    required this.label,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: muted,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value.round().toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.brand,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            inactiveTrackColor: activeColor.withValues(alpha: 0.18),
            thumbColor: Colors.white,
            overlayColor: activeColor.withValues(alpha: 0.15),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 9,
              elevation: 2,
            ),
          ),
          child: Slider(
            value: value,
            min: 200,
            max: 800,
            divisions: 60,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
