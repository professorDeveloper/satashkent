import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/models/referral_models.dart';

class ReferralListSection extends StatelessWidget {
  final List<ReferralItem> items;
  const ReferralListSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'yourReferrals'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 20),
          if (items.isEmpty)
            Center(
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name ?? '—',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: on.withValues(alpha: 0.85),
              ),
            ),
          ),
          if (item.state != null)
            Text(
              item.state!,
              style: TextStyle(
                fontSize: 12,
                color: on.withValues(alpha: 0.55),
              ),
            ),
        ],
      ),
    );
  }
}
