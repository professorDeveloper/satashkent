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
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<QuestionStatus?>(
          value: value,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: scheme.onSurface.withValues(alpha: 0.6),
          ),
          selectedItemBuilder: (_) => [
            _selectedText('allQuestions'.tr(), scheme.onSurface),
            _selectedText(
              QuestionLabels.status(QuestionStatus.newOne),
              const Color(0xFF2F7BD8),
            ),
            _selectedText(
              QuestionLabels.status(QuestionStatus.wrong),
              const Color(0xFFD63A3A),
            ),
            _selectedText(
              QuestionLabels.status(QuestionStatus.correct),
              const Color(0xFF239B5C),
            ),
          ],
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(
                'allQuestions'.tr(),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _statusItem(QuestionStatus.newOne, const Color(0xFF2F7BD8)),
            _statusItem(QuestionStatus.wrong, const Color(0xFFD63A3A)),
            _statusItem(QuestionStatus.correct, const Color(0xFF239B5C)),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _selectedText(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  DropdownMenuItem<QuestionStatus?> _statusItem(
    QuestionStatus status,
    Color color,
  ) {
    return DropdownMenuItem<QuestionStatus?>(
      value: status,
      child: Text(
        QuestionLabels.status(status),
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
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
