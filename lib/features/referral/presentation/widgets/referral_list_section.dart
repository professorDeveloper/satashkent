import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/models/referral_models.dart';

class ReferralListSection extends StatelessWidget {
  final List<ReferralItem> items;
  const ReferralListSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final muted =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
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
              Icon(Icons.group_outlined, size: 18, color: muted),
              const SizedBox(width: 8),
              Text(
                'yourReferrals'.tr(),
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'noReferrals'.tr(),
                style: TextStyle(fontSize: 13, color: muted),
              ),
            )
          else
            Column(
              children: [
                for (final item in items) ReferralRow(item: item),
              ],
            ),
        ],
      ),
    );
  }
}

class ReferralRow extends StatelessWidget {
  final ReferralItem item;
  const ReferralRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name ?? '—',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: on.withValues(alpha: 0.85),
              ),
            ),
          ),
          if (item.state != null)
            Text(
              item.state!,
              style: TextStyle(
                fontSize: 11,
                color: on.withValues(alpha: 0.55),
              ),
            ),
        ],
      ),
    );
  }
}
