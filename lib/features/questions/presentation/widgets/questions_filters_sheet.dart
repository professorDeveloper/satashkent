import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/question_filter.dart';
import 'question_labels.dart';

Future<QuestionFilter?> showQuestionsFiltersSheet(
  BuildContext context, {
  required QuestionFilter initial,
}) {
  return showModalBottomSheet<QuestionFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => _FiltersSheet(initial: initial),
  );
}

class _FiltersSheet extends StatefulWidget {
  final QuestionFilter initial;
  const _FiltersSheet({required this.initial});

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late Set<QuestionType> types = {...widget.initial.types};
  late Set<QuestionComplexity> complexities = {...widget.initial.complexities};
  late Set<QuestionSubject> subjects = {...widget.initial.subjects};

  void _apply() {
    Navigator.of(context).pop(widget.initial.copyWith(
      types: types,
      complexities: complexities,
      subjects: subjects,
    ));
  }

  void _clear() {
    setState(() {
      types = {};
      complexities = {};
      subjects = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    return SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scroll) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: muted.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'filters'.tr(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _clear,
                    child: Text('clearAll'.tr()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            Expanded(
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                children: [
                  _SectionTitle('complexity'.tr()),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in [
                        QuestionComplexity.easy,
                        QuestionComplexity.medium,
                        QuestionComplexity.hard,
                      ])
                        _Chip(
                          label: QuestionLabels.complexity(c),
                          color: QuestionLabels.complexityColor(c),
                          selected: complexities.contains(c),
                          onTap: () => setState(() {
                            if (complexities.contains(c)) {
                              complexities.remove(c);
                            } else {
                              complexities = {c};
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _SectionTitle('questionType'.tr()),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in [
                        QuestionType.singleChoice,
                        QuestionType.multiChoice,
                        QuestionType.input,
                        QuestionType.multiInput,
                        QuestionType.inputOption,
                      ])
                        _Chip(
                          label: QuestionLabels.type(t),
                          color: AppColors.brand,
                          selected: types.contains(t),
                          onTap: () => setState(() {
                            if (types.contains(t)) {
                              types.remove(t);
                            } else {
                              types = {t};
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _SectionTitle('subjectLabel'.tr()),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in [
                        QuestionSubject.math,
                        QuestionSubject.english,
                        QuestionSubject.apCalculus,
                        QuestionSubject.apChemistry,
                        QuestionSubject.apCsA,
                        QuestionSubject.apMacro,
                        QuestionSubject.apMicro,
                        QuestionSubject.apBiology,
                        QuestionSubject.apStatistics,
                        QuestionSubject.apPhysicsC,
                      ])
                        _Chip(
                          label: QuestionLabels.subject(s),
                          color: AppColors.brand,
                          selected: subjects.contains(s),
                          onTap: () => setState(() {
                            if (subjects.contains(s)) {
                              subjects.remove(s);
                            } else {
                              subjects = {s};
                            }
                          }),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: _apply,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'apply'.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? color.withValues(alpha: 0.14) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? color
                  : Theme.of(context).dividerColor,
              width: selected ? 1.4 : 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: selected ? color : scheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
