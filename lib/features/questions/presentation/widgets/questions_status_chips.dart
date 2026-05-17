import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/question.dart';
import 'question_labels.dart';

class QuestionsStatusChips extends StatelessWidget {
  final QuestionStatus? value;
  final ValueChanged<QuestionStatus?> onChanged;
  const QuestionsStatusChips({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = <_StatusOption>[
      _StatusOption(
        status: null,
        label: 'allQuestions'.tr(),
        color: AppColors.brand,
      ),
      _StatusOption(
        status: QuestionStatus.newOne,
        label: QuestionLabels.status(QuestionStatus.newOne),
        color: const Color(0xFF2F7BD8),
      ),
      _StatusOption(
        status: QuestionStatus.wrong,
        label: QuestionLabels.status(QuestionStatus.wrong),
        color: const Color(0xFFD63A3A),
      ),
      _StatusOption(
        status: QuestionStatus.correct,
        label: QuestionLabels.status(QuestionStatus.correct),
        color: const Color(0xFF239B5C),
      ),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final option = options[i];
          return _StatusChip(
            option: option,
            selected: option.status == value,
            onTap: () => onChanged(option.status),
          );
        },
      ),
    );
  }
}

class _StatusOption {
  final QuestionStatus? status;
  final String label;
  final Color color;
  const _StatusOption({
    required this.status,
    required this.label,
    required this.color,
  });
}

class _StatusChip extends StatelessWidget {
  final _StatusOption option;
  final bool selected;
  final VoidCallback onTap;
  const _StatusChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(20);
    final bg = selected ? option.color : scheme.surface;
    final fg = selected ? Colors.white : option.color;
    final borderColor = selected
        ? option.color
        : option.color.withValues(alpha: 0.35);
    return Material(
      color: bg,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : option.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                option.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: fg,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
