import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class ReferralCard extends StatelessWidget {
  static const _imageUrl = 'https://1600.satashkent.uz/referral.webp';
  const ReferralCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.65);
    final radius = BorderRadius.circular(18);
    return Material(
      color: scheme.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () => context.push('/referral'),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          decoration: BoxDecoration(
            borderRadius: radius,
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'referral'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'referralDescription'.tr(),
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: muted,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 110,
                height: 110,
                child: CachedNetworkImage(
                  imageUrl: _imageUrl,
                  fit: BoxFit.contain,
                  errorWidget: (_, _, _) => const Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.brand,
                    size: 48,
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
