import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user.dart';
import 'profile_avatar.dart';

class ProfileHeaderRow extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  const ProfileHeaderRow({super.key, required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);
    final displayName =
        user.name.isNotEmpty ? user.name : user.login;
    final subtitle = (user.phone ?? '').isNotEmpty
        ? user.phone!
        : (user.email ?? user.login);
    debugPrint("Profile header row:${user.image}");
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: profileAvatarHeroTag,
            child: ProfileAvatar(
              image: user.image,
              size: 64,
              ring: 0,
              ringColor: Colors.transparent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _EditSquareButton(onTap: onEdit),
        ],
      ),
    );
  }
}

class _EditSquareButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EditSquareButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.onSurface.withValues(alpha: 0.06);
    final icon = scheme.onSurface.withValues(alpha: 0.85);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(Icons.edit_rounded, color: icon, size: 18),
        ),
      ),
    );
  }
}
