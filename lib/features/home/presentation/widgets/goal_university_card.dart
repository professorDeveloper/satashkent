import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import 'edit_chip.dart';

class GoalUniversityCard extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onEdit;
  const GoalUniversityCard({
    super.key,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    final hasImage = (imageUrl ?? '').isNotEmpty;
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 36,
                left: 18,
                right: 18,
                bottom: 12,
              ),
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => Image.asset(
                        AppAssets.accepted,
                        fit: BoxFit.contain,
                      ),
                      errorWidget: (_, _, _) => Image.asset(
                        AppAssets.accepted,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(AppAssets.accepted, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                EditChip(onTap: onEdit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
