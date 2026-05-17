import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/question_detail.dart';

class AttemptsList extends StatelessWidget {
  final bool loading;
  final List<Attempt> attempts;
  final List<Answer> options;

  const AttemptsList({
    super.key,
    required this.loading,
    required this.attempts,
    this.options = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (loading && attempts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.brand,
            ),
          ),
        ),
      );
    }
    if (attempts.isEmpty) {
      final muted =
          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Text(
            'attemptsEmpty'.tr(),
            style: TextStyle(fontSize: 13.5, color: muted),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: attempts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => AttemptCard(
        index: i + 1,
        attempt: attempts[i],
        options: options,
      ),
    );
  }
}

class AttemptCard extends StatelessWidget {
  final int index;
  final Attempt attempt;
  final List<Answer> options;
  const AttemptCard({
    super.key,
    required this.index,
    required this.attempt,
    this.options = const [],
  });

  @override
  Widget build(BuildContext context) {
    final color = attempt.isRight ? AppColors.success : AppColors.error;
    final label =
        attempt.isRight ? 'attemptCorrect'.tr() : 'attemptWrong'.tr();

    final optionIndex =
        options.indexWhere((o) => o.id == attempt.answer);
    final hasLetter = optionIndex >= 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.22), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'attemptNumber'.tr(args: [index.toString()]),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              _StatusPill(color: color, label: label),
            ],
          ),
          const SizedBox(height: 10),
          hasLetter
              ? _LetterChip(
                  letter: String.fromCharCode(65 + optionIndex),
                  color: color,
                )
              : _TextChip(text: attempt.answer, color: color),
        ],
      ),
    );
  }
}

class _LetterChip extends StatelessWidget {
  final String letter;
  final Color color;
  const _LetterChip({required this.letter, required this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _TextChip extends StatelessWidget {
  final String text;
  final Color color;
  const _TextChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Text(
        text.isEmpty ? '—' : text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final Color color;
  final String label;
  const _StatusPill({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
