import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookmarkedSection extends StatelessWidget {
  const BookmarkedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'bookmarked'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.bookmark_border_rounded,
                  size: 40,
                  color: muted.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  'noBookmarks'.tr(),
                  style: TextStyle(fontSize: 13, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
