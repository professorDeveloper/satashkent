import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_dialog.dart';

Future<({int math, int english})?> showGoalScoreDialog(
  BuildContext context, {
  required int initialMath,
  required int initialEnglish,
}) {
  return showDialog<({int math, int english})>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _GoalScoreDialog(
      initialMath: initialMath,
      initialEnglish: initialEnglish,
    ),
  );
}

const _min = 200.0;
const _max = 800.0;
const _mathColor = Color(0xFF1E88E5);
const _englishColor = Color(0xFFE53935);

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
  late double math = widget.initialMath.clamp(_min, _max).toDouble();
  late double english = widget.initialEnglish.clamp(_min, _max).toDouble();

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'myGoalScore'.tr(),
      submitLabel: 'submit'.tr(),
      onSubmit: () => Navigator.of(context).pop(
        (math: math.round(), english: english.round()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              AppAssets.setScore,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 18),
          _ScoreSlider(
            label: 'mathScore'.tr(),
            value: math,
            color: _mathColor,
            onChanged: (v) => setState(() => math = v),
          ),
          const SizedBox(height: 16),
          _ScoreSlider(
            label: 'englishScore'.tr(),
            value: english,
            color: _englishColor,
            onChanged: (v) => setState(() => english = v),
          ),
        ],
      ),
    );
  }
}

class _ScoreSlider extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;
  const _ScoreSlider({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
            children: [
              TextSpan(text: '$label: '),
              TextSpan(
                text: value.round().toString(),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: scheme.onSurface.withValues(alpha: 0.15),
            thumbColor: scheme.onSurface,
            overlayColor: color.withValues(alpha: 0.18),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8,
              elevation: 2,
            ),
          ),
          child: Slider(
            value: value,
            min: _min,
            max: _max,
            divisions: 60,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
