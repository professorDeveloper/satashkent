import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AssessmentSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int? badgeCount;
  final VoidCallback onTap;

  const AssessmentSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    final radius = BorderRadius.circular(16);
    final hasCount = badgeCount != null && badgeCount! > 0;

    return Material(
      color: scheme.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
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
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (hasCount) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.brand,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeCount! > 99 ? '99+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(Icons.chevron_right_rounded, color: muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
