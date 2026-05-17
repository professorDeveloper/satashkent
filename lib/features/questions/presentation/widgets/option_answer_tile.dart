import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/question_detail.dart';
import 'question_html_view.dart';

class OptionAnswerTile extends StatelessWidget {
  final Answer answer;
  final int index;
  final bool selected;
  final VoidCallback? onTap;

  const OptionAnswerTile({
    super.key,
    required this.answer,
    required this.index,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(14);
    final letter = String.fromCharCode(65 + index);
    final borderColor = selected
        ? AppColors.brand
        : Theme.of(context).dividerColor;
    final fillColor = selected
        ? AppColors.brand.withValues(alpha: 0.06)
        : scheme.surface;
    return Material(
      color: fillColor,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: borderColor,
              width: selected ? 1.6 : 0.8,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _LetterCircle(letter: letter, selected: selected),
              const SizedBox(width: 12),
              Expanded(
                child: QuestionHtmlView(
                  html: answer.content,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LetterCircle extends StatelessWidget {
  final String letter;
  final bool selected;
  const _LetterCircle({required this.letter, required this.selected});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.brand : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? AppColors.brand
              : scheme.onSurface.withValues(alpha: 0.25),
          width: 1.4,
        ),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: selected
              ? Colors.white
              : scheme.onSurface.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}
