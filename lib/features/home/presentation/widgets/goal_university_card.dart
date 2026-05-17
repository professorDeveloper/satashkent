import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

class GoalUniversityCard extends StatelessWidget {
  final String? imageUrl;
  const GoalUniversityCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    final hasImage = (imageUrl ?? '').isNotEmpty;
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (hasImage)
            Positioned(
              left: 14,
              right: 14,
              top: 38,
              bottom: 14,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  color: muted.withValues(alpha: 0.05),
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.contain,
                    errorWidget: (_, _, _) => Icon(
                      Icons.account_balance_rounded,
                      size: 38,
                      color: muted.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Text(
              'myGoalUniversity'.tr(),
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: muted,
                height: 1.2,
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: IgnorePointer(
              child: Image.asset(
                AppAssets.accepted,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
