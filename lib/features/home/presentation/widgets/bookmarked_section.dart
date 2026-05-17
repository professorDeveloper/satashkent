import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookmarkedSection extends StatelessWidget {
  const BookmarkedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'bookmarked'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              'noBookmarks'.tr(),
              style: TextStyle(fontSize: 13, color: muted),
            ),
          ),
        ],
      ),
    );
  }
}
