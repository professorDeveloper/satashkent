import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
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
    final radius = BorderRadius.circular(18);
    return Material(
      color: scheme.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onEdit,
        child: Container(
          height: 190,
          decoration: BoxDecoration(borderRadius: radius),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'myGoalUniversity'.tr(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: muted,
                            ),
                          ),
                        ),
                        EditChip(onTap: onEdit),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: hasImage
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl!,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, _, _) =>
                                        _Placeholder(muted: muted),
                                  )
                                : _Placeholder(muted: muted),
                          ),
                        ),
                      ),
                    ),
                  ],
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
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final Color muted;
  const _Placeholder({required this.muted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brand.withValues(alpha: 0.06),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.brand,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
