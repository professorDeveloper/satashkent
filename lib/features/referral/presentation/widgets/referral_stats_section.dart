import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/models/referral_models.dart';

class ReferralStatsSection extends StatelessWidget {
  final ReferralStats stats;
  const ReferralStatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatusCard(
                title: 'pending'.tr(),
                count: stats.pendingPayment.count,
                discount: stats.pendingPayment.totalDiscount,
                color: const Color(0xFFE89B2D),
                bg: const Color(0xFFFDF2DE),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatusCard(
                title: 'approved'.tr(),
                count: stats.approved.count,
                discount: stats.approved.totalDiscount,
                color: const Color(0xFF239B5C),
                bg: const Color(0xFFDFF3E6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            MiniChip(
              label: 'requested'.tr(),
              count: stats.requested.count,
              color: const Color(0xFFE89B2D),
            ),
            const SizedBox(width: 8),
            MiniChip(
              label: 'completed'.tr(),
              count: stats.completed.count,
              color: const Color(0xFF2F7BD8),
            ),
            const SizedBox(width: 8),
            MiniChip(
              label: 'rejected'.tr(),
              count: stats.rejected.count,
              color: const Color(0xFFD63A3A),
            ),
          ],
        ),
      ],
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final int count;
  final num discount;
  final Color color;
  final Color bg;
  const StatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.discount,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.14) : bg,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${'totalDiscount'.tr()}: $discount',
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class MiniChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const MiniChip({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.14)
            : color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label $count',
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
