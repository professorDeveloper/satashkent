import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/assessment_summary.dart';

class AssessmentSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final AssessmentSummary? data;

  const AssessmentSection({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final on = Theme.of(context).colorScheme.onSurface;
    final active = data?.active ?? 0;
    final passed = data?.passed ?? 0;
    final recent = data?.recent ?? const <AssessmentRecent>[];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: on.withValues(alpha: 0.75)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              CountPill(
                label: 'active'.tr(),
                count: active,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              CountPill(
                label: 'passed'.tr(),
                count: passed,
                color: AppColors.brand,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (recent.isEmpty)
            Text(
              'noAssignments'.tr(),
              style: tt.bodySmall?.copyWith(
                color: on.withValues(alpha: 0.55),
              ),
            )
          else
            Column(
              children: [
                for (final r in recent) RecentRow(item: r),
              ],
            ),
        ],
      ),
    );
  }
}

class CountPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const CountPill({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final filled = count > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: filled ? color : Colors.transparent,
        border: Border.all(color: color.withValues(alpha: filled ? 0 : 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: filled ? Colors.white : color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: filled ? Colors.white : color,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentRow extends StatelessWidget {
  final AssessmentRecent item;
  const RecentRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name ?? '—',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: on.withValues(alpha: 0.85),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${item.right}/${item.total}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.brand,
            ),
          ),
        ],
      ),
    );
  }
}
