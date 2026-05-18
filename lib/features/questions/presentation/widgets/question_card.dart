import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/question.dart';
import 'question_labels.dart';

class QuestionCard extends StatelessWidget {
  final int index;
  final Question question;
  final VoidCallback? onTap;

  const QuestionCard({
    super.key,
    required this.index,
    required this.question,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    final radius = BorderRadius.circular(16);
    Color borderColor = Theme.of(context).dividerColor;
    switch (question.status) {
      case QuestionStatus.newOne:
        borderColor = Theme.of(context).dividerColor;
      case QuestionStatus.correct:
        borderColor = const Color(0xFF239B5C);
      case QuestionStatus.wrong:
        borderColor = const Color(0xFFE24646);
      case QuestionStatus.unknown:
        borderColor = Theme.of(context).dividerColor;
    }
    return Material(
      color: scheme.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 0.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    index.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: muted,
                    ),
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 6,
                    children: [
                      _TypePill(type: question.type),
                      _ComplexityPill(complexity: question.complexity),
                      _SubjectPill(subject: question.subject),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _title(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  height: 1.35,
                ),
              ),
              if (question.content.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  _body(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.5, color: muted, height: 1.4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _title() {
    final t = question.title.trim();
    if (t.isEmpty) return '—';
    return _stripHtml(t);
  }

  String _body() => _stripHtml(question.content.trim());

  String _stripHtml(String s) {
    return s
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

class _TypePill extends StatelessWidget {
  final QuestionType type;

  const _TypePill({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = type == QuestionType.input || type == QuestionType.multiInput
        ? const Color(0xFF239B5C)
        : const Color(0xFF2F7BD8);
    return _Pill(
      color: color,
      icon: QuestionLabels.typeIcon(type),
      label: QuestionLabels.type(type),
      tint: true,
    );
  }
}

class _ComplexityPill extends StatelessWidget {
  final QuestionComplexity complexity;

  const _ComplexityPill({required this.complexity});

  @override
  Widget build(BuildContext context) {
    final color = QuestionLabels.complexityColor(complexity);
    return _Pill(
      color: color,
      label: QuestionLabels.complexity(complexity),
      tint: true,
    );
  }
}

class _SubjectPill extends StatelessWidget {
  final QuestionSubject subject;

  const _SubjectPill({required this.subject});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _Pill(
      color: scheme.onSurface.withValues(alpha: 0.7),
      label: QuestionLabels.subject(subject),
      tint: false,
    );
  }
}

class _Pill extends StatelessWidget {
  final Color color;
  final String label;
  final IconData? icon;
  final bool tint;

  const _Pill({
    required this.color,
    required this.label,
    this.icon,
    this.tint = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: tint ? color.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: tint
            ? null
            : Border.all(color: color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
