import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';

class RoadmapCard extends StatelessWidget {
  final VoidCallback? onTap;
  const RoadmapCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.55);
    final radius = BorderRadius.circular(18);
    return Material(
      color: scheme.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          height: 150,
          decoration: BoxDecoration(borderRadius: radius),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                bottom: -10,
                child: Opacity(
                  opacity: 0.9,
                  child: SvgPicture.asset(
                    AppAssets.roadmapsBg,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Text(
                  'roadmap'.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: muted,
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
