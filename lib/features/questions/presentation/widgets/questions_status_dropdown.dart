import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/question.dart';
import 'question_labels.dart';

class QuestionsStatusDropdown extends StatelessWidget {
  final QuestionStatus? value;
  final ValueChanged<QuestionStatus?> onChanged;
  const QuestionsStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final options = _options();
    final current =
        options.firstWhere((o) => o.status == value, orElse: () => options.first);
    return PopupMenuButton<QuestionStatus?>(
      tooltip: '',
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      color: scheme.surface,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor, width: 0.6),
      ),
      padding: EdgeInsets.zero,
      menuPadding: const EdgeInsets.symmetric(vertical: 4),
      itemBuilder: (_) => [
        for (final option in options)
          PopupMenuItem<QuestionStatus?>(
            value: option.status,
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _MenuItem(option: option, selected: option.status == value),
          ),
      ],
      onSelected: onChanged,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(color: current.color),
            const SizedBox(width: 8),
            Text(
              current.label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: current.color,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: scheme.onSurface.withValues(alpha: 0.55),
            ),
          ],
        ),
      ),
    );
  }

  List<_StatusOption> _options() => [
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

class _MenuItem extends StatelessWidget {
  final _StatusOption option;
  final bool selected;
  const _MenuItem({required this.option, required this.selected});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _Dot(color: option.color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            option.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: option.color,
            ),
          ),
        ),
        if (selected)
          Icon(
            Icons.check_rounded,
            size: 16,
            color: scheme.onSurface.withValues(alpha: 0.75),
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class QuestionsTotalBadge extends StatelessWidget {
  final int total;
  const QuestionsTotalBadge({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${'total'.tr()}: ${_format(total)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  String _format(int n) {
    final s = n.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}
