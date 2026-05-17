import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileBanner extends StatelessWidget {
  static const _url = 'https://1600.satashkent.uz/spring-bg-desktop.avif';

  final bool fullBleed;

  const ProfileBanner({super.key, this.fullBleed = false});

  @override
  Widget build(BuildContext context) {
    final stack = Stack(
      fit: StackFit.expand,
      children: [
        const _Gradient(),
        CachedNetworkImage(imageUrl: _url, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.35),
              ],
            ),
          ),
        ),
      ],
    );
    if (fullBleed) return stack;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(height: 140, width: double.infinity, child: stack),
    );
  }
}

class _Gradient extends StatelessWidget {
  const _Gradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAC0D9), Color(0xFFA3508B), Color(0xFF4A2A4C)],
        ),
      ),
    );
  }
}
