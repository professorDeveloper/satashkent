import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';

const String profileAvatarHeroTag = 'profile-avatar';

class ProfileAvatar extends StatelessWidget {
  final String? image;
  final double size;
  final double ring;
  final Color ringColor;

  const ProfileAvatar({
    super.key,
    required this.image,
    this.size = 80,
    this.ring = 3,
    this.ringColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = (image ?? '').isNotEmpty;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(ring),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ringColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.brand,
        ),
        clipBehavior: Clip.antiAlias,
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: image!,
                cacheKey: image,
                fit: BoxFit.cover,
                placeholder: (_, _) => _logo(size),
                errorWidget: (_, _, _) => _logo(size),
              )
            : _logo(size),
      ),
    );
  }

  Widget _logo(double s) => Center(child: AppLogo(size: s * 0.55, white: true));
}
