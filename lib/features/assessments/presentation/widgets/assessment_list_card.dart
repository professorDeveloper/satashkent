import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/assessment_item.dart';

class AssessmentListCard extends StatelessWidget {
  final AssessmentItem item;
  final IconData icon;
  final String fallbackTitle;
  final VoidCallback? onTap;

  const AssessmentListCard({
    super.key,
    required this.item,
    required this.icon,
    required this.fallbackTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    final radius = BorderRadius.circular(16);
    return Material(
      color: scheme.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          decoration: BoxDecoration(
            borderRadius: radius,
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.6),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.brand, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_subtitle() != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _subtitle()!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: muted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _title() {
    final t = item.title;
    if (t != null && t.isNotEmpty) return t;
    return fallbackTitle;
  }

  String? _subtitle() {
    final parts = <String>[];
    if ((item.subject ?? '').isNotEmpty) parts.add(item.subject!);
    if (item.endsAt != null) {
      final d = item.endsAt!.toLocal();
      parts.add(
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
      );
    }
    return parts.isEmpty ? null : parts.join(' • ');
  }
}
