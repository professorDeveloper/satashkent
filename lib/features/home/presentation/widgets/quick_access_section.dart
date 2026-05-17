import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/assessment_active.dart';

class QuickAccessSection extends StatelessWidget {
  final List<AssessmentActive> assessments;
  final ValueChanged<String> onTap;
  const QuickAccessSection({
    super.key,
    required this.assessments,
    required this.onTap,
  });

  int _count(String type) {
    for (final a in assessments) {
      if (a.type == type) return a.active;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final items = <_QuickItem>[
      _QuickItem(
        type: 'placement',
        label: 'placements'.tr(),
        icon: Icons.task_alt_rounded,
        count: _count('placement'),
      ),
      _QuickItem(
        type: 'homework',
        label: 'homework'.tr(),
        icon: Icons.menu_book_rounded,
        count: _count('homework'),
      ),
      _QuickItem(
        type: 'exam',
        label: 'exams'.tr(),
        icon: Icons.assignment_rounded,
        count: _count('exam'),
      ),
      _QuickItem(
        type: 'finalExam',
        label: 'lastDances'.tr(),
        icon: Icons.school_rounded,
        count: _count('finalExam'),
      ),
      _QuickItem(
        type: 'levelCheck',
        label: 'levelChecks'.tr(),
        icon: Icons.show_chart_rounded,
        count: _count('levelCheck'),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
            child: Text(
              'quickAccess'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.7,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => _QuickCard(
              item: items[i],
              onTap: () => onTap(items[i].type),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickItem {
  final String type;
  final String label;
  final IconData icon;
  final int count;
  _QuickItem({
    required this.type,
    required this.label,
    required this.icon,
    required this.count,
  });
}

class _QuickCard extends StatelessWidget {
  final _QuickItem item;
  final VoidCallback onTap;
  const _QuickCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(16);
    return Material(
      color: scheme.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: radius,
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.6),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.count.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: -2,
                bottom: -4,
                child: Icon(
                  item.icon,
                  size: 42,
                  color: scheme.onSurface.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
